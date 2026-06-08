// =====================================================================
//  wall.scad  -  eine entnehmbare Wand (parametrisch je Seite)
//  SOLIDE Wand + erhabenes Voronoi-Relief (wie Zahnbürstenhalter).
//  Deckel-Mechanik: front/left/right tragen oben eine nach innen
//  überstehende LIPPE (Deckel 3-seitig gefangen); die RÜCKWAND ist um
//  (lid_t+lid_lip_t+clear) NIEDRIGER -> Deckel läuft drüber, schließt bündig.
//  local: x=Länge 0..L, y=Dicke 0..wall_t (Außen y=0), z=Höhe 0..wall_h.
//  Render einzeln:  openscad -D side=\"front\" -o wall.stl wall.scad
// =====================================================================
include <params.scad>
include <voronoi_data.scad>
use <voronoi.scad>

side = "front";   // per -D überschreiben (oder wi numerisch, Windows-tauglich)
wi   = -1;        // -1 = 'side' nutzen; 0/1/2/3 = front/back/left/right

function wall_len(s) = (s == "front" || s == "back") ? span_w : span_d;
function cable_cfg(s) =
    s == "front" ? cable_front : s == "back" ? cable_back :
    s == "left"  ? cable_left  : cable_right;
function cable_pos(cfg, L) =
    cfg == "center" ? L/2 : cfg == "left" ? 1.5*cable_w :
    cfg == "right"  ? L - 1.5*cable_w : -100;
// Wandhöhe: Rückwand niedriger (Deckel läuft drüber)
function wall_height(s) = (s == "back") ? wall_h - lid_t - lid_lip_t - lid_clear : wall_h;

module wall_relief(L, segs, wh) {
    ov = 0.6; m = 2.5;
    translate([0, ov, 0]) rotate([90, 0, 0])
        linear_extrude(relief_h + ov)
            intersection() {
                translate([m, m]) square([L - 2*m, wh - 2*m]);
                voro_web_2d(segs, voro_strut);
            }
}

module tongues(L, wh) {
    tyh = wall_t - front_skin;
    for (e = [0, 1]) {
        x0 = (e == 0) ? -tongue_d : L;
        bx = (e == 0) ? -tongue_d + rail_lead : L;
        hull() {
            translate([x0, front_skin, rail_lead]) cube([tongue_d, tyh, wh - rail_lead]);
            translate([bx, front_skin, 0])         cube([tongue_d - rail_lead, tyh, 0.1]);
        }
    }
}

// Deckel-Lippe oben innen (übersteht nach innen), trägt/fängt den Deckelrand
module lid_lip(L) {
    translate([0, wall_t, wall_h - lid_lip_t]) cube([L, lid_ov, lid_lip_t]);
}

module cable_slot(cx) {
    r = cable_w/2; y0 = -(relief_h + 1);
    translate([cx, y0, cable_h - r]) rotate([-90, 0, 0]) cylinder(r = r, h = wall_t - y0 + 1, $fn = 28);
    translate([cx - r, y0, -5]) cube([cable_w, wall_t - y0 + 1, (cable_h - r) + 5]);
}

module wall(s) {
    L    = wall_len(s);
    wh   = wall_height(s);
    segs = (s == "front" || s == "back") ? voro_wall_w : voro_wall_d;
    cfg  = cable_cfg(s);
    cx   = cable_pos(cfg, L);
    difference() {
        union() {
            translate([0, wall_t, 0]) rotate([90, 0, 0]) linear_extrude(wall_t) square([L, wh]);
            wall_relief(L, segs, wh);
            tongues(L, wh);
            if (s != "back") lid_lip(L);     // 3-seitige Deckel-Lippe
        }
        if (cfg != "none") cable_slot(cx);
    }
}

wall((wi < 0) ? side : ["front", "back", "left", "right"][wi]);
