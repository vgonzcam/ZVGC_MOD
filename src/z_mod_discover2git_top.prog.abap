*&---------------------------------------------------------------------*
*& Include          Z_MOD_DISCOVER2GIT_TOP
*&---------------------------------------------------------------------*

DATA: gr_scan   TYPE REF TO cl_ci_scan,
      gr_source TYPE REF TO cl_ci_source_include.
DATA: lt_csv       TYPE stringtab,
      itab_in_xml  TYPE string,
      itab_in_json TYPE STring.
DATA: gv_type      TYPE char10.

DATA: r_it_hier TYPE zcl_drm_scan=>gtty_hier.
