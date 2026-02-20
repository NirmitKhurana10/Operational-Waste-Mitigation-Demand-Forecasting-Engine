-- To calculate:
-- 	1.	Total disposables needed for each item (based on sales & mapping)
-- 	2.	Compare with stock, and
-- 	3.	Determine how many boxes of each disposable to order

CREATE MATERIALIZED VIEW daily_order_disposable AS
SELECT
  d.id AS disposable_id,
  d.disposable_name,
  SUM(dul.quantity_used) AS total_used_since_restock,
  ds.boxes_stock_qty AS current_stock,
  d.min_stock_qty AS min_stock_threshold,
  d.items_per_box,
  CASE
    WHEN ds.boxes_stock_qty > d.min_stock_qty THEN 
    0
      -- CEIL(SUM(dul.quantity_used)::float / d.items_per_box)
    ELSE
      CEIL(
        GREATEST(0,
          (d.min_stock_qty * d.items_per_box - ds.boxes_stock_qty * d.items_per_box)  -- top up to threshold
          + SUM(dul.quantity_used)                                                   -- plus usage
        )::float / d.items_per_box
      )
  END AS boxes_to_order
FROM disposable_usage_log dul
JOIN disposables d ON dul.disposable_id = d.id
JOIN disposable_stock ds ON ds.disposable_id = d.id
WHERE dul.log_date >= ds.last_restocked
GROUP BY d.id, d.disposable_name, ds.boxes_stock_qty, d.min_stock_qty, d.items_per_box
HAVING
  CASE
    WHEN ds.boxes_stock_qty > d.min_stock_qty THEN
    0
      -- CEIL(SUM(dul.quantity_used)::float / d.items_per_box)
    ELSE
      CEIL(
        GREATEST(0,
          (d.min_stock_qty * d.items_per_box - ds.boxes_stock_qty * d.items_per_box)
          + SUM(dul.quantity_used)
        )::float / d.items_per_box
      )
  END > 0;


-- This block is where the core forecasting logic happens.


-- SUM(
--   case
--     when disposable_mapping.order_type = 'eat-in' then food_sales.quantity_sold * 0.5 * disposable_mapping.disposable_qty_used
--     when disposable_mapping.order_type = 'take-out' then food_sales.quantity_sold * 0.5 * disposable_mapping.disposable_qty_used
--     else food_sales.quantity_sold * disposable_mapping.disposable_qty_used
--   end
-- ) as total_qty_used,


-- 	•	You’re assuming half the orders are eat-in, half are take-out, because your sales data doesn’t specify the type.
-- 	•	So you’re multiplying quantity_sold by 0.5 in each case.
-- 	•	If a disposable_mapping row has no order_type, it assumes full sales volume applies.

-- Example:
-- 	•	100 sales of mashed potatoes (food_id = 2)
-- 	•	1 plate for eat-in, 1 bowl + 1 lid for take-out
-- → This logic gives you:
-- 	•	50 plates
-- 	•	50 bowls
-- 	•	50 lids






-- This logic:

--   CEIL(
--     GREATEST(
--       0,
--       SUM(...) - ds.stock_qty
--     ) / disp.items_per_box
--   ) AS boxes_to_order

-- 	1.	Calculates how many disposables are short:
-- needed - current stock
-- 	2.	Ensures you don’t go negative (with GREATEST(0, ...))
-- 	3.	Divides by items per box to get how many full boxes to order
-- 	4.	Uses CEIL to round up to a full box — no partial box orders


-- DROP MATERIALIZED VIEW IF EXISTS daily_order_disposable;

REFRESH MATERIALIZED VIEW daily_order_disposable;
