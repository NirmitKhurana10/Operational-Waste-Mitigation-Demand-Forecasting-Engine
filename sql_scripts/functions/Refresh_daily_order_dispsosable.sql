CREATE OR REPLACE FUNCTION refresh_daily_order_disposable()
RETURNS VOID AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY daily_order_disposable;
END;
$$ LANGUAGE plpgsql;


select refresh_daily_order_disposable()
