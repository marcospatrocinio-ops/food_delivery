-- Create table
create table APP_PROFILES_ACCESS
(
  idprofile_access NUMBER not null,
  idprofile        NUMBER not null,
  idcompany        NUMBER not null,
  idmodule         NUMBER not null,
  idscreen         NUMBER not null,
  status           VARCHAR2(1) default 'A' not null,
  type_access      NUMBER default 1 not null,
  create_user      NUMBER(18) not null,
  create_datetime  DATE not null,
  update_user      NUMBER(18) not null,
  update_datetime  DATE not null
);

-- Create/Recreate indexes 
create index DTC_FK_APP_PROFILES_ACCESS1 on APP_PROFILES_ACCESS (IDPROFILE);

create index DTC_FK_APP_PROFILES_ACCESS2 on APP_PROFILES_ACCESS (IDMODULE);

create index DTC_FK_APP_PROFILES_ACCESS3 on APP_PROFILES_ACCESS (IDSCREEN);

-- Create/Recreate primary, unique and foreign key constraints 
alter table APP_PROFILES_ACCESS
  add constraint PK_APP_PROFILES_ACCESS primary key (IDPROFILE_ACCESS);
  
alter table APP_PROFILES_ACCESS
  add constraint FK_APP_PROFILES_ACCESS1 foreign key (IDPROFILE)
  references APP_PROFILES (IDPROFILE);

alter table APP_PROFILES_ACCESS
  add constraint FK_APP_PROFILES_ACCESS2 foreign key (IDMODULE)
  references APP_MODULES (IDMODULE);
  
  
alter table APP_PROFILES_ACCESS
  add constraint FK_APP_PROFILES_ACCESS3 foreign key (IDSCREEN)
  references APP_SCREENS (IDSCREEN);
  
