CREATE OR REPLACE FUNCTION func_users_check_name(
	p_name text
) RETURNS boolean AS $$
	BEGIN
		IF p_name IS NOT NULL AND char_length(trim(p_name)) = 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_users_check_name',
				MESSAGE = 'Missing name',
				DETAIL = 'p_name: '|| p_name;
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_check_name TO api;