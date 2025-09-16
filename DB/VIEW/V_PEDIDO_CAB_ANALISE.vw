  CREATE OR REPLACE FORCE EDITIONABLE VIEW "C_PEDIDO_CAB_ANALISE" ("PEDIDO_ID", "LOJA_ID", "TIPO_ENTREGA", "TIPO_ORIGEM", "DATA_ENTRADA", "CARD_PRIMARY_KEY", "CARD_SECONDARY_KEY", "CARD_TITLE", "CARD_SUBTITLE", "CARD_BODY", "CARD_SECONDARY_BODY", "CARD_ICON_ENTREGA", "CARD_ICON_ORIGEM", "CARD_ICON_TEMPO", "CARD_BADGE", "CARD_IMAGE") AS 
  select
 ped.PEDIDO_ID,
 ped.LOJA_ID,
 ped.TIPO_ENTREGA,
 ped.TIPO_ORIGEM,
 ped.DATA_ENTRADA,
 -- data
 ped.PEDIDO_ID card_primary_key,    -- primary key
 ped.CLIENTE_ID card_secondary_key,  -- secondary key if needed
 'Cliente: '||cli.nome card_title,          -- title
  'Entrada: '||to_char(ped.data_entrada,'HH24:MM') card_subtitle,       -- subtitle
  'texto teste 01' card_body,           -- card body text
  'texto teste 02' card_secondary_body, -- card secondary text, positioned near bottom
  -- ui and other attributes
  case 
    when ped.TIPO_ENTREGA = 'R' then
  (select setup_value from APP_SETUP where setup = 'ICON_TIPO_ENTREGA_R')
    when ped.TIPO_ENTREGA = 'E' then
  (select setup_value from APP_SETUP where setup = 'ICON_TIPO_ENTREGA_E')
  else ''
  end as card_icon_entrega,         -- icon class, e.g. fa-cloud
--
    case 
    when ped.TIPO_ORIGEM = 'B' then
  (select setup_value from APP_SETUP where setup = 'ICON_TIPO_ORIGEM_B')
    when ped.TIPO_ORIGEM = 'O' then
  (select setup_value from APP_SETUP where setup = 'ICON_TIPO_ORIGEM_O')
    when ped.TIPO_ORIGEM = 'I' then
  (select setup_value from APP_SETUP where setup = 'ICON_TIPO_ORIGEM_I')
  else ''
  end as card_icon_origem,         -- icon class, e.g. fa-cloud
--
   case 
    when ped.data_entrada + (10 / (24*60)) < sysdate  then
  (select setup_value from APP_SETUP where setup = 'ICON_SLEEPING')
  else ''
  end as card_icon_tempo,         -- icon class, e.g. fa-cloud
---
  '' card_badge,          -- badge, can be a small text
  '' card_image           -- image url, url or blob columns
from pedido_cab ped,
     cad_cliente cli
where ped.cliente_id = cli.cliente_id
and ped.status = 1
order by ped.DATA_ENTRADA;