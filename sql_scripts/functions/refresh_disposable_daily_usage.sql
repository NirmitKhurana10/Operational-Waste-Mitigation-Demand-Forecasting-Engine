CREATE OR REPLACE FUNCTION refresh_disposable_daily_usage()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY disposable_daily_usage;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;




-- It defines a trigger function that:
-- 	•	Automatically refreshes the disposable_daily_usage materialized view in the background (without blocking readers)
-- 	•	Doesn’t need to return anything, since it’s only reacting to some change elsewhere (like in food_sales)
