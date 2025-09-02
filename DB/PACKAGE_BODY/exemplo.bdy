CREATE OR REPLACE PACKAGE BODY APP_USER_SQL AS
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE DATE   - 08-08-2019
-- CREATE USER   - BRX Retail
-- PROJECT       -
-- DESCRIPTION   -
----------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: CHECK_AUTO_APPROVE
-- Purpose      : Check if NF will auto approve in SEFAZ, or if itll need a manual autorization
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION PASSWORD_FORCE_VALIDATION (O_error_message  IN OUT CLOB        ,
                                    I_username       IN     VARCHAR2    ,
                                    I_app_id         IN     NUMBER      ,
                                    I_password       IN     VARCHAR2    )
   return BOOLEAN is

   ----------------------------------------------------------------------------------
   -- Variable Declaration
   ----------------------------------------------------------------------------------
   L_program            VARCHAR2(100)      := 'APP_USER_SQL.PASSWORD_FORCE_VALIDATION';

   L_workspace_name              VARCHAR2(100);
   L_use_strong_rules            BOOLEAN := TRUE;
   L_min_length_err              BOOLEAN;
   L_new_differs_by_err          BOOLEAN;
   L_one_alpha_err               BOOLEAN;
   L_one_numeric_err             BOOLEAN;
   L_one_punctuation_err         BOOLEAN;
   L_one_upper_err               BOOLEAN;
   L_one_lower_err               BOOLEAN;
   L_not_like_username_err       BOOLEAN;
   L_not_like_workspace_name_err BOOLEAN;
   L_not_like_words_err          BOOLEAN;
   L_not_reusable_err            BOOLEAN;
   --L_password_history_days       PLS_INTEGER := apex_instance_admin.get_parameter ('PASSWORD_HISTORY_DAYS');

   ----------------------------------------------------------------------------------
   -- Lock declaration
   ----------------------------------------------------------------------------------

   ----------------------------------------------------------------------------------
   -- Cursor Declaration
   ----------------------------------------------------------------------------------
   cursor C_WORKSPACE is
      select w.workspace
        from apex_workspaces     w,
             apex_applications   a
       where w.workspace      = a.workspace
         and a.application_id = I_app_id;

BEGIN

   open  C_WORKSPACE;
   fetch C_WORKSPACE into L_workspace_name;
   close C_WORKSPACE;

   APEX_UTIL.STRONG_PASSWORD_CHECK (P_username                    => I_username,
                                    P_password                    => I_password,
                                    P_old_password                => null,
                                    P_workspace_name              => L_workspace_name,
                                    P_use_strong_rules            => L_use_strong_rules,
                                    P_min_length_err              => L_min_length_err,
                                    P_new_differs_by_err          => L_new_differs_by_err,
                                    P_one_alpha_err               => L_one_alpha_err,
                                    P_one_numeric_err             => L_one_numeric_err,
                                    P_one_punctuation_err         => L_one_punctuation_err,
                                    P_one_upper_err               => L_one_upper_err,
                                    P_one_lower_err               => L_one_lower_err,
                                    P_not_like_username_err       => L_not_like_username_err,
                                    P_not_like_workspace_name_err => L_not_like_workspace_name_err,
                                    P_not_like_words_err          => L_not_like_words_err,
                                    P_not_reusable_err            => L_not_reusable_err);

   O_error_message := NULL;

   if l_min_length_err THEN
       O_error_message  := O_error_message || chr(13)||'Password is too short';
   end if;

   if l_new_differs_by_err THEN
       O_error_message  := O_error_message || chr(13)||'Password is too similar to the old password';
   end if;

   if l_one_alpha_err THEN
       O_error_message  := O_error_message || chr(13)||'Password must contain at least one alphabetic character';
   end if;

   if l_one_numeric_err THEN
       O_error_message  := O_error_message || chr(13)||'Password  must contain at least one numeric character';
   end if;

   if l_one_punctuation_err THEN
       O_error_message  := O_error_message || chr(13)||'Password  must contain at least one punctuation character';
   end if;

   if l_one_upper_err THEN
       O_error_message  := O_error_message || 'Password must contain at least one upper-case character';
   end if;

   if l_one_lower_err THEN
       O_error_message  := O_error_message || chr(13)||'Password must contain at least one lower-case character';
   end if;

   if l_not_like_username_err THEN
       O_error_message  := O_error_message || chr(13)||'Password may not contain the username';
   end if;

   if l_not_like_workspace_name_err THEN
       O_error_message  := O_error_message || chr(13)||'Password may not contain the workspace name';
   end if;

   if l_not_like_words_err THEN
       O_error_message  := O_error_message || chr(13)||'Password contains one or more prohibited common words';
   end if;

   --if l_not_reusable_err THEN
   --    O_error_message  := O_error_message || chr(13)||'Password cannot be used because it has been used for the account within the last '||L_password_history_days||' days.';
   --end if;

   if O_error_message is NOT NULL then
      return FALSE;
   end if;

   return TRUE;

EXCEPTION
   when OTHERS then
      O_error_message := MSG_SQL.GET_MESSAGE_TEXT('PACKAGE_ERROR', SQLERRM, L_program, TO_CHAR(SQLCODE));
      return FALSE;

END PASSWORD_FORCE_VALIDATION;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: CHECK_AUTO_APPROVE
-- Purpose      : Check if NF will auto approve in SEFAZ, or if itll need a manual autorization
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION INTEGRATE_WORKSPACE_USER_CRE (O_error_message  IN OUT CLOB        ,
                                       I_username       IN     VARCHAR2    ,
                                       I_app_id         IN     NUMBER      ,
                                       I_password       IN     VARCHAR2    )
   return BOOLEAN is

   ----------------------------------------------------------------------------------
   -- Variable Declaration
   ----------------------------------------------------------------------------------
   L_program            VARCHAR2(100)      := 'APP_USER_SQL.INTEGRATE_WORKSPACE_USER_CRE';

   L_company            COMPANY.COMPANY%TYPE;
   L_user               APP_USER.APP_USER%TYPE;
   L_json_msg           CLOB;

   ----------------------------------------------------------------------------------
   -- Lock declaration
   ----------------------------------------------------------------------------------

   ----------------------------------------------------------------------------------
   -- Cursor Declaration
   ----------------------------------------------------------------------------------
   cursor C_COMP_USER is
      select (select d.comp_code_line from company_code_dtl d where d.comp_code_hdr = h.comp_code_hdr and d.comp_code = 'COMPANY') company,
             (select d.comp_code_line from company_code_dtl d where d.comp_code_hdr = h.comp_code_hdr and d.comp_code = 'USER')    user_id
        from company_code_hdr h
       where comp_code = 'DEFAULT_COMPANY_VALUES';

BEGIN

   open  C_COMP_USER;
   fetch C_COMP_USER into L_company, L_user;
   close C_COMP_USER;

   L_company := NVL(L_company,3);
   L_user    := NVL(L_user   ,1);

   L_json_msg := '{'                                ||
                   '"username": "'||I_username||'",'||
                   '"appid": "'   ||I_app_id  ||'",'||
                   '"password": "'||I_password||'" '||
                 '}';

   insert into integration_message
        values (INTEGRATION_MESSAGE_SEQ.NEXTVAL,  --integ_msg
                I_username  ,  --integ_msg_ref
                'S'                        ,  --integ_type
                'CRE'                      ,  --msg_type
                'APEX_WORKSPACE_USER'      ,  --fam_obj
                'GENERIC'                  ,  --erp
                 L_company                 ,  --company
                 'R'                       ,  --status
                 'J'                       ,  --clob_type
                 L_json_msg                ,  --message
                 NULL                      ,  --decoded_msg
                 NULL                      ,  --log_msg
                 L_user                    ,  --create_user
                 SYSDATE                   ,  --create_datetime
                 L_user                    ,  --update_user
                 SYSDATE                   ); --update_datetime

   return TRUE;

EXCEPTION
   when OTHERS then
      O_error_message := MSG_SQL.GET_MESSAGE_TEXT('PACKAGE_ERROR', SQLERRM, L_program, TO_CHAR(SQLCODE));
      return FALSE;

END INTEGRATE_WORKSPACE_USER_CRE;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: CHECK_AUTO_APPROVE
-- Purpose      : Check if NF will auto approve in SEFAZ, or if itll need a manual autorization
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION INTEGRATE_WORKSPACE_USER_MOD (O_error_message  IN OUT CLOB        ,
                                       I_username       IN     VARCHAR2    ,
                                       I_app_id         IN     NUMBER      ,
                                       I_password       IN     VARCHAR2    )
   return BOOLEAN is

   ----------------------------------------------------------------------------------
   -- Variable Declaration
   ----------------------------------------------------------------------------------
   L_program            VARCHAR2(100)      := 'APP_USER_SQL.INTEGRATE_WORKSPACE_USER_MOD';

   L_company            COMPANY.COMPANY%TYPE;
   L_user               APP_USER.APP_USER%TYPE;
   L_json_msg           CLOB;

   ----------------------------------------------------------------------------------
   -- Lock declaration
   ----------------------------------------------------------------------------------

   ----------------------------------------------------------------------------------
   -- Cursor Declaration
   ----------------------------------------------------------------------------------
   cursor C_COMP_USER is
      select (select d.comp_code_line from company_code_dtl d where d.comp_code_hdr = h.comp_code_hdr and d.comp_code = 'COMPANY') company,
             (select d.comp_code_line from company_code_dtl d where d.comp_code_hdr = h.comp_code_hdr and d.comp_code = 'USER')    user_id
        from company_code_hdr h
       where comp_code = 'DEFAULT_COMPANY_VALUES';

BEGIN

   open  C_COMP_USER;
   fetch C_COMP_USER into L_company, L_user;
   close C_COMP_USER;

   L_company := NVL(L_company,3);
   L_user    := NVL(L_user   ,1);

   L_json_msg := '{'                                ||
                   '"username": "'||I_username||'",'||
                   '"appid": "'   ||I_app_id  ||'",'||
                   '"password": "'||I_password||'" '||
                 '}';

   insert into integration_message
        values (INTEGRATION_MESSAGE_SEQ.NEXTVAL,  --integ_msg
                I_username  ,  --integ_msg_ref
                'S'                        ,  --integ_type
                'MOD'                      ,  --msg_type
                'APEX_WORKSPACE_USER'      ,  --fam_obj
                'GENERIC'                  ,  --erp
                 L_company                 ,  --company
                 'R'                       ,  --status
                 'J'                       ,  --clob_type
                 L_json_msg                ,  --message
                 NULL                      ,  --decoded_msg
                 NULL                      ,  --log_msg
                 L_user                    ,  --create_user
                 SYSDATE                   ,  --create_datetime
                 L_user                    ,  --update_user
                 SYSDATE                   ); --update_datetime

   return TRUE;

EXCEPTION
   when OTHERS then
      O_error_message := MSG_SQL.GET_MESSAGE_TEXT('PACKAGE_ERROR', SQLERRM, L_program, TO_CHAR(SQLCODE));
      return FALSE;

END INTEGRATE_WORKSPACE_USER_MOD;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: CHECK_AUTO_APPROVE
-- Purpose      : Check if NF will auto approve in SEFAZ, or if itll need a manual autorization
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION INTEGRATE_WORKSPACE_USER_DEL (O_error_message  IN OUT CLOB        ,
                                       I_username       IN     VARCHAR2    ,
                                       I_app_id         IN     NUMBER      )
   return BOOLEAN is

   ----------------------------------------------------------------------------------
   -- Variable Declaration
   ----------------------------------------------------------------------------------
   L_program            VARCHAR2(100)      := 'APP_USER_SQL.INTEGRATE_WORKSPACE_USER_DEL';

   L_company            COMPANY.COMPANY%TYPE;
   L_user               APP_USER.APP_USER%TYPE;
   L_json_msg           CLOB;

   ----------------------------------------------------------------------------------
   -- Lock declaration
   ----------------------------------------------------------------------------------

   ----------------------------------------------------------------------------------
   -- Cursor Declaration
   ----------------------------------------------------------------------------------
   cursor C_COMP_USER is
      select (select d.comp_code_line from company_code_dtl d where d.comp_code_hdr = h.comp_code_hdr and d.comp_code = 'COMPANY') company,
             (select d.comp_code_line from company_code_dtl d where d.comp_code_hdr = h.comp_code_hdr and d.comp_code = 'USER')    user_id
        from company_code_hdr h
       where comp_code = 'DEFAULT_COMPANY_VALUES';

BEGIN

   open  C_COMP_USER;
   fetch C_COMP_USER into L_company, L_user;
   close C_COMP_USER;

   L_company := NVL(L_company,3);
   L_user    := NVL(L_user   ,1);

   L_json_msg := '{'                                ||
                   '"username": "'||I_username||'",'||
                   '"appid": "'   ||I_app_id  ||'" '||
                 '}';

   insert into integration_message
        values (INTEGRATION_MESSAGE_SEQ.NEXTVAL,  --integ_msg
                I_username  ,  --integ_msg_ref
                'S'                        ,  --integ_type
                'DEL'                      ,  --msg_type
                'APEX_WORKSPACE_USER'      ,  --fam_obj
                'GENERIC'                  ,  --erp
                 L_company                 ,  --company
                 'R'                       ,  --status
                 'J'                       ,  --clob_type
                 L_json_msg                ,  --message
                 NULL                      ,  --decoded_msg
                 NULL                      ,  --log_msg
                 L_user                    ,  --create_user
                 SYSDATE                   ,  --create_datetime
                 L_user                    ,  --update_user
                 SYSDATE                   ); --update_datetime

   return TRUE;

EXCEPTION
   when OTHERS then
      O_error_message := MSG_SQL.GET_MESSAGE_TEXT('PACKAGE_ERROR', SQLERRM, L_program, TO_CHAR(SQLCODE));
      return FALSE;

END INTEGRATE_WORKSPACE_USER_DEL;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: SUBSCRIBE_WORKSPACE_USER
-- Purpose      :
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION SUBSCRIBE_WORKSPACE_USER_CRE (O_error_message  IN OUT CLOB        ,
                                       O_integ_msg       IN OUT INTEGRATION_MESSAGE.INTEG_MSG%TYPE,
                                       I_integ_msg       IN     INTEGRATION_MESSAGE.INTEG_MSG%TYPE,
                                       I_user            IN     APP_USER.APP_USER%TYPE            )
   return BOOLEAN is

   ----------------------------------------------------------------------------------
   -- Variable Declaration
   ----------------------------------------------------------------------------------
   L_program            VARCHAR2(100)      := 'APP_USER_SQL.SUBSCRIBE_WORKSPACE_USER_CRE';
   L_app_user           APP_USER.APP_USER%TYPE;

   ----------------------------------------------------------------------------------
   -- Lock declaration
   ----------------------------------------------------------------------------------

   ----------------------------------------------------------------------------------
   -- Cursor Declaration
   ----------------------------------------------------------------------------------
   cursor C_USER_SEQ is
      select APP_USER_SEQ.NEXTVAL
        from dual;

   cursor C_MESSAGE is
      select upper(j.username) username     ,
             w.workspace_id ,
             j.app_id       ,
             j.password     ,
             i.company      ,
             i.msg_type
        from apex_workspaces     w,
             apex_applications   a,
             integration_message i,
             JSON_TABLE(i.message,'$' COLUMNS (username VARCHAR2(50) path '$.username',
                                               app_id   NUMBER(25)   path '$.appid'   ,
                                               password VARCHAR2(50) path '$.password'   )) j
       where i.integ_msg      = I_integ_msg
         and w.workspace      = a.workspace
         and a.application_id = j.app_id;

   R_message C_MESSAGE%ROWTYPE;

BEGIN

   if SYSTEM_SETUP_SQL.GET_SYS_SETUP('SYS_TRACE_IND') = 'Y' then
      SYSTEM_LOG_SQL.TRACE(O_error_message,'INTEGRATION_MESSAGE',I_integ_msg,L_program,NULL,NULL);
   end if;

   -- Force machine number format.
   EXECUTE IMMEDIATE 'alter session set NLS_NUMERIC_CHARACTERS = ''.,''';

   O_integ_msg := I_integ_msg;

   open  C_MESSAGE;
   fetch C_MESSAGE into R_message;
   close C_MESSAGE;

   if R_message.msg_type != 'CRE' then
      return TRUE;
   end if;

   ----------------------------------------------------------------------------------
   -- Create workspace user
   ----------------------------------------------------------------------------------
   APEX_UTIL.SET_SECURITY_GROUP_ID (p_security_group_id => R_message.workspace_id);
   APEX_UTIL.CREATE_USER           (p_user_name         => R_message.username    ,
                                    p_web_password      => R_message.password    );

   ----------------------------------------------------------------------------------
   -- create rfa user
   ----------------------------------------------------------------------------------
   open  C_USER_SEQ;
   fetch C_USER_SEQ into L_app_user;
   close C_USER_SEQ;

   insert into app_user (app_user ,app_user_ref ,app_user_name ,status ,create_user ,create_datetime ,update_user ,update_datetime ,user_name ,company)
   select L_app_user           app_user       ,
          u.id                 app_user_ref   ,
          u.user_name          app_user_name  ,
          'A'                  status         ,
          I_user               create_user    ,
          SYSDATE              create_datetime,
          I_user               update_user    ,
          SYSDATE              update_datetime,
          u.user_name          user_name      ,
          R_message.company    company
     from apex_appl_acl_users u
    where u.user_name      = R_message.username
      and u.workspace_id   = R_message.workspace_id
      and u.application_id = R_message.app_id;

   insert into app_user_company (app_user, company, status, create_user ,create_datetime ,update_user ,update_datetime)
                         values (L_app_user       ,
                                 R_message.company,
                                 'A'              ,
                                 I_user           ,
                                 SYSDATE          ,
                                 I_user           ,
                                 SYSDATE          );

   delete from integration_message where integ_msg = I_integ_msg;

   return TRUE;

EXCEPTION
   when OTHERS then
      O_error_message := MSG_SQL.GET_MESSAGE_TEXT('PACKAGE_ERROR', SQLERRM, L_program, TO_CHAR(SQLCODE));
      return FALSE;

END SUBSCRIBE_WORKSPACE_USER_CRE;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: SUBSCRIBE_WORKSPACE_USER
-- Purpose      :
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION SUBSCRIBE_WORKSPACE_USER_MOD (O_error_message  IN OUT CLOB        ,
                                       O_integ_msg       IN OUT INTEGRATION_MESSAGE.INTEG_MSG%TYPE,
                                       I_integ_msg       IN     INTEGRATION_MESSAGE.INTEG_MSG%TYPE,
                                       I_user            IN     APP_USER.APP_USER%TYPE            )
   return BOOLEAN is

   ----------------------------------------------------------------------------------
   -- Variable Declaration
   ----------------------------------------------------------------------------------
   L_program            VARCHAR2(100)      := 'APP_USER_SQL.SUBSCRIBE_WORKSPACE_USER_MOD';

   ----------------------------------------------------------------------------------
   -- Lock declaration
   ----------------------------------------------------------------------------------

   ----------------------------------------------------------------------------------
   -- Cursor Declaration
   ----------------------------------------------------------------------------------
   cursor C_MESSAGE is
      select upper(j.username) username     ,
             w.workspace_id ,
             j.app_id       ,
             j.password     ,
             i.company      ,
             i.msg_type
        from apex_workspaces     w,
             apex_applications   a,
             integration_message i,
             JSON_TABLE(i.message,'$' COLUMNS (username VARCHAR2(50) path '$.username',
                                               app_id   NUMBER(25)   path '$.appid'   ,
                                               password VARCHAR2(50) path '$.password'   )) j
       where i.integ_msg      = I_integ_msg
         and w.workspace      = a.workspace
         and a.application_id = j.app_id;

   R_message C_MESSAGE%ROWTYPE;

BEGIN

   if SYSTEM_SETUP_SQL.GET_SYS_SETUP('SYS_TRACE_IND') = 'Y' then
      SYSTEM_LOG_SQL.TRACE(O_error_message,'INTEGRATION_MESSAGE',I_integ_msg,L_program,NULL,NULL);
   end if;

   -- Force machine number format.
   EXECUTE IMMEDIATE 'alter session set NLS_NUMERIC_CHARACTERS = ''.,''';

   O_integ_msg := I_integ_msg;

   open  C_MESSAGE;
   fetch C_MESSAGE into R_message;
   close C_MESSAGE;

   if R_message.msg_type != 'MOD' then
      return TRUE;
   end if;

   ----------------------------------------------------------------------------------
   -- Create workspace user
   ----------------------------------------------------------------------------------
   APEX_UTIL.SET_SECURITY_GROUP_ID (p_security_group_id => R_message.workspace_id);
   APEX_UTIL.REMOVE_USER           (p_user_name         => R_message.username);
   APEX_UTIL.CREATE_USER           (p_user_name         => R_message.username    ,
                                    p_web_password      => R_message.password    );

   delete from integration_message where integ_msg = I_integ_msg;

   return TRUE;

EXCEPTION
   when OTHERS then
      O_error_message := MSG_SQL.GET_MESSAGE_TEXT('PACKAGE_ERROR', SQLERRM, L_program, TO_CHAR(SQLCODE));
      return FALSE;

END SUBSCRIBE_WORKSPACE_USER_MOD;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function Name: SUBSCRIBE_WORKSPACE_USER
-- Purpose      :
----------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION SUBSCRIBE_WORKSPACE_USER_DEL (O_error_message  IN OUT CLOB        ,
                                       O_integ_msg       IN OUT INTEGRATION_MESSAGE.INTEG_MSG%TYPE,
                                       I_integ_msg       IN     INTEGRATION_MESSAGE.INTEG_MSG%TYPE,
                                       I_user            IN     APP_USER.APP_USER%TYPE            )
   return BOOLEAN is

   ----------------------------------------------------------------------------------
   -- Variable Declaration
   ----------------------------------------------------------------------------------
   L_program            VARCHAR2(100)      := 'APP_USER_SQL.SUBSCRIBE_WORKSPACE_USER_DEL';

   ----------------------------------------------------------------------------------
   -- Lock declaration
   ----------------------------------------------------------------------------------

   ----------------------------------------------------------------------------------
   -- Cursor Declaration
   ----------------------------------------------------------------------------------
   cursor C_MESSAGE is
      select upper(j.username) username     ,
             w.workspace_id ,
             j.app_id       ,
             i.company      ,
             i.msg_type
        from apex_workspaces     w,
             apex_applications   a,
             integration_message i,
             JSON_TABLE(i.message,'$' COLUMNS (username VARCHAR2(50) path '$.username',
                                               app_id   NUMBER(25)   path '$.appid'   )) j
       where i.integ_msg      = I_integ_msg
         and w.workspace      = a.workspace
         and a.application_id = j.app_id;

   R_message C_MESSAGE%ROWTYPE;

BEGIN

   if SYSTEM_SETUP_SQL.GET_SYS_SETUP('SYS_TRACE_IND') = 'Y' then
      SYSTEM_LOG_SQL.TRACE(O_error_message,'INTEGRATION_MESSAGE',I_integ_msg,L_program,NULL,NULL);
   end if;

   -- Force machine number format.
   EXECUTE IMMEDIATE 'alter session set NLS_NUMERIC_CHARACTERS = ''.,''';

   O_integ_msg := I_integ_msg;

   open  C_MESSAGE;
   fetch C_MESSAGE into R_message;
   close C_MESSAGE;

   if R_message.msg_type != 'DEL' then
      return TRUE;
   end if;

   ----------------------------------------------------------------------------------
   -- Create workspace user
   ----------------------------------------------------------------------------------
   APEX_UTIL.SET_SECURITY_GROUP_ID (p_security_group_id => R_message.workspace_id);
   APEX_UTIL.REMOVE_USER           (p_user_name         => R_message.username);

   ----------------------------------------------------------------------------------
   -- create rfa user
   ----------------------------------------------------------------------------------
   delete from app_user_company where app_user in (select app_user from app_user where app_user_name = UPPER(R_message.username));
   delete from app_user         where app_user_name = UPPER(R_message.username);


   delete from integration_message where integ_msg = I_integ_msg;

   return TRUE;

EXCEPTION
   when OTHERS then
      O_error_message := MSG_SQL.GET_MESSAGE_TEXT('PACKAGE_ERROR', SQLERRM, L_program, TO_CHAR(SQLCODE));
      return FALSE;

END SUBSCRIBE_WORKSPACE_USER_DEL;
----------------------------------------------------------------------------------------------------------------------------------------------------------
END APP_USER_SQL;
/

