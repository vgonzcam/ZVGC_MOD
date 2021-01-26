*&---------------------------------------------------------------------*
*& Report Z_MOD_GET_POSTMAN_BODY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_get_postman_body.



PARAMETERS: p_prog TYPE trdir-name.

DATA: lit_hier   TYPE zcl_drm_scan=>gtty_hier.
DATA: lit_source TYPE zcl_drm_scan=>gtty_source.
DATA: lv_source  TYPE zcl_drm_scan=>gty_source.
DATA: lv_code    TYPE string.


DATA(lcl_scan) = NEW zcl_drm_scan( ).
lcl_scan->program = p_prog.

"* Lee la jerarquía
CALL METHOD lcl_scan->scan_object
  EXPORTING
    li_show_info = abap_false
  IMPORTING
    r_it_hier    = lit_hier.

IF lit_hier IS NOT INITIAL.
  LOOP AT lit_hier ASSIGNING FIELD-SYMBOL(<hier>).

    DATA: gr_source TYPE REF TO cl_ci_source_include.

    gr_source = cl_ci_source_include=>create( p_name = <hier>-name ).
    cl_demo_output=>begin_section( <hier>-name ).

    lv_source-name = <hier>-name.
    LOOP AT gr_source->lines ASSIGNING FIELD-SYMBOL(<line>).

      INSERT INITIAL LINE INTO TABLE lv_source-source ASSIGNING FIELD-SYMBOL(<src>).
      <src> = <line> && '\n'.
      lv_code = lv_code && <src>.

    ENDLOOP.
    cl_demo_output=>write_text( lv_code ).

    INSERT INITIAL LINE INTO TABLE lit_source ASSIGNING FIELD-SYMBOL(<source>).
    <source> = lv_source.
    CLEAR lv_source.

    gr_source->clear( ).
    UNASSIGN <source>.
    UNASSIGN <src>.

    clear lv_code.
  ENDLOOP.

  IF lit_source IS NOT INITIAL.


    cl_demo_output=>display( ).

  ENDIF.

ENDIF.
