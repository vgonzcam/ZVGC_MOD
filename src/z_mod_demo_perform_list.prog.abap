*&---------------------------------------------------------------------*
*& Report Z_MOD_DEMO_PERFORM_LIST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_demo_perform_list.

DATA n TYPE i.
" En llamada, como lista...
DO 2 TIMES.
  PERFORM sy-index OF subr_1 subr_2.
ENDDO.

" Alternativa...
DATA(subr) = 'DO_SOMETHING'.
DATA(prog) = sy-repid.
PERFORM (subr) IN PROGRAM (prog) IF FOUND.

FORM subr_1.
  cl_demo_output=>display( 'Doing something on FORM subr_1' ).
ENDFORM.

FORM subr_2.
  cl_demo_output=>display( 'Doing something on FORM subr_2' ).
ENDFORM.

FORM DO_SOMETHING.
  cl_demo_output=>display( 'Doing something on FORM DO_SOMETHING' ).
ENDFORM.
