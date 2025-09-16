-- Create table
create table APP_SCREENS
(
  idscreen        NUMBER not null,
  idmodule        NUMBER not null,
  screen_name     VARCHAR2(250) not null,
  status          VARCHAR2(1) default 'A' not null,
  create_user     NUMBER(18) not null,
  create_datetime DATE not null,
  update_user     NUMBER(18) not null,
  update_datetime DATE not null,
  app_code_module NUMBER,
  app_idpage_apex NUMBER,
  help_link       VARCHAR2(4000)
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table APP_SCREENS
  add constraint PK_SCREENS primary key (IDSCREEN);
  
alter table APP_SCREENS
  add constraint FK_SCREENS1 foreign key (IDMODULE)
  references APP_MODULES (IDMODULE);
