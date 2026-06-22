# Dremel casero — Adaptador motor → cepillo de pulido

Proyecto: convertir un motor DC 12 V en una herramienta rotativa tipo Dremel para
**pulir piezas impresas en 3D (PLA)**, mediante una pieza impresa que conecta la punta
roscada del motor con accesorios de pulido de eje fino.

_Última actualización: 2026-06-22_

---

## 1. Componentes de partida

### Motor — XD-3420 (DC, imán permanente)
| Dato | Valor |
|---|---|
| Tensión | 12 V (también admite 24 V) |
| Velocidad sin carga | ~3500 rpm @12 V (≈7000 @24 V) |
| Potencia | ~30 W |
| Eje liso | Ø3 mm |
| **Punta roscada** | **M8 macho, ~13 mm de largo** |
| Extra | agujero transversal en el eje (del diseño original, no se usa aquí) |

Nota: ~3500 rpm es una velocidad **baja**, lo cual es bueno para pulir PLA (menos
riesgo de derretir el plástico por fricción).

### Cepillo de pulido
- Cepillo redondo (cup brush) con **eje central Ø3,7 mm × 42 mm de largo**.

### Tornillería
- **Tuerca M8** estándar (13 mm entre caras) — el usuario ya la tiene.
- **Insertos M2 de latón** termofusibles: OD 3,2 mm × 3 mm de largo (kit 55 uds).
- **Tornillos M2 × 4 mm** (van con los insertos).

---

## 2. Concepto de la solución

No existe un modelo comercial/online que encaje con estas medidas concretas
(M8 → eje 3,7 mm), así que se diseña un **adaptador a medida**.

Estrategia elegida (la más fiable):
- **Lado motor:** alojamiento **hexagonal para una tuerca M8 metálica cautiva**.
  La rosca que aguanta el motor es de **acero**, no de PLA → mucho más resistente.
  La bolsa es profunda (13,5 mm) para alojar **1 o 2 tuercas** (la 2.ª de contratuerca
  contra las vibraciones).
- **Lado cepillo:** taladro para el eje de 3,7 mm + **prisionero lateral** que lo fija.
  Evolución: de prisionero M3 autorroscante en PLA → a **inserto M2 de latón + tornillo
  M2×4** (rosca metálica, más duradera para cambiar de accesorio).

---

## 3. Parámetros del diseño (versión actual)

Archivo paramétrico: `adaptador_motor_cepillo.scad` (OpenSCAD) y `adaptador.py` (Python/trimesh).

| Parámetro | Valor | Descripción |
|---|---|---|
| `OD` | 20 mm | diámetro exterior del cuerpo |
| `L` | 41 mm | longitud total |
| `NUT_AF` | 13 mm | tuerca M8 entre caras (nominal) |
| `NUT_CLEAR` | **−0,10 mm** | → AF efectivo **12,9 mm** (press-fit) |
| `NUT_DEPTH` | 13,5 mm | profundidad bolsa (1–2 tuercas) |
| `CLEAR_BORE_D / _H` | 8,6 / 3 mm | alivio para la punta de rosca del motor |
| `SHAFT_D` | 3,7 mm | eje del cepillo |
| `SHAFT_FIT` | 0,15 mm | → taladro del eje **3,85 mm** |
| `BORE_DEPTH` | 20 mm | profundidad de sujeción del eje |
| `SET_Z` | 8 mm | altura del prisionero desde la base |
| `POCKET_D` | 5,0 mm | avellanado del prisionero |
| `POCKET_FLOOR_R` | 5,7 mm | radio de la cara del inserto (pared efectiva ~3,8 mm) |
| `INSERT_HOLE_D` | 3,0 mm | taladro para inserto M2 (OD 3,2) |
| `INSERT_LEN` | 3,2 mm | longitud inserto + holgura |
| `BOLT_CLEAR_D` | 2,3 mm | paso del tornillo M2 hasta el eje |

Comprobaciones: malla cerrada (`watertight`), pared central entre taladros 4,5 mm,
pared lateral de la tuerca 2,2 mm, la punta del M2×4 alcanza el eje (~0,2 mm de apriete).

---

## 4. Lista de materiales (BOM)

- 1× adaptador impreso (PLA, o PETG si hay calor).
- 1–2× tuerca M8.
- 1× inserto M2 de latón (OD 3,2 × 3 mm).
- 1× tornillo M2×4 (prisionero). *Recomendado tener M2×5/×6 por si falta apriete.*

---

## 5. Impresión

- **Orientación:** de pie (eje Z vertical), boca de la tuerca hacia arriba → sin soportes.
- **Material:** PLA para empezar; **PETG** si se nota reblandecimiento por calor.
- **Perímetros:** 3–4. **Relleno:** 40–60 % (pieza que gira → maciza y equilibrada).
- **Altura de capa:** 0,16–0,20 mm.

---

## 6. Montaje

1. Meter la(s) **tuerca(s) M8** a presión en el hexágono (lado motor).
2. **Enroscar el adaptador** en la punta M8 del motor (apretar a mano).
3. Instalar el **inserto M2** de latón: calentarlo y empujarlo en el taladro Ø3
   (queda hundido dentro del avellanado).
4. **Insertar el eje del cepillo** (Ø3,7) por el otro extremo.
5. Apretar el **tornillo M2×4** contra el eje para fijarlo.

**Sentido de giro:** la rosca es a derechas; asegurarse de que el motor gire en el
sentido que *aprieta* el adaptador. Si gira al revés: invertir polaridad, usar la 2.ª
tuerca de contratuerca, o una gota de fijador de roscas.

**Aviso PLA + calor:** trabajar a tirones, sin forzar; el PLA reblandece >60 °C.

---

## 7. Registro de cambios

- **v0.1** — Diseño inicial. Adaptador M8 (tuerca cautiva) → eje 3,7 mm con prisionero
  M3 autorroscante. STL generado con trimesh.
- **v0.2** — Ajuste tras leer specs reales del motor (rosca M8 de 13 mm): bolsa de
  tuerca a 13,5 mm (cabe 2.ª tuerca de contratuerca), L=41 mm.
- **v0.3** — **Bugfix STL:** el taladro del prisionero atravesaba por completo el eje
  (booleana de trimesh con caras coincidentes → malla no estanca). Reconstruido con
  **manifold3d**: malla limpia y cerrada; prisionero ahora entra por **un solo lado**.
- **v0.4 (actual)** — Tras impresión preliminar OK:
  - Tuerca: `NUT_CLEAR` −0,10 → AF 12,9 mm (press-fit, antes entraba holgada).
  - Prisionero: cambio a **inserto M2 de latón + tornillo M2×4**, con alojamiento
    escalonado (avellanado Ø5 → inserto Ø3 → paso Ø2,3) para que el tornillo corto
    alcance el eje.

---

## 8. Pendiente / ideas futuras

- [ ] Confirmar que la tuerca M8 enrosca bien en la punta del motor (validar que es M8).
- [ ] Probar v0.4 impresa: ajuste del inserto M2 y apriete del tornillo.
- [ ] Afinar `INSERT_HOLE_D` (2,9–3,1) según el agarre del inserto.
- [ ] Valorar tornillo M2×5/×6 si el M2×4 queda corto de apriete.
- [ ] (Opcional) Empuñadura/soporte para sujetar el motor en la mano.
- [ ] (Opcional) Variante con rosca M8 impresa directamente (sin tuerca).

---

## 9. Archivos del proyecto

- `adaptador_motor_cepillo.stl` — modelo listo para imprimir (versión actual).
- `adaptador_motor_cepillo.scad` — fuente paramétrica para OpenSCAD.
- `adaptador.py` — fuente paramétrica en Python (trimesh).
- `build_manifold.py` — generador limpio con manifold3d (referencia).
- `adaptador_vista_previa.png` — render exterior + sección.
- `adaptador_inserto_M2_cortes.png` — cortes de verificación del prisionero.
- `Imagen_motor.png`, `Imagen_motor1.png` — fotos/specs del motor XD-3420.
