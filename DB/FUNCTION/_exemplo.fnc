CREATE OR REPLACE FUNCTION REPLACE_CLOB
(
  in_source  IN CLOB,
  in_search  IN CLOB,
  in_replace IN CLOB
)
RETURN CLOB
IS
  l_pos pls_integer;
BEGIN
  l_pos := instr(in_source, in_search);

  IF l_pos > 0 THEN
    RETURN substr(in_source, 1, l_pos-1)
        || in_replace
        || substr(in_source, l_pos+LENGTH(in_search));
  END IF;

  RETURN in_source;
END replace_clob;
/

