import numpy as np, trimesh
from manifold3d import Manifold

# ---------------- Parametros ----------------
OD=20.0; L=41.0
# Tuerca M8 cautiva (AjUSTADO: press-fit)
NUT_AF=13.0; NUT_CLEAR=-0.10            # AF efectivo 12.9 (antes 13.45)
NUT_DEPTH=13.5
CLEAR_BORE_D=8.6; CLEAR_BORE_H=3.0
# Eje del cepillo
SHAFT_D=3.7; SHAFT_FIT=0.15; BORE_D=SHAFT_D+SHAFT_FIT; BORE_DEPTH=20.0
# Prisionero: INSERTO M2 de laton (OD 3.2 x 3) + tornillo M2x4
SET_Z=8.0
POCKET_D=5.0                # avellanado para acercar el inserto al eje y dar paso al util
POCKET_FLOOR_R=5.7          # radio donde queda la cara del inserto (pared efectiva ~3.8mm)
INSERT_HOLE_D=3.0           # taladro para el inserto termofusible (OD 3.2)
INSERT_LEN=3.2             # longitud del inserto + holgura
BOLT_CLEAR_D=2.3           # paso libre del tornillo M2 hasta el eje
SEG=96

def cylZ(h,d,seg=SEG): return Manifold.cylinder(h,d/2.0,d/2.0,seg,False)
def alongX(h,d,x0,seg=48):
    return cylZ(h,d,seg).rotate([0,90,0]).translate([x0,0,SET_Z])  # +Z -> +X, abarca x0..x0+h

hex_circ=((NUT_AF+NUT_CLEAR)/2.0)/np.cos(np.radians(30))
body=cylZ(L,OD)
nut=cylZ(NUT_DEPTH+1.0,2*hex_circ,6).translate([0,0,L-NUT_DEPTH])  # d=2*circ -> hexagono
nut=cylZ(NUT_DEPTH+1.0,2*hex_circ,6).rotate([0,0,30]).translate([0,0,L-NUT_DEPTH])
clr=cylZ(CLEAR_BORE_H+1.0,CLEAR_BORE_D,64).translate([0,0,L-NUT_DEPTH-CLEAR_BORE_H])
bore=cylZ(BORE_DEPTH+1.0,BORE_D,64).translate([0,0,-1.0])
csk=Manifold.cylinder(1.6,BORE_D/2.0+1.2,BORE_D/2.0,48,False).translate([0,0,-0.01])

# --- alojamiento del prisionero, escalonado (de fuera a dentro) ---
pocket = alongX(OD/2.0+0.6-POCKET_FLOOR_R, POCKET_D, POCKET_FLOOR_R)        # avellanado Ø5
insert = alongX(INSERT_LEN, INSERT_HOLE_D, POCKET_FLOOR_R-INSERT_LEN)       # taladro inserto Ø3
boltcl = alongX(POCKET_FLOOR_R-INSERT_LEN+0.5, BOLT_CLEAR_D, -0.5)          # paso M2 hasta el eje

part = body - nut - clr - bore - csk - pocket - insert - boltcl

mg=part.to_mesh(); V=np.asarray(mg.vert_properties)[:,:3]; F=np.asarray(mg.tri_verts)
trimesh.Trimesh(vertices=V,faces=F,process=False).export('adaptador_motor_cepillo.stl')
r=trimesh.load('adaptador_motor_cepillo.stl'); r.merge_vertices()
print("watertight:",r.is_watertight,"| winding:",r.is_winding_consistent,
      "| vol cm3:",round(r.volume/1000,2),"| bbox:",np.round(r.bounds[1]-r.bounds[0],2))
print("Hexagono AF efectivo (mm):",round(2*hex_circ*np.cos(np.radians(30)),2))
print("Pared efectiva en prisionero (mm):",round(POCKET_FLOOR_R-BORE_D/2.0,2))
print("Punta tornillo M2x4 llega a radio (mm):",round(POCKET_FLOOR_R-4.0,2)," (eje en",round(BORE_D/2.0,2),")")
