// =====================================================================
//  Kabelbox - frei konfigurierbar  -  EIN-DATEI fuer MakerWorld
//  Solide Voronoi-Relief-Waende (entnehmbar), glatter Schiebedeckel
//  (3-seitig unter Lippen gefangen, laeuft ueber die niedrigere Rueckwand),
//  je Wand waehlbares Kabelloch.
// =====================================================================

/* [Teil-Auswahl] */
part = "montage"; // [montage:Vorschau, platte:Alle Teile nebeneinander, box:Korpus, lid:Deckel, wall_front:Wand vorne, wall_back:Wand hinten, wall_left:Wand links, wall_right:Wand rechts]

// ============================ params.scad ============================
// =====================================================================
//  params.scad  -  Kabelbox, frei konfigurierbar (einzige Wahrheitsquelle)
//  Koordinaten: x=Breite, y=Tiefe (Front y=0, Rück y=box_d), z=Höhe.
//  4 Eckpfosten (flush) mit Nuten -> 4 entnehmbare Voronoi-Wände;
//  glatter Schiebedeckel von hinten; Füße; alles bündig.
// =====================================================================

/* [Maße] */
box_w = 200;   // Breite X (mm)
box_d = 150;   // Tiefe Y (mm)
box_h = 41.8;  // Höhe Z (mm, ohne Füße) -> 35 mm nutzbar (Boden bis Deckel)

/* [Kabellöcher je Wand] */
//  none = keins | left/center/right = Position (unten offener Schlitz)
cable_front = "none";   // [none:keins, left:links, center:mitte, right:rechts]
cable_back  = "right";  // [none:keins, left:links, center:mitte, right:rechts]  (1. Kiste)
cable_left  = "none";   // [none:keins, left:links, center:mitte, right:rechts]
cable_right = "right";  // [none:keins, left:links, center:mitte, right:rechts]  (1. Kiste)

// ---- Struktur -------------------------------------------------------
wall_t     = 3.0;   // Wandstärke (Außenfläche bündig)
floor_t    = 3.0;   // Bodenstärke
fillet_r   = 5.0;   // Kantenrundung R5 (wie Holder)
post_sz    = 10.0;  // Eckpfosten-Bein (X=Y), flush in der Ecke
foot_r     = 5.0;   // Fuß
foot_h     = 5.0;
foot_inset = 5.0;

// ---- Feder & Nut: Wand <-> Pfosten ----------------------------------
//  Feder (Rippe) sitzt hinter einer Front-Skin des Pfostens -> flush & in
//  Querrichtung gefangen (Prinzip wie Holder-Rückwand).
front_skin = 1.0;   // Pfosten-Skin vor der Feder (Außenseite)
tongue_d   = 4.0;   // Federtiefe in den Pfosten (Längsrichtung der Wand)
rail_clear = 0.3;   // Spiel Feder<->Nut
rail_lead  = 1.2;   // 45°-Einführfase unten an der Feder

// ---- Deckel (glatt, von hinten eingeschoben) ------------------------
//  Vorne/links/rechts: Lippe übergreift den Deckelrand (3-seitig gefangen);
//  Rückwand niedriger -> Deckel läuft drüber, schließt hinten bündig ab.
lid_t      = 2.5; // Deckeldicke
lid_lip_t  = 1.0; // Höhe/Überdeckung der Lippe über dem Deckelrand
lid_ov     = 3.0; // Lippen-Überstand nach innen (Deckel-Eingriff)
lid_clear  = 0.3; // Spiel Deckel

// ---- Kabelloch (unten offen, wie Zahnbürstenhalter) -----------------
cable_w = 12;   // Schlitzbreite (X entlang der Wand)
cable_h = 12;   // Oberkante des Schlitzes über dem Boden (Z)

// ---- Voronoi (Wand-Relief) ------------------------------------------
voro_seed  = 11;
voro_cell  = 14;    // Zellabstand Wand-Relief
voro_strut = 1.8;   // Stegbreite
relief_h   = 1.2;   // Reliefhöhe (erhaben)

// ---- abgeleitete Maße / Helfer (NICHT ändern) -----------------------
// lichte Spannweiten zwischen den Pfosten
span_w = box_w - 2*post_sz;   // Front/Rück-Wandlänge (X)
span_d = box_d - 2*post_sz;   // Links/Rechts-Wandlänge (Y)
wall_h = box_h - floor_t;     // Wandhöhe über dem Boden

$fn = 32;

// ============================ voronoi_data.scad ============================
// AUTO-GENERIERT von gen_voronoi.py - nicht von Hand editieren.
// cell=14.0 seed=11

// voro_wall_w: Rechteck 180.0 x 38.8 mm, 92 Segmente
voro_wall_w = [
  [180.000,22.731,173.730,21.714],
  [173.730,21.714,171.915,23.722],
  [171.915,23.722,172.943,38.800],
  [65.411,38.800,67.445,37.456],
  [67.445,37.456,68.242,38.800],
  [49.220,38.800,47.510,26.459],
  [47.510,26.459,55.592,24.025],
  [67.445,37.456,69.330,29.236],
  [55.592,24.025,69.330,29.236],
  [137.469,38.800,141.517,29.784],
  [126.457,38.800,129.886,29.599],
  [141.517,29.784,129.886,29.599],
  [127.533,14.180,141.390,15.750],
  [127.533,14.180,123.024,23.478],
  [123.024,23.478,129.886,29.599],
  [141.517,29.784,144.953,26.978],
  [141.390,15.750,144.953,26.978],
  [156.107,38.800,153.000,30.483],
  [144.953,26.978,153.000,30.483],
  [171.915,23.722,159.230,25.623],
  [153.000,30.483,159.230,25.623],
  [115.130,38.800,114.347,37.900],
  [110.662,38.800,114.347,37.900],
  [87.671,38.800,82.493,30.970],
  [70.884,28.310,69.330,29.236],
  [70.884,28.310,74.873,27.142],
  [74.873,27.142,82.493,30.970],
  [70.884,28.310,64.746,6.413],
  [74.873,27.142,82.497,10.728],
  [82.497,10.728,64.746,6.413],
  [37.439,38.800,33.306,29.267],
  [25.746,38.800,26.884,31.804],
  [33.306,29.267,26.884,31.804],
  [47.510,26.459,39.422,23.572],
  [39.422,23.572,33.306,29.267],
  [10.383,38.800,11.784,26.881],
  [26.884,31.804,16.557,27.068],
  [11.784,26.881,16.557,27.068],
  [39.422,23.572,36.444,12.316],
  [16.557,27.068,27.505,9.420],
  [36.444,12.316,27.505,9.420],
  [126.054,12.099,123.782,0.000],
  [126.054,12.099,127.533,14.180],
  [141.390,15.750,145.284,9.580],
  [145.284,9.580,138.453,0.000],
  [114.771,28.365,114.266,29.548],
  [114.771,28.365,107.131,13.440],
  [114.266,29.548,98.734,26.955],
  [107.131,13.440,104.460,11.471],
  [104.460,11.471,96.802,15.720],
  [96.802,15.720,96.204,22.972],
  [98.734,26.955,96.204,22.972],
  [123.024,23.478,114.771,28.365],
  [114.347,37.900,114.266,29.548],
  [126.054,12.099,107.131,13.440],
  [97.103,38.800,98.734,26.955],
  [105.001,8.020,111.850,0.000],
  [105.001,8.020,104.460,11.471],
  [82.493,30.970,96.204,22.972],
  [82.497,10.728,83.183,10.229],
  [83.183,10.229,96.802,15.720],
  [172.209,12.638,174.947,9.076],
  [172.209,12.638,158.667,8.079],
  [174.947,9.076,171.837,0.000],
  [156.453,0.000,155.230,4.676],
  [158.667,8.079,155.230,4.676],
  [173.730,21.714,172.209,12.638],
  [180.000,7.254,174.947,9.076],
  [159.230,25.623,158.667,8.079],
  [145.284,9.580,155.230,4.676],
  [84.092,0.000,84.387,0.282],
  [84.387,0.282,84.902,0.000],
  [83.183,10.229,84.387,0.282],
  [105.001,8.020,97.818,0.000],
  [55.592,24.025,57.636,8.548],
  [64.746,6.413,63.474,5.504],
  [57.636,8.548,63.474,5.504],
  [11.784,26.881,9.039,24.907],
  [9.039,24.907,0.000,26.211],
  [41.214,0.000,41.148,6.779],
  [52.510,0.000,52.755,6.829],
  [41.148,6.779,52.755,6.829],
  [36.444,12.316,41.148,6.779],
  [57.636,8.548,52.755,6.829],
  [63.474,5.504,64.375,0.000],
  [23.480,6.002,23.689,0.000],
  [23.480,6.002,9.730,8.766],
  [4.242,0.000,7.150,6.503],
  [7.150,6.503,9.730,8.766],
  [27.505,9.420,23.480,6.002],
  [9.039,24.907,9.730,8.766],
  [0.000,10.296,7.150,6.503]
];

// voro_wall_d: Rechteck 130.0 x 38.8 mm, 60 Segmente
voro_wall_d = [
  [10.932,25.027,0.000,27.735],
  [10.932,25.027,9.516,12.581],
  [9.516,12.581,8.225,11.164],
  [0.000,14.647,8.225,11.164],
  [10.932,25.027,14.917,29.369],
  [14.917,29.369,8.661,38.800],
  [41.207,32.511,41.781,38.800],
  [41.207,32.511,34.348,29.078],
  [34.348,29.078,29.603,29.019],
  [28.318,38.800,27.353,37.652],
  [27.353,37.652,28.118,30.393],
  [28.118,30.393,29.603,29.019],
  [26.502,38.800,27.353,37.652],
  [14.917,29.369,28.118,30.393],
  [9.516,12.581,27.323,14.291],
  [27.323,14.291,29.603,29.019],
  [73.112,26.238,58.261,22.835],
  [73.112,26.238,71.478,38.800],
  [58.031,38.800,55.174,32.331],
  [55.174,32.331,58.261,22.835],
  [41.207,32.511,55.174,32.331],
  [8.225,11.164,7.860,0.000],
  [27.323,14.291,29.627,10.034],
  [29.627,10.034,24.032,0.000],
  [86.471,30.902,96.216,26.235],
  [86.471,30.902,76.257,24.466],
  [96.216,26.235,92.382,17.198],
  [92.382,17.198,83.124,12.671],
  [76.257,24.466,78.280,14.866],
  [78.280,14.866,83.124,12.671],
  [84.902,0.000,83.124,12.671],
  [67.353,9.400,74.251,0.000],
  [67.353,9.400,78.280,14.866],
  [101.097,28.265,96.216,26.235],
  [101.097,28.265,101.069,38.800],
  [86.471,30.902,83.388,38.800],
  [73.112,26.238,76.257,24.466],
  [59.665,0.000,62.900,9.815],
  [42.927,0.000,41.383,6.267],
  [41.383,6.267,48.068,14.067],
  [48.068,14.067,56.955,16.923],
  [56.955,16.923,62.900,9.815],
  [67.353,9.400,62.900,9.815],
  [29.627,10.034,41.383,6.267],
  [34.348,29.078,48.068,14.067],
  [58.261,22.835,56.955,16.923],
  [101.097,28.265,106.396,26.319],
  [116.963,38.800,118.230,30.454],
  [106.396,26.319,118.230,30.454],
  [130.000,31.845,120.438,29.749],
  [118.230,30.454,120.438,29.749],
  [92.382,17.198,99.854,6.129],
  [106.396,26.319,110.584,12.710],
  [110.584,12.710,99.854,6.129],
  [99.854,6.129,98.466,0.000],
  [118.772,8.218,117.432,0.000],
  [118.772,8.218,124.046,11.165],
  [130.000,11.069,124.046,11.165],
  [110.584,12.710,118.772,8.218],
  [120.438,29.749,124.046,11.165]
];

// ============================ voronoi.scad ============================
// =====================================================================
//  voronoi.scad  -  Voronoi-Netz (2D) + Relief-Platzierung auf Flächen
// =====================================================================

// 2D-Netz: jedes Segment wird zu einer "Kapsel" (hull zweier Kreise).
module voro_web_2d(segs, strut) {
    r = strut / 2;
    union()
        for (s = segs)
            hull() {
                translate([s[0], s[1]]) circle(r = r, $fn = 16);
                translate([s[2], s[3]]) circle(r = r, $fn = 16);
            }
}

// Relief-Scheibe: Netz auf Rechteck w x h geclippt, Dicke "thick" in +Z.
// Taucht "ov" mm in den Körper ein (-Z), damit es sicher verschmilzt.
module voro_slab(w, h, segs, strut, thick, ov = 0.8) {
    translate([0, 0, -ov])
        linear_extrude(height = thick + ov)
            intersection() {
                square([w, h]);
                voro_web_2d(segs, strut);
            }
}

// --- Platzierung auf den 4 Außenflächen eines Korpus (x:0..W, y:0..D, z:0..H)
//     Relief ragt nach außen (erhaben), um Rand-Margin m eingerückt
//     (sitzt so auf den flachen Bändern, nicht in den abgerundeten Kanten).
//     segs sind bereits für (Seite-2m) x (H-2m) erzeugt.
module relief_front(W, H, segs, strut, thick, m)           // -Y bei y=0
    translate([m, 0, m]) rotate([90, 0, 0])
        voro_slab(W - 2*m, H - 2*m, segs, strut, thick);

module relief_back(W, D, H, segs, strut, thick, m)         // +Y bei y=D
    translate([W - m, D, m]) rotate([90, 0, 180])
        voro_slab(W - 2*m, H - 2*m, segs, strut, thick);

module relief_left(D, H, segs, strut, thick, m)            // -X bei x=0
    translate([0, D - m, m]) rotate([90, 0, -90])
        voro_slab(D - 2*m, H - 2*m, segs, strut, thick);

module relief_right(W, D, H, segs, strut, thick, m)        // +X bei x=W
    translate([W, m, m]) rotate([90, 0, 90])
        voro_slab(D - 2*m, H - 2*m, segs, strut, thick);

// ============================ box.scad ============================
// =====================================================================
//  box.scad  -  Rahmen der Kabelbox (bleibt fest):
//   gerundeter Boden + 4 Eckpfosten (flush) mit je 2 senkrechten Wand-Nuten,
//   4 Füße. Nuten liegen INNERHALB der Pfosten (Front-Skin) -> flush.
// =====================================================================

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


// ============================ wall.scad ============================
// =====================================================================
//  wall.scad  -  eine entnehmbare Wand (parametrisch je Seite)
//  SOLIDE Wand + erhabenes Voronoi-Relief (wie Zahnbürstenhalter).
//  Deckel-Mechanik: front/left/right tragen oben eine nach innen
//  überstehende LIPPE (Deckel 3-seitig gefangen); die RÜCKWAND ist um
//  (lid_t+lid_lip_t+clear) NIEDRIGER -> Deckel läuft drüber, schließt bündig.
//  local: x=Länge 0..L, y=Dicke 0..wall_t (Außen y=0), z=Höhe 0..wall_h.
//  Render einzeln:  openscad -D side=\"front\" -o wall.stl wall.scad
// =====================================================================


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


// ============================ lid.scad ============================
// =====================================================================
//  lid.scad  -  glatter Deckel. Gleitet von hinten unter die Lippen von
//  Front/Links/Rechts (3-seitig gefangen), läuft über die niedrigere
//  Rückwand und schließt hinten bündig (y=box_d) ab. Eck-Aussparungen
//  für die 4 Pfosten. Oberseite leicht versenkt (unter den Lippen).
// =====================================================================

module lid() {
    c    = lid_clear;
    x0   = wall_t + c;  x1 = box_w - wall_t - c;
    y0   = wall_t + c;  y1 = box_d;                 // hinten bündig (über Rückwand)
    ztop = box_h - lid_lip_t - lid_clear;
    zbot = ztop - lid_t;
    difference() {
        translate([x0, y0, zbot]) cube([x1 - x0, y1 - y0, lid_t]);
        // 4 Eck-Aussparungen für die Pfosten
        for (cx = [0, 1], cy = [0, 1])
            translate([cx*(box_w - post_sz - 0.4) - 0.5,
                       cy*(box_d - post_sz - 0.4) - 0.5, zbot - 1])
                cube([post_sz + 0.9, post_sz + 0.9, lid_t + 2]);
    }
}


// ============================ Render / Teil-Auswahl ============================
module _wall_flat(s) { translate([tongue_d, 0, wall_t]) rotate([-90, 0, 0]) wall(s); }
module _platte() {
    GAP = 12;
    box();
    translate([box_w + GAP, 0, -(box_h - lid_t)]) lid();
    yb = box_d + GAP;
    translate([0, yb, 0])                         _wall_flat("front");
    translate([span_w + 2*tongue_d + GAP, yb, 0]) _wall_flat("back");
    translate([0, yb + wall_h + GAP, 0])          _wall_flat("left");
    translate([span_d + 2*tongue_d + GAP, yb + wall_h + GAP, 0]) _wall_flat("right");
}
if      (part == "platte")     _platte();
else if (part == "box")        box();
else if (part == "lid")        lid();
else if (part == "wall_front") wall("front");
else if (part == "wall_back")  wall("back");
else if (part == "wall_left")  wall("left");
else if (part == "wall_right") wall("right");
else { box(); for (s = ["front","back","left","right"]) place_wall(s) wall(s); lid(); }
