*&---------------------------------------------------------------------*
*& Include          Z_MOD_DEMO_ALV_REPORTING_LIB
*&---------------------------------------------------------------------*
TABLES: scarr.

SELECT-OPTIONS so_carr FOR scarr-carrid  NO INTERVALS NO-EXTENSION.
PARAMETERS: p_obj1 RADIOBUTTON GROUP rad1 DEFAULT 'X',
            p_obj2 RADIOBUTTON GROUP rad1.
