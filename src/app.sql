-- #import ./utils.sql

create table this.users (name text);

insert into this.users (name)
select 'User ' || x from generate_series(0,100) x;

func! is_proc_exists(name text) RETURNS boolean
  SELECT EXISTS (
    SELECT * FROM pg_proc WHERE proname = name
  )

create table this.countries (
  "name" text,
  "tld" text,
  "cca2" text,
  "ccn3" text,
  "cca3" text,
  "currency" text,
  "callingCode" text,
  "capital" text,
  "altSpellings" text,
  "relevance" text,
  "region" text,
  "subregion" text,
  "languages" text,
  "translations" text,
  "latlng" text,
  "demonym" text,
  "landlocked" text,
  "borders" text,
  "area" text
);

\set root `pwd`/data/countries.csv

COPY this.countries
FROM :'root'
DELIMITER AS ';'
CSV;


proc! web(req jsonb) returns jsonb
  DECLARE
    proc_name varchar;
    proc varchar;
    res jsonb;
  BEGIN
    proc_name = quote_ident(lower(req->>'meth') || '_action_' || split_part(req->>'uri', '/', 3));
    proc = 'SELECT app.' || proc_name || '($1)';
    RAISE NOTICE '%', proc_name;
    IF proc_name <> '' AND this.is_proc_exists(proc_name) THEN
      EXECUTE proc INTO res USING req;
      RETURN res;
    ELSE
      RETURN json_build_object('error', ('[' || proc_name || '] not exists'), 'status', 500);
    END IF;

func! get_action_users(req jsonb) returns jsonb
  select json_agg(u.*)::jsonb from this.users u

func! get_action_roles(req jsonb) returns jsonb
  select '{"a":1}'::jsonb

func! get_action_countries(_req_ jsonb) returns jsonb
  select json_agg(c.*)::jsonb
    from this.countries c
     where name ilike '%' || COALESCE((_req_#>>'{params,q}'), '') || '%'
      limit 20

func! get_action_procs(req jsonb) RETURNS jsonb
  SELECT json_agg(pg_proc.*)::jsonb
    FROM pg_proc
   WHERE proname ilike '%_action_%'
