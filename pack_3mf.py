"""Packt Korpus + 4 Waende (flach gelegt) + Deckel in EIN 3MF.
Hinweis: bei grossen Boxen (z.B. 200x150) passen Korpus + Deckel NICHT zusammen
auf eine X2D-Platte (je ~plattengross) -> dann 2 Platten noetig."""
import os
import trimesh
import numpy as np

D = os.path.dirname(os.path.abspath(__file__))
GAP = 10.0


def load(n):
    # force='mesh' -> immer ein einzelnes Trimesh (STLs haben durchs Relief 2
    # Volumes; sonst liefert trimesh ein Scene-Objekt, dessen apply_transform
    # mit KeyError 'world' scheitert).
    return trimesh.load(rf"{D}\{n}", force="mesh")


def at(mesh, x, y, rot=None):
    m = mesh.copy()
    if rot is not None:
        m.apply_transform(trimesh.transformations.rotation_matrix(rot[0], rot[1]))
    m.apply_translation(-m.bounds[0])
    m.apply_translation([x, y, 0])
    return m


scene = trimesh.Scene()
box = load("box.stl")
scene.add_geometry(at(box, 0, 0), geom_name="Korpus")

# Deckel rechts neben den Korpus
lid = load("lid.stl")
x = box.extents[0] + GAP
scene.add_geometry(at(lid, x, 0), geom_name="Deckel")

# 4 Waende flach gelegt (auf den Ruecken gekippt), in einer Reihe darunter
y_row = box.extents[1] + GAP
xx = 0.0
for s in ("front", "back", "left", "right"):
    w = load(f"wall_{s}.stl")
    wf = at(w, xx, y_row, rot=(np.pi / 2, [1, 0, 0]))   # um X kippen -> flach
    scene.add_geometry(wf, geom_name=f"Wand_{s}")
    xx += wf.extents[0] + GAP

out = rf"{D}\Kabelbox_frei_Konfig.3mf"
scene.export(out)
bb = scene.bounds
print("Plattenbedarf:", (bb[1] - bb[0])[:2].round(1), "mm (X2D 256x256)")
print("geschrieben:", out)
