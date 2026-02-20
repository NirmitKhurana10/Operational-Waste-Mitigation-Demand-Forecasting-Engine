CREATE OR REPLACE FUNCTION update_stock_after_restock()
RETURNS void AS $$
BEGIN
  UPDATE disposable_stock ds
  SET boxes_stock_qty = ds.boxes_stock_qty + rl.boxes_added
  FROM restock_log rl
  WHERE ds.disposable_id = rl.disposable_id
    AND rl.restock_date = CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;
