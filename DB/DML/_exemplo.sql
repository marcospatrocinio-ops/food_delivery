prompt Importing table NVPAIR_ATTRIB...
set feedback off
set define off

MERGE INTO NVPAIR_ATTRIB R
      USING (SELECT 'SYSTAX_DTL_GENERICO' NV_ATTRIB,
                    'Parametro Generico Detalhe da Chamada Systax' NV_ATTRIB_NAME,
                    'DFT' NV_OPERATION_TYPE,
                    'VARCHAR2' NV_ATTR_DATATYPE,
                    'N' NV_REQUIRED_IND,
                    'T' NV_FIELD_TYPE,
                    NULL NV_CODE_NAME,
                    'N' NV_FILTER_IND,
                    'N' NV_EDIT_IND,
                    'Y' NV_VISIBLE_IND,
                    'A' STATUS,
                    -1  CREATE_USER,
                    SYSDATE CREATE_DATETIME,
                    -1 UPDATE_USER,
                    SYSDATE UPDATE_DATETIME
                 FROM DUAL) O
  ON (R.NV_ATTRIB      = O.NV_ATTRIB
  AND R.NV_ATTRIB_NAME = O.NV_ATTRIB_NAME)
 WHEN MATCHED THEN
    UPDATE SET R.UPDATE_DATETIME     = SYSDATE
             , UPDATE_USER           = -1
 WHEN NOT MATCHED THEN 
    INSERT (  
            NV_ATTRIB,
            NV_ATTRIB_NAME,
            NV_OPERATION_TYPE,
            NV_ATTR_DATATYPE,
            NV_REQUIRED_IND,
            NV_FIELD_TYPE,
            NV_CODE_NAME,
            NV_FILTER_IND,
            NV_EDIT_IND,
            NV_VISIBLE_IND,
            STATUS,
            CREATE_USER,
            CREATE_DATETIME,
            UPDATE_USER,
            UPDATE_DATETIME)
    VALUES (O.NV_ATTRIB,
            O.NV_ATTRIB_NAME,
            O. NV_OPERATION_TYPE,
            O.NV_ATTR_DATATYPE,
            O.NV_REQUIRED_IND,
            O.NV_FIELD_TYPE,
            O.NV_CODE_NAME,
            O.NV_FILTER_IND,
            O.NV_EDIT_IND,
            O.NV_VISIBLE_IND,
            O.STATUS,
            O.CREATE_USER,
            O.CREATE_DATETIME,
            O.UPDATE_USER,
            O.UPDATE_DATETIME);   
------------------------------------------------- 
prompt Importing table FISCAL_GROUP_NVPAIR...

MERGE INTO FISCAL_GROUP_NVPAIR R
      USING (SELECT 4503                         AS FISCAL_GROUP
                    ,'GROUP_ATTRIBUTES'          AS NV_GROUP
                    ,'SYSTAX_DTL_GENERICO'       AS NV_ATTRIB
                    ,'excluiICMS=1'              AS NV_VALUE_STRING
               FROM DUAL) O
  ON (R.FISCAL_GROUP = O.FISCAL_GROUP
  AND R.NV_GROUP     = O.NV_GROUP
  AND R.NV_ATTRIB    = O.NV_ATTRIB)
 WHEN MATCHED THEN
    UPDATE SET R.UPDATE_DATETIME     = SYSDATE
             , UPDATE_USER           = -1
 WHEN NOT MATCHED THEN 
    INSERT (  
            FISCAL_GROUP_NVPAIR,
            FISCAL_GROUP,
            NV_GROUP,
            NV_SUBGROUP,
            NV_ATTRIB,
            NV_ATTRIB_PARENT,
            NV_ORDER_SEQ,
            STATUS,
            NV_VALUE_NUMBER,
            NV_VALUE_STRING,
            NV_VALUE_DATE,
            NV_VALUE_CLOB,
            NV_REF_1,
            NV_REF_2,
            NV_REF_3,
            NV_REF_4,
            CREATE_USER,
            CREATE_DATETIME,
            UPDATE_USER,
            UPDATE_DATETIME)
    VALUES (FISCAL_GROUP_NVPAIR_SEQ.NEXTVAL,
            O.FISCAL_GROUP,
            O.NV_GROUP,
            NULL,
            O.NV_ATTRIB,
            NULL,
            1, 
            'A',
            NULL,
            O.NV_VALUE_STRING,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            -1,
            SYSDATE,
            -1,
            SYSDATE); 

commit;

prompt Done.