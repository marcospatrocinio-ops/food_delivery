CREATE OR REPLACE PACKAGE PCK_AUTHENTICATION as
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: FNC_VALIDATE_USER
-- Purpose      : User access validation process.
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION FNC_VALIDATE_USER(P_username IN VARCHAR2,
                           P_password IN VARCHAR2) return BOOLEAN;

end PCK_AUTHENTICATION;
/
