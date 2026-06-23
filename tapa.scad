// =====================================================================
//  Tapa para la bandeja del regulador (se atornilla a la base)
//  Fijacion: 4x inserto M2 (en la base) + tornillo M2x4 avellanado.
//  Imprimir plana (avellanados hacia arriba), sin soportes.
// =====================================================================
LID_X = 70;  LID_Y = 42;  LID_T = 3;   // tamaño y espesor de la tapa
lid_yc = 97;                            // centro en Y (coincide con la bandeja)
CB_D = 4.2;  CB_DEPTH = 2;              // avellanado para la cabeza M2
CLR_D = 2.4;                            // paso del vastago M2
WIRE_D = 10;                            // muesca para el cable de alimentacion
ins_pos = [[-31,82],[31,82],[-31,112],[31,112]];
$fn = 64;

difference(){
    translate([-LID_X/2, lid_yc-LID_Y/2, 0]) cube([LID_X,LID_Y,LID_T]);
    for(p=ins_pos){
        translate([p[0],p[1],-1]) cylinder(d=CLR_D, h=LID_T+2);          // paso
        translate([p[0],p[1],LID_T-CB_DEPTH]) cylinder(d=CB_D, h=CB_DEPTH+1); // avellanado
    }
    translate([0,lid_yc+LID_Y/2,-1]) cylinder(d=WIRE_D, h=LID_T+2);      // muesca cable
}
