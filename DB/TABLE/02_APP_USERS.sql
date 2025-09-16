-- Create table
create table APP_USERS
(
  iduser              NUMBER not null,
  user_login          VARCHAR2(20) not null,
  user_password       VARCHAR2(50) not null,
  user_email          VARCHAR2(60) not null,
  user_name           VARCHAR2(250) not null,
  user_phone          VARCHAR2(50),
  status              VARCHAR2(1) default 'A' not null,
  create_user         NUMBER(18) not null,
  create_datetime     DATE not null,
  update_user         NUMBER(18) not null,
  update_datetime     DATE not null
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table APP_USERS
  add constraint PK_APP_USERS primary key (IDUSER);
  
  
