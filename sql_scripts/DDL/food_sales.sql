CREATE TABLE food_sales (
    id SERIAL PRIMARY KEY,
    week_number INT NOT NULL,
    food_item_id INT REFERENCES food_items(id),
    quantity_sold INT NOT NULL
);

ALTER TABLE food_sales ADD COLUMN date DATE;
