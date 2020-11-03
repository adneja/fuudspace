PGDMP                     
    x            fuudi    12.4    12.4 '   9           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            :           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ;           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            <           1262    26063    fuudi    DATABASE     w   CREATE DATABASE fuudi WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE fuudi;
                postgres    false                        3079    26064    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            =           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    3                        3079    26101 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            >           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                        false    2            E           1247    26608 	   typ_files    TYPE     \   CREATE TYPE public.typ_files AS (
	id integer,
	name text,
	size integer,
	mimetype text
);
    DROP TYPE public.typ_files;
       public          postgres    false            H           1247    26611    typ_fooditems    TYPE     A   CREATE TYPE public.typ_fooditems AS (
	id integer,
	name text
);
     DROP TYPE public.typ_fooditems;
       public          postgres    false            K           1247    26614    typ_mealplans    TYPE     j   CREATE TYPE public.typ_mealplans AS (
	id integer,
	name text,
	description text,
	is_favorite boolean
);
     DROP TYPE public.typ_mealplans;
       public          postgres    false            N           1247    26617    typ_measurements    TYPE     U   CREATE TYPE public.typ_measurements AS (
	id integer,
	name text,
	long_name text
);
 #   DROP TYPE public.typ_measurements;
       public          postgres    false            Q           1247    26620    typ_recipes    TYPE     b  CREATE TYPE public.typ_recipes AS (
	id integer,
	name text,
	description text,
	cooking_time integer,
	portions integer,
	file_id integer,
	file_mimetype text,
	created_by integer,
	created_by_name text,
	created_epoch integer,
	rating double precision,
	number_of_ratings integer,
	saves integer,
	matching_ingredients integer,
	is_favorite boolean
);
    DROP TYPE public.typ_recipes;
       public          postgres    false            f           1247    26701    typ_recipes_ingredients    TYPE     �   CREATE TYPE public.typ_recipes_ingredients AS (
	recipe_id integer,
	fooditem_id integer,
	fooditem_name text,
	measurement_id integer,
	measurement_name text,
	amount integer
);
 *   DROP TYPE public.typ_recipes_ingredients;
       public          postgres    false            l           1247    26710    typ_recipes_instructions    TYPE     y   CREATE TYPE public.typ_recipes_instructions AS (
	id integer,
	recipe_id integer,
	number integer,
	instructions text
);
 +   DROP TYPE public.typ_recipes_instructions;
       public          postgres    false            r           1247    26719    typ_recipes_ratings    TYPE     �   CREATE TYPE public.typ_recipes_ratings AS (
	recipe_id integer,
	rating integer,
	comment text,
	created_by integer,
	created_by_name text,
	created_epoch double precision
);
 &   DROP TYPE public.typ_recipes_ratings;
       public          postgres    false            T           1247    26626 	   typ_users    TYPE     J   CREATE TYPE public.typ_users AS (
	id integer,
	email text,
	name text
);
    DROP TYPE public.typ_users;
       public          postgres    false            {           1247    26802    typ_users_shoppinglist    TYPE     �   CREATE TYPE public.typ_users_shoppinglist AS (
	fooditem_id integer,
	fooditem_name text,
	amount integer,
	standardized_measurement text,
	created_by integer,
	checked boolean
);
 )   DROP TYPE public.typ_users_shoppinglist;
       public          postgres    false            6           1255    26455    func_files_check_mimetype(text)    FUNCTION     �  CREATE FUNCTION public.func_files_check_mimetype(p_mimetype text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_mimetype IS NOT NULL AND split_part(p_mimetype, '/', 1) <> 'image'  THEN
			RAISE EXCEPTION USING
				HINT = 'func_files_check_mimetype',
				MESSAGE = 'File must be an image',
				DETAIL = 'p_mimetype: ' || p_mimetype;
		END IF;
		
		RETURN true;
	END;
$$;
 A   DROP FUNCTION public.func_files_check_mimetype(p_mimetype text);
       public          postgres    false            ?           0    0 3   FUNCTION func_files_check_mimetype(p_mimetype text)    ACL     P   GRANT ALL ON FUNCTION public.func_files_check_mimetype(p_mimetype text) TO api;
          public          postgres    false    310            7           1255    26457    func_files_check_name(text)    FUNCTION     m  CREATE FUNCTION public.func_files_check_name(p_name text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_name IS NOT NULL AND char_length(trim(p_name)) = 0 THEN
			RAISE EXCEPTION USING	
				HINT = 'func_files_check_name',
				MESSAGE = 'Name must be longer than 0 characters',
				DETAIL = 'p_name: ' || p_name;
		END IF;
		
		RETURN true;
	END;
$$;
 9   DROP FUNCTION public.func_files_check_name(p_name text);
       public          postgres    false            @           0    0 +   FUNCTION func_files_check_name(p_name text)    ACL     H   GRANT ALL ON FUNCTION public.func_files_check_name(p_name text) TO api;
          public          postgres    false    311            :           1255    26453    func_files_check_size(integer)    FUNCTION     h  CREATE FUNCTION public.func_files_check_size(p_size integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_size IS NOT NULL AND NOT p_size > 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_files_check_size',
				MESSAGE = 'File size must be larger than 0',
				DETAIL = 'p_size: ' || CAST(p_size AS text);
		END IF;
		
		RETURN true;
	END;
$$;
 <   DROP FUNCTION public.func_files_check_size(p_size integer);
       public          postgres    false            A           0    0 .   FUNCTION func_files_check_size(p_size integer)    ACL     K   GRANT ALL ON FUNCTION public.func_files_check_size(p_size integer) TO api;
          public          postgres    false    314            X           1255    26631 /   func_files_insert(text, integer, text, integer)    FUNCTION       CREATE FUNCTION public.func_files_insert(p_name text, p_size integer, p_mimetype text, p_created_by integer) RETURNS SETOF public.typ_files
    LANGUAGE plpgsql
    AS $$
	DECLARE	
		v_new_file_id integer;
	BEGIN		
		-- insert file
		INSERT INTO tbl_files(
			name,
			size,
			mimetype,
			created_by
		) VALUES (
			p_name,
			p_size,
			p_mimetype,
			p_created_by
		) RETURNING id INTO v_new_file_id;
		
		-- return new file row
		RETURN QUERY
			SELECT 
				* 
			FROM 
				viw_files 
			WHERE 
				id = v_new_file_id;
	END;
$$;
 l   DROP FUNCTION public.func_files_insert(p_name text, p_size integer, p_mimetype text, p_created_by integer);
       public          postgres    false    837            B           0    0 ^   FUNCTION func_files_insert(p_name text, p_size integer, p_mimetype text, p_created_by integer)    ACL     {   GRANT ALL ON FUNCTION public.func_files_insert(p_name text, p_size integer, p_mimetype text, p_created_by integer) TO api;
          public          postgres    false    344            5           1255    26463    func_fooditems_check_name(text)    FUNCTION     t  CREATE FUNCTION public.func_fooditems_check_name(p_name text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_name IS NOT NULL AND char_length(trim(p_name)) = 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_fooditems_check_name',
				MESSAGE = 'Name must be longer than 0 characters',
				DETAIL = 'p_name: ' || p_name;
		END IF;
		
		RETURN true;
	END;
$$;
 =   DROP FUNCTION public.func_fooditems_check_name(p_name text);
       public          postgres    false            C           0    0 /   FUNCTION func_fooditems_check_name(p_name text)    ACL     L   GRANT ALL ON FUNCTION public.func_fooditems_check_name(p_name text) TO api;
          public          postgres    false    309            Q           1255    26636 $   func_fooditems_insert(text, integer)    FUNCTION     �  CREATE FUNCTION public.func_fooditems_insert(p_name text, p_created_by integer) RETURNS SETOF public.typ_fooditems
    LANGUAGE plpgsql
    AS $$
	DECLARE
		v_new_fooditem_id integer;
	BEGIN
		-- insert fooditem
		INSERT INTO tbl_fooditems(
			name,
			created_by
		) VALUES (
			p_name,
			p_created_by
		) RETURNING
			id INTO v_new_fooditem_id;
		
		-- return new fooditem row
		RETURN QUERY
			SELECT 
				* 
			FROM 
				viw_fooditems 
			WHERE 
				id = v_new_fooditem_id;
	END;
$$;
 O   DROP FUNCTION public.func_fooditems_insert(p_name text, p_created_by integer);
       public          postgres    false    840            D           0    0 A   FUNCTION func_fooditems_insert(p_name text, p_created_by integer)    ACL     ^   GRANT ALL ON FUNCTION public.func_fooditems_insert(p_name text, p_created_by integer) TO api;
          public          postgres    false    337            R           1255    26637    func_fooditems_query(text)    FUNCTION       CREATE FUNCTION public.func_fooditems_query(p_search text) RETURNS SETOF public.typ_fooditems
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_fooditems
			WHERE
				lower(name) LIKE '%' || lower(p_search) || '%';
	END;
$$;
 :   DROP FUNCTION public.func_fooditems_query(p_search text);
       public          postgres    false    840            E           0    0 ,   FUNCTION func_fooditems_query(p_search text)    ACL     I   GRANT ALL ON FUNCTION public.func_fooditems_query(p_search text) TO api;
          public          postgres    false    338            4           1255    26451 6   func_global_check_created(timestamp without time zone)    FUNCTION     �  CREATE FUNCTION public.func_global_check_created(p_created timestamp without time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_created IS NOT NULL AND p_created > now() THEN
			RAISE EXCEPTION USING
				HINT = 'func_global_check_created',
				MESSAGE = 'Created timestamp can not be from the future',
				DETAIL = 'p_created: ' || p_created;
		END IF;
		
		RETURN true;
	END;
$$;
 W   DROP FUNCTION public.func_global_check_created(p_created timestamp without time zone);
       public          postgres    false            F           0    0 I   FUNCTION func_global_check_created(p_created timestamp without time zone)    ACL     f   GRANT ALL ON FUNCTION public.func_global_check_created(p_created timestamp without time zone) TO api;
          public          postgres    false    308            9           1255    26459 %   func_global_check_created_by(integer)    FUNCTION     �  CREATE FUNCTION public.func_global_check_created_by(p_created_by integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_created_by IS NOT NULL AND NOT EXISTS(SELECT id FROM tbl_users WHERE id = p_created_by) THEN
			RAISE EXCEPTION USING
				HINT = 'func_global_check_created_by',
				MESSAGE = 'Invalid user_id',
				DETAIL = 'p_created_by: ' || p_created_by;
		END IF;
		
		RETURN true;
	END;
$$;
 I   DROP FUNCTION public.func_global_check_created_by(p_created_by integer);
       public          postgres    false            G           0    0 ;   FUNCTION func_global_check_created_by(p_created_by integer)    ACL     X   GRANT ALL ON FUNCTION public.func_global_check_created_by(p_created_by integer) TO api;
          public          postgres    false    313            B           1255    26516    func_global_check_file(integer)    FUNCTION     �  CREATE FUNCTION public.func_global_check_file(p_file_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	 BEGIN
	 	IF p_file_id IS NOT NULL AND NOT EXISTS(SELECT id FROM tbl_files WHERE id = p_file_id) THEN
			RAISE EXCEPTION USING 
				HINT = 'func_global_check_file',
				MESSAGE = 'Invalid file reference',
				DETAIL = 'p_file_id: ' || CAST(p_file_id AS text);
		END IF;
		
		RETURN true;
	 END;
$$;
 @   DROP FUNCTION public.func_global_check_file(p_file_id integer);
       public          postgres    false            H           0    0 2   FUNCTION func_global_check_file(p_file_id integer)    ACL     O   GRANT ALL ON FUNCTION public.func_global_check_file(p_file_id integer) TO api;
          public          postgres    false    322            8           1255    26476    func_mealplans_check_name(text)    FUNCTION     u  CREATE FUNCTION public.func_mealplans_check_name(p_name text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_name IS NOT NULL AND char_length(trim(p_name)) = 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_mealplans_check_name',
				MESSAGE = 'Name must be longer than 0 characters',
				DETAIL = 'p_name: ' || p_name;
		END IF;
		
		RETURN true;
	END;
$$;
 =   DROP FUNCTION public.func_mealplans_check_name(p_name text);
       public          postgres    false            I           0    0 /   FUNCTION func_mealplans_check_name(p_name text)    ACL     L   GRANT ALL ON FUNCTION public.func_mealplans_check_name(p_name text) TO api;
          public          postgres    false    312            `           1255    26737 $   func_mealplans_get(integer, integer)    FUNCTION     K  CREATE FUNCTION public.func_mealplans_get(p_id integer, p_created_by integer DEFAULT NULL::integer) RETURNS SETOF public.typ_mealplans
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*,
				func_users_mealplans_exists(p_id, p_created_by) AS is_favorite
			FROM
				viw_mealplans
			WHERE
				id = p_id;
	END
$$;
 M   DROP FUNCTION public.func_mealplans_get(p_id integer, p_created_by integer);
       public          postgres    false    843            J           0    0 ?   FUNCTION func_mealplans_get(p_id integer, p_created_by integer)    ACL     \   GRANT ALL ON FUNCTION public.func_mealplans_get(p_id integer, p_created_by integer) TO api;
          public          postgres    false    352            U           1255    26647 $   func_mealplans_insert(text, integer)    FUNCTION     �  CREATE FUNCTION public.func_mealplans_insert(p_name text, p_created_by integer) RETURNS SETOF public.typ_mealplans
    LANGUAGE plpgsql
    AS $$
	DECLARE
		v_new_mealplan_id integer;
	BEGIN
		-- insert mealplan
		INSERT INTO tbl_mealplans(
			name,
			created_by
		) VALUES (
			p_name,
			p_created_by
		) RETURNING id INTO v_new_mealplan_id;
		
		-- add to creators favorites
		INSERT INTO tbl_users_mealplans(
			mealplan_id,
			created_by
		) VALUES (
			v_new_mealplan_id,
			p_created_by
		);
		
		-- return new plan
		RETURN QUERY
			SELECT 
				*,
				false AS is_favorite
			FROM 
				viw_mealplans 
			WHERE 
				id = v_new_mealplan_id;
	END;
$$;
 O   DROP FUNCTION public.func_mealplans_insert(p_name text, p_created_by integer);
       public          postgres    false    843            K           0    0 A   FUNCTION func_mealplans_insert(p_name text, p_created_by integer)    ACL     ^   GRANT ALL ON FUNCTION public.func_mealplans_insert(p_name text, p_created_by integer) TO api;
          public          postgres    false    341            _           1255    26735 #   func_mealplans_query(text, integer)    FUNCTION     �  CREATE FUNCTION public.func_mealplans_query(p_search text, p_created_by integer DEFAULT NULL::integer) RETURNS SETOF public.typ_mealplans
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			SELECT
				m.*,
				func_users_mealplans_exists(m.id, p_created_by) AS is_favorite
			FROM
				viw_mealplans AS m
			WHERE
				(lower(name) || lower(COALESCE(description, ''))) LIKE ('%' || p_search || '%');
				
	END;
$$;
 P   DROP FUNCTION public.func_mealplans_query(p_search text, p_created_by integer);
       public          postgres    false    843            L           0    0 B   FUNCTION func_mealplans_query(p_search text, p_created_by integer)    ACL     _   GRANT ALL ON FUNCTION public.func_mealplans_query(p_search text, p_created_by integer) TO api;
          public          postgres    false    351            d           1255    26744 ,   func_mealplans_recipes_get(integer, integer)    FUNCTION     �  CREATE FUNCTION public.func_mealplans_recipes_get(p_mealplan_id integer, p_created_by integer DEFAULT NULL::integer) RETURNS SETOF public.typ_recipes
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			SELECT 
				r.*,
				0 AS matching_ingredients,
				func_users_recipes_exists(r.id, p_created_by) AS is_favorite
			FROM
				viw_recipes AS r
				INNER JOIN tbl_mealplans_recipes AS mr
					ON r.id = mr.recipe_id
			WHERE
				mr.mealplan_id = p_mealplan_id;
	END;
$$;
 ^   DROP FUNCTION public.func_mealplans_recipes_get(p_mealplan_id integer, p_created_by integer);
       public          postgres    false    849            M           0    0 P   FUNCTION func_mealplans_recipes_get(p_mealplan_id integer, p_created_by integer)    ACL     m   GRANT ALL ON FUNCTION public.func_mealplans_recipes_get(p_mealplan_id integer, p_created_by integer) TO api;
          public          postgres    false    356            h           1255    26749 8   func_mealplans_recipes_insert(integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.func_mealplans_recipes_insert(p_mealplan_id integer, p_recipe_id integer, p_created_by integer) RETURNS SETOF public.typ_recipes
    LANGUAGE plpgsql
    AS $$
	BEGIN
		-- add recipes
		INSERT INTO tbl_mealplans_recipes(
			mealplan_id,
			recipe_id,
			created_by
		)			
		VALUES (
			p_mealplan_id,
			p_recipe_id,
			p_created_by
		);
			
		RETURN QUERY
			SELECT 
				r.*,
				0 AS matching_ingredients,
				func_users_recipes_exists(r.id, p_created_by) AS is_favorite
			FROM 
				viw_recipes AS r
				INNER JOIN tbl_mealplans_recipes AS mr
					ON r.id = mr.recipe_id
			WHERE 
				mr.mealplan_id = p_mealplan_id;
	END;
$$;
 v   DROP FUNCTION public.func_mealplans_recipes_insert(p_mealplan_id integer, p_recipe_id integer, p_created_by integer);
       public          postgres    false    849            N           0    0 h   FUNCTION func_mealplans_recipes_insert(p_mealplan_id integer, p_recipe_id integer, p_created_by integer)    ACL     �   GRANT ALL ON FUNCTION public.func_mealplans_recipes_insert(p_mealplan_id integer, p_recipe_id integer, p_created_by integer) TO api;
          public          postgres    false    360            g           1255    26820 :   func_mealplans_recipes_insert_json(integer, text, integer)    FUNCTION       CREATE FUNCTION public.func_mealplans_recipes_insert_json(p_mealplan_id integer, p_recipes_json text, p_created_by integer) RETURNS SETOF public.typ_recipes
    LANGUAGE plpgsql
    AS $$
	BEGIN
		-- insert mealplan recipes
		INSERT INTO tbl_mealplans_recipes(
			mealplan_id,
			recipe_id,
			created_by
		) 
		SELECT
			p_mealplan_id,
			r.recipe_id,
			p_created_by
		FROM
			json_to_recordset(p_recipes_json::json) AS r (
				recipe_id integer
			);
		
		-- return mealplan recipes
		RETURN QUERY
			SELECT
				r.*,
				0 AS matching_ingredients,
				func_users_recipes_exists(r.id, p_created_by) AS is_favorite
			FROM
				viw_recipes AS r
				INNER JOIN tbl_mealplans_recipes AS mr
					ON r.id = mr.recipe_id
			WHERE
				mr.mealplan_id = p_mealplan_id;
	END;
$$;
 {   DROP FUNCTION public.func_mealplans_recipes_insert_json(p_mealplan_id integer, p_recipes_json text, p_created_by integer);
       public          postgres    false    849            O           0    0 m   FUNCTION func_mealplans_recipes_insert_json(p_mealplan_id integer, p_recipes_json text, p_created_by integer)    ACL     �   GRANT ALL ON FUNCTION public.func_mealplans_recipes_insert_json(p_mealplan_id integer, p_recipes_json text, p_created_by integer) TO api;
          public          postgres    false    359            G           1255    26482 '   func_measurements_check_long_name(text)    FUNCTION     �  CREATE FUNCTION public.func_measurements_check_long_name(p_long_name text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_long_name IS NOT NULL AND char_length(trim(p_long_name)) = 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_measurements_check_long_name',
				MESSAGE = 'Long name must be longer than 0 characters',
				DETAIL = 'p_long_name: ' || p_long_name;
		END IF;
		
		IF p_long_name IS NOT NULL AND EXISTS(SELECT id FROM tbl_measurements WHERE long_name = p_long_name) THEN
			RAISE EXCEPTION USING 
				HINT = 'func_measurements_check_long_name',
				MESSAGE = 'Long name must be unique',
				DETAIL = 'p_long_name: ' || p_long_name;
		END IF;
		
		RETURN true;
	END;
$$;
 J   DROP FUNCTION public.func_measurements_check_long_name(p_long_name text);
       public          postgres    false            P           0    0 <   FUNCTION func_measurements_check_long_name(p_long_name text)    ACL     Y   GRANT ALL ON FUNCTION public.func_measurements_check_long_name(p_long_name text) TO api;
          public          postgres    false    327            D           1255    26480 "   func_measurements_check_name(text)    FUNCTION     |  CREATE FUNCTION public.func_measurements_check_name(p_name text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_name IS NOT NULL AND char_length(trim(p_name)) = 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_measurements_check_long_name',
				MESSAGE = 'Name must be longer than 0 characters',
				DETAIL = 'p_name: ' || p_name;
		END IF;
		
		IF p_name IS NOT NULL AND EXISTS(SELECT id FROM tbl_measurements WHERE name = p_name) THEN
			RAISE EXCEPTION USING 
				HINT = 'func_measurements_check_long_name',
				MESSAGE = 'Name must be unqiue',
				DETAIL = 'p_name: ' || p_name;
		END IF;
		
		RETURN true;
	END;
$$;
 @   DROP FUNCTION public.func_measurements_check_name(p_name text);
       public          postgres    false            Q           0    0 2   FUNCTION func_measurements_check_name(p_name text)    ACL     O   GRANT ALL ON FUNCTION public.func_measurements_check_name(p_name text) TO api;
          public          postgres    false    324            W           1255    26654    func_measurements_query(text)    FUNCTION     #  CREATE FUNCTION public.func_measurements_query(p_search text) RETURNS SETOF public.typ_measurements
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_measurements
			WHERE
				(lower(name) || lower(long_name)) LIKE '%' || lower(p_search) || '%';
	END;
$$;
 =   DROP FUNCTION public.func_measurements_query(p_search text);
       public          postgres    false    846            R           0    0 /   FUNCTION func_measurements_query(p_search text)    ACL     L   GRANT ALL ON FUNCTION public.func_measurements_query(p_search text) TO api;
          public          postgres    false    343            ;           1255    26484 (   func_measurements_types_check_name(text)    FUNCTION     �  CREATE FUNCTION public.func_measurements_types_check_name(p_name text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_name IS NOT NULL AND char_length(trim(p_name)) = 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_measurements_types_check_name',
				MESSAGE = 'Name must be longer than 0 characters',
				DETAIL = 'p_name: ' || p_name;
		END IF;
		
		RETURN true;
	END;
$$;
 F   DROP FUNCTION public.func_measurements_types_check_name(p_name text);
       public          postgres    false            S           0    0 8   FUNCTION func_measurements_types_check_name(p_name text)    ACL     U   GRANT ALL ON FUNCTION public.func_measurements_types_check_name(p_name text) TO api;
          public          postgres    false    315            <           1255    26486 <   func_measurements_types_check_standardized_measurement(text)    FUNCTION       CREATE FUNCTION public.func_measurements_types_check_standardized_measurement(p_standardized_measurement text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_standardized_measurement IS NOT NULL AND char_length(trim(p_standardized_measurement)) = 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_measurements_types_check_standardized_measurement',
				MESSAGE = 'Standardized measurement must be longer than 0 characters',
				DETAIL = 'p_standardized_measurement: ' || p_name;
		END IF;
		
		RETURN true;
	END;
$$;
 n   DROP FUNCTION public.func_measurements_types_check_standardized_measurement(p_standardized_measurement text);
       public          postgres    false            T           0    0 `   FUNCTION func_measurements_types_check_standardized_measurement(p_standardized_measurement text)    ACL     }   GRANT ALL ON FUNCTION public.func_measurements_types_check_standardized_measurement(p_standardized_measurement text) TO api;
          public          postgres    false    316            F           1255    26512 (   func_recipes_check_cooking_time(integer)    FUNCTION     �  CREATE FUNCTION public.func_recipes_check_cooking_time(p_cooking_time integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_cooking_time IS NOT NULL AND NOT p_cooking_time > 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_recipes_check_cooking_time',
				MESSAGE = 'Cooking time must be at least 1 minute',
				DETAIL = 'p_cooking_time: ' || CAST(p_cooking_time AS text);
		END IF;
		
		RETURN true;
	END;
$$;
 N   DROP FUNCTION public.func_recipes_check_cooking_time(p_cooking_time integer);
       public          postgres    false            U           0    0 @   FUNCTION func_recipes_check_cooking_time(p_cooking_time integer)    ACL     ]   GRANT ALL ON FUNCTION public.func_recipes_check_cooking_time(p_cooking_time integer) TO api;
          public          postgres    false    326            @           1255    26510 $   func_recipes_check_description(text)    FUNCTION     �  CREATE FUNCTION public.func_recipes_check_description(p_description text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_description IS NOT NULL AND char_length(trim(p_description)) = 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_recipes_check_name',
				MESSAGE = 'Name must be longer than 0 characters',
				DETAIL = 'p_description: ' || p_description;
		END IF;
		
		RETURN true;
	END;
$$;
 I   DROP FUNCTION public.func_recipes_check_description(p_description text);
       public          postgres    false            V           0    0 ;   FUNCTION func_recipes_check_description(p_description text)    ACL     X   GRANT ALL ON FUNCTION public.func_recipes_check_description(p_description text) TO api;
          public          postgres    false    320            A           1255    26508    func_recipes_check_name(text)    FUNCTION     q  CREATE FUNCTION public.func_recipes_check_name(p_name text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_name IS NOT NULL AND char_length(trim(p_name)) = 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_recipes_check_name',
				MESSAGE = 'Name must be longer than 0 characters',
				DETAIL = 'p_name: ' || p_name;
		END IF;
		
		RETURN true;
	END;
$$;
 ;   DROP FUNCTION public.func_recipes_check_name(p_name text);
       public          postgres    false            W           0    0 -   FUNCTION func_recipes_check_name(p_name text)    ACL     J   GRANT ALL ON FUNCTION public.func_recipes_check_name(p_name text) TO api;
          public          postgres    false    321            E           1255    26514 $   func_recipes_check_portions(integer)    FUNCTION     �  CREATE FUNCTION public.func_recipes_check_portions(p_portions integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_portions IS NOT NULL AND NOT p_portions > 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_recipes_check_cooking_time',
				MESSAGE = 'Portions cannot be 0',
				DETAIL = 'p_portions: ' || CAST(p_portions AS text);
		END IF;
		
		RETURN true;
	END;
$$;
 F   DROP FUNCTION public.func_recipes_check_portions(p_portions integer);
       public          postgres    false            X           0    0 8   FUNCTION func_recipes_check_portions(p_portions integer)    ACL     U   GRANT ALL ON FUNCTION public.func_recipes_check_portions(p_portions integer) TO api;
          public          postgres    false    325            V           1255    26730 "   func_recipes_get(integer, integer)    FUNCTION     c  CREATE FUNCTION public.func_recipes_get(p_id integer, p_created_by integer DEFAULT NULL::integer) RETURNS SETOF public.typ_recipes
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*,
				0 AS matching_ingredients,
				func_users_recipes_exists(p_id, p_created_by) AS is_favorite
			FROM
				viw_recipes
			WHERE
				id = p_id;
	END;
$$;
 K   DROP FUNCTION public.func_recipes_get(p_id integer, p_created_by integer);
       public          postgres    false    849            Y           0    0 =   FUNCTION func_recipes_get(p_id integer, p_created_by integer)    ACL     Z   GRANT ALL ON FUNCTION public.func_recipes_get(p_id integer, p_created_by integer) TO api;
          public          postgres    false    342            C           1255    26522 .   func_recipes_ingredients_check_amount(integer)    FUNCTION     �  CREATE FUNCTION public.func_recipes_ingredients_check_amount(p_amount integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_amount IS NOT NULL AND NOT p_amount > 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_recipes_ingredients_check_amount',
				MESSAGE = 'Amount cannot be 0',
				DETAIL = 'p_amount: ' || CAST(p_amount AS text);
		END IF;
		
		RETURN true;
	END;
$$;
 N   DROP FUNCTION public.func_recipes_ingredients_check_amount(p_amount integer);
       public          postgres    false            Z           0    0 @   FUNCTION func_recipes_ingredients_check_amount(p_amount integer)    ACL     ]   GRANT ALL ON FUNCTION public.func_recipes_ingredients_check_amount(p_amount integer) TO api;
          public          postgres    false    323            Y           1255    26750 %   func_recipes_ingredients_get(integer)    FUNCTION       CREATE FUNCTION public.func_recipes_ingredients_get(p_recipe_id integer) RETURNS SETOF public.typ_recipes_ingredients
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_recipes_ingredients
			WHERE
				recipe_id = p_recipe_id;
	END;
$$;
 H   DROP FUNCTION public.func_recipes_ingredients_get(p_recipe_id integer);
       public          postgres    false    870            [           0    0 :   FUNCTION func_recipes_ingredients_get(p_recipe_id integer)    ACL     W   GRANT ALL ON FUNCTION public.func_recipes_ingredients_get(p_recipe_id integer) TO api;
          public          postgres    false    345            f           1255    26746 L   func_recipes_ingredients_insert(integer, integer, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.func_recipes_ingredients_insert(p_recipe_id integer, p_fooditem_id integer, p_measurement_id integer, p_amount_id integer, p_created_by integer) RETURNS SETOF public.typ_recipes_ingredients
    LANGUAGE plpgsql
    AS $$
	BEGIN
		-- insert ingredients
		INSERT INTO tbl_recipes_ingredients(
			recipe_id,
			fooditem_id,
			measurement_id,
			amount,
			created_by
		) VALUES (
			p_recipe_id,
			p_fooditem_id,
			p_measurement_id,
			p_amount_id,
			p_created_by
		);
		
		-- return recipes ingredients
		RETURN QUERY
			SELECT 
				* 
			FROM 
				viw_recipes_ingredients 
			WHERE 
				recipe_id = p_recipe_id;
	END;
$$;
 �   DROP FUNCTION public.func_recipes_ingredients_insert(p_recipe_id integer, p_fooditem_id integer, p_measurement_id integer, p_amount_id integer, p_created_by integer);
       public          postgres    false    870            \           0    0 �   FUNCTION func_recipes_ingredients_insert(p_recipe_id integer, p_fooditem_id integer, p_measurement_id integer, p_amount_id integer, p_created_by integer)    ACL     �   GRANT ALL ON FUNCTION public.func_recipes_ingredients_insert(p_recipe_id integer, p_fooditem_id integer, p_measurement_id integer, p_amount_id integer, p_created_by integer) TO api;
          public          postgres    false    358            Z           1255    26822 <   func_recipes_ingredients_insert_json(integer, text, integer)    FUNCTION     �  CREATE FUNCTION public.func_recipes_ingredients_insert_json(p_recipe_id integer, p_ingredients_json text, p_created_by integer) RETURNS SETOF public.typ_recipes_ingredients
    LANGUAGE plpgsql
    AS $$
	BEGIN
		-- insert ingredients
		INSERT INTO tbl_recipes_ingredients(
			recipe_id,
			fooditem_id,
			measurement_id,
			amount,
			created_by
		) 
		SELECT
			p_recipe_id,
			i.fooditem_id,
			i.measurement_id,
			i.amount,
			p_created_by
		FROM
			json_to_recordset(p_ingredients_json::json) AS i (
				fooditem_id integer,
				measurement_id integer,
				amount integer
			);
		
		-- return recipe ingredients
		RETURN QUERY
			SELECT
				*
			FROM
				viw_recipes_ingredients
			WHERE
				recipe_id = p_recipe_id;
	END;
$$;
    DROP FUNCTION public.func_recipes_ingredients_insert_json(p_recipe_id integer, p_ingredients_json text, p_created_by integer);
       public          postgres    false    870            �            1259    26137    tbl_recipes    TABLE     �  CREATE TABLE public.tbl_recipes (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    cooking_time integer NOT NULL,
    portions integer NOT NULL,
    file_id integer NOT NULL,
    reviewed timestamp without time zone,
    reviewed_by integer,
    CONSTRAINT check_tbl_recipes_cooking_time CHECK (public.func_recipes_check_cooking_time(cooking_time)),
    CONSTRAINT check_tbl_recipes_created CHECK (public.func_global_check_created(created)),
    CONSTRAINT check_tbl_recipes_description CHECK (public.func_recipes_check_description(description)),
    CONSTRAINT check_tbl_recipes_name CHECK (public.func_recipes_check_name(name)),
    CONSTRAINT check_tbl_recipes_portions CHECK (public.func_recipes_check_portions(portions)),
    CONSTRAINT check_tbl_recipes_reviewed CHECK (public.func_global_check_created(reviewed))
);
    DROP TABLE public.tbl_recipes;
       public         heap    postgres    false    326    308    320    321    325    308            ]           0    0    TABLE tbl_recipes    ACL     .   GRANT ALL ON TABLE public.tbl_recipes TO api;
          public          postgres    false    207            ?           1255    26490 C   func_recipes_insert(text, text, integer, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.func_recipes_insert(p_name text, p_description text, p_cooking_time integer, p_portions integer, p_file_id integer, p_created_by integer) RETURNS SETOF public.tbl_recipes
    LANGUAGE plpgsql
    AS $$
	DECLARE
		v_new_recipe_id integer;
	BEGIN		
		-- insert recipe
		INSERT INTO tbl_recipes(
			name,
			description,
			cooking_time,
			portions,
			file_id,
			created_by
		) VALUES (
			p_name,
			p_description,
			p_cooking_time,
			p_portions,
			p_file_id,
			p_created_by
		) RETURNING id INTO v_new_recipe_id;
		
		-- return new recipe row
		RETURN QUERY
			SELECT * FROM tbl_recipes WHERE id = v_new_recipe_id;
	END;
$$;
 �   DROP FUNCTION public.func_recipes_insert(p_name text, p_description text, p_cooking_time integer, p_portions integer, p_file_id integer, p_created_by integer);
       public          postgres    false    207            ^           0    0 �   FUNCTION func_recipes_insert(p_name text, p_description text, p_cooking_time integer, p_portions integer, p_file_id integer, p_created_by integer)    ACL     �   GRANT ALL ON FUNCTION public.func_recipes_insert(p_name text, p_description text, p_cooking_time integer, p_portions integer, p_file_id integer, p_created_by integer) TO api;
          public          postgres    false    319            I           1255    26535 1   func_recipes_instructions_check_instruction(text)    FUNCTION     �  CREATE FUNCTION public.func_recipes_instructions_check_instruction(p_instruction text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_instruction IS NOT NULL AND char_length(p_instruction) < 5 THEN
			RAISE EXCEPTION USING
				HINT = 'func_recipes_instructions_check_instruction',
				MESSAGE = 'Instruction must be longer than 5 characters',
				DETAIL = 'p_instruction: ' || p_instruction;
		END IF;
		
		RETURN true;
	END;
$$;
 V   DROP FUNCTION public.func_recipes_instructions_check_instruction(p_instruction text);
       public          postgres    false            _           0    0 H   FUNCTION func_recipes_instructions_check_instruction(p_instruction text)    ACL     e   GRANT ALL ON FUNCTION public.func_recipes_instructions_check_instruction(p_instruction text) TO api;
          public          postgres    false    329            K           1255    26529 8   func_recipes_instructions_check_number(integer, integer)    FUNCTION       CREATE FUNCTION public.func_recipes_instructions_check_number(p_recipe_id integer, p_number integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_number IS NOT NULL AND NOT p_number > 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_recipes_instructions_check_number',
				MESSAGE = 'Number cannot be 0',
				DETAIL = 'p_number: ' || CAST(p_number AS text);
		END IF;
		
		IF p_number IS NOT NULL AND EXISTS(SELECT id FROM tbl_recipes_instructions WHERE recipe_id = p_recipe_id AND number = p_number) THEN
			RAISE EXCEPTION USING
				HINT = 'func_recipes_instructions_check_number',
				MESSAGE = 'Number must be unique',
				DETAIL = 'p_number: ' || CAST(p_number AS text) || ', p_recipe_id: ' || CAST(p_recipe_id AS text);
		END IF;
		
		RETURN true;
	END;
$$;
 d   DROP FUNCTION public.func_recipes_instructions_check_number(p_recipe_id integer, p_number integer);
       public          postgres    false            `           0    0 V   FUNCTION func_recipes_instructions_check_number(p_recipe_id integer, p_number integer)    ACL     s   GRANT ALL ON FUNCTION public.func_recipes_instructions_check_number(p_recipe_id integer, p_number integer) TO api;
          public          postgres    false    331            [           1255    26715 &   func_recipes_instructions_get(integer)    FUNCTION       CREATE FUNCTION public.func_recipes_instructions_get(p_recipe_id integer) RETURNS SETOF public.typ_recipes_instructions
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_recipes_instructions
			WHERE
				recipe_id = p_recipe_id;
	END;
$$;
 I   DROP FUNCTION public.func_recipes_instructions_get(p_recipe_id integer);
       public          postgres    false    876            a           0    0 ;   FUNCTION func_recipes_instructions_get(p_recipe_id integer)    ACL     X   GRANT ALL ON FUNCTION public.func_recipes_instructions_get(p_recipe_id integer) TO api;
          public          postgres    false    347            i           1255    26751 A   func_recipes_instructions_insert(integer, integer, text, integer)    FUNCTION     E  CREATE FUNCTION public.func_recipes_instructions_insert(p_recipe_id integer, p_number integer, p_instruction text, p_created_by integer) RETURNS SETOF public.typ_recipes_instructions
    LANGUAGE plpgsql
    AS $$
	BEGIN
		-- insert instructions
		INSERT INTO tbl_recipes_instructions (
			recipe_id,
			number,
			instruction,
			created_by
		) VALUES (	
			p_recipe_id,
			p_number,
			p_instruction,
			p_created_by
		);
			
		-- return recipe instructions
		RETURN QUERY
			SELECT 
				* 
			FROM 
				viw_recipes_instructions 
			WHERE 
				recipe_id = p_recipe_id;
	END;
$$;
 �   DROP FUNCTION public.func_recipes_instructions_insert(p_recipe_id integer, p_number integer, p_instruction text, p_created_by integer);
       public          postgres    false    876            b           0    0 z   FUNCTION func_recipes_instructions_insert(p_recipe_id integer, p_number integer, p_instruction text, p_created_by integer)    ACL     �   GRANT ALL ON FUNCTION public.func_recipes_instructions_insert(p_recipe_id integer, p_number integer, p_instruction text, p_created_by integer) TO api;
          public          postgres    false    361            O           1255    26824 =   func_recipes_instructions_insert_json(integer, text, integer)    FUNCTION     �  CREATE FUNCTION public.func_recipes_instructions_insert_json(p_recipe_id integer, p_instructions_json text, p_created_by integer) RETURNS SETOF public.typ_recipes_instructions
    LANGUAGE plpgsql
    AS $$
	BEGIN
		-- insert ingredients
		INSERT INTO tbl_recipes_instructions(
			recipe_id,
			number,
			instruction,
			created_by
		) 
		SELECT
			p_recipe_id,
			i.number,
			i.instruction,
			p_created_by
		FROM
			json_to_recordset(p_instructions_json::json) AS i (
				number integer,
				instruction text
			);
		
		-- return recipe ingredients
		RETURN QUERY
			SELECT
				*
			FROM
				viw_recipes_instructions
			WHERE
				recipe_id = p_recipe_id;
	END;
$$;
 �   DROP FUNCTION public.func_recipes_instructions_insert_json(p_recipe_id integer, p_instructions_json text, p_created_by integer);
       public          postgres    false    876            o           1255    26748 0   func_recipes_query(text, integer, text, integer)    FUNCTION     �  CREATE FUNCTION public.func_recipes_query(p_search text DEFAULT ''::text, p_cooking_time integer DEFAULT 120, p_ingredients_json text DEFAULT '[]'::text, p_created_by integer DEFAULT NULL::integer) RETURNS SETOF public.typ_recipes
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			WITH ingredients AS (
				SELECT
					to_json(value)::text::int AS fooditem_id
				FROM
					json_array_elements(p_ingredients_json::json) 
			), matches AS (
				SELECT
					recipe_id,
					COUNT(fooditem_id) AS count
				FROM
					tbl_recipes_ingredients
				WHERE
					fooditem_id IN (SELECT fooditem_id FROM ingredients)
				GROUP BY
					recipe_id
			)
			
			SELECT
				r.*,
				COALESCE(m.count, 0)::integer AS ingredients_matches,
				func_users_recipes_exists(r.id, p_created_by) AS is_favorite
			FROM
				viw_recipes AS r
				LEFT JOIN matches AS m
					ON r.id = m.recipe_id
			WHERE
				(lower(r.name) || lower(r.description)) LIKE '%' || p_search || '%'
				AND r.cooking_time <= (CASE
											WHEN p_cooking_time >= 120 THEN r.cooking_time
									   		ELSE p_cooking_time
									  END)
			ORDER BY
				COALESCE(m.count, 0)::integer DESC,
				r.saves DESC,
				r.rating DESC;
	END;
$$;
    DROP FUNCTION public.func_recipes_query(p_search text, p_cooking_time integer, p_ingredients_json text, p_created_by integer);
       public          postgres    false    849            c           0    0 q   FUNCTION func_recipes_query(p_search text, p_cooking_time integer, p_ingredients_json text, p_created_by integer)    ACL     �   GRANT ALL ON FUNCTION public.func_recipes_query(p_search text, p_cooking_time integer, p_ingredients_json text, p_created_by integer) TO api;
          public          postgres    false    367            J           1255    26543 *   func_recipes_ratings_check_rating(integer)    FUNCTION     �  CREATE FUNCTION public.func_recipes_ratings_check_rating(p_rating integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_rating IS NOT NULL AND (p_rating > 5 OR p_rating < 1) THEN
			RAISE EXCEPTION USING
				HINT = 'func_recipes_ratings_check_rating',
				MESSAGE = 'Rating must be from 1 to 5',
				DETAIL = 'p_rating: ' || CAST(p_rating AS text);
		END IF;
		
		RETURN true;
	END;
$$;
 J   DROP FUNCTION public.func_recipes_ratings_check_rating(p_rating integer);
       public          postgres    false            d           0    0 <   FUNCTION func_recipes_ratings_check_rating(p_rating integer)    ACL     Y   GRANT ALL ON FUNCTION public.func_recipes_ratings_check_rating(p_rating integer) TO api;
          public          postgres    false    330            ^           1255    26724 !   func_recipes_ratings_get(integer)    FUNCTION       CREATE FUNCTION public.func_recipes_ratings_get(p_recipe_id integer) RETURNS SETOF public.typ_recipes_ratings
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_recipes_ratings
			WHERE
				recipe_id = p_recipe_id;
	END;
$$;
 D   DROP FUNCTION public.func_recipes_ratings_get(p_recipe_id integer);
       public          postgres    false    882            e           0    0 6   FUNCTION func_recipes_ratings_get(p_recipe_id integer)    ACL     S   GRANT ALL ON FUNCTION public.func_recipes_ratings_get(p_recipe_id integer) TO api;
          public          postgres    false    350            j           1255    26760 <   func_recipes_ratings_insert(integer, integer, text, integer)    FUNCTION       CREATE FUNCTION public.func_recipes_ratings_insert(p_recipe_id integer, p_rating integer, p_comment text, p_created_by integer) RETURNS SETOF public.typ_recipes_ratings
    LANGUAGE plpgsql
    AS $$
	BEGIN		
		-- insert ratings
		INSERT INTO tbl_recipes_ratings(
			recipe_id,
			rating,
			comment,
			created_by
		) VALUES (
			p_recipe_id,
			p_rating,
			p_comment,
			p_created_by
		);
		
		-- return recipe ratings
		RETURN QUERY
			SELECT 
				* 
			FROM 
				viw_recipes_ratings 
			WHERE 
				recipe_id = p_recipe_id;
	END;
$$;
    DROP FUNCTION public.func_recipes_ratings_insert(p_recipe_id integer, p_rating integer, p_comment text, p_created_by integer);
       public          postgres    false    882            f           0    0 q   FUNCTION func_recipes_ratings_insert(p_recipe_id integer, p_rating integer, p_comment text, p_created_by integer)    ACL     �   GRANT ALL ON FUNCTION public.func_recipes_ratings_insert(p_recipe_id integer, p_rating integer, p_comment text, p_created_by integer) TO api;
          public          postgres    false    362            2           1255    26164 -   func_recipes_togglebookmark(integer, integer)    FUNCTION     z  CREATE FUNCTION public.func_recipes_togglebookmark(p_recipe_id integer, p_created_by integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	DECLARE
		v_bookmarked boolean;
	BEGIN
		IF EXISTS(SELECT from tbl_users_recipes WHERE recipe_id = p_recipe_id AND created_by = p_created_by) THEN
			DELETE FROM 
				tbl_users_recipes 
			WHERE 
				recipe_id = p_recipe_id 
				AND created_by = p_created_by;
				
			v_bookmarked := false;
		ELSE
			INSERT INTO tbl_users_recipes (
				recipe_id,
				created_by
			) VALUES (
				p_recipe_id,
				p_created_by
			);
			
			v_bookmarked := true;
		END IF;
		
		RETURN v_bookmarked;
	END;
$$;
 ]   DROP FUNCTION public.func_recipes_togglebookmark(p_recipe_id integer, p_created_by integer);
       public          postgres    false            g           0    0 O   FUNCTION func_recipes_togglebookmark(p_recipe_id integer, p_created_by integer)    ACL     l   GRANT ALL ON FUNCTION public.func_recipes_togglebookmark(p_recipe_id integer, p_created_by integer) TO api;
          public          postgres    false    306            H           1255    26549 '   func_shoppinglist_check_amount(integer)    FUNCTION     w  CREATE FUNCTION public.func_shoppinglist_check_amount(p_amount integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_amount IS NOT NULL AND NOT p_amount > 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_shoppinglist_check_amount',
				MESSAGE = 'Amount cannot be 0',
				DETAIL = 'p_amount: ' || CAST(p_amount AS text);
		END IF;
		
		RETURN true;
	END;
$$;
 G   DROP FUNCTION public.func_shoppinglist_check_amount(p_amount integer);
       public          postgres    false            h           0    0 9   FUNCTION func_shoppinglist_check_amount(p_amount integer)    ACL     V   GRANT ALL ON FUNCTION public.func_shoppinglist_check_amount(p_amount integer) TO api;
          public          postgres    false    328            M           1255    26570    func_users_check_email(text)    FUNCTION     Z  CREATE FUNCTION public.func_users_check_email(p_email text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_email IS NOT NULL AND char_length(trim(p_email)) = 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_users_check_email',
				MESSAGE = 'Missing email',
				DETAIL = 'p_email: '|| p_email;
		END IF;
		
		RETURN true;
	END;
$$;
 ;   DROP FUNCTION public.func_users_check_email(p_email text);
       public          postgres    false            i           0    0 -   FUNCTION func_users_check_email(p_email text)    ACL     J   GRANT ALL ON FUNCTION public.func_users_check_email(p_email text) TO api;
          public          postgres    false    333            L           1255    26573    func_users_check_name(text)    FUNCTION     R  CREATE FUNCTION public.func_users_check_name(p_name text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_name IS NOT NULL AND char_length(trim(p_name)) = 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_users_check_name',
				MESSAGE = 'Missing name',
				DETAIL = 'p_name: '|| p_name;
		END IF;
		
		RETURN true;
	END;
$$;
 9   DROP FUNCTION public.func_users_check_name(p_name text);
       public          postgres    false            j           0    0 +   FUNCTION func_users_check_name(p_name text)    ACL     H   GRANT ALL ON FUNCTION public.func_users_check_name(p_name text) TO api;
          public          postgres    false    332            N           1255    26575    func_users_check_password(text)    FUNCTION     r  CREATE FUNCTION public.func_users_check_password(p_password text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF p_password IS NOT NULL AND char_length(trim(p_password)) = 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_users_check_password',
				MESSAGE = 'Missing password',
				DETAIL = 'p_password: '|| p_password;
		END IF;
		
		RETURN true;
	END;
$$;
 A   DROP FUNCTION public.func_users_check_password(p_password text);
       public          postgres    false            k           0    0 3   FUNCTION func_users_check_password(p_password text)    ACL     P   GRANT ALL ON FUNCTION public.func_users_check_password(p_password text) TO api;
          public          postgres    false    334            �            1259    26194 	   tbl_users    TABLE     !  CREATE TABLE public.tbl_users (
    id integer NOT NULL,
    email text NOT NULL,
    name text NOT NULL,
    password text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT check_tbl_users_created CHECK (public.func_global_check_created(created)),
    CONSTRAINT check_tbl_users_email CHECK (public.func_users_check_email(email)),
    CONSTRAINT check_tbl_users_name CHECK (public.func_users_check_name(name)),
    CONSTRAINT check_tbl_users_password CHECK (public.func_users_check_password(password))
);
    DROP TABLE public.tbl_users;
       public         heap    postgres    false    308    333    332    334            l           0    0    TABLE tbl_users    ACL     ,   GRANT ALL ON TABLE public.tbl_users TO api;
          public          postgres    false    211            �            1259    26200 	   viw_users    VIEW     x   CREATE VIEW public.viw_users AS
 SELECT tbl_users.id,
    tbl_users.email,
    tbl_users.name
   FROM public.tbl_users;
    DROP VIEW public.viw_users;
       public          postgres    false    211    211    211            m           0    0    TABLE viw_users    ACL     ,   GRANT ALL ON TABLE public.viw_users TO api;
          public          postgres    false    212            n           1255    26815 )   func_users_create(text, text, text, text)    FUNCTION     �  CREATE FUNCTION public.func_users_create(p_email text, p_name text, p_password text, p_repeat_password text) RETURNS SETOF public.viw_users
    LANGUAGE plpgsql
    AS $$
	DECLARE
		v_new_user_id integer;
	BEGIN
		-- check if passwords match
		IF p_password <> p_repeat_password THEN 
			RAISE EXCEPTION USING
				MESSAGE = 'Passwords do not match.';
		END IF;
		
		-- insert user
		INSERT INTO tbl_users(
			email,
			name,
			password
		) VALUES (
			p_email,
			p_name,
			crypt(p_password, gen_salt('bf'))
		) RETURNING id INTO v_new_user_id;
		
		-- return new user row
		RETURN QUERY
			SELECT * FROM viw_users WHERE id = v_new_user_id;
	END;
$$;
 l   DROP FUNCTION public.func_users_create(p_email text, p_name text, p_password text, p_repeat_password text);
       public          postgres    false    212            n           0    0 ^   FUNCTION func_users_create(p_email text, p_name text, p_password text, p_repeat_password text)    ACL     {   GRANT ALL ON FUNCTION public.func_users_create(p_email text, p_name text, p_password text, p_repeat_password text) TO api;
          public          postgres    false    366            3           1255    26205    func_users_exists(text)    FUNCTION     �   CREATE FUNCTION public.func_users_exists(p_email text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN EXISTS(SELECT email FROM tbl_users WHERE email = p_email);
	END;
$$;
 6   DROP FUNCTION public.func_users_exists(p_email text);
       public          postgres    false            o           0    0 (   FUNCTION func_users_exists(p_email text)    ACL     E   GRANT ALL ON FUNCTION public.func_users_exists(p_email text) TO api;
          public          postgres    false    307            S           1255    26598    func_users_get(text, text)    FUNCTION     '  CREATE FUNCTION public.func_users_get(p_email text, p_password text) RETURNS SETOF public.viw_users
    LANGUAGE plpgsql
    AS $$
	DECLARE
		v_user_id integer;
	BEGIN
		SELECT
			id
		INTO
			v_user_id
		FROM
			tbl_users
		WHERE
			email = p_email
			AND password = crypt(p_password, password);
			
		IF v_user_id IS NULL THEN
			RAISE EXCEPTION USING 
				HINT = 'func_users_get',
				MESSAGE = 'Invalid credentials',
				DETAIL = 'p_email: ' || p_email;
		ELSE
			RETURN QUERY
				SELECT * FROM viw_users WHERE id = v_user_id;
		END IF;
	END;
$$;
 D   DROP FUNCTION public.func_users_get(p_email text, p_password text);
       public          postgres    false    212            p           0    0 6   FUNCTION func_users_get(p_email text, p_password text)    ACL     S   GRANT ALL ON FUNCTION public.func_users_get(p_email text, p_password text) TO api;
          public          postgres    false    339            P           1255    26729 -   func_users_mealplans_delete(integer, integer)    FUNCTION       CREATE FUNCTION public.func_users_mealplans_delete(p_mealplan_id integer, p_created_by integer) RETURNS SETOF public.typ_mealplans
    LANGUAGE plpgsql
    AS $$
	BEGIN
		-- delete saved user mealplan
		DELETE FROM 
			tbl_users_mealplans
		WHERE
			mealplan_id = p_mealplan_id
			AND created_by = p_created_by;
		
		-- return saved mealplan
		RETURN QUERY
			SELECT
				*,
				func_users_mealplans_exists(p_mealplan_id, p_created_by) AS is_favorite
			FROM
				viw_mealplans
			WHERE
				id = p_mealplan_id;
	END;
$$;
 _   DROP FUNCTION public.func_users_mealplans_delete(p_mealplan_id integer, p_created_by integer);
       public          postgres    false    843            q           0    0 Q   FUNCTION func_users_mealplans_delete(p_mealplan_id integer, p_created_by integer)    ACL     n   GRANT ALL ON FUNCTION public.func_users_mealplans_delete(p_mealplan_id integer, p_created_by integer) TO api;
          public          postgres    false    336            ]           1255    26733 -   func_users_mealplans_exists(integer, integer)    FUNCTION     4  CREATE FUNCTION public.func_users_mealplans_exists(p_mealplan_id integer, p_created_by integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN EXISTS(SELECT mealplan_id FROM tbl_users_mealplans WHERE mealplan_id = p_mealplan_id AND created_by = p_created_by);
	END;
$$;
 _   DROP FUNCTION public.func_users_mealplans_exists(p_mealplan_id integer, p_created_by integer);
       public          postgres    false            r           0    0 Q   FUNCTION func_users_mealplans_exists(p_mealplan_id integer, p_created_by integer)    ACL     n   GRANT ALL ON FUNCTION public.func_users_mealplans_exists(p_mealplan_id integer, p_created_by integer) TO api;
          public          postgres    false    349            e           1255    26827 !   func_users_mealplans_get(integer)    FUNCTION     �  CREATE FUNCTION public.func_users_mealplans_get(p_created_by integer) RETURNS SETOF public.typ_mealplans
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			SELECT
				m.*,
				func_users_mealplans_exists(m.id, p_created_by) AS is_favorite
			FROM
				viw_mealplans AS m
				INNER JOIN tbl_users_mealplans AS um
					ON m.id = um.mealplan_id
			WHERE
				um.created_by = p_created_by;
	END;
$$;
 E   DROP FUNCTION public.func_users_mealplans_get(p_created_by integer);
       public          postgres    false    843            s           0    0 7   FUNCTION func_users_mealplans_get(p_created_by integer)    ACL     T   GRANT ALL ON FUNCTION public.func_users_mealplans_get(p_created_by integer) TO api;
          public          postgres    false    357            >           1255    26728 -   func_users_mealplans_insert(integer, integer)    FUNCTION       CREATE FUNCTION public.func_users_mealplans_insert(p_mealplan_id integer, p_created_by integer) RETURNS SETOF public.typ_mealplans
    LANGUAGE plpgsql
    AS $$
	BEGIN
		-- insert saved user mealplan
		INSERT INTO tbl_users_mealplans(
			mealplan_id,
			created_by
		) VALUES (
			p_mealplan_id,
			p_created_by
		);
		
		-- return saved mealplan
		RETURN QUERY
			SELECT
				*,
				func_users_mealplans_exists(p_mealplan_id, p_created_by) AS is_favorite
			FROM
				viw_mealplans
			WHERE
				id = p_mealplan_id;
	END;
$$;
 _   DROP FUNCTION public.func_users_mealplans_insert(p_mealplan_id integer, p_created_by integer);
       public          postgres    false    843            t           0    0 Q   FUNCTION func_users_mealplans_insert(p_mealplan_id integer, p_created_by integer)    ACL     n   GRANT ALL ON FUNCTION public.func_users_mealplans_insert(p_mealplan_id integer, p_created_by integer) TO api;
          public          postgres    false    318            =           1255    26727 +   func_users_recipes_delete(integer, integer)    FUNCTION       CREATE FUNCTION public.func_users_recipes_delete(p_recipe_id integer, p_created_by integer) RETURNS SETOF public.typ_recipes
    LANGUAGE plpgsql
    AS $$
	BEGIN
		-- insert saved user recipe
		DELETE FROM 
			tbl_users_recipes
		WHERE
			recipe_id = p_recipe_id
			AND created_by = p_created_by;
		
		-- return saved recipe
		RETURN QUERY
			SELECT
				*,
				0 AS matching_ingredients,
				func_users_recipes_exists(p_recipe_id, p_created_by) AS is_favorite
			FROM
				viw_recipes
			WHERE
				id = p_recipe_id;
	END;
$$;
 [   DROP FUNCTION public.func_users_recipes_delete(p_recipe_id integer, p_created_by integer);
       public          postgres    false    849            u           0    0 M   FUNCTION func_users_recipes_delete(p_recipe_id integer, p_created_by integer)    ACL     j   GRANT ALL ON FUNCTION public.func_users_recipes_delete(p_recipe_id integer, p_created_by integer) TO api;
          public          postgres    false    317            \           1255    26732 +   func_users_recipes_exists(integer, integer)    FUNCTION     (  CREATE FUNCTION public.func_users_recipes_exists(p_recipe_id integer, p_created_by integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN EXISTS(SELECT recipe_id FROM tbl_users_recipes WHERE recipe_id = p_recipe_id AND created_by = p_created_by);
	END;
$$;
 [   DROP FUNCTION public.func_users_recipes_exists(p_recipe_id integer, p_created_by integer);
       public          postgres    false            v           0    0 M   FUNCTION func_users_recipes_exists(p_recipe_id integer, p_created_by integer)    ACL     j   GRANT ALL ON FUNCTION public.func_users_recipes_exists(p_recipe_id integer, p_created_by integer) TO api;
          public          postgres    false    348            b           1255    26826    func_users_recipes_get(integer)    FUNCTION     �  CREATE FUNCTION public.func_users_recipes_get(p_created_by integer) RETURNS SETOF public.typ_recipes
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			SELECT
				r.*,
				0 AS matching_ingredients,
				func_users_recipes_exists(r.id, p_created_by) AS is_favorite
			FROM
				viw_recipes AS r
				INNER JOIN tbl_users_recipes AS ur
					ON r.id = ur.recipe_id
			WHERE
				r.created_by = p_created_by;
	END;
$$;
 C   DROP FUNCTION public.func_users_recipes_get(p_created_by integer);
       public          postgres    false    849            w           0    0 5   FUNCTION func_users_recipes_get(p_created_by integer)    ACL     R   GRANT ALL ON FUNCTION public.func_users_recipes_get(p_created_by integer) TO api;
          public          postgres    false    354            c           1255    26726 +   func_users_recipes_insert(integer, integer)    FUNCTION       CREATE FUNCTION public.func_users_recipes_insert(p_recipe_id integer, p_created_by integer) RETURNS SETOF public.typ_recipes
    LANGUAGE plpgsql
    AS $$
	BEGIN
		-- insert saved user recipe
		INSERT INTO tbl_users_recipes(
			recipe_id,
			created_by
		) VALUES (
			p_recipe_id,
			p_created_by
		);
		
		-- return saved recipe
		RETURN QUERY
			SELECT
				*,
				0 AS matching_ingredients,
				func_users_recipes_exists(p_recipe_id, p_created_by) AS is_favorite
			FROM
				viw_recipes
			WHERE
				id = p_recipe_id;
	END;
$$;
 [   DROP FUNCTION public.func_users_recipes_insert(p_recipe_id integer, p_created_by integer);
       public          postgres    false    849            x           0    0 M   FUNCTION func_users_recipes_insert(p_recipe_id integer, p_created_by integer)    ACL     j   GRANT ALL ON FUNCTION public.func_users_recipes_insert(p_recipe_id integer, p_created_by integer) TO api;
          public          postgres    false    355            l           1255    26812 '   func_users_shoppinglist_delete(integer)    FUNCTION     d  CREATE FUNCTION public.func_users_shoppinglist_delete(p_created_by integer) RETURNS SETOF public.typ_users_shoppinglist
    LANGUAGE plpgsql
    AS $$
	BEGIN
		DELETE FROM
			tbl_users_shoppinglist
		WHERE
			created_by = p_created_by;
			
		RETURN QUERY
			SELECT
				*
			FROM
				viw_users_shoppinglist
			WHERE
				created_by = p_created_by;
	END;
$$;
 K   DROP FUNCTION public.func_users_shoppinglist_delete(p_created_by integer);
       public          postgres    false    891            y           0    0 =   FUNCTION func_users_shoppinglist_delete(p_created_by integer)    ACL     Z   GRANT ALL ON FUNCTION public.func_users_shoppinglist_delete(p_created_by integer) TO api;
          public          postgres    false    364            a           1255    26810 $   func_users_shoppinglist_get(integer)    FUNCTION       CREATE FUNCTION public.func_users_shoppinglist_get(p_created_by integer) RETURNS SETOF public.typ_users_shoppinglist
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_users_shoppinglist
			WHERE
				created_by = p_created_by;
	END;
$$;
 H   DROP FUNCTION public.func_users_shoppinglist_get(p_created_by integer);
       public          postgres    false    891            z           0    0 :   FUNCTION func_users_shoppinglist_get(p_created_by integer)    ACL     W   GRANT ALL ON FUNCTION public.func_users_shoppinglist_get(p_created_by integer) TO api;
          public          postgres    false    353            k           1255    26809 B   func_users_shoppinglist_insert(integer, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.func_users_shoppinglist_insert(p_fooditem_id integer, p_measurement_id integer, p_amount integer, p_created_by integer) RETURNS SETOF public.typ_users_shoppinglist
    LANGUAGE plpgsql
    AS $$
	BEGIN
		INSERT INTO tbl_users_shoppinglist(
			fooditem_id,
			measurement_id,
			amount,
			created_by
		) VALUES (
			p_fooditem_id,
			p_measurement_id,
			p_amount,
			p_created_by
		);
		
		RETURN QUERY
			SELECT
				*
			FROM
				viw_users_shoppinglist;
	END;
$$;
 �   DROP FUNCTION public.func_users_shoppinglist_insert(p_fooditem_id integer, p_measurement_id integer, p_amount integer, p_created_by integer);
       public          postgres    false    891            {           0    0 �   FUNCTION func_users_shoppinglist_insert(p_fooditem_id integer, p_measurement_id integer, p_amount integer, p_created_by integer)    ACL     �   GRANT ALL ON FUNCTION public.func_users_shoppinglist_insert(p_fooditem_id integer, p_measurement_id integer, p_amount integer, p_created_by integer) TO api;
          public          postgres    false    363            T           1255    26825 2   func_users_shoppinglist_insert_json(text, integer)    FUNCTION     u  CREATE FUNCTION public.func_users_shoppinglist_insert_json(p_shoppinglist_json text, p_created_by integer) RETURNS SETOF public.typ_users_shoppinglist
    LANGUAGE plpgsql
    AS $$
	BEGIN
		INSERT INTO tbl_users_shoppinglist(
			fooditem_id,
			measurement_id,
			amount,
			created_by
		) 
		SELECT
			s.fooditem_id,
			s.measurement_id,
			s.amount,
			p_created_by
		FROM
			json_to_recordset(p_shoppinglist_json::json) AS s (
				fooditem_id integer,
				measurement_id integer,
				amount integer
			);
			
		RETURN QUERY
			SELECT
				*
			FROM
				viw_users_shoppinglist
			WHERE
				created_by = p_created_by;
	END;
$$;
 j   DROP FUNCTION public.func_users_shoppinglist_insert_json(p_shoppinglist_json text, p_created_by integer);
       public          postgres    false    891            |           0    0 \   FUNCTION func_users_shoppinglist_insert_json(p_shoppinglist_json text, p_created_by integer)    ACL     y   GRANT ALL ON FUNCTION public.func_users_shoppinglist_insert_json(p_shoppinglist_json text, p_created_by integer) TO api;
          public          postgres    false    340            m           1255    26813 9   func_users_shoppinglist_update(integer, boolean, integer)    FUNCTION     �  CREATE FUNCTION public.func_users_shoppinglist_update(p_fooditem_id integer, p_checked boolean, p_created_by integer) RETURNS SETOF public.typ_users_shoppinglist
    LANGUAGE plpgsql
    AS $$
	BEGIN
		UPDATE 
			tbl_users_shoppinglist
		SET
			checked = p_checked
		WHERE
			fooditem_id = p_fooditem_id
			AND created_by = p_created_by;
			
		RETURN QUERY
			SELECT
				*
			FROM
				viw_users_shoppinglist
			WHERE
				created_by = p_created_by;
	END;
$$;
 u   DROP FUNCTION public.func_users_shoppinglist_update(p_fooditem_id integer, p_checked boolean, p_created_by integer);
       public          postgres    false    891            }           0    0 g   FUNCTION func_users_shoppinglist_update(p_fooditem_id integer, p_checked boolean, p_created_by integer)    ACL     �   GRANT ALL ON FUNCTION public.func_users_shoppinglist_update(p_fooditem_id integer, p_checked boolean, p_created_by integer) TO api;
          public          postgres    false    365            �            1259    26112 	   tbl_files    TABLE     A  CREATE TABLE public.tbl_files (
    id integer NOT NULL,
    name text NOT NULL,
    size integer NOT NULL,
    mimetype text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    CONSTRAINT check_tbl_files_created CHECK (public.func_global_check_created(created)),
    CONSTRAINT check_tbl_files_mimetype CHECK (public.func_files_check_mimetype(mimetype)),
    CONSTRAINT check_tbl_files_name CHECK (public.func_files_check_name(name)),
    CONSTRAINT check_tbl_files_size CHECK (public.func_files_check_size(size))
);
    DROP TABLE public.tbl_files;
       public         heap    postgres    false    308    310    311    314            ~           0    0    TABLE tbl_files    ACL     ,   GRANT ALL ON TABLE public.tbl_files TO api;
          public          postgres    false    204            �            1259    26210    tbl_files_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.tbl_files_id_seq;
       public          postgres    false    204                       0    0    tbl_files_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.tbl_files_id_seq OWNED BY public.tbl_files.id;
          public          postgres    false    213            �           0    0    SEQUENCE tbl_files_id_seq    ACL     ?   GRANT SELECT,USAGE ON SEQUENCE public.tbl_files_id_seq TO api;
          public          postgres    false    213            �            1259    26120    tbl_fooditems    TABLE       CREATE TABLE public.tbl_fooditems (
    id integer NOT NULL,
    name text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    reviewed timestamp without time zone,
    reviewed_by integer,
    CONSTRAINT check_tbl_fooditems_created CHECK (public.func_global_check_created(created)),
    CONSTRAINT check_tbl_fooditems_name CHECK (public.func_fooditems_check_name(name)),
    CONSTRAINT check_tbl_fooditems_reviewed CHECK (public.func_global_check_created(reviewed))
);
 !   DROP TABLE public.tbl_fooditems;
       public         heap    postgres    false    308    309    308            �           0    0    TABLE tbl_fooditems    ACL     0   GRANT ALL ON TABLE public.tbl_fooditems TO api;
          public          postgres    false    205            �            1259    26212    tbl_fooditems_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_fooditems_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.tbl_fooditems_id_seq;
       public          postgres    false    205            �           0    0    tbl_fooditems_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.tbl_fooditems_id_seq OWNED BY public.tbl_fooditems.id;
          public          postgres    false    214            �           0    0    SEQUENCE tbl_fooditems_id_seq    ACL     C   GRANT SELECT,USAGE ON SEQUENCE public.tbl_fooditems_id_seq TO api;
          public          postgres    false    214            �            1259    26472    tbl_global_defaults    TABLE     P   CREATE TABLE public.tbl_global_defaults (
    default_measurement_id integer
);
 '   DROP TABLE public.tbl_global_defaults;
       public         heap    postgres    false            �            1259    26128    tbl_mealplans    TABLE     �  CREATE TABLE public.tbl_mealplans (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    public boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    CONSTRAINT check_tbl_mealplans_created CHECK (public.func_global_check_created(created)),
    CONSTRAINT check_tbl_mealplans_name CHECK (public.func_mealplans_check_name(name))
);
 !   DROP TABLE public.tbl_mealplans;
       public         heap    postgres    false    308    312            �           0    0    TABLE tbl_mealplans    ACL     0   GRANT ALL ON TABLE public.tbl_mealplans TO api;
          public          postgres    false    206            �            1259    26214    tbl_mealplans_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_mealplans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.tbl_mealplans_id_seq;
       public          postgres    false    206            �           0    0    tbl_mealplans_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.tbl_mealplans_id_seq OWNED BY public.tbl_mealplans.id;
          public          postgres    false    215            �           0    0    SEQUENCE tbl_mealplans_id_seq    ACL     C   GRANT SELECT,USAGE ON SEQUENCE public.tbl_mealplans_id_seq TO api;
          public          postgres    false    215            �            1259    26216    tbl_mealplans_recipes    TABLE     P  CREATE TABLE public.tbl_mealplans_recipes (
    mealplan_id integer NOT NULL,
    recipe_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    id integer NOT NULL,
    CONSTRAINT check_tbl_mealplans_recipes_created CHECK (public.func_global_check_created(created))
);
 )   DROP TABLE public.tbl_mealplans_recipes;
       public         heap    postgres    false    308            �           0    0    TABLE tbl_mealplans_recipes    ACL     8   GRANT ALL ON TABLE public.tbl_mealplans_recipes TO api;
          public          postgres    false    216            �            1259    26220    tbl_mealplans_recipes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_mealplans_recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.tbl_mealplans_recipes_id_seq;
       public          postgres    false    216            �           0    0    tbl_mealplans_recipes_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.tbl_mealplans_recipes_id_seq OWNED BY public.tbl_mealplans_recipes.id;
          public          postgres    false    217            �           0    0 %   SEQUENCE tbl_mealplans_recipes_id_seq    ACL     K   GRANT SELECT,USAGE ON SEQUENCE public.tbl_mealplans_recipes_id_seq TO api;
          public          postgres    false    217            �            1259    26165    tbl_measurements    TABLE       CREATE TABLE public.tbl_measurements (
    id integer NOT NULL,
    name text NOT NULL,
    standardized integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    type_id integer,
    long_name text
);
 $   DROP TABLE public.tbl_measurements;
       public         heap    postgres    false            �           0    0    TABLE tbl_measurements    ACL     3   GRANT ALL ON TABLE public.tbl_measurements TO api;
          public          postgres    false    209            �            1259    26222    tbl_measurements_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_measurements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.tbl_measurements_id_seq;
       public          postgres    false    209            �           0    0    tbl_measurements_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.tbl_measurements_id_seq OWNED BY public.tbl_measurements.id;
          public          postgres    false    218            �           0    0     SEQUENCE tbl_measurements_id_seq    ACL     F   GRANT SELECT,USAGE ON SEQUENCE public.tbl_measurements_id_seq TO api;
          public          postgres    false    218            �            1259    26172    tbl_measurements_types    TABLE     �  CREATE TABLE public.tbl_measurements_types (
    id integer NOT NULL,
    name text NOT NULL,
    standardized_measurement text NOT NULL,
    CONSTRAINT check_tbl_measurements_types_name CHECK (public.func_measurements_types_check_name(name)),
    CONSTRAINT check_tbl_measurements_types_standardized_measurement CHECK (public.func_measurements_types_check_standardized_measurement(standardized_measurement))
);
 *   DROP TABLE public.tbl_measurements_types;
       public         heap    postgres    false    315    316            �           0    0    TABLE tbl_measurements_types    ACL     9   GRANT ALL ON TABLE public.tbl_measurements_types TO api;
          public          postgres    false    210            �            1259    26224    tbl_measurements_types_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_measurements_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.tbl_measurements_types_id_seq;
       public          postgres    false    210            �           0    0    tbl_measurements_types_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.tbl_measurements_types_id_seq OWNED BY public.tbl_measurements_types.id;
          public          postgres    false    219            �           0    0 &   SEQUENCE tbl_measurements_types_id_seq    ACL     L   GRANT SELECT,USAGE ON SEQUENCE public.tbl_measurements_types_id_seq TO api;
          public          postgres    false    219            �            1259    26226    tbl_recipes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.tbl_recipes_id_seq;
       public          postgres    false    207            �           0    0    tbl_recipes_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.tbl_recipes_id_seq OWNED BY public.tbl_recipes.id;
          public          postgres    false    220            �           0    0    SEQUENCE tbl_recipes_id_seq    ACL     A   GRANT SELECT,USAGE ON SEQUENCE public.tbl_recipes_id_seq TO api;
          public          postgres    false    220            �            1259    26228    tbl_recipes_ingredients    TABLE     �  CREATE TABLE public.tbl_recipes_ingredients (
    recipe_id integer NOT NULL,
    fooditem_id integer NOT NULL,
    measurement_id integer NOT NULL,
    amount integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    CONSTRAINT check_tbl_recipes_ingredients_amount CHECK (public.func_recipes_ingredients_check_amount(amount)),
    CONSTRAINT check_tbl_recipes_ingredients_created CHECK (public.func_global_check_created(created))
);
 +   DROP TABLE public.tbl_recipes_ingredients;
       public         heap    postgres    false    323    308            �           0    0    TABLE tbl_recipes_ingredients    ACL     :   GRANT ALL ON TABLE public.tbl_recipes_ingredients TO api;
          public          postgres    false    221            �            1259    26232    tbl_recipes_instructions    TABLE     �  CREATE TABLE public.tbl_recipes_instructions (
    id integer NOT NULL,
    recipe_id integer NOT NULL,
    number integer NOT NULL,
    instruction text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    CONSTRAINT check_tbl_recipes_instructions_created CHECK (public.func_global_check_created(created)),
    CONSTRAINT check_tbl_recipes_instructions_instruction CHECK (public.func_recipes_instructions_check_instruction(instruction))
);
 ,   DROP TABLE public.tbl_recipes_instructions;
       public         heap    postgres    false    308    329            �           0    0    TABLE tbl_recipes_instructions    ACL     ;   GRANT ALL ON TABLE public.tbl_recipes_instructions TO api;
          public          postgres    false    222            �            1259    26239    tbl_recipes_instructions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_recipes_instructions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.tbl_recipes_instructions_id_seq;
       public          postgres    false    222            �           0    0    tbl_recipes_instructions_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.tbl_recipes_instructions_id_seq OWNED BY public.tbl_recipes_instructions.id;
          public          postgres    false    223            �           0    0 (   SEQUENCE tbl_recipes_instructions_id_seq    ACL     N   GRANT SELECT,USAGE ON SEQUENCE public.tbl_recipes_instructions_id_seq TO api;
          public          postgres    false    223            �            1259    26155    tbl_recipes_ratings    TABLE     �  CREATE TABLE public.tbl_recipes_ratings (
    recipe_id integer NOT NULL,
    rating integer NOT NULL,
    comment text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    CONSTRAINT check_tbl_recipes_ratings_created CHECK (public.func_global_check_created(created)),
    CONSTRAINT check_tbl_recipes_ratings_rating CHECK (public.func_recipes_ratings_check_rating(rating))
);
 '   DROP TABLE public.tbl_recipes_ratings;
       public         heap    postgres    false    308    330            �           0    0    TABLE tbl_recipes_ratings    ACL     6   GRANT ALL ON TABLE public.tbl_recipes_ratings TO api;
          public          postgres    false    208            �            1259    26241    tbl_users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.tbl_users_id_seq;
       public          postgres    false    211            �           0    0    tbl_users_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.tbl_users_id_seq OWNED BY public.tbl_users.id;
          public          postgres    false    224            �           0    0    SEQUENCE tbl_users_id_seq    ACL     ?   GRANT SELECT,USAGE ON SEQUENCE public.tbl_users_id_seq TO api;
          public          postgres    false    224            �            1259    26243    tbl_users_mealplans    TABLE       CREATE TABLE public.tbl_users_mealplans (
    mealplan_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    CONSTRAINT check_tbl_users_mealplans_created CHECK (public.func_global_check_created(created))
);
 '   DROP TABLE public.tbl_users_mealplans;
       public         heap    postgres    false    308            �           0    0    TABLE tbl_users_mealplans    ACL     6   GRANT ALL ON TABLE public.tbl_users_mealplans TO api;
          public          postgres    false    225            �            1259    26247    tbl_users_recipes    TABLE       CREATE TABLE public.tbl_users_recipes (
    recipe_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    CONSTRAINT check_tbl_users_recipes_created CHECK (public.func_global_check_created(created))
);
 %   DROP TABLE public.tbl_users_recipes;
       public         heap    postgres    false    308            �           0    0    TABLE tbl_users_recipes    ACL     4   GRANT ALL ON TABLE public.tbl_users_recipes TO api;
          public          postgres    false    226            �            1259    26780    tbl_users_shoppinglist    TABLE        CREATE TABLE public.tbl_users_shoppinglist (
    fooditem_id integer NOT NULL,
    measurement_id integer NOT NULL,
    amount integer NOT NULL,
    checked boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL
);
 *   DROP TABLE public.tbl_users_shoppinglist;
       public         heap    postgres    false            �           0    0    TABLE tbl_users_shoppinglist    ACL     9   GRANT ALL ON TABLE public.tbl_users_shoppinglist TO api;
          public          postgres    false    245            �            1259    26627 	   viw_files    VIEW     �   CREATE VIEW public.viw_files AS
 SELECT tbl_files.id,
    tbl_files.name,
    tbl_files.size,
    tbl_files.mimetype
   FROM public.tbl_files;
    DROP VIEW public.viw_files;
       public          postgres    false    204    204    204    204            �           0    0    TABLE viw_files    ACL     /   GRANT SELECT ON TABLE public.viw_files TO api;
          public          postgres    false    234            �            1259    26632    viw_fooditems    VIEW     s   CREATE VIEW public.viw_fooditems AS
 SELECT tbl_fooditems.id,
    tbl_fooditems.name
   FROM public.tbl_fooditems;
     DROP VIEW public.viw_fooditems;
       public          postgres    false    205    205            �           0    0    TABLE viw_fooditems    ACL     3   GRANT SELECT ON TABLE public.viw_fooditems TO api;
          public          postgres    false    235            �            1259    26642    viw_mealplans    VIEW     �   CREATE VIEW public.viw_mealplans AS
 SELECT tbl_mealplans.id,
    tbl_mealplans.name,
    tbl_mealplans.description
   FROM public.tbl_mealplans;
     DROP VIEW public.viw_mealplans;
       public          postgres    false    206    206    206            �           0    0    TABLE viw_mealplans    ACL     3   GRANT SELECT ON TABLE public.viw_mealplans TO api;
          public          postgres    false    236            �            1259    26650    viw_measurements    VIEW     �   CREATE VIEW public.viw_measurements AS
 SELECT tbl_measurements.id,
    tbl_measurements.name,
    tbl_measurements.long_name
   FROM public.tbl_measurements;
 #   DROP VIEW public.viw_measurements;
       public          postgres    false    209    209    209            �           0    0    TABLE viw_measurements    ACL     6   GRANT SELECT ON TABLE public.viw_measurements TO api;
          public          postgres    false    237            �            1259    26693    viw_recipes    VIEW     �  CREATE VIEW public.viw_recipes AS
 WITH ratings AS (
         SELECT tbl_recipes_ratings.recipe_id,
            round(avg(tbl_recipes_ratings.rating), 1) AS rating,
            count(tbl_recipes_ratings.recipe_id) AS number_of_ratings
           FROM public.tbl_recipes_ratings
          GROUP BY tbl_recipes_ratings.recipe_id
        ), saves AS (
         SELECT ur.recipe_id,
            count(ur.recipe_id) AS saves
           FROM public.tbl_users_recipes ur
          GROUP BY ur.recipe_id
        ), num_of_ingredients AS (
         SELECT i.recipe_id,
            count(i.fooditem_id) AS num_of_ingredients
           FROM public.tbl_recipes_ingredients i
          GROUP BY i.recipe_id
        )
 SELECT r.id,
    r.name,
    r.description,
    r.cooking_time,
    r.portions,
    f.id AS file_id,
    f.mimetype AS file_mimetype,
    r.created_by,
    u.name AS created_by_name,
    (date_part('epoch'::text, r.created))::integer AS created_epoch,
    (COALESCE(ratings.rating, (0)::numeric))::double precision AS rating,
    (COALESCE(ratings.number_of_ratings, (0)::bigint))::integer AS number_of_ratings,
    (COALESCE(saves.saves, (0)::bigint))::integer AS saves
   FROM (((((public.tbl_recipes r
     JOIN public.tbl_users u ON ((r.created_by = u.id)))
     LEFT JOIN public.tbl_files f ON ((r.file_id = f.id)))
     LEFT JOIN ratings ON ((r.id = ratings.recipe_id)))
     LEFT JOIN saves ON ((r.id = saves.recipe_id)))
     LEFT JOIN num_of_ingredients ON ((r.id = num_of_ingredients.recipe_id)));
    DROP VIEW public.viw_recipes;
       public          postgres    false    226    211    211    208    207    207    207    204    208    207    204    207    207    207    207    221    221            �           0    0    TABLE viw_recipes    ACL     .   GRANT ALL ON TABLE public.viw_recipes TO api;
          public          postgres    false    238            �            1259    26702    viw_recipes_ingredients    VIEW     �  CREATE VIEW public.viw_recipes_ingredients AS
 SELECT r.id AS recipe_id,
    f.id AS fooditem_id,
    f.name AS fooditem_name,
    m.id AS measurement_id,
    m.name AS measurement_name,
    i.amount
   FROM (((public.tbl_recipes_ingredients i
     JOIN public.tbl_measurements m ON ((i.measurement_id = m.id)))
     JOIN public.tbl_fooditems f ON ((i.fooditem_id = f.id)))
     JOIN public.tbl_recipes r ON ((i.recipe_id = r.id)));
 *   DROP VIEW public.viw_recipes_ingredients;
       public          postgres    false    221    221    221    221    209    209    207    205    205            �           0    0    TABLE viw_recipes_ingredients    ACL     :   GRANT ALL ON TABLE public.viw_recipes_ingredients TO api;
          public          postgres    false    240            �            1259    26711    viw_recipes_instructions    VIEW     �   CREATE VIEW public.viw_recipes_instructions AS
 SELECT i.id,
    i.recipe_id,
    i.number,
    i.instruction
   FROM public.tbl_recipes_instructions i;
 +   DROP VIEW public.viw_recipes_instructions;
       public          postgres    false    222    222    222    222            �           0    0    TABLE viw_recipes_instructions    ACL     ;   GRANT ALL ON TABLE public.viw_recipes_instructions TO api;
          public          postgres    false    242            �            1259    26720    viw_recipes_ratings    VIEW     &  CREATE VIEW public.viw_recipes_ratings AS
 SELECT r.recipe_id,
    r.rating,
    r.comment,
    r.created_by,
    u.name AS created_by_name,
    date_part('epoch'::text, r.created) AS created_epoch
   FROM (public.tbl_recipes_ratings r
     JOIN public.tbl_users u ON ((r.created_by = u.id)));
 &   DROP VIEW public.viw_recipes_ratings;
       public          postgres    false    208    208    208    208    208    211    211            �           0    0    TABLE viw_recipes_ratings    ACL     6   GRANT ALL ON TABLE public.viw_recipes_ratings TO api;
          public          postgres    false    244            �            1259    26843    viw_users_shoppinglist    VIEW     [  CREATE VIEW public.viw_users_shoppinglist AS
 WITH cte AS (
         SELECT s.fooditem_id,
            f.name AS fooditem_name,
            (s.amount * m.standardized) AS amount,
            mt.standardized_measurement,
            s.created_by,
            s.checked
           FROM (((public.tbl_users_shoppinglist s
             JOIN public.tbl_fooditems f ON ((s.fooditem_id = f.id)))
             JOIN public.tbl_measurements m ON ((s.measurement_id = m.id)))
             JOIN public.tbl_measurements_types mt ON ((m.type_id = mt.id)))
        )
 SELECT cte.fooditem_id,
    cte.fooditem_name,
    (sum(cte.amount))::integer AS amount,
    cte.standardized_measurement,
    cte.created_by,
    cte.checked
   FROM cte
  GROUP BY cte.fooditem_id, cte.fooditem_name, cte.standardized_measurement, cte.created_by, cte.checked
  ORDER BY cte.fooditem_name;
 )   DROP VIEW public.viw_users_shoppinglist;
       public          postgres    false    245    210    209    209    209    210    245    245    205    205    245    245            �           0    0    TABLE viw_users_shoppinglist    ACL     9   GRANT ALL ON TABLE public.viw_users_shoppinglist TO api;
          public          postgres    false    247            "           2604    26270    tbl_files id    DEFAULT     l   ALTER TABLE ONLY public.tbl_files ALTER COLUMN id SET DEFAULT nextval('public.tbl_files_id_seq'::regclass);
 ;   ALTER TABLE public.tbl_files ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    204            (           2604    26271    tbl_fooditems id    DEFAULT     t   ALTER TABLE ONLY public.tbl_fooditems ALTER COLUMN id SET DEFAULT nextval('public.tbl_fooditems_id_seq'::regclass);
 ?   ALTER TABLE public.tbl_fooditems ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    214    205            .           2604    26272    tbl_mealplans id    DEFAULT     t   ALTER TABLE ONLY public.tbl_mealplans ALTER COLUMN id SET DEFAULT nextval('public.tbl_mealplans_id_seq'::regclass);
 ?   ALTER TABLE public.tbl_mealplans ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    206            H           2604    26273    tbl_mealplans_recipes id    DEFAULT     �   ALTER TABLE ONLY public.tbl_mealplans_recipes ALTER COLUMN id SET DEFAULT nextval('public.tbl_mealplans_recipes_id_seq'::regclass);
 G   ALTER TABLE public.tbl_mealplans_recipes ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216            =           2604    26274    tbl_measurements id    DEFAULT     z   ALTER TABLE ONLY public.tbl_measurements ALTER COLUMN id SET DEFAULT nextval('public.tbl_measurements_id_seq'::regclass);
 B   ALTER TABLE public.tbl_measurements ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    209            >           2604    26275    tbl_measurements_types id    DEFAULT     �   ALTER TABLE ONLY public.tbl_measurements_types ALTER COLUMN id SET DEFAULT nextval('public.tbl_measurements_types_id_seq'::regclass);
 H   ALTER TABLE public.tbl_measurements_types ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    210            2           2604    26276    tbl_recipes id    DEFAULT     p   ALTER TABLE ONLY public.tbl_recipes ALTER COLUMN id SET DEFAULT nextval('public.tbl_recipes_id_seq'::regclass);
 =   ALTER TABLE public.tbl_recipes ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    207            N           2604    26277    tbl_recipes_instructions id    DEFAULT     �   ALTER TABLE ONLY public.tbl_recipes_instructions ALTER COLUMN id SET DEFAULT nextval('public.tbl_recipes_instructions_id_seq'::regclass);
 J   ALTER TABLE public.tbl_recipes_instructions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    222            A           2604    26278    tbl_users id    DEFAULT     l   ALTER TABLE ONLY public.tbl_users ALTER COLUMN id SET DEFAULT nextval('public.tbl_users_id_seq'::regclass);
 ;   ALTER TABLE public.tbl_users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    211                      0    26112 	   tbl_files 
   TABLE DATA           R   COPY public.tbl_files (id, name, size, mimetype, created, created_by) FROM stdin;
    public          postgres    false    204   ��                 0    26120    tbl_fooditems 
   TABLE DATA           ]   COPY public.tbl_fooditems (id, name, created, created_by, reviewed, reviewed_by) FROM stdin;
    public          postgres    false    205   N�      5          0    26472    tbl_global_defaults 
   TABLE DATA           E   COPY public.tbl_global_defaults (default_measurement_id) FROM stdin;
    public          postgres    false    227   ��      !          0    26128    tbl_mealplans 
   TABLE DATA           [   COPY public.tbl_mealplans (id, name, description, public, created, created_by) FROM stdin;
    public          postgres    false    206   ��      *          0    26216    tbl_mealplans_recipes 
   TABLE DATA           `   COPY public.tbl_mealplans_recipes (mealplan_id, recipe_id, created, created_by, id) FROM stdin;
    public          postgres    false    216   4�      $          0    26165    tbl_measurements 
   TABLE DATA           k   COPY public.tbl_measurements (id, name, standardized, created, created_by, type_id, long_name) FROM stdin;
    public          postgres    false    209   ��      %          0    26172    tbl_measurements_types 
   TABLE DATA           T   COPY public.tbl_measurements_types (id, name, standardized_measurement) FROM stdin;
    public          postgres    false    210   ��      "          0    26137    tbl_recipes 
   TABLE DATA           �   COPY public.tbl_recipes (id, name, description, created, created_by, cooking_time, portions, file_id, reviewed, reviewed_by) FROM stdin;
    public          postgres    false    207   ��      /          0    26228    tbl_recipes_ingredients 
   TABLE DATA           v   COPY public.tbl_recipes_ingredients (recipe_id, fooditem_id, measurement_id, amount, created, created_by) FROM stdin;
    public          postgres    false    221   �      0          0    26232    tbl_recipes_instructions 
   TABLE DATA           k   COPY public.tbl_recipes_instructions (id, recipe_id, number, instruction, created, created_by) FROM stdin;
    public          postgres    false    222   .�      #          0    26155    tbl_recipes_ratings 
   TABLE DATA           ^   COPY public.tbl_recipes_ratings (recipe_id, rating, comment, created, created_by) FROM stdin;
    public          postgres    false    208   ,�      &          0    26194 	   tbl_users 
   TABLE DATA           G   COPY public.tbl_users (id, email, name, password, created) FROM stdin;
    public          postgres    false    211   �      3          0    26243    tbl_users_mealplans 
   TABLE DATA           O   COPY public.tbl_users_mealplans (mealplan_id, created, created_by) FROM stdin;
    public          postgres    false    225   ��      4          0    26247    tbl_users_recipes 
   TABLE DATA           K   COPY public.tbl_users_recipes (recipe_id, created, created_by) FROM stdin;
    public          postgres    false    226   ��      6          0    26780    tbl_users_shoppinglist 
   TABLE DATA           s   COPY public.tbl_users_shoppinglist (fooditem_id, measurement_id, amount, checked, created, created_by) FROM stdin;
    public          postgres    false    245   S�      �           0    0    tbl_files_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.tbl_files_id_seq', 129, true);
          public          postgres    false    213            �           0    0    tbl_fooditems_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.tbl_fooditems_id_seq', 1522, true);
          public          postgres    false    214            �           0    0    tbl_mealplans_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.tbl_mealplans_id_seq', 15, true);
          public          postgres    false    215            �           0    0    tbl_mealplans_recipes_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.tbl_mealplans_recipes_id_seq', 32, true);
          public          postgres    false    217            �           0    0    tbl_measurements_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.tbl_measurements_id_seq', 24, true);
          public          postgres    false    218            �           0    0    tbl_measurements_types_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.tbl_measurements_types_id_seq', 4, true);
          public          postgres    false    219            �           0    0    tbl_recipes_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.tbl_recipes_id_seq', 43, true);
          public          postgres    false    220            �           0    0    tbl_recipes_instructions_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.tbl_recipes_instructions_id_seq', 53, true);
          public          postgres    false    223            �           0    0    tbl_users_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.tbl_users_id_seq', 14, true);
          public          postgres    false    224            X           2606    26280    tbl_files pk_tbl_files 
   CONSTRAINT     T   ALTER TABLE ONLY public.tbl_files
    ADD CONSTRAINT pk_tbl_files PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.tbl_files DROP CONSTRAINT pk_tbl_files;
       public            postgres    false    204            Z           2606    26282    tbl_fooditems pk_tbl_fooditems 
   CONSTRAINT     \   ALTER TABLE ONLY public.tbl_fooditems
    ADD CONSTRAINT pk_tbl_fooditems PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.tbl_fooditems DROP CONSTRAINT pk_tbl_fooditems;
       public            postgres    false    205            ^           2606    26284    tbl_mealplans pk_tbl_mealplans 
   CONSTRAINT     \   ALTER TABLE ONLY public.tbl_mealplans
    ADD CONSTRAINT pk_tbl_mealplans PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.tbl_mealplans DROP CONSTRAINT pk_tbl_mealplans;
       public            postgres    false    206            r           2606    26286 .   tbl_mealplans_recipes pk_tbl_mealplans_recipes 
   CONSTRAINT     l   ALTER TABLE ONLY public.tbl_mealplans_recipes
    ADD CONSTRAINT pk_tbl_mealplans_recipes PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.tbl_mealplans_recipes DROP CONSTRAINT pk_tbl_mealplans_recipes;
       public            postgres    false    216            f           2606    26288 $   tbl_measurements pk_tbl_measurements 
   CONSTRAINT     b   ALTER TABLE ONLY public.tbl_measurements
    ADD CONSTRAINT pk_tbl_measurements PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.tbl_measurements DROP CONSTRAINT pk_tbl_measurements;
       public            postgres    false    209            l           2606    26290 0   tbl_measurements_types pk_tbl_measurements_types 
   CONSTRAINT     n   ALTER TABLE ONLY public.tbl_measurements_types
    ADD CONSTRAINT pk_tbl_measurements_types PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.tbl_measurements_types DROP CONSTRAINT pk_tbl_measurements_types;
       public            postgres    false    210            `           2606    26292    tbl_recipes pk_tbl_recipes 
   CONSTRAINT     X   ALTER TABLE ONLY public.tbl_recipes
    ADD CONSTRAINT pk_tbl_recipes PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.tbl_recipes DROP CONSTRAINT pk_tbl_recipes;
       public            postgres    false    207            t           2606    26294 2   tbl_recipes_ingredients pk_tbl_recipes_ingredients 
   CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ingredients
    ADD CONSTRAINT pk_tbl_recipes_ingredients PRIMARY KEY (recipe_id, fooditem_id);
 \   ALTER TABLE ONLY public.tbl_recipes_ingredients DROP CONSTRAINT pk_tbl_recipes_ingredients;
       public            postgres    false    221    221            b           2606    26552 *   tbl_recipes_ratings pk_tbl_recipes_ratings 
   CONSTRAINT     {   ALTER TABLE ONLY public.tbl_recipes_ratings
    ADD CONSTRAINT pk_tbl_recipes_ratings PRIMARY KEY (recipe_id, created_by);
 T   ALTER TABLE ONLY public.tbl_recipes_ratings DROP CONSTRAINT pk_tbl_recipes_ratings;
       public            postgres    false    208    208            n           2606    26296    tbl_users pk_tbl_users 
   CONSTRAINT     T   ALTER TABLE ONLY public.tbl_users
    ADD CONSTRAINT pk_tbl_users PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.tbl_users DROP CONSTRAINT pk_tbl_users;
       public            postgres    false    211            x           2606    26298 *   tbl_users_mealplans pk_tbl_users_mealplans 
   CONSTRAINT     }   ALTER TABLE ONLY public.tbl_users_mealplans
    ADD CONSTRAINT pk_tbl_users_mealplans PRIMARY KEY (mealplan_id, created_by);
 T   ALTER TABLE ONLY public.tbl_users_mealplans DROP CONSTRAINT pk_tbl_users_mealplans;
       public            postgres    false    225    225            z           2606    26300 &   tbl_users_recipes pk_tbl_users_recipes 
   CONSTRAINT     w   ALTER TABLE ONLY public.tbl_users_recipes
    ADD CONSTRAINT pk_tbl_users_recipes PRIMARY KEY (recipe_id, created_by);
 P   ALTER TABLE ONLY public.tbl_users_recipes DROP CONSTRAINT pk_tbl_users_recipes;
       public            postgres    false    226    226            \           2606    26741 '   tbl_fooditems unique_tbl_fooditems_name 
   CONSTRAINT     b   ALTER TABLE ONLY public.tbl_fooditems
    ADD CONSTRAINT unique_tbl_fooditems_name UNIQUE (name);
 Q   ALTER TABLE ONLY public.tbl_fooditems DROP CONSTRAINT unique_tbl_fooditems_name;
       public            postgres    false    205            h           2606    26562 2   tbl_measurements unique_tbl_measurements_long_name 
   CONSTRAINT     r   ALTER TABLE ONLY public.tbl_measurements
    ADD CONSTRAINT unique_tbl_measurements_long_name UNIQUE (long_name);
 \   ALTER TABLE ONLY public.tbl_measurements DROP CONSTRAINT unique_tbl_measurements_long_name;
       public            postgres    false    209            j           2606    26560 -   tbl_measurements unique_tbl_measurements_name 
   CONSTRAINT     h   ALTER TABLE ONLY public.tbl_measurements
    ADD CONSTRAINT unique_tbl_measurements_name UNIQUE (name);
 W   ALTER TABLE ONLY public.tbl_measurements DROP CONSTRAINT unique_tbl_measurements_name;
       public            postgres    false    209            v           2606    26757 ?   tbl_recipes_instructions unique_tbl_recipes_instructions_number 
   CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_instructions
    ADD CONSTRAINT unique_tbl_recipes_instructions_number UNIQUE (recipe_id, number);
 i   ALTER TABLE ONLY public.tbl_recipes_instructions DROP CONSTRAINT unique_tbl_recipes_instructions_number;
       public            postgres    false    222    222            d           2606    26759 .   tbl_recipes_ratings unique_tbl_recipes_ratings 
   CONSTRAINT     z   ALTER TABLE ONLY public.tbl_recipes_ratings
    ADD CONSTRAINT unique_tbl_recipes_ratings UNIQUE (recipe_id, created_by);
 X   ALTER TABLE ONLY public.tbl_recipes_ratings DROP CONSTRAINT unique_tbl_recipes_ratings;
       public            postgres    false    208    208            p           2606    26302     tbl_users unique_tbl_users_email 
   CONSTRAINT     \   ALTER TABLE ONLY public.tbl_users
    ADD CONSTRAINT unique_tbl_users_email UNIQUE (email);
 J   ALTER TABLE ONLY public.tbl_users DROP CONSTRAINT unique_tbl_users_email;
       public            postgres    false    211            {           2606    26303     tbl_files fk_tbl_files_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_files
    ADD CONSTRAINT fk_tbl_files_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 J   ALTER TABLE ONLY public.tbl_files DROP CONSTRAINT fk_tbl_files_tbl_users;
       public          postgres    false    204    211    3182            |           2606    26308 4   tbl_fooditems fk_tbl_fooditems_reviewed_by_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_fooditems
    ADD CONSTRAINT fk_tbl_fooditems_reviewed_by_tbl_users FOREIGN KEY (reviewed_by) REFERENCES public.tbl_users(id);
 ^   ALTER TABLE ONLY public.tbl_fooditems DROP CONSTRAINT fk_tbl_fooditems_reviewed_by_tbl_users;
       public          postgres    false    205    3182    211            }           2606    26313 (   tbl_fooditems fk_tbl_fooditems_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_fooditems
    ADD CONSTRAINT fk_tbl_fooditems_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 R   ALTER TABLE ONLY public.tbl_fooditems DROP CONSTRAINT fk_tbl_fooditems_tbl_users;
       public          postgres    false    211    3182    205            ~           2606    26553 4   tbl_fooditems fk_tbl_fooditems_tbl_users_reviewed_by    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_fooditems
    ADD CONSTRAINT fk_tbl_fooditems_tbl_users_reviewed_by FOREIGN KEY (reviewed_by) REFERENCES public.tbl_users(id);
 ^   ALTER TABLE ONLY public.tbl_fooditems DROP CONSTRAINT fk_tbl_fooditems_tbl_users_reviewed_by;
       public          postgres    false    205    3182    211            �           2606    26318 <   tbl_mealplans_recipes fk_tbl_mealplans_recipes_tbl_mealplans    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_mealplans_recipes
    ADD CONSTRAINT fk_tbl_mealplans_recipes_tbl_mealplans FOREIGN KEY (mealplan_id) REFERENCES public.tbl_mealplans(id);
 f   ALTER TABLE ONLY public.tbl_mealplans_recipes DROP CONSTRAINT fk_tbl_mealplans_recipes_tbl_mealplans;
       public          postgres    false    3166    216    206            �           2606    26323 :   tbl_mealplans_recipes fk_tbl_mealplans_recipes_tbl_recipes    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_mealplans_recipes
    ADD CONSTRAINT fk_tbl_mealplans_recipes_tbl_recipes FOREIGN KEY (recipe_id) REFERENCES public.tbl_recipes(id) ON DELETE CASCADE;
 d   ALTER TABLE ONLY public.tbl_mealplans_recipes DROP CONSTRAINT fk_tbl_mealplans_recipes_tbl_recipes;
       public          postgres    false    216    3168    207            �           2606    26328 8   tbl_mealplans_recipes fk_tbl_mealplans_recipes_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_mealplans_recipes
    ADD CONSTRAINT fk_tbl_mealplans_recipes_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 b   ALTER TABLE ONLY public.tbl_mealplans_recipes DROP CONSTRAINT fk_tbl_mealplans_recipes_tbl_users;
       public          postgres    false    216    3182    211                       2606    26333 (   tbl_mealplans fk_tbl_mealplans_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_mealplans
    ADD CONSTRAINT fk_tbl_mealplans_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 R   ALTER TABLE ONLY public.tbl_mealplans DROP CONSTRAINT fk_tbl_mealplans_tbl_users;
       public          postgres    false    3182    206    211            �           2606    26338 ;   tbl_measurements fk_tbl_measurements_tbl_measurements_types    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_measurements
    ADD CONSTRAINT fk_tbl_measurements_tbl_measurements_types FOREIGN KEY (type_id) REFERENCES public.tbl_measurements_types(id);
 e   ALTER TABLE ONLY public.tbl_measurements DROP CONSTRAINT fk_tbl_measurements_tbl_measurements_types;
       public          postgres    false    3180    209    210            �           2606    26343 .   tbl_measurements fk_tbl_measurements_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_measurements
    ADD CONSTRAINT fk_tbl_measurements_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 X   ALTER TABLE ONLY public.tbl_measurements DROP CONSTRAINT fk_tbl_measurements_tbl_users;
       public          postgres    false    3182    211    209            �           2606    26348 @   tbl_recipes_ingredients fk_tbl_recipes_ingredients_tbl_fooditems    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ingredients
    ADD CONSTRAINT fk_tbl_recipes_ingredients_tbl_fooditems FOREIGN KEY (fooditem_id) REFERENCES public.tbl_fooditems(id);
 j   ALTER TABLE ONLY public.tbl_recipes_ingredients DROP CONSTRAINT fk_tbl_recipes_ingredients_tbl_fooditems;
       public          postgres    false    3162    205    221            �           2606    26353 C   tbl_recipes_ingredients fk_tbl_recipes_ingredients_tbl_measurements    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ingredients
    ADD CONSTRAINT fk_tbl_recipes_ingredients_tbl_measurements FOREIGN KEY (measurement_id) REFERENCES public.tbl_measurements(id);
 m   ALTER TABLE ONLY public.tbl_recipes_ingredients DROP CONSTRAINT fk_tbl_recipes_ingredients_tbl_measurements;
       public          postgres    false    221    209    3174            �           2606    26358 >   tbl_recipes_ingredients fk_tbl_recipes_ingredients_tbl_recipes    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ingredients
    ADD CONSTRAINT fk_tbl_recipes_ingredients_tbl_recipes FOREIGN KEY (recipe_id) REFERENCES public.tbl_recipes(id) ON DELETE CASCADE;
 h   ALTER TABLE ONLY public.tbl_recipes_ingredients DROP CONSTRAINT fk_tbl_recipes_ingredients_tbl_recipes;
       public          postgres    false    207    221    3168            �           2606    26363 <   tbl_recipes_ingredients fk_tbl_recipes_ingredients_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ingredients
    ADD CONSTRAINT fk_tbl_recipes_ingredients_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 f   ALTER TABLE ONLY public.tbl_recipes_ingredients DROP CONSTRAINT fk_tbl_recipes_ingredients_tbl_users;
       public          postgres    false    211    221    3182            �           2606    26368 @   tbl_recipes_instructions fk_tbl_recipes_instructions_tbl_recipes    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_instructions
    ADD CONSTRAINT fk_tbl_recipes_instructions_tbl_recipes FOREIGN KEY (recipe_id) REFERENCES public.tbl_recipes(id) ON DELETE CASCADE;
 j   ALTER TABLE ONLY public.tbl_recipes_instructions DROP CONSTRAINT fk_tbl_recipes_instructions_tbl_recipes;
       public          postgres    false    3168    207    222            �           2606    26373 >   tbl_recipes_instructions fk_tbl_recipes_instructions_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_instructions
    ADD CONSTRAINT fk_tbl_recipes_instructions_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 h   ALTER TABLE ONLY public.tbl_recipes_instructions DROP CONSTRAINT fk_tbl_recipes_instructions_tbl_users;
       public          postgres    false    3182    222    211            �           2606    26378 6   tbl_recipes_ratings fk_tbl_recipes_ratings_tbl_recipes    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ratings
    ADD CONSTRAINT fk_tbl_recipes_ratings_tbl_recipes FOREIGN KEY (recipe_id) REFERENCES public.tbl_recipes(id) ON DELETE CASCADE;
 `   ALTER TABLE ONLY public.tbl_recipes_ratings DROP CONSTRAINT fk_tbl_recipes_ratings_tbl_recipes;
       public          postgres    false    3168    208    207            �           2606    26383 4   tbl_recipes_ratings fk_tbl_recipes_ratings_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ratings
    ADD CONSTRAINT fk_tbl_recipes_ratings_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 ^   ALTER TABLE ONLY public.tbl_recipes_ratings DROP CONSTRAINT fk_tbl_recipes_ratings_tbl_users;
       public          postgres    false    3182    208    211            �           2606    26388 0   tbl_recipes fk_tbl_recipes_reviewed_by_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes
    ADD CONSTRAINT fk_tbl_recipes_reviewed_by_tbl_users FOREIGN KEY (reviewed_by) REFERENCES public.tbl_users(id);
 Z   ALTER TABLE ONLY public.tbl_recipes DROP CONSTRAINT fk_tbl_recipes_reviewed_by_tbl_users;
       public          postgres    false    207    211    3182            �           2606    26393 $   tbl_recipes fk_tbl_recipes_tbl_files    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes
    ADD CONSTRAINT fk_tbl_recipes_tbl_files FOREIGN KEY (file_id) REFERENCES public.tbl_files(id);
 N   ALTER TABLE ONLY public.tbl_recipes DROP CONSTRAINT fk_tbl_recipes_tbl_files;
       public          postgres    false    204    207    3160            �           2606    26398 $   tbl_recipes fk_tbl_recipes_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes
    ADD CONSTRAINT fk_tbl_recipes_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 N   ALTER TABLE ONLY public.tbl_recipes DROP CONSTRAINT fk_tbl_recipes_tbl_users;
       public          postgres    false    207    3182    211            �           2606    26418 8   tbl_users_mealplans fk_tbl_users_mealplans_tbl_mealplans    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_users_mealplans
    ADD CONSTRAINT fk_tbl_users_mealplans_tbl_mealplans FOREIGN KEY (mealplan_id) REFERENCES public.tbl_mealplans(id);
 b   ALTER TABLE ONLY public.tbl_users_mealplans DROP CONSTRAINT fk_tbl_users_mealplans_tbl_mealplans;
       public          postgres    false    3166    206    225            �           2606    26423 4   tbl_users_mealplans fk_tbl_users_mealplans_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_users_mealplans
    ADD CONSTRAINT fk_tbl_users_mealplans_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 ^   ALTER TABLE ONLY public.tbl_users_mealplans DROP CONSTRAINT fk_tbl_users_mealplans_tbl_users;
       public          postgres    false    211    225    3182            �           2606    26428 2   tbl_users_recipes fk_tbl_users_recipes_tbl_recipes    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_users_recipes
    ADD CONSTRAINT fk_tbl_users_recipes_tbl_recipes FOREIGN KEY (recipe_id) REFERENCES public.tbl_recipes(id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.tbl_users_recipes DROP CONSTRAINT fk_tbl_users_recipes_tbl_recipes;
       public          postgres    false    3168    226    207            �           2606    26433 0   tbl_users_recipes fk_tbl_users_recipes_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_users_recipes
    ADD CONSTRAINT fk_tbl_users_recipes_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 Z   ALTER TABLE ONLY public.tbl_users_recipes DROP CONSTRAINT fk_tbl_users_recipes_tbl_users;
       public          postgres    false    3182    211    226            �           2606    26785 >   tbl_users_shoppinglist fk_tbl_users_shoppinglist_tbl_fooditems    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_users_shoppinglist
    ADD CONSTRAINT fk_tbl_users_shoppinglist_tbl_fooditems FOREIGN KEY (fooditem_id) REFERENCES public.tbl_fooditems(id);
 h   ALTER TABLE ONLY public.tbl_users_shoppinglist DROP CONSTRAINT fk_tbl_users_shoppinglist_tbl_fooditems;
       public          postgres    false    245    3162    205            �           2606    26790 A   tbl_users_shoppinglist fk_tbl_users_shoppinglist_tbl_measurements    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_users_shoppinglist
    ADD CONSTRAINT fk_tbl_users_shoppinglist_tbl_measurements FOREIGN KEY (measurement_id) REFERENCES public.tbl_measurements(id);
 k   ALTER TABLE ONLY public.tbl_users_shoppinglist DROP CONSTRAINT fk_tbl_users_shoppinglist_tbl_measurements;
       public          postgres    false    3174    245    209            �           2606    26795 :   tbl_users_shoppinglist fk_tbl_users_shoppinglist_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_users_shoppinglist
    ADD CONSTRAINT fk_tbl_users_shoppinglist_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 d   ALTER TABLE ONLY public.tbl_users_shoppinglist DROP CONSTRAINT fk_tbl_users_shoppinglist_tbl_users;
       public          postgres    false    3182    245    211               �  x��Z�nI}�|E~@��[UQo�$�o�#;�ql��<L�~َwf�Z�5`��u�9<d�&�Z�*�jģ7�F�}��U�֚SC��/�=�L�b2�~�������T��'���*�6h�w<]��n�]�o&����2>��!׭x1�0�����H��:�cm�	���]ɭ�W痵�&��!���v��5�ϴU+>��V���*�"�Ѧ/���<c�ͥ��C�m�¢6`�WY�n�\?�8��`q��T�M���YR/J��%��M91��?�����i-��f��S��(>�R��SA��]s����o���<4,m��ؚv�A�t��������>�Hm��=�غ���*Y���Z{�-H;�HܣSޣ��>�kk
���Jݚ�.-v��Y}[����{���g����˲J���(@Գ��*,o#�J٭f�[�%��T9K���m��V��$}s��?����?����O�Bq���(�\����'H<�q�:8g@!�D��+Z� � A}(��%�J�,{��Z�d�e1����#+@/�h+�k$�ڲ�Ul�jc$��

+���U+��U���q:�R)�
�1�(�*�ye�'1�ւ�d��V�z��#���x����.q'�
�$p"L�NVA<dq�����U�������t�Ǐa�R�*����㸺�����|{�p��n�4����N�K��B�>Ky���Yۖ{�A��>Z��<PZ�\��h�Y5`y��m�F.n5�fG�Wi
�>�S]�њ�¼�p��U`b�%%X�U`� 1�>Z���-Mi�m[�����@���S�њ�B���LI3�J�#�"������X������v����e.����2�h���W��Rm���AB@��Ax��}ڗ���e����������u�p���0���3�����0:�99�
�Pk9_�$z��� �p�:�8][K\ԇV���4B�T���� 3Wtg�[\|������ݗ9k���og͈J��MY�x�yjC��>RMv^ذ���!�s�	������������V!�1�����CÇv�����A�%=���艊����l�{�P�ނ��@����Ppm�R:�,�������8��1��g���An��o�^�҃�Y�(�/JzBJ�����G�k�vq�=g�(������]��Q��˸�:|��T{����F�ۇ��ԍ_\�o>^���z�AE�Q��/�k�!�����������۫����U2��?����o��a�����n������(��������c�{]{�/��*�E}���c7���ƚ���2�F;�V"0zvPWn��D?ည�y���X�B��
U(�4>5�� b��
)|N�ѷB��	4�R��,�#��f��HEeOgwRz�-�#.�3����Oݓ� l�I�mG�磔_��\�r�c��K<�r����R~�t��Cݎ8na,*�[��������.E���As���E�j�McT�X�=�A��Ƽ�UD!j�=0�ᜣ����Vx֗{Dx�T���'程^7�~�>��9�į�����?~��ϥC��7w��\���t�'�DD oCAڨ�2�O��� ��|˪'��K��)�����||5G7��@~��D/QF�;���>���o�|�	I2���� '���H}"m)tc\��������w7w���d�L�M���D�S�󥻶_q���j�L�	Vد�L��QƯ,�c0�%� �jXj���K u�����3��������������~��6U��B�����z���O&L���>�F�qL��(��r^��L�"�ǼT=^A�����'H����NB���h-zЋ;����oT���1m諵�C2D��_"Y��q��a5���/��Qp�^�(���ʻw������          ;  x�m��n�6�������9���:h�(�M�P��fm!������w�$%/�;G<�����<��zR<��� �*�5�IZB�ďo��Bq�~Ij_��dm��jq׏q�l�K���pf��k��bu��MZ��Ǎ7�, ���Ⴕ5Z���֟Y+����V)�;��'5iO�s'���s����5I�֓���^�lEK�jsF��м͊��V�6V��	%�h��d����qbA���n�ƱY��2�R4y��>���5h�,�����A��n?i�b�l@^�OA�U�ݶ���vM�R����=����f'+��B�f�-k6a��Ì>��	�q��}�ę\�E�}�;.�G�A����P��j$������8�i�$���Xrf��\�q�R�"��[D#n�k���.y28���x7M��@�֤�
��b�R���s[|XW�^�H�P|�G��9�C���T$9|(˒�:��	��Tr�e�}*��U�p�G�+&�$Vm�<~xZ�ܩFȎ|)�����y�p$��-����]��],rJ�����5�M�Ʊ(0垡S{�'U��]���{Nӡԁ�x�Tz�)-uN|�C|�n�!�q)2y�uf�yq|JC���yʱ7�P�q�5����IG��4���q��%j��J �z��Zϻ�S��k��
���6��r)0J:X&�p��m�GW��ݲ��!���Rc��q�єS�9�^"A9�g��-�	��Υw����m����mڥ��9�58�K��x��yj{���9��l3�����G�����Ґ�yz�踞���)�����Ӥ������g�r��������׏�_����(�/��H��пt���+��������e���_��:IH���~���͂6yDi'�nf��bW�x�ۥ��#��g'��f�K����v�9%�y�w�����.�.d�7���3Yx�l<�s����Y�m��j�L���|���%�D�^�1MǇ��������9asc9�?`{2��s���0_�����O������������\�      5      x������ � �      !   n   x���1�0��9�/�����t�]*�N�E�ק02�����~�儦+-�*
���dW�Zɒ
m���>��X獏�<~��Z+�}������Գ������Rz��&&      *   {   x����� D�5TAF̼P���#&�D��?�3#���@;����i�:��G"7H.��A�J�9{2�OJ�S��:�hE�q!"I�GE�M�T�4U_h���E�nKQ���:%�M}+��_�	H[      $   �  x���A��0E��)r�
"Eʖn0뢻nǓ
�O�lz��r[l����?���&XΏP��/����(�h5�!@X�s��6���+�2<r��p7xIlj��~�WJp�w�ia,;i��'	6 �Qj�Q��*G������"#�Vs���gM�u0C�ł��t���O>a����@̡2��/��sZۨ�\Ԇ0I>XI�\Xu=|�z�w ��l�K��*��bt�D����]���xvwU�v|{lտm�3QW�j��m��{�J�,���HS��-��O^�k4���y5��.���B���2�-�3��Q.�ƨ�q��Y3���k��P��Y���B��8�״�A-��׫*yֳ"�^�}Z���6N6���/@0�~����bE��qk��=�	H�j���Wq��K�����������[�V��n�1�=��      %   <   x�3�,��)�M����2�,O�L�(�L�2�,�LMN�,H.�2��I�K/��������� ���      "   !  x�u�Mk�0@�ʯ�ǵsl�c�S/��Q�,)n����٬Y����A��O"��4��n\�X��~��̀�?��;/�%�JQ!-��+��t$(0���������g���i������J*��RB	��a���	W�\���s�o�c�헚K�>�����S��-��!6C�C�&����FR5�Z�0��� I����U�,�}������s?�Ѝc���ݯ�����R-t��Lj���T&��>�d��A��BiU��ld����,kւ��R�7�(�7�}+      /     x���Q�� �o���"{0`8���k�U��-���i,`@�Ds�JJ`����v)�� �,��&F AI�.:�3Q+��͡-$V��)Qa�QHS k�O*���3��}#��W�>:���$��ڿҪ������q�~,_\�EO纴C�`]��2��ɵ�ym�#X�ez��`�{�\�w�<w	���d\��(�^�L�{0�����,���-��p�����'��Ѣ��OB�y1�h[�`���<�J�?��K�w_,Լ�i6V�a۶?�F��      0   �  x��TMs�0=�_���K�skrm:is�a+XE�<�B~}we d`��}�oy���qvg�B��nu�U=�Ⱦq|��+|<�*�%+g��*���V�*/�Z]��3^!��b��7N5Z����b�jT�Ⱦ�� �O�A���D#��X�Bd�bN4��1hwĽ�����ϥK*�٣rϤ��F�z�=;���-*4����&2&8�{�_�ɠ��J�;��y�����Lx�H%_�"���X',��7hʈ����#��S`�F�V��P��r��m�i�)?�[���~�î�FA'�8��|�p��eߣ[�v2X�XK�M錮'��s|h��S���2UAT%�5*"�4ך��#c���q��QJB������ю8�a0�	8�ξ�*���񿺵N����s�^�]Ga� v)�je��A�8�<:��h�vvwE���1KNM�Nd�r�ew)��ρ+>_e"]�E5�-�fbI���x�=rӎ�D��7�Z��c�;�]F��Y��F��:WE\�+��l�`��N�@?��@+Ij�r��
|�|���!�k����H�#�]�9M-{�C��v���}��
^2�9��kuss���t�����]4�}�����Pp�}� ���g�`\�����?1�����K2m\��ǁ�w�=�s"X�d����6�I�I��t��X$C��WQK��t�k�{�X����
�x�1Xq�EYT�\
��u�r��t6����      #   �   x�eϱm1�Z�B�I���:�Mc$Bw.�<�'�b���!v���?Q������}��H��ؘ�t��G졆e:�ׯXՈr��i{�2�y����k���X�s��"8�0H����1fb�Q���t�|��U2,�WZo^�w[��Z"7�6�tc�l˺�����ʪPZ�F��� ެSE'o9���:E�      &   �  x�}��r�@�5<�i�npe�`�R�V�Be* ����y�y��ؐT����Y��/���B�e��UQ���}�G��B�����=�ࠧ[.?�s����|{������8MF��:Vf�إ1����h|�B��A�d��T	�!҇�T]U]4�p&��rH��*[کU�1]Q��D��ɒ6f�������'������!C��IY��ϓ���%����z�L'��2yi_��\���}<���|]/�
�k���mY�I�G�X�m��$�;y#��/2F�nM+�����4�I�V������]����;;=$Q���k�	����N��Rl��z��lZ4��lJ<#;'[�J1�Hl��?1�*�S����h�E�/Y���      3   ,   x���4202�54�52W00�20�25�3�42���4����� z*N      4   e   x�M��!�P�8�%�1�%����2��Վ���ఄ^��f1�����Ĭp�����|=�z��l@G��-`!
Ԁ���Q���0M���h����N      6   �   x���A� ��u<E/ C@�,]��G(�tQ�f�~�?\�F2�I��2�Y^"��!%���P]���v�k��ӕ��>N}<W4�Ʀ%�D͝t�DnG���s��-��p~Y�
��~�i�I�1��\�92O�]���j�n�����'?����4�v��9��9��9��9��9��8���`Z�PZw;�ָyZ7�����ԧ����������������w���ݤ�0�����8���Ӳ,_^,0     