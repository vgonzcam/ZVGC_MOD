*&---------------------------------------------------------------------*
*& Include          ZVGC_MOD_R5_JSON_002_DO
*&---------------------------------------------------------------------*

DATA(str) = 'xxx'.
DO.
***** [statement_block DO]
  str = str && str.
  IF strlen( str ) > 10000.
    EXIT.
  ENDIF.
ENDDO.

DO 10 TIMES.
***** [statement_block DO N TIMES]
ENDDO.
