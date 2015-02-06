#module fhir
  #statefull
  #import
    ../src/migrations.sql #as x

#migrate users
  #pre
    x#table_not_exists('users')

  #post
    table_exists('users') and (select exists from users)

  #migrate-up
    create table users (name varchar)

    insert into users (name)
      values ('nicola')

  #migrate-down
    drop table users

#def expect(msg, line, ~cnt, #=>)
  SELECT expect(#msg, #line, (~cnt), (~#=>));

#expect special assertion
  select count(*)
    from users
  #=> 5

#func name(jsonb x)=> jsonb
  select x

#def #last(x,y)
  x || y

#func roles()=> bigint
  select #last(roles) FROM users

#var x = '{a: 1, b: 2}'

SELECT #x || 'ups'
