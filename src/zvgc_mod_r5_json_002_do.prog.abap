*&---------------------------------------------------------------------*
*& Include          ZVGC_MOD_R5_JSON_002_DO
*&---------------------------------------------------------------------*

DATA(str_do) = 'xxx'.
DO.
***** [statement_block DO]
  str_do = str_do && str_do.
  IF strlen( str_do ) > 10000.
    EXIT.
  ENDIF.
ENDDO.

DO 10 TIMES.
***** [statement_block DO N TIMES]
ENDDO.
