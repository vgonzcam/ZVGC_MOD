*&---------------------------------------------------------------------*
*& Include          ZVGC_MOD_R5_JSON_002_CASE
*&---------------------------------------------------------------------*

DATA: lv_variable TYPE c LENGTH 1 VALUE 'X'.
DATA: lv_x        TYPE c LENGTH 1 VALUE 'X'.

CASE sy-ucomm.
  WHEN 'BACK'.
***** [statement_case-when]
  WHEN 'CANCEL'.
***** [statement_case-when]
  WHEN 'EXIT'.
***** [statement_case-when]
  WHEN OTHERS.
***** [statement_case-when others]
ENDCASE.

CASE 'X'.
  WHEN: lv_variable, lv_x.
***** [statement_case-when -> Multiple]
  WHEN OTHERS.
***** [statement_case-when others]
ENDCASE.
