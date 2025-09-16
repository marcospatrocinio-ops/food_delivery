create or replace trigger "APP_USERS_TRG_SETS"
before
insert or update or delete on "APP_USERS"
for each row
begin
   if inserting then
      :NEW.create_user     := v('APP_USER_ID');
      :NEW.create_datetime := sysdate;
   end if;
    :NEW.update_user     := v('APP_USER_ID');
    :NEW.update_datetime := sysdate;
 end;
/