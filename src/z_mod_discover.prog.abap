*&---------------------------------------------------------------------*
*& Report Z_MOD_DISCOVER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_discover.

DATA: lr_table  TYPE REF TO data,
      lr_wa     TYPE REF TO data,
      gr_scan   TYPE REF TO cl_ci_scan,
      gr_source TYPE REF TO cl_ci_source_include.
FIELD-SYMBOLS: <t> TYPE STANDARD TABLE,
               <w> TYPE c.

PARAMETERS: p_prog  LIKE trdir-name,
            p_onlyz TYPE abap_bool AS CHECKBOX.

START-OF-SELECTION.

  gr_source = cl_ci_source_include=>create( p_name = p_prog ).
  CREATE OBJECT gr_scan EXPORTING p_include = gr_source.



  DATA: r_it_hier TYPE zcl_drm_scan=>gtty_hier.

  DATA(lcl_scan) = NEW zcl_drm_scan( ).
  lcl_scan->program = p_prog.

  "* Lee la jerarquía
  CALL METHOD lcl_scan->scan_object
    EXPORTING
      li_show_info = abap_true
      li_onlyz     = p_onlyz
    IMPORTING
      r_it_hier    = r_it_hier.


  IF 1 = 2.
  ENDIF.
