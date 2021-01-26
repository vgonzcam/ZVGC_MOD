*&---------------------------------------------------------------------*
*& Report Z_MOD_DISCOVER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_discover_old.

DATA: lr_table  TYPE REF TO data,
      lr_wa     TYPE REF TO data,
      gr_scan   TYPE REF TO cl_ci_scan,
      gr_source TYPE REF TO cl_ci_source_include.
FIELD-SYMBOLS: <t> TYPE STANDARD TABLE,
               <w> TYPE c.

PARAMETERS: p_prog  LIKE trdir-name,
            p_incl  TYPE abap_bool AS CHECKBOX,
            p_onlyz TYPE abap_bool AS CHECKBOX.

START-OF-SELECTION.

  gr_source = cl_ci_source_include=>create( p_name = p_prog ).
  CREATE OBJECT gr_scan EXPORTING p_include = gr_source.

  IF p_incl IS NOT INITIAL.

    CREATE DATA lr_wa TYPE c LENGTH 40.
    ASSIGN      lr_wa->* TO <w>.
    CREATE DATA lr_table LIKE STANDARD TABLE OF <w>.
    ASSIGN      lr_table->* TO <t>.
    LOAD REPORT p_prog PART 'INCL' INTO <t>.

    WRITE: p_prog, 'Part', 'INCL'.                          "#EC NOTEXT

    LOOP AT <t> INTO <w>.
      WRITE / <w>.
    ENDLOOP.

  ENDIF.

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


*****
*****  DATA tree         TYPE REF TO cl_abap_syntax_tree.
*****  DATA grammar TYPE REF TO cl_rnd_grammar.
*****
*****
*****  tree = cl_abap_syntax_tree=>create(
*****    stmnts = gr_scan->statements
*****    tokens = gr_scan->tokens
*****    stmt_index_from  = 0
*****    stmt_index_to    = 0
*****    with_level_nodes = ' '
*****    discard_stream   = boolc( 'X' IS INITIAL )
*****    grammar = grammar
*****).
*****
*****
*****  DATA nodes        TYPE cl_abap_syntax_tree=>t_nodeinfotab.
*****  DATA rule_props   TYPE cl_abap_syntax_tree=>t_ruleprop_filter.
*****
*****  rule_props-incl_op      =                              'O'.
*****  rule_props-excl_op         =                             'O'.
*****  rule_props-inclusive       =                              '08'.
*****  rule_props-exclusive       =                              '00'.
*****
*****
*****
*****  nodes = tree->get_nodes( node_index   = 0
*****                            axis         = 3
*****                            filter_mode  = 1
*****                            rule_props   = rule_props
*****                          ).
*****
*****
*****
*****  data: l_parser                  type ref to cl_aci_parser,
*****         l_nodes                   type aci_astnodes.
*****
*****
*****   create object l_parser.
*****   l_parser->parse_program(
*****              exporting
*****                progname = p_prog
*****                mode     = 1
*****              importing
*****                error    = error ).
