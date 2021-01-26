*&---------------------------------------------------------------------*
*& Report ZVGC_MOD_002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvgc_mod_002.

INCLUDE zvgc_mod_002_1a.
INCLUDE zvgc_mod_002_1b.
INCLUDE zvgc_mod_002_1c.

START-OF-SELECTION.
  PERFORM zvgc_mod_002_1a.
  PERFORM zvgc_mod_002_1c.
  PERFORM zvgc_mod_002_1b.
