*&---------------------------------------------------------------------*
*& Report Z_MOD_DEMO_IF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_demo_if.

DATA: lv_variable TYPE i VALUE 1.

IF lv_variable EQ 1.
  WRITE: 'Hola soy lv_variable y mi valor es uno'.
ELSEIF lv_variable EQ 2.
  WRITE: 'Hola soy lv_variable y mi valor es dos'.
ELSE.
  WRITE: 'Hola soy lv_variable y mi valor es diferente a uno y dos'.
ENDIF.

" Modelo persona normal no VGC...
IF 1 = 2.
ELSEIF 1 = 3.
ELSEIF 1 = 4.
ENDIF.

" Modelo CAD y VGC
IF 1 = 2.
ELSE.
  IF 1 = 3.
  ELSE.
    IF 1 = 4.
    ELSE.
    ENDIF.
  ENDIF.
ENDIF.

IF NOT 1 = 2 AND 1 = 3.
ENDIF.

IF NOT 1 = 2.
  IF 1 = 3.
    " Felicidades por su paciencia
  ENDIF.
ENDIF.
