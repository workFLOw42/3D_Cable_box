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
