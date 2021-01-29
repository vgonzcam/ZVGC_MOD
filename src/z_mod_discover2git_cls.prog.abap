*&---------------------------------------------------------------------*
*& Include          Z_MOD_DISCOVER2GIT_CLS
*&---------------------------------------------------------------------*
CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_vrm_values,
        key  TYPE char40,
        text TYPE char80,
      END   OF ty_vrm_values.
    TYPES: tt_vrm_values TYPE STANDARD TABLE OF ty_vrm_values
             WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_config,
        key   TYPE char10,
        desc  TYPE char50,
        dynnr TYPE sy-dynnr,
      END   OF ty_config.
    DATA: t_config TYPE STANDARD TABLE OF ty_config.
    METHODS:
      get_vrm_values
        RETURNING VALUE(rt_values) TYPE tt_vrm_values,
      get_dynnr
        IMPORTING iv_objtype      TYPE char10
        EXPORTING ev_ex_type      TYPE char10
        RETURNING VALUE(rv_dynnr) TYPE sy-dynnr.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION .
  METHOD get_vrm_values.
    DATA: ls_config LIKE LINE OF me->t_config.

    ls_config-key   = 'LOCAL'.
    ls_config-desc  = 'Ejecución el Local'.
    ls_config-dynnr = '0100'.
    APPEND ls_config TO me->t_config.

    ls_config-key   = 'GIT'.
    ls_config-desc  = 'Upload to GIT'.
    ls_config-dynnr = '0200'.
    APPEND ls_config TO me->t_config.

    DATA: ls_vrm LIKE LINE OF rt_values.
    LOOP AT me->t_config INTO ls_config.
      ls_vrm-key = ls_config-key.
      ls_vrm-text = ls_config-desc.
      APPEND ls_vrm TO rt_values.
    ENDLOOP.

  ENDMETHOD.                    "get_vrm_values

  METHOD get_dynnr.
*   get the screen number
    DATA: ls_config LIKE LINE OF me->t_config.
    READ TABLE me->t_config INTO ls_config
      WITH KEY key = iv_objtype.
    IF sy-subrc EQ 0.
      rv_dynnr = ls_config-dynnr.
      ev_ex_type = ls_config-key.
    ELSE.
      rv_dynnr = '0100'.
    ENDIF.
  ENDMETHOD.                    "get_dynnr

ENDCLASS.                    "lcl_main IMPLEMENTATION

DATA: t_objtypes TYPE lcl_main=>tt_vrm_values.
DATA: o_main TYPE REF TO lcl_main.
