-- Create table
create table APP_SETUP
(
  app_setup        NUMBER(18) not null,
  setup            VARCHAR2(25) not null,
  setup_name       VARCHAR2(250) not null,
  setup_value      VARCHAR2(4000) not null,
  create_user      NUMBER(18) not null,
  create_datetime  DATE not null,
  update_user      NUMBER(18) not null,
  update_datetime  DATE not null,
  cust_identity    VARCHAR2(255)
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table APP_SETUP
  add constraint PK_APP_SETUP primary key (APP_SETUP);
  
