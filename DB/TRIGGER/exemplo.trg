CREATE OR REPLACE TRIGGER APP_USERS_TRG
  BEFORE INSERT OR UPDATE ON APP_USERS
  FOR EACH ROW
-- {{all_keywords_git}}
begin
  if inserting then
    if :new.iduser is null then
      select app_users_seq.nextval into :new.iduser from dual;
    end if;
    :new.user_password := pck_security.fnc_encrypt_password(string_pass => :new.user_password);
  end if;
end;
/

