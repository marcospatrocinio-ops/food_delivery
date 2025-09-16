-- Create table
create table APP_PROFILES_USERS
(
  id              NUMBER not null,
  idprofile       NUMBER not null,
  iduser          NUMBER not null,
  status          VARCHAR2(1) default 'A' not null,
  create_user     NUMBER(18) not null,
  create_datetime DATE not null,
  update_user     NUMBER(18) not null,
  update_datetime DATE not null
);

-- Create/Recreate indexes 
create index DTC_FK_APP_PROFILES_USER1 on APP_PROFILES_USERS (IDPROFILE);

create index DTC_FK_APP_PROFILES_USER2 on APP_PROFILES_USERS (IDUSER);


-- Create/Recreate primary, unique and foreign key constraints 
alter table APP_PROFILES_USERS
  add constraint PK_APP_PROFILES_USERS primary key (ID);
  
alter table APP_PROFILES_USERS
  add constraint FK_APP_PROFILES_USER1 foreign key (IDPROFILE)
  references APP_PROFILES (IDPROFILE);

alter table APP_PROFILES_USERS
  add constraint FK_APP_PROFILES_USER2 foreign key (IDUSER)
  references APP_USERS (IDUSER);

