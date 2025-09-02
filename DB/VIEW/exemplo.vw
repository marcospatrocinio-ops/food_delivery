create or replace force view sec_user_locs as
select t2.entity, t1.app_user_ref from app_user t1,app_user_entity t2
    where t1.app_user = t2.app_user;

