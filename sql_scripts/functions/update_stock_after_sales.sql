CREATE OR REPLACE FUNCTION update_stock_after_sales()
RETURNS VOID AS $$
BEGIN
  UPDATE disposable_stock AS ds
  SET boxes_stock_qty = FLOOR(
    GREATEST(0, ((ds.boxes_stock_qty * d.items_per_box) - dul.quantity_used) / d.items_per_box)
  )
  FROM disposable_usage_log AS dul
  JOIN disposables AS d ON d.id = dul.disposable_id
  WHERE ds.disposable_id = dul.disposable_id
    AND dul.log_date = CURRENT_DATE - 1;
END;
$$ LANGUAGE plpgsql;


select update_stock_after_sales()
