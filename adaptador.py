"""
Adaptador motor XD-3420 (punta roscada M8 macho, 13 mm) -> cepillo pulido (eje 3,7 mm).
Lado motor: bolsa HEXAGONAL para 1 o 2 TUERCAS M8 metalicas (rosca de acero).
Lado cepillo: taladro 3,85 mm + prisionero M3 lateral autorroscante.
Imprimir en vertical (eje Z), sin soportes.
"""
import numpy as np, trimesh
from shapely.geometry import Polygon

OD=20.0; L=41.0
NUT_AF=13.0; NUT_CLEAR=0.45; NUT_DEPTH=13.5      # cabe 1 o 2 tuercas M8 (13 mm rosca motor)
CLEAR_BORE_D=8.6; CLEAR_BORE_H=3.0               # alivio para la punta de la rosca
SHAFT_D=3.7; SHAFT_FIT=0.15; BORE_D=SHAFT_D+SHAFT_FIT; BORE_DEPTH=20.0
SET_PILOT_D=2.6; SET_Z=8.0
SECTIONS=96

def cyl(r,h,z0):
    c=trimesh.creation.cylinder(radius=r,height=h,sections=SECTIONS)
    c.apply_translation([0,0,z0+h/2.0]); return c

body=cyl(OD/2.0,L,0.0)

af=NUT_AF+NUT_CLEAR; circ=(af/2.0)/np.cos(np.radians(30))
ang=np.radians(np.arange(6)*60+30)
hexpts=np.column_stack([circ*np.cos(ang),circ*np.sin(ang)])
nut_pocket=trimesh.creation.extrude_polygon(Polygon(hexpts),height=NUT_DEPTH+1.0)
nut_pocket.apply_translation([0,0,L-NUT_DEPTH])

clear_bore=cyl(CLEAR_BORE_D/2.0,CLEAR_BORE_H,L-NUT_DEPTH-CLEAR_BORE_H)

brush_bore=cyl(BORE_D/2.0,BORE_DEPTH+1.0,-1.0)
cone=trimesh.creation.cone(radius=BORE_D/2.0+1.2,height=1.6,sections=SECTIONS)
cone.apply_transform(trimesh.transformations.rotation_matrix(np.pi,[1,0,0],[0,0,0]))
cone.apply_translation([0,0,1.4])

# Prisionero de UN SOLO lado: extremo interior en el eje (x=0), sale por +X.
SET_LEN=OD/2.0+2.0
setscrew=trimesh.creation.cylinder(radius=SET_PILOT_D/2.0,height=SET_LEN,sections=48)
setscrew.apply_transform(trimesh.transformations.rotation_matrix(np.pi/2,[0,1,0]))  # eje -> X
setscrew.apply_translation([SET_LEN/2.0,0,SET_Z])  # abarca x=0..SET_LEN (no cruza al lado opuesto)

cutters=trimesh.util.concatenate([nut_pocket,clear_bore,brush_bore,cone,setscrew])
part=trimesh.boolean.difference([body,cutters],engine='manifold')

print("Estanca:",part.is_watertight)
b=part.bounds; print("BBox (mm):",np.round(b[1]-b[0],2),"Vol(cm3):",round(part.volume/1000,1))
# comprobacion de pared entre taladros
print("Pared central (mm):", round((L-NUT_DEPTH-CLEAR_BORE_H)-BORE_DEPTH,2))
print("Pared lateral tuerca (mm):", round(OD/2.0-circ,2))
part.export('adaptador_motor_cepillo.stl')
print("STL OK")
