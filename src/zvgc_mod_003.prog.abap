*&---------------------------------------------------------------------*
*& Report ZVGC_MOD_003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvgc_mod_003.

DATA titular  TYPE string.
DATA cantidad TYPE i.

titular = 'Titular'.
IF cantidad LT 0.
  cantidad = 0.
  IF titular = 'M.Rajoy'.
    cantidad = 10000.
  ENDIF.
ELSE.
  cantidad = 10.
ENDIF.
