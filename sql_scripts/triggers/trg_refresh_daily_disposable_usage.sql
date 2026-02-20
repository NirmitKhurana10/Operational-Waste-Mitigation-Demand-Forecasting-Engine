DROP trigger if exists trg_refresh_daily_disposable_usage on food_sales

CREATE TRIGGER trg_refresh_disposable_daily_usage
AFTER INSERT ON food_sales
FOR EACH STATEMENT
EXECUTE FUNCTION refresh_disposable_daily_usage();
