# Changelog

Versionshistorie der frei konfigurierbaren Kabelbox. Maße in mm.

## [1.0] – 2026-06-08 · Erste Veröffentlichung

Frei konfigurierbare Kabelbox (Eigenentwicklung, OpenSCAD + Python), Design-Vokabular
wie der Zahnbürstenhalter (gerundet R5, 5-mm-Füße, Voronoi, Schiebe-Mechanik, bündig).
Reproduzierbar aus den Quellen baubar; MakerWorld-Einzeldatei mit Customizer enthalten.

### Funktionen
- **Rahmen** = gerundeter Boden + **4 Eckpfosten** (flush) mit je **2 senkrechten
  Wand-Nuten** (Nut bündig im Pfosten, Front-Skin → kein Überstand) + 4 Füße.
- **4 entnehmbare Voronoi-Gitterwände**, senkrecht in die Pfosten-Nuten geschoben.
- **Glatter Schiebedeckel**: Front/Links/Rechts mit nach innen überstehender **Lippe**
  (3-seitig gefangen), von hinten eingeschoben; **Rückwand niedriger** → Deckel läuft
  drüber, schließt hinten bündig ab; Eck-Aussparungen für die Pfosten; Oberseite leicht
  versenkt. Entnahme: nach hinten herausschieben.
- **Kabelloch je Wand** (none/left/center/right), nach unten offen (Stecker passt);
  mitte=exakt mittig, links/rechts=ein Lochbreiten-Abstand zum Rand.
- **Editierbar**: `box_w/box_d/box_h`; Korpus skaliert mit. Auslieferungsmaß
  **200 × 150 × 41,8 mm** (+5 mm Füße) → **35 mm lichte Nutzhöhe** (Boden bis Deckel).
- Wand-STL-Export via numerischem Index `wi` (Windows-`-D`-String-Bug umgangen).
- **MakerWorld**-Einzeldatei `kabelbox_makerworld.scad` (Customizer: Maße +
  Kabellöcher + Teil-/Platten-Auswahl).
- Arbeitsnotizen für Wiederaufnahme in **`DEVNOTES.md`**.

### Verifiziert
- Wand-Feder sitzt in der bündigen Pfosten-Nut (Front-Skin bleibt → flush),
  Box-Außenkontur exakt 200×150 (nichts steht über) – per `contains`-Test.
- Lichte Nutzhöhe **35,0 mm** (Boden z=3,0 → Deckel-Unterkante z=38,0) – per STL-Bounds.

### Hinweis
- Bei großen Boxen (z. B. 200×150) passen **Korpus + Deckel nicht gemeinsam** auf
  eine X2D-Platte (256×256) – dann Teile einzeln / 2 Platten oder Box kleiner.
- Voronoi für die Auslieferungsmaße vorberechnet; bei Maßänderung `gen_voronoi.py` neu.
