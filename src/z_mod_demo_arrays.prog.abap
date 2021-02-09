*&---------------------------------------------------------------------*
*& Report Z_MOD_DEMO_ARRAYS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_MOD_DEMO_ARRAYS.

DATA: BEGIN OF reg_datos, "estructura
        nombre TYPE char35,
        tlfno  TYPE char2.
DATA: END OF reg_datos.

DATA: t_tabla1 LIKE TABLE OF reg_datos. "tabla

TYPES:BEGIN OF dat_pers, "TYPE
        nombre TYPE char35,
        tlfno  TYPE char2,
      END OF dat_pers.

TYPES: tp_persontab  TYPE TABLE OF dat_pers. "TIPO TABLA

DATA: t_tabla2 TYPE TABLE OF dat_pers, "TABLA DEL TIPO ...
      t_tabla3 TYPE tp_persontab. " TIPO DEL TIPO TABLA


DATA: lv_array TYPE dat_pers. "variable de tipo array


CLEAR reg_datos.
reg_datos-nombre = 'ana'.
reg_datos-tlfno = '61333'.
APPEND reg_datos TO t_tabla1.

CLEAR reg_datos.
reg_datos-nombre = 'luis'.
APPEND reg_datos TO t_tabla1.

CLEAR lv_array.
lv_array-nombre = 'MARIA'.
APPEND lv_array TO t_tabla2.

CLEAR lv_array.
lv_array-nombre = 'LUISA'.
reg_datos-tlfno = '61333'.
APPEND lv_array TO t_tabla2.


CLEAR lv_array.
lv_array-nombre = 'AITOR'.
APPEND lv_array TO t_tabla3.

CLEAR lv_array.
lv_array-nombre = 'SANTI'.
reg_datos-tlfno = '61333'.
APPEND lv_array TO t_tabla3.
