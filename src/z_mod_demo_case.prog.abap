*&---------------------------------------------------------------------*
*& Report Z_MOD_DEMO_CASE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_demo_case.

DATA: lv_variable TYPE i VALUE 1.
CASE lv_variable.
  WHEN 1.
    WRITE: 'Hola soy lv_variable y mi valor es uno'.
  WHEN 2.
    WRITE: 'Hola soy lv_variable y mi valor es dos'.
  WHEN OTHERS.
    WRITE: 'Hola soy lv_variable y mi valor es diferente a uno y dos'.
ENDCASE.
