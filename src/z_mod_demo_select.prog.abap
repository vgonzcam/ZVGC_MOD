*&---------------------------------------------------------------------*
*& Report Z_MOD_DEMO_SELECT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_demo_select.

" Select sencillo
DATA: itab TYPE STANDARD TABLE OF scarr.
SELECT *
       FROM   scarr
       INTO TABLE itab.

" Select INLINE
SELECT *
       FROM   scarr
       INTO TABLE @DATA(result).

" Select con condiciones y seleccion de campos
TABLES: scarr.
TYPES: BEGIN OF scarr_type,
         carrid   TYPE  s_carr_id,
         carrname TYPE s_carrname,
       END OF scarr_type.
DATA:  itab_scarr_type TYPE STANDARD TABLE OF scarr_type.

SELECT carrid carrname
       FROM   scarr
       INTO TABLE itab_scarr_type
       WHERE carrid EQ 'LH'.

" Select con condiciones y seleccion de campos INLINE
DATA: lv_carrid TYPE s_carr_id VALUE 'LH'.
SELECT carrid, carrname
     FROM   scarr
     WHERE carrid EQ 'LH' OR carrid EQ @lv_carrid
     INTO TABLE @DATA(itab_scarr).

IF 1 = 2.

ENDIF.
