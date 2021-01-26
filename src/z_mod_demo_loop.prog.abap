*&---------------------------------------------------------------------*
*& Report Z_MOD_DEMO_LOOP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_demo_loop.

" Caso simple While
DATA square TYPE i.

WRITE: /, 'While', /.
DO 10 TIMES.
  square = ipow( base = sy-index exp = 2 ).
  WRITE: square.
ENDDO.

" Caso 'complejo' while con tabla interna y declaración inline
TYPES: BEGIN OF t_struct,
         col1 TYPE syindex,
         col2 TYPE i,
       END OF t_struct,
       t_itab TYPE TABLE OF t_struct WITH EMPTY KEY.

DATA itab TYPE t_itab.

WRITE: /, 'While + ITAB', /.
WHILE lines( itab ) < 10.
  itab = VALUE #( BASE itab ( col1 = sy-index col2 = ipow( base = sy-index exp = 2  ) ) ).
  WRITE: sy-index.
ENDWHILE.

" Caso LOOP sobre itab

WRITE: /, 'LOOP', /.
LOOP AT itab ASSIGNING FIELD-SYMBOL(<fs>).
  WRITE: <fs>-col1, <fs>-col2, /.
ENDLOOP.
cl_demo_output=>display( itab ).
