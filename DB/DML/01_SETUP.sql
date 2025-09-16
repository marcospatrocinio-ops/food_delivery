prompt Importing table system_setup...
set feedback off
set define off
insert into app_setup (APP_SETUP, SETUP, SETUP_NAME, SETUP_VALUE, CREATE_USER, CREATE_DATETIME, UPDATE_USER, UPDATE_DATETIME, CUST_IDENTITY)
values (1, 'APEX_VALIDA_SENHA', 'Liga(Y)/Desliga(N) a validação de complexidade de senha do RFA', 'Y', 1, SYSDATE, 1, SYSDATE, null);
prompt Done.


prompt Importing table APP_USERS...
set feedback off
set define off
insert into APP_USERS (IDUSER, USER_LOGIN, USER_PASSWORD, USER_EMAIL, CODE_USER, USER_NAME, USER_FIRSTNAME, USER_LASTNAME, USER_PHONE, USER_OTHER, USER_DIRECT_MANAGER, USER_POSITION, USER_AREA, STATUS, CREATE_USER, CREATE_DATETIME, UPDATE_USER, UPDATE_DATETIME)
values (1, 'sysadm', 'sysadm', 'mail@mail.com', 1, 'SYSADM', 'SYSADM', 'SYSADM', null, null, null, null, null, 'A', 10000, sysdate, 10000, sysdate);

prompt Importing table APP_MODULES...
set feedback off
set define off
insert into APP_MODULES (idmodule,module_name,status,create_user,create_datetime,update_user,update_datetime)
values (10,'Home','A', 1, sysdate, 1, sysdate);

insert into APP_MODULES (idmodule,module_name,status,create_user,create_datetime,update_user,update_datetime)
values (20000,'Gestão Pedidos',, 'A', 1, sysdate, 1, sysdate);

insert into APP_MODULES (idmodule,module_name,status,create_user,create_datetime,update_user,update_datetime)
values (40000,'Cadastro','A', 1, sysdate, 1, sysdate);

insert into APP_MODULES (idmodule,module_name,status,create_user,create_datetime,update_user,update_datetime)
values (60000,'Cardápio', 'A', 1, sysdate, 1, sysdate);

insert into APP_MODULES (idmodule,module_name,status,create_user,create_datetime,update_user,update_datetime)
values (70000,'Segurança', 'A', 1, sysdate, 1, sysdate);




