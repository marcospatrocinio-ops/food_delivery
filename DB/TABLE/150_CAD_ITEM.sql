CREATE TABLE cad_item (
    item_id      NUMBER(10)       CONSTRAINT pk_cad_item PRIMARY KEY,
    item_ref     VARCHAR2(20 CHAR) NOT NULL UNIQUE,
    nome_curto   VARCHAR2(20 CHAR) NOT NULL,
    nome_longo   VARCHAR2(250 CHAR),
    valor_venda  NUMBER(10,2)     NOT NULL,
    loja_id      NUMBER(10)       NOT NULL,
    stock        CHAR(1)          DEFAULT 'N' NOT NULL
                  CONSTRAINT ck_cad_item_stock CHECK (stock IN ('S','N')),
    tipo         CHAR(1)          NOT NULL
                  CONSTRAINT ck_cad_item_tipo CHECK (tipo IN ('P','M','R'))
);


comment on table "CAD_ITEM" is 'Cadastro do item';

comment on column "CAD_ITEM"."STOCK" is 'Controla estoque S/N';

comment on column "CAD_ITEM"."TIPO" is 'P-produsido/M-Materia prima / R-Revenda';

create unique index "CAD_ITEM_IDX"
on "CAD_ITEM" ( "ITEM_ID" );

alter table "WKSP_PROJETOLOJA"."CAD_ITEM" add constraint
"CAD_ITEM_LOJA_CON" foreign key ( "LOJA_ID" ) references "CAD_LOJA" ( "LOJA_ID" ) on delete set null;



create sequence "CAD_ITEM_SEQ"
start with 1
increment by 1
cache 20
minvalue 1
maxvalue 9999999999
nocycle;


create or replace trigger "CAD_ITEM_TRG"
before
insert or update or delete on "CAD_ITEM"
for each row
begin
    if inserting then  
       if :new.ITEM_ID is null then  
          select CAD_ITEM_SEQ.nextval into :new.ITEM_ID from dual;     
       end if;  
       ---
       if :new.ITEM_REF  is null then 
          :new.ITEM_REF := :new.ITEM_ID;
       end if;
    end if; 
end;
/

