// =====================================================================
//  Adaptador motor XD-3420 (punta roscada M8) -> cepillo de pulido
//  Lado motor:  bolsa hexagonal para 1 o 2 TUERCAS M8 (press-fit)
//  Lado cepillo: taladro eje 3,7 mm + INSERTO M2 de laton + tornillo M2x4
//  Imprimir DE PIE (eje Z), sin soportes.
// =====================================================================

/* [Cuerpo] */
OD            = 20;     // diametro exterior (mm)
L             = 41;     // longitud total (mm)

/* [Lado motor - tuerca M8] */
NUT_AF        = 13;     // tuerca M8 entre caras (mm)
NUT_CLEAR     = -0.10;  // AJUSTADO: AF efectivo 12.9 (press-fit). Sube si no entra.
NUT_DEPTH     = 13.5;   // 13.5 = caben 2 tuercas (la 2a de contratuerca)
CLEAR_BORE_D  = 8.6;    // alivio para la punta de la rosca del motor
CLEAR_BORE_H  = 3;

/* [Lado cepillo - eje 3,7 mm] */
SHAFT_D       = 3.7;
SHAFT_FIT     = 0.15;   // holgura del taladro del eje
BORE_DEPTH    = 20;

/* [Prisionero - inserto M2 laton OD3.2 x 3 + tornillo M2x4] */
SET_Z          = 8;     // altura del prisionero desde la base
POCKET_D       = 5.0;   // avellanado (acerca el inserto al eje y da paso al util)
POCKET_FLOOR_R = 5.7;   // radio de la cara del inserto (pared efectiva ~3.8 mm)
INSERT_HOLE_D  = 3.0;   // taladro para el inserto termofusible (OD 3.2)
INSERT_LEN     = 3.2;   // longitud inserto + holgura
BOLT_CLEAR_D   = 2.3;   // paso libre del tornillo M2 hasta el eje

/* [Calidad] */
$fn = 120;

BORE_D   = SHAFT_D + SHAFT_FIT;
hex_circ = ((NUT_AF + NUT_CLEAR)/2) / cos(30);

module nut_pocket(){
    translate([0,0,L-NUT_DEPTH]) rotate([0,0,30])
        cylinder(r=hex_circ, h=NUT_DEPTH+1, $fn=6);
}
module clear_bore(){
    translate([0,0,L-NUT_DEPTH-CLEAR_BORE_H])
        cylinder(d=CLEAR_BORE_D, h=CLEAR_BORE_H+1);   // solapa 1mm en la bolsa
}
module brush_bore(){
    translate([0,0,-1]) cylinder(d=BORE_D, h=BORE_DEPTH+1);
    translate([0,0,-0.01]) cylinder(d1=BORE_D+2.4, d2=BORE_D, h=1.5); // avellanado entrada
}
module setscrew_insert(){
    translate([0,0,SET_Z]) rotate([0,90,0]){   // +Z local -> +X global
        translate([0,0,POCKET_FLOOR_R])
            cylinder(d=POCKET_D, h=OD/2+0.6-POCKET_FLOOR_R);          // avellanado Ø5
        translate([0,0,POCKET_FLOOR_R-INSERT_LEN])
            cylinder(d=INSERT_HOLE_D, h=INSERT_LEN+0.01);             // taladro inserto Ø3
        translate([0,0,-0.5])
            cylinder(d=BOLT_CLEAR_D, h=POCKET_FLOOR_R-INSERT_LEN+0.5);// paso tornillo Ø2.3
    }
}

difference(){
    cylinder(d=OD, h=L);
    nut_pocket();
    clear_bore();
    brush_bore();
    setscrew_insert();
}
