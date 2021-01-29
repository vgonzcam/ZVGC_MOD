class ZCL_DRM_SCAN definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF gty_hier,
        name    TYPE c LENGTH 40,
        type    TYPE seu_obj,
        parent  TYPE c LENGTH 100,
        level   TYPE c LENGTH 4,
        details TYPE seocpdname,
      END OF gty_hier .
  types:
    gtty_hier TYPE STANDARD TABLE OF gty_hier .
  types:
    BEGIN OF gty_source,
        name   TYPE c LENGTH 40,
        source TYPE sci_include,
      END OF gty_source .
  types:
    gtty_source TYPE STANDARD TABLE OF gty_source .

  data PROGRAM type SOBJ_NAME .

  methods PROGRAM_SEARCH
    importing
      !UV_PROG type SOBJ_NAME
    changing
      !CIT_HIER type GTTY_HIER .
  methods RECURSIVE_SEARCH
    importing
      !UV_TYPE type SEU_OBJ
      !UV_NAME type SOBJ_NAME
    changing
      !CV_NUMB type I
      !CIT_HIER type GTTY_HIER
    exceptions
      TYPE_NOT_FOUND .
  methods SCAN_OBJECT
    importing
      !LI_SHOW_INFO type ABAP_BOOL default ABAP_TRUE
      !LI_ONLYZ type ABAP_BOOL default ABAP_TRUE
    exporting
      value(R_IT_HIER) type ZCL_DRM_SCAN=>GTTY_HIER .
  methods GET_INCLUDES
    importing
      !UV_PROG type SOBJ_NAME
    changing
      !CIT_HIER type GTTY_HIER .
  methods GET_PROG_FROM_CLASS
    importing
      !CIFNAME type SEOCLSNAME
    exporting
      !PROGNAME type PROGNAME .
  methods GET_PROG_FROM_IF
    importing
      !IFNAME type SEOCLSNAME
    exporting
      !PROGNAME type PROGNAME .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS ZCL_DRM_SCAN IMPLEMENTATION.


  METHOD get_includes.

    FIELD-SYMBOLS: <t> TYPE STANDARD TABLE,
                   <w> TYPE c.
    DATA: lr_table TYPE REF TO data,
          lr_wa    TYPE REF TO data.

    CREATE DATA lr_wa TYPE c LENGTH 40.
    ASSIGN      lr_wa->* TO <w>.
    CREATE DATA lr_table LIKE STANDARD TABLE OF <w>.
    ASSIGN      lr_table->* TO <t>.

    LOAD REPORT uv_prog PART 'INCL' INTO <t>.

    LOOP AT <t> INTO <w>.
      IF <w>(1) = 'Z' OR <w>(1) = 'Y'.
        INSERT INITIAL LINE INTO TABLE cit_hier ASSIGNING FIELD-SYMBOL(<hier>).
        <hier>-name   = <w>.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_prog_from_class.
    progname = cl_oo_classname_service=>get_classpool_name( cifname ).
  ENDMETHOD.


  method GET_PROG_FROM_IF.
    progname = cl_oo_classname_service=>get_interfacepool_name( ifname ).
  endmethod.


  METHOD program_search.

    DATA: result   TYPE seoincl_t,
          result_i TYPE seop_methods_w_include.

    DATA(gr_source) = cl_ci_source_include=>create( p_name = uv_prog ).
    DATA(gr_scan) = NEW cl_ci_scan( p_include = gr_source ).
    " Vamos a modelizar la tbala de LEVELS como queremos:
    LOOP AT  gr_scan->levels ASSIGNING FIELD-SYMBOL(<level>).
      INSERT INITIAL LINE INTO TABLE cit_hier ASSIGNING FIELD-SYMBOL(<hier>).
      <hier>-level  = <level>-depth.
      <hier>-name   = <level>-name.

      CASE <level>-type.
        WHEN 'P'.
          <hier>-type = 'PROG'.
        WHEN 'C'.
          <hier>-type = 'CLASS'.
        WHEN OTHERS.
      ENDCASE.

      TRY .
          <hier>-parent = gr_scan->levels[ <level>-level ]-name.
          <hier>-details = result_i[ incname = <level>-name ]-cpdkey.
        CATCH cx_sy_itab_line_not_found.
        CATCH cx_root.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


  METHOD recursive_search.

    DATA: lt_data      TYPE STANDARD TABLE OF senvi,
          ls_ret       TYPE seocpdkey,
          lv_prog      TYPE program,
          lv_class     TYPE string,
          lt_prog_hier TYPE gtty_hier,
          ls_prog_hier TYPE gty_hier,
          lv_func      TYPE rs38l-name,
          lv_incl      TYPE rs38l-include,
          ls_mtdkey    TYPE seocpdkey.
    DATA: luv_type     TYPE seu_obj.


    cv_numb = cv_numb + 1.

    luv_type = uv_type.
    IF luv_type = 'DEVC'.
      luv_type = 'PROG'.
    ENDIF.

    CALL FUNCTION 'REPOSITORY_ENVIRONMENT_RFC'
      EXPORTING
        obj_type        = luv_type
        object_name     = uv_name
      TABLES
        environment_tab = lt_data.

    LOOP AT cit_hier ASSIGNING FIELD-SYMBOL(<ls_del>).
      DELETE lt_data WHERE object EQ <ls_del>-name AND
                           type   EQ <ls_del>-type.
    ENDLOOP.

    DATA:  lr_type   TYPE RANGE OF seu_obj.
    TYPES: lr_type_t TYPE RANGE OF seu_obj.

    lr_type = VALUE lr_type_t(
              LET s = 'I'
                  o = 'EQ'
              IN sign   = s
                 option = o
                 ( low = 'PROG' )
                 ( low = 'DEVC' ) ).

    IF uv_type IN lr_type.

      me->program_search(
        EXPORTING
          uv_prog  = uv_name
        CHANGING
          cit_hier = lt_prog_hier
             ).

    ENDIF.

    IF lt_data[] IS NOT INITIAL.
      LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<ls_incl>) WHERE type     EQ 'INCL'
                                                          AND call_obj NE ''.
        APPEND INITIAL LINE TO cit_hier ASSIGNING FIELD-SYMBOL(<ls_hier_incl>).

        TRY .
            CLEAR ls_prog_hier.
            ls_prog_hier = lt_prog_hier[ name = <ls_incl>-object ].

            CHECK ls_prog_hier-type IN lr_type.

            <ls_hier_incl>-name   = ls_prog_hier-name.
            <ls_hier_incl>-parent = ls_prog_hier-parent.
            <ls_hier_incl>-level  = ls_prog_hier-level - 1.
            <ls_hier_incl>-type   = <ls_incl>-type.
          CATCH cx_sy_itab_line_not_found.
            <ls_hier_incl>-name = <ls_incl>-object.
            <ls_hier_incl>-type = <ls_incl>-type.
            <ls_hier_incl>-level = cv_numb.
            <ls_hier_incl>-parent = <ls_incl>-call_obj.
        ENDTRY.
      ENDLOOP.

      IF uv_type EQ 'CLAS'.

        DATA: lcl_obj    TYPE REF TO cl_abap_objectdescr,
              it_methods TYPE abap_methdescr_tab,
              wa_methods TYPE abap_methdescr.

        cl_abap_objectdescr=>describe_by_name(
          EXPORTING
            p_name         = uv_name
          RECEIVING
            p_descr_ref    = DATA(tmp_obj)
          EXCEPTIONS
            type_not_found = 1
               ).
        IF sy-subrc <> 0.
        ELSE.

          lcl_obj ?= tmp_obj.

          it_methods = lcl_obj->methods.

          LOOP AT it_methods INTO wa_methods.
            APPEND INITIAL LINE TO cit_hier ASSIGNING FIELD-SYMBOL(<ls_method>).

            <ls_method>-details = wa_methods-name.
            <ls_method>-type    = 'CLAS'.
            <ls_method>-parent  = uv_name.

            CLEAR ls_prog_hier.

            TRY.
                ls_prog_hier = cit_hier[ name = <ls_method>-parent ].
                <ls_method>-level = ls_prog_hier-level + 1.
              CATCH cx_sy_itab_line_not_found.
                <ls_method>-level   = cv_numb.
            ENDTRY.

            ls_mtdkey-clsname = uv_name.
            ls_mtdkey-cpdname = wa_methods-name.
            cl_oo_classname_service=>get_method_include(
              EXPORTING
                mtdkey                = ls_mtdkey
              RECEIVING
                result                = <ls_method>-name
              EXCEPTIONS
                class_not_existing    = 1
                method_not_existing   = 2
                OTHERS                = 3
                   ).
            IF sy-subrc NE 0.ENDIF.

          ENDLOOP.

          cv_numb = cv_numb + 1.


        ENDIF.
      ENDIF.


      LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<ls_data>) WHERE ( type     EQ 'CLAS'
                                                           OR   type     EQ 'PROG'
                                                           OR   type     EQ 'FUNC' )
                                                          AND call_obj   NE ''.
        APPEND INITIAL LINE TO cit_hier ASSIGNING FIELD-SYMBOL(<ls_hier>).
        <ls_hier>-name = <ls_data>-object.
        <ls_hier>-type = <ls_data>-type.

        TRY .
            ls_prog_hier = lt_prog_hier[ name = <ls_data>-call_obj
                                         type = 'PROG' ].
            <ls_hier>-level = ls_prog_hier-level.
          CATCH cx_sy_itab_line_not_found.
            <ls_hier>-level = cv_numb.
        ENDTRY.

        IF <ls_data>-object CA '='.
          lv_prog = <ls_data>-object.

          lv_class = lv_prog(30).
          DATA(lv_sect)  = lv_prog+30.
          REPLACE ALL OCCURRENCES OF '=' IN lv_class WITH ''.
          cl_oo_classname_service=>get_method_by_include(
            EXPORTING
              incname             = lv_prog
            RECEIVING
              mtdkey              = ls_ret
            EXCEPTIONS
              class_not_existing  = 1
              method_not_existing = 2
              OTHERS              = 3
                 ).

          IF sy-subrc <> 0.
            CASE lv_sect.
              WHEN 'CCAU'.
                <ls_hier>-details = |SOURCE|.
              WHEN 'CCDEF'.
                <ls_hier>-details = |DEFINITION|.
              WHEN 'CCIMP'.
                <ls_hier>-details = |IMPLEMENTATION|.
              WHEN 'CCMAC'.
                <ls_hier>-details = |MACROS|.
              WHEN 'CI'.
                <ls_hier>-details = |PRIVATE SECTION|.
              WHEN 'CO'.
                <ls_hier>-details = |PROTECTED SECTION|.
              WHEN 'CU'.
                <ls_hier>-details = |PUBLIC SECTION|.
              WHEN 'CP'.
                <ls_hier>-details = |CLASS BUILDER|.
              WHEN 'CT'.
                <ls_hier>-details = |CLASS BUILDER|.
              WHEN OTHERS.
            ENDCASE.

            <ls_hier>-parent = <ls_data>-call_obj.
          ELSE.

            <ls_hier>-details = |{ lv_class }->{ ls_ret-cpdname }|.
            <ls_hier>-parent = <ls_data>-call_obj.
          ENDIF.
        ELSE.
          <ls_hier>-parent = <ls_data>-call_obj.

        ENDIF.

        IF <ls_data>-type = 'FUNC'.

          lv_func = <ls_data>-object.
          CALL FUNCTION 'FUNCTION_INCLUDE_INFO'
            CHANGING
              funcname            = lv_func
              include             = lv_incl
            EXCEPTIONS
              function_not_exists = 1
              include_not_exists  = 2
              group_not_exists    = 3
              no_selections       = 4
              no_function_include = 5
              OTHERS              = 6.
          IF sy-subrc EQ 0.
            <ls_hier>-details = lv_incl.
          ENDIF.

        ENDIF.

        TRY.
            CLEAR ls_prog_hier.
            ls_prog_hier = cit_hier[ name = <ls_data>-call_obj ].
            <ls_hier>-level = ls_prog_hier-level + 1.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.

        IF <ls_hier>-name(1) EQ 'Z' OR
           <ls_hier>-name(1) EQ 'Y'.

          me->recursive_search(
            EXPORTING
              uv_type  = <ls_hier>-type
              uv_name  = <ls_hier>-name
            CHANGING
              cv_numb  = cv_numb
              cit_hier = cit_hier
                 ).

        ENDIF.
      ENDLOOP.

      DELETE ADJACENT DUPLICATES FROM cit_hier.
      SORT cit_hier BY level parent.

    ENDIF.

  ENDMETHOD.


  METHOD scan_object.

    DATA: lit_hier     TYPE gtty_hier,
          lv_numb      TYPE i VALUE 0,
          lv_parsetype TYPE euobj-id,
          lv_func      TYPE rs38l-name,
          lv_incl      TYPE rs38l-include.

    DATA: lr_start     TYPE RANGE OF char40.
    lr_start = VALUE #( sign = 'I' option = 'CP' ( low = 'Z*') ).

    SELECT SINGLE object
      FROM tadir
      INTO @DATA(lv_type)
     WHERE obj_name EQ @program.
    IF sy-subrc EQ 0.
      lv_parsetype = lv_type.
    ELSE.
      SELECT SINGLE COUNT( * )
        FROM tfdir
       WHERE funcname EQ @program.
      IF sy-subrc EQ 0.
        lv_parsetype = 'FUNC'.

        lv_func = program.

        CALL FUNCTION 'FUNCTION_INCLUDE_INFO'
          CHANGING
            funcname            = lv_func
            include             = lv_incl
          EXCEPTIONS
            function_not_exists = 1
            include_not_exists  = 2
            group_not_exists    = 3
            no_selections       = 4
            no_function_include = 5
            OTHERS              = 6.
      ENDIF.

    ENDIF.

    APPEND INITIAL LINE TO lit_hier ASSIGNING FIELD-SYMBOL(<ls_hier>).
    <ls_hier>-name  = program.
    <ls_hier>-type  = lv_parsetype.
    <ls_hier>-level = lv_numb.

    IF lv_incl IS NOT INITIAL.
      <ls_hier>-details = lv_incl.
    ENDIF.

    me->recursive_search(
      EXPORTING
        uv_type  = <ls_hier>-type
        uv_name  = <ls_hier>-name
      CHANGING
        cv_numb  = lv_numb
        cit_hier = lit_hier
           ).

    IF li_onlyz EQ abap_true.
      DELETE lit_hier WHERE name NOT IN lr_start.
    ENDIF.


    cl_demo_output=>write_data( lit_hier ).

    IF lit_hier[] IS NOT INITIAL AND li_show_info EQ abap_true.
      cl_demo_output=>display( ).
    ENDIF.

    r_it_hier = lit_hier.

  ENDMETHOD.
ENDCLASS.
