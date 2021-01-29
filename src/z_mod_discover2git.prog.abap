*&---------------------------------------------------------------------*
*& Report Z_MOD_DISCOVER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_discover2git.

INCLUDE z_mod_discover2git_top.
INCLUDE z_mod_discover2git_cls.
INCLUDE z_mod_discover2git_sel.
INCLUDE z_mod_discover2git_frm.

" https://github.com/tricktresor/transfer_abapgit
" https://blogs.sap.com/2020/11/24/data-exchange-with-your-github-repository-using-abapgit/

INITIALIZATION.
  PERFORM initialization.

AT SELECTION-SCREEN OUTPUT.
  PERFORM sel_scree_output.

START-OF-SELECTION.

  gr_source = cl_ci_source_include=>create( p_name = p_prog ).
  CREATE OBJECT gr_scan EXPORTING p_include = gr_source.

  DATA(lcl_scan) = NEW zcl_drm_scan( ).
  lcl_scan->program = p_prog.

  DATA(lp_show) = p_show.
  IF gv_type = 'GIT'.
    lp_show = abap_false.
  ENDIF.

  CALL METHOD lcl_scan->scan_object
    EXPORTING
      li_show_info = lp_show
      li_onlyz     = p_onlyz
    IMPORTING
      r_it_hier    = r_it_hier.


  IF gv_type = 'GIT'.
    PERFORM generate_csv_from_itab  CHANGING lt_csv.
    PERFORM generate_xml_from_itab  CHANGING itab_in_xml.
    PERFORM generate_json_from_itab CHANGING itab_in_json.
    PERFORM push_file_to_repo.
  ENDIF.
