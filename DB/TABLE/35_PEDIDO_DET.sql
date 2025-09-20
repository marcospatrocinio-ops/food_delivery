-- Criação da tabela de detalhe do pedido
CREATE TABLE PEDIDO_DTL (
    PEDIDO_DTL_ID NUMBER(10,0)    NOT NULL,
    PEDIDO_ID     NUMBER(10,0)    NOT NULL,
    LINHA_ID      NUMBER(5,0)     NOT NULL,
    ITEM_ID       NUMBER(10,0)    NOT NULL,
    QUANTIDADE    NUMBER(5,0)     NOT NULL,
    VALOR_VENDA   NUMBER(12,2)    NOT NULL,
    VALOR_TOTAL  NUMBER(10,2)     NOT NULL, 
    STATUS        VARCHAR2(1 CHAR) NOT NULL,
    
    CONSTRAINT PK_PEDIDO_DTL PRIMARY KEY (PEDIDO_DTL_ID),
    CONSTRAINT FK_PEDIDO_DTL_PEDIDO FOREIGN KEY (PEDIDO_ID)
        REFERENCES PEDIDO_CAB (PEDIDO_ID),
    CONSTRAINT CK_PEDIDO_DTL_STATUS CHECK (STATUS IN ('A','I'))
);

-- Comentário da tabela
COMMENT ON TABLE PEDIDO_DTL IS 'Detalhe do pedido';

-- Comentários das colunas
COMMENT ON COLUMN PEDIDO_DTL.PEDIDO_DTL_ID IS 'Identificador único do detalhe do pedido';
COMMENT ON COLUMN PEDIDO_DTL.PEDIDO_ID     IS 'Chave estrangeira para tabela PEDIDO';
COMMENT ON COLUMN PEDIDO_DTL.LINHA_ID      IS 'Número da linha no pedido';
COMMENT ON COLUMN PEDIDO_DTL.ITEM_ID       IS 'Identificador do item';
COMMENT ON COLUMN PEDIDO_DTL.QUANTIDADE    IS 'Quantidade solicitada';
COMMENT ON COLUMN PEDIDO_DTL.VALOR_VENDA   IS 'Valor unitário de venda';
COMMENT ON COLUMN PEDIDO_DTL.STATUS        IS 'A = Ativo / I = Inativo';

alter table "WKSP_PROJETOLOJA"."PEDIDO_DTL" add constraint
"PEDIDO_DTL_ITEM_FK" foreign key ( "ITEM_ID" ) references "CAD_ITEM" ( "ITEM_ID" ) on delete set null;



create sequence "PEDIDO_DTL_SEQ"
start with 1
increment by 1
cache 20
minvalue 1
maxvalue 9999999999
nocycle;

create or replace trigger "PEDIDO_DTL_TRG" 
before 
insert or update or delete on "PEDIDO_DTL" 
for each row 
begin 
    if inserting then  
       if :new.PEDIDO_DTL_ID is null then  
          select PEDIDO_DTL_SEQ.nextval into :new.PEDIDO_DTL_ID from dual;  
          :new.status := 'A';  
          :new.valor_total := :new.valor_venda * :new.quantidade;

       end if;
    end if;
    ---
    if updating then
         :new.valor_total := :new.valor_venda * :new.quantidade;
    end if;  
end;
/

create or replace trigger PEDIDO_DTL_BI
before insert on PEDIDO_DTL
for each row
declare
   v_linha number;
begin
   select nvl(max(LINHA_id),0)+1
     into v_linha
     from PEDIDO_DTL
    where PEDIDO_ID = :new.PEDIDO_ID;

   :new.LINHA_ID := v_linha;
end;
/

CREATE OR REPLACE TRIGGER PEDIDO_DTL_AS
AFTER INSERT OR UPDATE OR DELETE ON PEDIDO_DTL
DECLARE
BEGIN
    -- Atualiza todos os pedidos que foram afetados na tabela pedido_dtl
    MERGE INTO pedido_cab pc
    USING (
        SELECT pedido_id, NVL(SUM(valor_venda * quantidade),0) AS total
          FROM pedido_dtl
         GROUP BY pedido_id
    ) dt
    ON (pc.pedido_id = dt.pedido_id)
    WHEN MATCHED THEN
      UPDATE SET pc.valor_total = dt.total;
END;
/