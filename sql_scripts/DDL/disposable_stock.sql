-- Table 4: Current stock of disposables

CREATE TABLE disposable_stock (
    id SERIAL PRIMARY KEY,
    disposable_id INT REFERENCES disposables(id),
    stock_qty INT NOT NULL
);

alter table disposable_stock
add column id SERIAL PRIMARY KEY


UPDATE disposable_stock
SET last_restocked = CURRENT_DATE - 2;
