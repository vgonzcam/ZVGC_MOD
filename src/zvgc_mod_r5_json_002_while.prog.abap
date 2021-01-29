*&---------------------------------------------------------------------*
*& Include          ZVGC_MOD_R5_JSON_002_WHILE
*&---------------------------------------------------------------------*

DATA itab TYPE TABLE OF i.
DATA: a TYPE i.

WHILE a <> 8.
***** [statement_block WHILE]
  a = a + 1.
ENDWHILE.

WHILE lines( itab ) < 100.
***** [statement_block WHILE]
  itab = VALUE #( BASE itab ( sy-index ) ).
ENDWHILE.
