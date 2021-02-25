*&---------------------------------------------------------------------*
*& Report Z_MOD_R5_EXPORT_IMPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_r5_export_import.

DATA: gv_value TYPE char40.

gv_value = 'Z_MOD_EXPORT'.

CALL FUNCTION 'Z_MOD_EXPORT'
  EXPORTING
    i_value = gv_value.

CLEAR gv_value.

CALL FUNCTION 'Z_MOD_IMPORT'
  IMPORTING
    e_value = gv_value.

WRITE: /, gv_value.
