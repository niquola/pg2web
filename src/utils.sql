func helper(_x_ text) RETURNS text
  SELECT format('Hello %s', _x_)::text

