-- Table 5: Purchase order tracking (optional)

CREATE TABLE purchase_orders (
    id SERIAL PRIMARY KEY,
    disposable_id INT REFERENCES disposables(id),
    quantity_ordered INT NOT NULL,
    order_date DATE NOT NULL
);
