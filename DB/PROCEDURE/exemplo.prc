CREATE OR REPLACE PROCEDURE PRC_PURGE_DML_AUDIT_LOG
AS
  l_deletedRows  NUMBER;
  l_cmd          VARCHAR2(2000);
BEGIN

/*
-- Limpeza FULL na tabela de auditoria
truncate table DML_AUDIT_LOG;
alter sequence DML_AUDIT_LOG_SEQ restart start with 1;
*/

  FOR tab IN (select owner, table_name, NVL(purge_days, 30) purge_days
                from BRX_AUDIT_TABLE
            order by owner, table_name)
  LOOP

    l_cmd :=    'DELETE FROM DML_AUDIT_LOG'
             || ' WHERE rownum <= 10000 '           -- Commit parcial
             ||   ' AND create_date <= SYSDATE - '  || tab.purge_days
             ||   ' AND owner = '''      || tab.owner      || ''''
             ||   ' AND table_name = ''' || tab.table_name || '''' ;

     l_deletedRows := 1;

     WHILE l_deletedRows > 0
     LOOP
         EXECUTE IMMEDIATE l_cmd;
         l_deletedRows := SQL%ROWCOUNT;
        COMMIT;
     END LOOP;

  END LOOP;

END;
/

