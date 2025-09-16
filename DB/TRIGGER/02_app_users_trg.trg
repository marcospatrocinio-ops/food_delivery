CREATE OR REPLACE TRIGGER app_users_trg
  before insert or update on app_users
  for each row
begin
  if inserting then
    if :new.iduser is null then
      select app_users_seq.nextval into :new.iduser from dual;
    end if;
    :new.user_password := pck_security.fnc_encrypt_password(string_pass => :new.user_password);
  end if;
end;
/
