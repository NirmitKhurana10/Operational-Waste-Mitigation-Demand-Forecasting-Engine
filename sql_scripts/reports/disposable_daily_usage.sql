-- View to calculate daily usage
CREATE MATERIALIZED VIEW disposable_daily_usage AS
SELECT
  disposables.id AS disposable_id,
  disposables.disposable_name,
  CURRENT_DATE - 1 AS log_date,
  CEIL(
    SUM(
    CASE
      WHEN disposable_mapping.order_type = 'eat-in' THEN food_sales.quantity_sold * 0.5 * disposable_mapping.disposable_qty_used
      WHEN disposable_mapping.order_type = 'take-out' THEN food_sales.quantity_sold * 0.5 * disposable_mapping.disposable_qty_used
      ELSE food_sales.quantity_sold * disposable_mapping.disposable_qty_used
    END
  )
  ) AS quantity_used
FROM food_sales
JOIN disposable_mapping ON food_sales.food_item_id = disposable_mapping.food_item_id
JOIN disposables ON disposable_mapping.disposable_id = disposables.id
WHERE food_sales.date = CURRENT_DATE - 1
GROUP BY disposables.id;


REFRESH MATERIALIZED VIEW disposable_daily_usage;


-- drop materialized view disposable_daily_usage
