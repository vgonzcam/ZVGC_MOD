*&---------------------------------------------------------------------*
*& INCLUDE          ZVGC_MOD_002_1A
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& FORM ZVGC_MOD_002_1A
*&---------------------------------------------------------------------*
*& TEXT
*&---------------------------------------------------------------------*
*& -->  P1        TEXT
*& <--  P2        TEXT
*&---------------------------------------------------------------------*
FORM zvgc_mod_002_1a .

  data: lit_mara TYPE STANDARD TABLE OF mara.

  IF sy-repid = 'ZVGC_MOD_002_1A'.
  ENDIF.

  LOOP AT lit_mara ASSIGNING FIELD-SYMBOL(<mara>).
    IF <mara>-matnr CP 'INICIO*'.
      write: 'Estas en ZVGC_MOD_002_1A - LOOP - IF'.
    ENDIF.
  ENDLOOP.
ENDFORM.
