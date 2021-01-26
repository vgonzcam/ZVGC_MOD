*&---------------------------------------------------------------------*
*& Report Z_MOD_DEMO_PERFORM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mod_demo_perform.

DATA: num1 TYPE i,
      num2 TYPE i,
      sum  TYPE i.

num1 = 2. num2 = 4.
PERFORM addit USING num1 num2 CHANGING sum.

num1 = 7. num2 = 11.
PERFORM addit USING num1 num2 CHANGING sum.

FORM addit  USING add_num1  TYPE i
                  add_num2  TYPE i
         CHANGING add_sum   TYPE i.

  add_sum = add_num1 + add_num2.

  PERFORM out USING add_num1 add_num2 add_sum.

ENDFORM.

FORM out   USING out_num1 TYPE any
                 out_num2 TYPE any
                 out_sum  TYPE any.

  WRITE: / 'Sum of', out_num1, 'and', out_num2, 'is', out_sum.
ENDFORM.
