-- Create table
create table CAD_EMPRESA
(
  CAD_EMPRESA            NUMBER(18) not null,
  CAD_EMPRESA_name       VARCHAR2(250) not null,
  CAD_EMPRESA_type       VARCHAR2(25) not null,
  status            VARCHAR2(1) default 'W' not null,
  create_user       NUMBER(18) not null,
  create_datetime   DATE not null,
  update_user       NUMBER(18) not null,
  update_datetime   DATE not null,
);

-- Create/Recreate primary, unique and foreign key constraints 
alter table CAD_EMPRESA
  add constraint PK_CAD_EMPRESA primary key (CAD_EMPRESA);
 


