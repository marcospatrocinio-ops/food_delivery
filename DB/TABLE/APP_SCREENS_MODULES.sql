-- Create table
create table APP_SCREENS_MODULES
(
  id              NUMBER not null,
  idscreen        NUMBER,
  idmodule        NUMBER not null,
  status          VARCHAR2(1) default 'A' not null,
  create_user     NUMBER(18) not null,
  create_datetime DATE not null,
  update_user     NUMBER(18) not null,
  update_datetime DATE not null,
  idcompany       NUMBER not null
);
-- Create/Recreate indexes 
create index APP_SCREENS_MODULES1 on APP_SCREENS_MODULES (IDSCREEN);

-- Create/Recreate primary, unique and foreign key constraints 
alter table APP_SCREENS_MODULES
  add constraint PK_APP_SCREENS_MODULESY primary key (ID);
  
alter table APP_SCREENS_MODULES
  add constraint FK_APP_SCREENS_MODULES1 foreign key (IDSCREEN)
  references APP_SCREENS (IDSCREEN);

