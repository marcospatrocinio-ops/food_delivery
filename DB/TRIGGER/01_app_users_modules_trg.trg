CREATE OR REPLACE TRIGGER app_users_modules_trg
  before insert or update on APP_USERS_MODULES
  for each row
begin
  if inserting then
    if :new.idusermodule is null then
      select app_users_modules_seq.nextval into :new.idusermodule from dual;
    end if;
  end if;
end;
/
