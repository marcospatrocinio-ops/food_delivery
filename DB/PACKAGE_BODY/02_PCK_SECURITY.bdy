create or replace PACKAGE BODY PCK_SECURITY IS
----------------------------------------------------------------------------------------------------------------------------------------------------------
  --
  function fnc_validate_access_page(p_iduser      in number,
                                    p_idscreen    in number,
                                    p_type_access in number) return boolean is
    v_retorno number;
    v_sysdbx  number;
    v_sysadm  number;
  begin
    --
    begin
      select 1
        into v_sysdbx
        from app_users u
       where u.iduser = p_iduser
         and u.user_login = 'sysadm';
      return true;
    exception
      when no_data_found then
        null;
    end;
/*
    --
    select r
      into v_retorno
      from (select 1 r
              from app_profiles_access pa
             inner join app_profiles_users pu
                on pu.idcompany = pa.idcompany
               and pu.idprofile = pa.idprofile
             where pa.idcompany = p_idcompany
               and pa.status = 'A'
               and pu.iduser = p_iduser
               and pu.status = 'A'
               and exists (select *
                      from app_screens s
                     where s.app_idpage_apex = p_idscreen
                       and s.idscreen = pa.idscreen
                       and s.status = 'A')
               and pa.type_access >= p_type_access
            union all
            select 1 r
              from app_users_access ua
             where ua.idcompany = p_idcompany
               and ua.status = 'A'
               and ua.iduser = p_iduser
               and exists (select 1
                      from app_screens s
                     where s.app_idpage_apex = p_idscreen
                       and s.idscreen = ua.idscreen
                       and s.status = 'A')
               and ua.type_access >= p_type_access)
     where rownum = 1;
*/
    return true;
  exception
    when no_data_found then
      return false;
  end fnc_validate_access_page;
  --------------------------------------------------------------------------------------------------------------------------
  function fnc_encrypt_password(string_pass varchar2) return varchar2 is
    hexkey varchar2(32) := null;
  begin
    --hexkey := rawtohex(DBMS_OBFUSCATION_TOOLKIT.md5(input => UTL_RAW.cast_to_raw(string_pass)));
    --return nvl(hexkey, '');
    return string_pass;
  end fnc_encrypt_password;
  --------------------------------------------------------------------------------------------------------------------------
  function fnc_get_menu(p_menu_pai   in number,
                        p_menu_filho in number,
                        p_iduser     in number) return boolean is

    v_modulo_pai   number;
    v_modulo_filho number;
    v_tela         number;
    v_retorno      number;
    v_sysdbx       number;
    v_sysadm       number;
  begin
    --
    begin
      select 1
        into v_sysdbx
        from app_users u
       where u.iduser = p_iduser
         and u.user_login = 'sysadm';
      return true;
    exception
      when no_data_found then
        null;
    end;
 /*
 --   Valida se companhia tem menu pai
    begin
      select m.idmodule
        into v_modulo_pai
        from app_screens_modules sm
       inner join app_modules m
          on m.idmodule = sm.idmodule
       where sm.idcompany = p_idcompany
         and sm.status = 'A'
         and m.status = 'A'
         and m.app_code_module = p_menu_pai
         and rownum = 1;
    exception
      when no_data_found then
        return false;
    end;

    --Valida se companhia tem menu fiho
    begin
      select s.idmodule, s.app_idpage_apex--s.idscreen
        into v_modulo_filho, v_tela
        from app_screens_modules sm
       inner join app_modules m
          on m.idmodule = sm.idmodule
       inner join app_screens s
          on s.idmodule = m.idmodule
         and s.idscreen = sm.idscreen
       where sm.idcompany = p_idcompany
         and sm.status = 'A'
         and m.status = 'A'
         and m.app_code_module = p_menu_pai
         and (p_menu_filho is null or s.app_code_module = p_menu_filho)
         and s.status = 'A'
         and rownum = 1;
    exception
      when no_data_found then
        return false;
    end;

    begin
      select 1
        into v_retorno
        from app_users_access a
       where a.idcompany = p_idcompany
         and a.status = 'A'
         and a.iduser = p_iduser
         and a.idmodule = v_modulo_filho
         and a.idscreen = v_tela
         and rownum = 1;
    exception
      when no_data_found then
        v_retorno := 0;
    end;
 
    --
    if v_retorno = 0 then
      begin
        select 1
          into v_retorno
          from app_modules m
         inner join app_screens s
            on m.idmodule = s.idmodule
         inner join app_screens_modules sm
            on sm.idscreen = s.idscreen
           and sm.status = 'A'
         inner join app_profiles_access pa
            on pa.idcompany = sm.idcompany
           and pa.idscreen = sm.idscreen
           and pa.status = 'A'
         inner join app_profiles_users pu
            on pu.idcompany = pa.idcompany
           and pu.idprofile = pa.idprofile
           and pu.status = 'A'
         where sm.idcompany = p_idcompany
           and pu.iduser = p_iduser
           and (p_menu_pai is null or m.app_code_module = p_menu_pai)
           and (p_menu_filho is null or (s.app_code_module = p_menu_filho and
               s.app_idpage_apex = v_tela))
           and rownum = 1;
      exception
        when no_data_found then
          v_retorno := 0;
      end;
    end if;
 */
    --
    if v_retorno = 0 then
      return false;
    else
      return true;
    end if;
    --
  end fnc_get_menu;
  --------------------------------------------------------------------------------------------------------------------------
  FUNCTION fnc_validate_password(P_password varchar2) return varchar2 AS
  
  BEGIN
 	   -- Criterios de aceite de nova senha pro usuario
/*
     IF APP_SETUP_SQL.GET_SYS_SETUP('APEX_VALIDA_SENHA') = 'Y' THEN
       --
       -- Comprimento minimo: 8 a 12 caracteres
       IF NOT ( LENGTH(P_password) BETWEEN 8 AND 12 ) THEN
          RETURN 'Senha deve conter de 8 a 12 caracteres.';
       END IF;

       -- Complexidade: Uma letra maiuscula (A-Z)
       IF NOT ( REGEXP_LIKE(P_password, '^.*[A-Z]', 'c') ) THEN
          RETURN 'Senha deve conter ao menos uma letra maiúscula (A-Z).';
       END IF;

       -- Complexidade: Uma letra minuscula (z-z)
       IF NOT ( REGEXP_LIKE(P_password, '^.*[a-z]', 'c') ) THEN
          RETURN 'Senha deve conter ao menos uma letra minúscula (a-z).';
       END IF;

       -- Complexidade: Um numero (0-9)
       IF NOT ( REGEXP_LIKE(P_password, '^.*[0-9]') ) THEN
          RETURN 'Senha deve conter ao menos um número (0-9).';
       END IF;

       -- Complexidade: Um caracter especial
       IF NOT ( REGEXP_LIKE(P_password, '^.*[!@#$%^&*()_]', 'c') ) THEN
          RETURN 'Senha deve conter ao menos um caracter especial.';
       END IF;
       --
     END IF;
*/
     -- Senha Ok
     RETURN NULL;

  END fnc_validate_password;
  --------------------------------------------------------------------------------------------------------------------------
  procedure modify_password(p_iduser      in number,
                            p_oldpass     in varchar2,
                            p_newpass     in varchar2,
                            p_confirmpass in varchar2,
                            p_msg         out varchar2) is
    v_pass varchar2(200);
  begin
    --
    select u.user_password
      into v_pass
      from app_users u
     where u.iduser    = p_iduser;
    --
    if trim(v_pass) = pck_security.fnc_encrypt_password(p_oldpass) then
      --
      p_msg := pck_security.fnc_validate_password(P_password => p_newpass);

      if p_msg is not null then
         return;
      end if;
      --
      if pck_security.fnc_encrypt_password(p_newpass) <>
         pck_security.fnc_encrypt_password(p_confirmpass) then
        p_msg := 'Senhas não coincidem, favor verificar.';
      else
        update app_users u
           set u.user_password = pck_security.fnc_encrypt_password(p_newpass)
         where u.iduser = p_iduser;
        commit;
        p_msg := 0;
      end if;
      --
    else
      p_msg := 'Senha atual não confere com a informada.';
    end if;
  end modify_password;
  --------------------------------------------------------------------------------------------------------------------------
  function fnc_read_itens_page(p_iduser    in number,
                               p_idscreen  in number) return boolean is
  begin
    if pck_security.fnc_validate_access_page(p_iduser      => p_iduser,
                                             p_idscreen    => p_idscreen,
                                             p_type_access => 1) = true then
      return false;
    else
      return true;
    end if;
  end fnc_read_itens_page;

   ----------------------------------------------------------------------------------------------------------------------------------------------------------
   -- Function Name: FNC_APEX_BUTTON_ENABLED
   -- Purpose      : Verifica se usuario tem permissao para acessar botao com base no perfil
   ----------------------------------------------------------------------------------------------------------------------------------------------------------
   FUNCTION FNC_APEX_BUTTON_ENABLED(P_app_user    in varchar2,
                                    P_id_screen   in number  ,
                                    P_button_name in varchar2) return boolean is
      L_found number;
   BEGIN

      -- Usuario admin
      if upper(P_app_user) in ('SYSADM') then
         return TRUE;
      end if;
/*
      -- Usuario pertence a um grupo que tem permissao de acesso ao botao
      select count(1) --u.iduser, u.user_login, p.idprofile, p.name profile_name, a.id_screen, a.button_name
        into L_found
        from APP_USERS                    u
        join APP_PROFILES_USERS           pu on pu.iduser    = u.iduser
        join APP_PROFILES                 p  on p.idprofile  = pu.idprofile
        join APP_PROFILES_ACCESS_BUTTON   a  on a.id_profile = pu.idprofile
       where 1=1
         and a.id_screen         = p_id_screen
         and a.button_name       = p_button_name
         and upper(u.user_login) = upper(p_app_user);

      if l_found > 0 then
         RETURN TRUE;
      end if;
*/
      return FALSE;
   END FNC_APEX_BUTTON_ENABLED;

  --------------------------------------------------------------------------------------------------------------------------
END PCK_SECURITY;
/