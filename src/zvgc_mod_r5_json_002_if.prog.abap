*&---------------------------------------------------------------------*
*& Include          ZVGC_MOD_R5_JSON_002_IF
*&---------------------------------------------------------------------*

DATA: lv_evaluacion TYPE string.

IF lv_evaluacion = 'IF'.
***** [statement_blockif]
ELSEIF lv_evaluacion = 'ELSEIF'.
***** [statement_blockelseif]
ELSEIF sy-subrc = 0.
***** [statement_blockelseif - sy-subrc]
ELSEIF sy-datum > sy-datlo.
***** [statement_blockelseif - sy-datum > sy-datlo]
ELSEIF lv_evaluacion = abap_true.
***** [statement_blockelseif - abap_true ]
ELSEIF NOT ( lv_evaluacion = abap_false ).
***** [statement_blockelseif - abap_true ]
ELSEIF lv_evaluacion = cl_abap_char_utilities=>cr_lf.
***** [statement_blockelseif - cl_abap_char_utilities=>cr_lf ]
ELSEIF NOT cl_demo_sap_gui=>check( ).
***** [statement_blockelseif - NOT cl_demo_sap_gui=>check( )]
ELSE.
***** [statement_blockelse]
  PERFORM if_in_if.
ENDIF.

IF lv_evaluacion = 'ON' AND lv_evaluacion = 'OFF'.
***** [statement_blockif]
ENDIF.
IF lv_evaluacion = 'ON' OR lv_evaluacion = 'OFF'.
***** [statement_blockif]
ENDIF.
IF ( lv_evaluacion = '1' OR lv_evaluacion = '2' )  AND ( lv_evaluacion = '3' OR lv_evaluacion = '4' ).
***** [statement_blockif]
ENDIF.

CHECK sy-subrc EQ 0.
CHECK NOT sy-datum < sy-dayst.
