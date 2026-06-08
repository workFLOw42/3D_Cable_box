# Baut alle Teile der Kabelbox: Voronoi -> STL -> 3MF -> Vorschau
$ErrorActionPreference = "Stop"
$osc = "C:\Program Files\OpenSCAD\openscad.exe"
$dir = $PSScriptRoot

Write-Host "1/4 Voronoi-Daten..."
python "$dir\gen_voronoi.py"

Write-Host "2/4 Korpus + Deckel..."
& $osc -o "$dir\box.stl" "$dir\box.scad"
& $osc -o "$dir\lid.stl" "$dir\lid.scad"

Write-Host "3/4 Waende..."
$names = @("front", "back", "left", "right")
for ($i = 0; $i -lt 4; $i++) {
    & $osc -D "wi=$i" -o "$dir\wall_$($names[$i]).stl" "$dir\wall.scad"
}

Write-Host "4/4 3MF + Vorschau..."
python "$dir\pack_3mf.py"
& $osc -o "$dir\assembly_iso.png" --imgsize 950,650 --viewall --autocenter `
    --colorscheme Tomorrow --camera=0,0,0,60,0,28,0 "$dir\assembly.scad"

Write-Host "Fertig."
