// =====================================================================
//  assembly.scad  -  Vorschau: Rahmen + 4 Wände + Deckel (nur Ansicht)
// =====================================================================
include <params.scad>
include <voronoi_data.scad>
use <voronoi.scad>
use <box.scad>
use <wall.scad>
use <lid.scad>

color([0.20, 0.45, 0.75]) box();
for (s = ["front", "back", "left", "right"])
    color([0.90, 0.78, 0.32]) place_wall(s) wall(s);
color([0.82, 0.86, 0.92]) lid();
