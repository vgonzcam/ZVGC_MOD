*&---------------------------------------------------------------------*
*& Include          ZVGC_MOD_R5_JSON_002_LOOP
*&---------------------------------------------------------------------*


" LOOP - ENDLOOP
" DO   - ENDDO
" WHILE - ENDWHILE

DATA: scarr_tab TYPE SORTED TABLE OF scarr WITH UNIQUE KEY carrname.
DATA: lwa_scarr TYPE scarr.

SELECT * FROM scarr INTO TABLE @scarr_tab.

LOOP AT scarr_tab ASSIGNING FIELD-SYMBOL(<scarr_line>).
***** [statement_block ASSIGNING FIELD-SYMBOL(<scarr_line>)]
ENDLOOP.

LOOP AT scarr_tab INTO DATA(lv_scarr).
***** [statement_block INTO DATA(lv_scarr)]
ENDLOOP.

LOOP AT scarr_tab INTO lwa_scarr.
***** [statement_block INTO lwa_scarr]
ENDLOOP.

LOOP AT scarr_tab INTO lwa_scarr FROM 1 TO 2.
***** [statement_block INTO lwa_scarr FROM 1 to 2]
ENDLOOP.

LOOP AT scarr_tab INTO lwa_scarr WHERE carrid IS NOT INITIAL.
***** [statement_block INTO lwa_scarr WHERE CARRID is NOT INITIAL]
ENDLOOP.

LOOP AT scarr_tab INTO lwa_scarr WHERE carrid   IS NOT INITIAL
                               AND carrname IS NOT INITIAL.
***** [statement_block INTO lwa_scarr WHERE CARRID   is NOT INITIAL AND CARRNAME is NOT INITIAL]
ENDLOOP.

LOOP AT scarr_tab INTO lwa_scarr FROM 1 TO 2
                             WHERE carrid   IS NOT INITIAL
                               AND carrname IS NOT INITIAL.
***** [statement_block FROM 1 to 2 INTO lwa_scarr WHERE CARRID   is NOT INITIAL AND CARRNAME is NOT INITIAL]
ENDLOOP.
