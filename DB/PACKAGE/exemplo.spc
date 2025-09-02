CREATE OR REPLACE PACKAGE APP_USER_SQL AS
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE DATE   - 08-08-2019
-- CREATE USER   - BRX Retail
-- PROJECT       -
-- DESCRIPTION   - 
----------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: PASSWORD_FORCE_VALIDATION
-- Purpose      : Validate password force
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION PASSWORD_FORCE_VALIDATION (O_error_message  IN OUT CLOB        ,
                                    I_username       IN     VARCHAR2    ,
                                    I_app_id         IN     NUMBER      ,
                                    I_password       IN     VARCHAR2    )
   return BOOLEAN;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: CHECK_AUTO_APPROVE
-- Purpose      : Check if NF will auto approve in SEFAZ, or if itll need a manual autorization
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION INTEGRATE_WORKSPACE_USER_CRE (O_error_message  IN OUT CLOB        ,
                                       I_username       IN     VARCHAR2    ,
                                       I_app_id         IN     NUMBER      ,
                                       I_password       IN     VARCHAR2    )
   return BOOLEAN;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: CHECK_AUTO_APPROVE
-- Purpose      : Check if NF will auto approve in SEFAZ, or if itll need a manual autorization
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION INTEGRATE_WORKSPACE_USER_MOD (O_error_message  IN OUT CLOB        ,
                                       I_username       IN     VARCHAR2    ,
                                       I_app_id         IN     NUMBER      ,
                                       I_password       IN     VARCHAR2    )
   return BOOLEAN;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: CHECK_AUTO_APPROVE
-- Purpose      : Check if NF will auto approve in SEFAZ, or if itll need a manual autorization
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION INTEGRATE_WORKSPACE_USER_DEL (O_error_message  IN OUT CLOB        ,
                                       I_username       IN     VARCHAR2    ,
                                       I_app_id         IN     NUMBER      )
   return BOOLEAN;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: SUBSCRIBE_WORKSPACE_USER
-- Purpose      :
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION SUBSCRIBE_WORKSPACE_USER_CRE (O_error_message  IN OUT CLOB        ,
                                       O_integ_msg       IN OUT INTEGRATION_MESSAGE.INTEG_MSG%TYPE,
                                       I_integ_msg       IN     INTEGRATION_MESSAGE.INTEG_MSG%TYPE,
                                       I_user            IN     APP_USER.APP_USER%TYPE            )
   return BOOLEAN;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: SUBSCRIBE_WORKSPACE_USER
-- Purpose      :
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION SUBSCRIBE_WORKSPACE_USER_MOD (O_error_message  IN OUT CLOB        ,
                                       O_integ_msg       IN OUT INTEGRATION_MESSAGE.INTEG_MSG%TYPE,
                                       I_integ_msg       IN     INTEGRATION_MESSAGE.INTEG_MSG%TYPE,
                                       I_user            IN     APP_USER.APP_USER%TYPE            )

   return BOOLEAN;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: SUBSCRIBE_WORKSPACE_USER
-- Purpose      :
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION SUBSCRIBE_WORKSPACE_USER_DEL (O_error_message  IN OUT CLOB        ,
                                       O_integ_msg       IN OUT INTEGRATION_MESSAGE.INTEG_MSG%TYPE,
                                       I_integ_msg       IN     INTEGRATION_MESSAGE.INTEG_MSG%TYPE,
                                       I_user            IN     APP_USER.APP_USER%TYPE            )

   return BOOLEAN;
----------------------------------------------------------------------------------------------------------------------------------------------------------
END APP_USER_SQL;
/

