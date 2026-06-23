// =====================================================================
//  Base 2-en-1 para la empuñadura del Dremel casero (uso horizontal)
//  - Cuna + cola de milano HEMBRA (desliza desde el frente al tope).
//  - Bandeja superior para el regulador PWM (medidas reales del usuario).
//  - Muesca para el mando + canal de cable hacia el motor.
//  Imprimir con la base apoyada (Z arriba), sin soportes. Relleno 12-15%.
// =====================================================================

/* [Empuñadura / cuna] */
ROUT = 29.2; CR = 29.7; Zc = 46;

/* [Base] */
BW = 84; BD = 120; BH = 46;

/* [Cola de milano hembra] */
CRADLE_Y0 = -5; CRADLE_Y1 = 72;
DT_TOP_W = 16.6; DT_BOT_W = 22.6; DTz_bot = 8.3; DTz_top = 17.3;

/* [Regulador PWM] (medidas reales) */
REG_X = 44;     // ancho de la bandeja (placa ~40 + holgura)
REG_Y = 34;     // fondo de la bandeja (~30 + holgura)
REG_DEPTH = 20; // alto util (componentes ~13 mm)
KNOB_D = 20;    // diametro del mando
KNOB_CL = 2;    // holgura de la muesca
KNOB_Z = 8;     // altura del eje del mando sobre el suelo de la bandeja

$fn = 128;
reg_yc = BD-6-REG_Y/2; reg_floor = BH-REG_DEPTH;

module base(){
  difference(){
    translate([-BW/2,0,0]) cube([BW,BD,BH]);
    translate([0,CRADLE_Y0,Zc]) rotate([-90,0,0]) cylinder(r=CR, h=CRADLE_Y1-CRADLE_Y0);
    hull(){
      translate([0,(CRADLE_Y0-1+CRADLE_Y1)/2,(DTz_bot+10.2)/2])
        cube([DT_BOT_W, CRADLE_Y1-CRADLE_Y0+2, 10.2-DTz_bot], center=true);
      translate([0,(CRADLE_Y0-1+CRADLE_Y1)/2,(12.8+DTz_top)/2])
        cube([DT_TOP_W, CRADLE_Y1-CRADLE_Y0+2, DTz_top-12.8], center=true);
    }
    // bandeja del regulador (abre arriba)
    translate([0,reg_yc, BH-REG_DEPTH/2+1]) cube([REG_X,REG_Y,REG_DEPTH+2],center=true);
    // muesca del mando (sale por la pared trasera)
    translate([0,BD-12,reg_floor+KNOB_Z]) rotate([-90,0,0]) cylinder(r=(KNOB_D+KNOB_CL)/2, h=16);
    // canal de cable + bajada vertical
    translate([0,0,9]) rotate([-90,0,0]) cylinder(r=5, h=BD);
    translate([0,reg_yc,9]) cylinder(r=4, h=REG_DEPTH+2);
    // 4 alojamientos para insertos M2 (tapa)
    for(p=[[-31,82],[31,82],[-31,112],[31,112]])
        translate([p[0],p[1],BH-4]) cylinder(d=3.0, h=5, $fn=48);
  }
}
base();
