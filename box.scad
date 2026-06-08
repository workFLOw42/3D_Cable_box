// =====================================================================
//  box.scad  -  Rahmen der Kabelbox (bleibt fest):
//   gerundeter Boden + 4 Eckpfosten (flush) mit je 2 senkrechten Wand-Nuten,
//   4 Füße. Nuten liegen INNERHALB der Pfosten (Front-Skin) -> flush.
// =====================================================================
include <params.scad>

module rounded_block(w, d, h, r) {
    minkowski() {
        translate([r, r, r]) cube([w - 2*r, d - 2*r, h - 2*r]);
        sphere(r = r, $fn = 24);
    }
}

// Platziert local (x=Länge 0..L, y=Dicke 0..wall_t [Außen y=0], z=Höhe 0..wall_h)
// auf die jeweilige Seite. L: front/back=span_w, left/right=span_d.
module place_wall(side) {
    if      (side == "front") translate([post_sz, 0, floor_t]) children();
    else if (side == "right") translate([box_w, post_sz, floor_t]) rotate([0,0,90]) children();
    else if (side == "back")  translate([box_w - post_sz, box_d, floor_t]) rotate([0,0,180]) children();
    else if (side == "left")  translate([0, box_d - post_sz, floor_t]) rotate([0,0,-90]) children();
}
function wall_len(side) = (side == "front" || side == "back") ? span_w : span_d;

// 4 Eck-Säulen (volle Höhe) – werden mit rounded_block geschnitten (runde Ecke)
module corner_cols() {
    for (cx = [0, 1], cy = [0, 1])
        translate([cx*(box_w - post_sz), cy*(box_d - post_sz), 0])
            cube([post_sz, post_sz, box_h + 1]);
}

// Nut-Schneider in local Wand-Koordinaten (schneidet die Pfosten an beiden Enden).
// Feder sitzt y∈[front_skin, wall_t]; Skin y∈[0,front_skin] bleibt -> flush.
module groove_cutter(L) {
    gy = wall_t + rail_clear - front_skin;       // Nuttiefe in Y
    for (e = [0, 1]) {
        gx = (e == 0) ? -tongue_d - rail_clear : L - 0.1;
        translate([gx, front_skin, 0])
            cube([tongue_d + rail_clear + 0.1, gy, wall_h + box_h]);
    }
}

module feet() {
    insets = foot_inset + foot_r;
    for (px = [insets, box_w - insets], py = [insets, box_d - insets])
        translate([px, py, -foot_h]) cylinder(h = foot_h + 0.5, r = foot_r, $fn = 36);
}

// Rundungs-Hülle (Top sauber runden, Relief/Füße nicht beschneiden)
module round_env() {
    e = 1.0;
    minkowski() {
        translate([fillet_r - e, fillet_r - e, fillet_r - foot_h - 1])
            cube([box_w - 2*fillet_r + 2*e, box_d - 2*fillet_r + 2*e,
                  box_h - 2*fillet_r + foot_h + 1]);
        sphere(r = fillet_r, $fn = 24);
    }
}

module box() {
    intersection() {
        difference() {
            union() {
                intersection() {
                    rounded_block(box_w, box_d, box_h, fillet_r);
                    union() {
                        cube([box_w, box_d, floor_t]);   // Boden
                        corner_cols();                    // 4 Pfosten
                    }
                }
                feet();
            }
            for (s = ["front", "back", "left", "right"])
                place_wall(s) groove_cutter(wall_len(s));
        }
        round_env();
    }
}

box();
