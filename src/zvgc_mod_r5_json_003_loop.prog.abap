*&---------------------------------------------------------------------*
*& Include          ZVGC_MOD_R5_JSON_003_LOOP
*&---------------------------------------------------------------------*

 types: begin of t_typo,
   ope type c LENGTH 2,
 end of t_typo.

 data: t_dat1 TYPE STANDARD TABLE OF t_typo.
 data:  t_dat3 TYPE STANDARD TABLE OF t_typo.

 data: t_dat2 TYPE STANDARD TABLE OF t_typo with HEADER LINE.
 data: t_dat4 TYPE STANDARD TABLE OF t_typo with HEADER LINE.

 data: s_reg type t_typo,
       lv_lines type i.

START-OF-SELECTION.

s_reg-ope = 'A1'.
append s_reg to t_dat1.

s_reg-ope = 'A2'.
append s_reg to t_dat1.

clear s_reg.

if t_dat1 is not initial.
  write: /'tabla 1 llena'.
endif.
* Pasamos contenido de una tabla a otra
t_dat3 = t_dat1.

DESCRIBE TABLE t_dat3 lines lv_lines.
write: / 'lineas tabla 3', lv_lines. "2


t_dat2-ope = 'B1'.
if t_dat2 is not initial.
  write: /'cabecera llena'.
endif.
if t_dat2[] is  initial.
   write: /'tabla 2 vacia'.
endif.

append t_dat2.
if t_dat2[] is not initial.
    write: /, 'tabla 2 llena'.

endif.


t_dat4 = t_dat2.
DESCRIBE TABLE t_dat4 lines lv_lines.
write: /,'lineas tabla 4', lv_lines. " 0

* Pasamos contenido de una tabla a otra
t_dat4[] = t_dat2[].
DESCRIBE TABLE t_dat4 lines lv_lines.
write:  /, 'lineas tabla 4', lv_lines. "4

clear t_dat2[].

if t_dat2[] is  initial.
  write: / 'tabla 2 vacia'.
endif.
write: / 'fin'.
