*&---------------------------------------------------------------------*
*& Include          ZVGC_MOD_R5_JSON_002_IF_IND
*&---------------------------------------------------------------------*


IF 1 = 1.
  IF 2 = 2.
    PERFORM if_in_if.
  ENDIF.
ENDIF.
*&---------------------------------------------------------------------*
*& Form if_in_if
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM if_in_if .
  IF 'IFIF' = 'BETWEENBETWEEN'.
  ENDIF.
ENDFORM.
