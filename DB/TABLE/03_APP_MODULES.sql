-- Create table
create table APP_MODULES
(
  idmodule        NUMBER not null,
  module_name     VARCHAR2(250) not null,
  status          VARCHAR2(1) default 'A' not null,
  create_user     NUMBER(18) not null,
  create_datetime DATE not null,
  update_user     NUMBER(18) not null,
  update_datetime DATE not null,
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table APP_MODULES
  add constraint PK_APP_MODULES primary key (IDMODULE);

