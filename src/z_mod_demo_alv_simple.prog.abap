*&---------------------------------------------------------------------*
*& Report Z_MOD_DEMO_ALV_SIMPLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_demo_alv_simple.

TABLES: scarr.

DATA: lo_alv  TYPE REF TO cl_salv_table.
DATA: scarr_tab TYPE STANDARD TABLE OF scarr.

SELECT-OPTIONS so_carr FOR scarr-carrid  NO INTERVALS NO-EXTENSION.

SELECT *
    FROM scarr
    INTO TABLE scarr_tab
          WHERE carrid IN so_carr.

TRY.
    cl_salv_table=>factory(
      IMPORTING r_salv_table = lo_alv
      CHANGING  t_table = scarr_tab ).

    lo_alv->display( ).
  CATCH cx_salv_msg.
    MESSAGE 'ALV display not possible' TYPE 'I'
            DISPLAY LIKE 'E'.
  CATCH cx_root.
ENDTRY.
