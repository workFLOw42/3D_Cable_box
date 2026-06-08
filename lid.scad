// =====================================================================
//  lid.scad  -  glatter Deckel. Gleitet von hinten unter die Lippen von
//  Front/Links/Rechts (3-seitig gefangen), läuft über die niedrigere
//  Rückwand und schließt hinten bündig (y=box_d) ab. Eck-Aussparungen
//  für die 4 Pfosten. Oberseite leicht versenkt (unter den Lippen).
// =====================================================================
include <params.scad>

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

lid();
