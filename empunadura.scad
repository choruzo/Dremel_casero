// =====================================================================
//  Empuñadura (mango barril con abrazadera) para motor XD-3420
//  Sujeta el cuerpo Ø51 mm apretando un tornillo M4 (clamp tipo C).
//  Cola de milano inferior -> encaja deslizando en la base (2 en 1).
//  Imprimir DE PIE (eje Z), sin soportes.
// =====================================================================

/* [Motor] */
MOTOR_D = 51;     // diametro del cuerpo del motor (mm)
FIT     = 0.4;    // holgura del clamp (lo cierra el tornillo)

/* [Mango] */
WALL    = 3.5;    // espesor de pared
LEN     = 60;     // longitud del mango

/* [Abrazadera] */
SLIT    = 3;      // ancho de la ranura de la C
EAR_X   = 11.5;   // ancho de cada orejeta
EAR_OUT = 12;     // cuanto sobresalen las orejetas
EAR_Z0  = 0;      // base de las orejetas (0 = sin voladizo)
EAR_Z1  = 46;     // alto de las orejetas
M4_CLEAR = 4.3;   // paso del tornillo M4
M4_NUT_AF = 7;    // tuerca M4 entre caras
M4_NUT_CL = 0.4;

/* [Cola de milano - dock] */
DT_TOP_W = 16;    // ancho en la raiz
DT_BOT_W = 22;    // ancho en la punta (mas ancho = bloquea)
DT_H     = 8;     // altura

$fn = 128;

RIN  = (MOTOR_D+FIT)/2;
ROUT = RIN + WALL;
BOLT_Y = ROUT + 6;
BOLT_Z = (EAR_Z0+EAR_Z1)/2;

module body(){
    difference(){
        cylinder(r=ROUT, h=LEN);
        translate([0,0,-1]) cylinder(r=RIN, h=LEN+2);
    }
}
module ears(){
    for(s=[-1,1])
        translate([s*(SLIT/2+EAR_X/2), (RIN+ROUT+EAR_OUT)/2, (EAR_Z0+EAR_Z1)/2])
            cube([EAR_X, (ROUT+EAR_OUT)-RIN, EAR_Z1-EAR_Z0], center=true);
}
module dovetail(){
    linear_extrude(LEN)
        polygon([[-DT_BOT_W/2,-(ROUT+DT_H)],[DT_BOT_W/2,-(ROUT+DT_H)],
                 [DT_TOP_W/2,-RIN+1],[-DT_TOP_W/2,-RIN+1]]);
}
module cuts(){
    // ranura de la C
    translate([0,(RIN-2+ROUT+EAR_OUT+5)/2, LEN/2])
        cube([SLIT,(ROUT+EAR_OUT+5)-(RIN-2),LEN+4],center=true);
    // tornillo M4: paso desde -X
    translate([0,BOLT_Y,BOLT_Z]) rotate([0,90,0])
        translate([0,0,-(ROUT+EAR_OUT+1)])
            cylinder(d=M4_CLEAR, h=(ROUT+EAR_OUT+1)+(SLIT/2+EAR_X));
    // tuerca M4 cautiva en la orejeta +X
    translate([0,BOLT_Y,BOLT_Z]) rotate([0,90,0])
        translate([0,0,(SLIT/2+EAR_X)-EAR_X*0.55])
            cylinder(r=(M4_NUT_AF+M4_NUT_CL)/2/cos(30), h=EAR_X*0.55+0.1, $fn=6);
}
difference(){
    union(){ body(); ears(); dovetail(); }
    cuts();
}
