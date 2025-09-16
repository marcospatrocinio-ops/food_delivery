CREATE OR REPLACE PACKAGE BODY APP_SETUP_SQL AS

FUNCTION GET_SYS_SETUP (I_setup IN APP_SETUP.SETUP%TYPE)
   return VARCHAR2 is

   ----------------------------------------------------------------------------------
   -- Variable Declaration
   ----------------------------------------------------------------------------------
   L_program            VARCHAR2(100)      := 'APP_SETUP_SQL.GET_SYS_SETUP';

   ----------------------------------------------------------------------------------
   -- Lock declaration
   ----------------------------------------------------------------------------------

   ----------------------------------------------------------------------------------
   -- Cursor Declaration
   ----------------------------------------------------------------------------------
   cursor C_SETUP is
      select s.setup_value
        from app_setup s
       where s.setup   = I_setup;

   R_setup C_SETUP%ROWTYPE;

BEGIN

   open  C_SETUP;
   fetch C_SETUP into R_setup;
   close C_SETUP;

   return R_setup.setup_value;

EXCEPTION
   when OTHERS then
      return NULL;

END GET_SYS_SETUP;
----------------------------------------------------------------------------------------------------------------------------------------------------------
END APP_SETUP_SQL;
/
