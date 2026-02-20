-- Table 3: Disposables mapping to food items

CREATE TABLE disposable_mapping (
    id SERIAL PRIMARY KEY,
    food_item_id INT REFERENCES food_items(id),
    disposable_id INT REFERENCES disposables(id),
    disposable_qty FLOAT NOT NULL
);

ALTER TABLE disposable_mapping ADD COLUMN order_type TEXT;

ALTER TABLE disposable_mapping
  ADD CONSTRAINT uniq_mapping UNIQUE (food_item_id, disposable_id, order_type);
