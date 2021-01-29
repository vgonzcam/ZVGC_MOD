*&---------------------------------------------------------------------*
*& Report Z_MOD_DISCOVER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_discover2git.

DATA: gr_scan   TYPE REF TO cl_ci_scan,
      gr_source TYPE REF TO cl_ci_source_include.
PARAMETERS: p_prog  LIKE trdir-name,
            p_onlyz TYPE abap_bool AS CHECKBOX,
            p_show  TYPE abap_bool AS CHECKBOX.
PARAMETERS: p_repo TYPE zabapgit-value OBLIGATORY MATCHCODE OBJECT zabapgit_repo.

PARAMETERS: p_gitusr TYPE string DEFAULT '' LOWER CASE OBLIGATORY.
PARAMETERS: p_gitpwd TYPE string            LOWER CASE OBLIGATORY.


DATA: lt_csv       TYPE stringtab,
      itab_in_xml  TYPE string,
      itab_in_json TYPE STring.

START-OF-SELECTION.

  gr_source = cl_ci_source_include=>create( p_name = p_prog ).
  CREATE OBJECT gr_scan EXPORTING p_include = gr_source.



  DATA: r_it_hier TYPE zcl_drm_scan=>gtty_hier.

  DATA(lcl_scan) = NEW zcl_drm_scan( ).
  lcl_scan->program = p_prog.

  "* Lee la jerarquía
  CALL METHOD lcl_scan->scan_object
    EXPORTING
      li_show_info = p_show
      li_onlyz     = p_onlyz
    IMPORTING
      r_it_hier    = r_it_hier.


  PERFORM generate_csv_from_itab  CHANGING lt_csv.
  PERFORM generate_xml_from_itab  CHANGING itab_in_xml.
  PERFORM generate_json_from_itab CHANGING itab_in_json.
  PERFORM push_file_to_repo.







  IF 1 = 2.
  ENDIF.
*&---------------------------------------------------------------------*
*& Form generate_csv_from_itab
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LT_CSV
*&---------------------------------------------------------------------*
FORM generate_csv_from_itab  CHANGING p_lt_csv TYPE stringtab.

  " Alternativa...
  " https://codezentrale.de/tag/cl_icf_csv/

  DATA lo_csv_converter TYPE REF TO if_dmc_ui_tab_to_csv_converter.
  DATA lo_tab_to_csv_conv_conf TYPE REF TO if_dmc_ui_tab_to_csv_conv_conf.
  DATA lo_structdescr TYPE REF TO cl_abap_structdescr.
  DATA lo_tabledescr TYPE REF TO cl_abap_tabledescr.
  DATA lt_fields_to_separate TYPE cl_abap_structdescr=>component_table.
  FIELD-SYMBOLS <ls_field_to_separate> TYPE abap_componentdescr.
  DATA lv_columns TYPE string.
  DATA lv_separator TYPE char01.

  CREATE OBJECT lo_tab_to_csv_conv_conf TYPE cl_dmc_ui_tab_to_csv_conv_conf.
  lo_tab_to_csv_conv_conf->set_add_no_column_names( ).

  CREATE OBJECT lo_csv_converter TYPE cl_dmc_ui_tab_to_csv_converter.
  p_lt_csv = lo_csv_converter->convert( it_table_to_convert = r_it_hier
                                        io_tab_to_csv_conv_conf = lo_tab_to_csv_conv_conf ).

  " Creamos la linea de cabecera...
  lo_tabledescr ?= cl_abap_typedescr=>describe_by_data( r_it_hier ).
  lo_structdescr ?= lo_tabledescr->get_table_line_type( ).
  lt_fields_to_separate = lo_structdescr->get_components( ).

  lv_separator = lo_tab_to_csv_conv_conf->get_separator( ).

  LOOP AT lt_fields_to_separate ASSIGNING <ls_field_to_separate>.
    IF lv_columns IS INITIAL .
      lv_columns = <ls_field_to_separate>-name.
    ELSE.
      CONCATENATE lv_columns <ls_field_to_separate>-name INTO lv_columns SEPARATED BY lv_separator.
    ENDIF.
  ENDLOOP.

  " Hacemos efectiva la nueva linea...
  INSERT lv_columns INTO p_lt_csv INDEX 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form generate_xml_from_itab
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- ITAB_IN_XML
*&---------------------------------------------------------------------*
FORM generate_xml_from_itab  CHANGING p_itab_in_xml TYPE string.

  DATA(o_writer_itab_xml) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10
                                                           encoding = 'UTF8'
                                                           no_empty_elements = abap_true ).
  CALL TRANSFORMATION id SOURCE values = r_it_hier RESULT XML o_writer_itab_xml.
  DATA(itab_xml) = cl_abap_codepage=>convert_from( o_writer_itab_xml->get_output( ) ).

  p_itab_in_xml = itab_xml.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form generate_json_from_itab
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- ITAB_IN_JSON
*&---------------------------------------------------------------------*
FORM generate_json_from_itab  CHANGING p_itab_in_json TYPE string.

  DATA(o_writer_itab_json) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json
                                                           encoding = 'UTF8'
                                                           no_empty_elements = abap_true  ).
  CALL TRANSFORMATION id SOURCE values = r_it_hier RESULT XML o_writer_itab_json.
  DATA(itab_json) = cl_abap_codepage=>convert_from( o_writer_itab_json->get_output( ) ).

  p_itab_in_json = itab_json.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form push_file_to_repo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM push_file_to_repo .

  DATA(lv_data) = zcl_abapgit_convert=>string_to_xstring_utf8( itab_in_json ).
  DATA(lv_filename) = |{ p_prog }.json|.


  DATA(lo_online) = CAST zcl_abapgit_repo_online( zcl_abapgit_repo_srv=>get_instance( )->get( p_repo ) ).
  DATA(lt_files) = lo_online->get_files_remote( ).


  READ TABLE lt_files WITH KEY filename = lv_filename data = lv_data TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    DATA(ls_comment) = VALUE zif_abapgit_definitions=>ty_comment(
      committer-name  = sy-uname
      comment         = 'File Updated' ).

  ELSE.
    ls_comment = VALUE zif_abapgit_definitions=>ty_comment(
      committer-name  = sy-uname
      comment         = 'File Created' ).
  ENDIF.

  DATA(lo_stage) = NEW zcl_abapgit_stage(
      iv_merge_source = lo_online->get_current_remote( ) ).

  lo_stage->add(
    iv_path     = CONV #( '/' )
    iv_filename = lv_filename
    iv_data     = lv_data ).

  lo_online->push(
    EXPORTING
      is_comment = ls_comment
      io_stage   = lo_stage   ).


ENDFORM.

FORM password_popup
        USING iv_repo_url
        CHANGING cv_user cv_pass.
  cv_user = p_gitusr.
  cv_pass = p_gitpwd.
ENDFORM.
