"""Erzeugt Voronoi-Kantensegmente fuer die Kabelbox-Waende -> voronoi_data.scad.
Liest Masse aus params.scad. Zwei Wand-Flaechen: Front/Rueck (span_w x wall_h)
und Links/Rechts (span_d x wall_h)."""
import re
import numpy as np
from scipy.spatial import Voronoi
import os

# Pfade relativ zum Skript -> funktioniert aus jedem Klon.
_HERE = os.path.dirname(os.path.abspath(__file__))

PARAMS = os.path.join(_HERE, "params.scad")
OUT = os.path.join(_HERE, "voronoi_data.scad")


def read_params(path):
    txt = open(path, encoding="utf-8").read()
    p = {}
    for m in re.finditer(r'^\s*(\w+)\s*=\s*([-\d.]+)\s*;', txt, re.M):
        p[m.group(1)] = float(m.group(2))
    return p


def liang_barsky(x0, y0, x1, y1, w, h):
    dx, dy = x1 - x0, y1 - y0
    p = [-dx, dx, -dy, dy]
    q = [x0, w - x0, y0, h - y0]
    u0, u1 = 0.0, 1.0
    for pi, qi in zip(p, q):
        if pi == 0:
            if qi < 0:
                return None
        else:
            t = qi / pi
            if pi < 0:
                u0 = max(u0, t)
            else:
                u1 = min(u1, t)
    if u0 > u1:
        return None
    return (x0 + u0 * dx, y0 + u0 * dy, x0 + u1 * dx, y0 + u1 * dy)


def voro_segments(w, h, cell, seed):
    rng = np.random.default_rng(seed)
    m = cell
    nx = max(2, int(round((w + 2 * m) / cell)))
    ny = max(2, int(round((h + 2 * m) / cell)))
    xs = np.linspace(-m, w + m, nx)
    ys = np.linspace(-m, h + m, ny)
    gx, gy = np.meshgrid(xs, ys)
    pts = np.column_stack([gx.ravel(), gy.ravel()]).astype(float)
    pts += (rng.random(pts.shape) - 0.5) * cell * 0.8
    vor = Voronoi(pts)
    segs = []
    for (a, b) in vor.ridge_vertices:
        if a < 0 or b < 0:
            continue
        c = liang_barsky(*vor.vertices[a], *vor.vertices[b], w, h)
        if c and (abs(c[0] - c[2]) > 1e-6 or abs(c[1] - c[3]) > 1e-6):
            segs.append(c)
    return segs


def fmt(segs):
    return "[\n" + ",\n".join(
        f"  [{s[0]:.3f},{s[1]:.3f},{s[2]:.3f},{s[3]:.3f}]" for s in segs) + "\n]"


def main():
    p = read_params(PARAMS)
    span_w = p["box_w"] - 2 * p["post_sz"]
    span_d = p["box_d"] - 2 * p["post_sz"]
    wall_h = p["box_h"] - p["floor_t"]
    seed = int(p["voro_seed"]); cell = p["voro_cell"]
    jobs = {
        "voro_wall_w": (span_w, wall_h, seed,     cell),
        "voro_wall_d": (span_d, wall_h, seed + 1, cell),
    }
    lines = ["// AUTO-GENERIERT von gen_voronoi.py - nicht von Hand editieren.",
             f"// cell={cell} seed={seed}", ""]
    for name, (w, h, sd, c) in jobs.items():
        segs = voro_segments(w, h, c, sd)
        lines.append(f"// {name}: Rechteck {w:.1f} x {h:.1f} mm, {len(segs)} Segmente")
        lines.append(f"{name} = {fmt(segs)};")
        lines.append("")
        print(f"{name}: {w:.1f} x {h:.1f} -> {len(segs)} Segmente")
    open(OUT, "w", encoding="utf-8").write("\n".join(lines))
    print("geschrieben:", OUT)


if __name__ == "__main__":
    main()
