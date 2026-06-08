# DEVNOTES – Kabelbox_frei_Konfig (Stand v1.0)

Arbeitsnotizen für die **Wiederaufnahme**. Kurz, aber vollständig.

## Status
**v1.0, funktionsfähig & verifiziert.** Eigenentwicklung (OpenSCAD + Python),
Design-Vokabular wie der Zahnbürstenhalter-Halter (`Elektr_Zahnbuerstenhalter_frei_Konfig`).

## Build / Werkzeuge
- **Build:** `powershell -File build.ps1` im Projektordner (nutzt `$PSScriptRoot`,
  also pfad-unabhängig). Erzeugt Voronoi-Daten, alle STLs, 3MF und die Vorschau.
- **Werkzeuge:** OpenSCAD (Windows-Default `C:\Program Files\OpenSCAD\openscad.exe`),
  Python mit numpy/scipy/trimesh.
- **Hinweis (lokale Eigenheit):** Wird der Ordner über OneDrive synchronisiert,
  können direkte Datei-Schreibzugriffe fehlschlagen — dann in einem lokalen Ordner
  bauen und die Ergebnisse per `Copy-Item` zurückkopieren.

## Architektur (Koordinaten: x=Breite, y=Tiefe [Front y=0, Rück y=box_d], z=Höhe)
- `params.scad` = **einzige Wahrheitsquelle** (Maße, Belegung, Feder/Nut, Deckel, Voronoi).
- `box.scad` = **Rahmen** (bleibt fest): gerundeter Boden + 4 Eckpfosten (flush) mit je
  2 senkrechten Wand-Nuten + Boden, 4 Füße. `place_wall(side)` platziert local→Seite
  (auch für Wände/Deckel genutzt). Top via `round_env()` gerundet.
- `wall.scad` = **1 entnehmbare Wand**, parametrisch je Seite. Solide + erhabenes
  Voronoi-Relief. Federn an den Enden → Pfosten-Nuten. Front/Links/Rechts: **Lippe**
  oben (`lid_lip`); **Rückwand: niedriger** (`wall_height("back")`). Kabel-Schlitz unten offen.
- `lid.scad` = **glatter Deckel**, 3-seitig unter den Lippen gefangen, hinten bündig,
  Eck-Aussparungen für Pfosten.
- `voronoi.scad` (reuse) + `voronoi_data.scad` (auto via `gen_voronoi.py`).
- `assembly.scad` (Vorschau), `pack_3mf.py`, `kabelbox_makerworld.scad` (Einzeldatei).

## Schlüssel-Parameter (params.scad)
- Maße: `box_w=200, box_d=150, box_h=41.8` (editierbar; 35 mm nutzbar Boden→Deckel),
  `wall_t=3, floor_t=3, post_sz=10, fillet_r=5`.
- Feder/Nut Wand↔Pfosten: `front_skin=1` (Skin vor Feder → flush), `tongue_d=4`,
  `rail_clear=0.3`, `rail_lead=1.2`.
- Deckel: `lid_t=2.5`, `lid_lip_t=1.0` (Lippen-Überdeckung), `lid_ov=3.0` (Lippe nach innen),
  `lid_clear=0.3`. Rückwand-Absenkung = `lid_t+lid_lip_t+lid_clear = 3.8`.
- Kabelloch: `cable_w=12`, `cable_h=12` (Oberkante über Boden), **unten offen**.
  Belegung: `cable_front/back/left/right` ∈ none/left/center/right.
  Position: center=mittig; left/right = 1 Lochbreite Abstand zum inneren Rand.
- Voronoi: `voro_seed=11, voro_cell=14, voro_strut=1.8, relief_h=1.2`.

## 1. Kiste (aktuell gesetzt, vom Nutzer bestätigt)
`cable_right="right"` (rechte Wand, Loch **hinten**, Welt-y≈122) +
`cable_back="right"` (Rückwand, Loch **links**/−x, Welt-x≈28). Front/Links = none.

## Verifiziert (contains-Tests)
- Box-Außenkontur exakt 200×150 (Füße bis z=−5) → **nichts steht über**.
- Wand-Feder sitzt in **flush** Pfosten-Nut; Front-Skin bleibt.
- (v1.1, Welt-Z am Assembly) Boden-Oberkante z=3,0; Deckel-Unterkante z=38,0
  → **35,0 mm nutzbar** (STL-Bounds verifiziert). Deckel z 38,0–40,5 (versenkt <41,8),
  hinten y=150 bündig; Rückwand-Oberkante z=38,0 (= niedriger, Deckel läuft drüber),
  Front/Links/Rechts z=41,8.

## Gotchas (WICHTIG)
- **Windows OpenSCAD `-D string="..."` reicht KEINE Strings durch** (→ undef)! Deshalb:
  Wand-STLs via **numerischen Index** `-D wi=0..3` (build.ps1). Auch `part`/`side`/`cable_*`
  lassen sich per CLI **nicht** als String setzen → Konfig nur via Datei/Customizer testen
  (oder Wert per `sed` in eine Temp-Datei backen).
- **X2D-Platte:** bei 200×150 passen **Korpus + Deckel NICHT zusammen** auf 256×256
  (Platte misst ~412–682). → Teile einzeln (2 Platten) oder Box kleiner. `part="platte"`
  ist für kleinere Boxen / Auto-Anordnung in Bambu Studio gedacht.
- **Voronoi** ist für die Default-Maße vorberechnet → bei Maßänderung `gen_voronoi.py` neu.
- Relief steht (wie beim Holder) `relief_h` nach außen über (Box dadurch +~2,4 mm).

## Offene Punkte / mögliche nächste Schritte
- **Deckel-Sicherung:** aktuell gleitet der Deckel zur Entnahme nach hinten heraus
  (gefangen nur in Z durch die Lippen). Falls gewünscht: kleiner **Rast-Nupsi** in den
  L/R-Lippen, der ihn in Endlage hält.
- **Probedruck-Feintuning:** Spiele `rail_clear` (Wand↔Nut) und `lid_clear` (Deckel)
  ggf. ±0,1 mm.
- **platte-Layout** ist simpel (nebeneinander); bei Bedarf kompakter packen.

## Build-/Verifikations-Ablauf
1. `params.scad` anpassen → `python gen_voronoi.py` (falls Maße/Voronoi geändert).
2. `powershell -File build.ps1` → box.stl, wall_{front,back,left,right}.stl, lid.stl,
   3MF, assembly_iso.png.
3. MakerWorld-Datei neu erzeugen (Bash-Concat, siehe Befehl in der Git-Historie /
   unten*) wenn `params/box/wall/lid` geändert.
4. Per PowerShell `Copy-Item` nach `…\Github\Kabelbox_frei_Konfig`.

*MakerWorld-Concat: alle Quellen ohne `include/use` und ohne Top-Level-Aufrufe
(`box();`,`lid();`,`wall(`,`side =`,`wi =`) zusammenfügen, Customizer-Header + Render-
/Teil-Auswahl (`part`: montage/platte/box/lid/wall_*) anhängen.
