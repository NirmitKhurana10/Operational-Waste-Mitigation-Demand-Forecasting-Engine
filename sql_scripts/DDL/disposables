-- Table 6 : Master Data for Disposables

CREATE TABLE disposables (
    id SERIAL PRIMARY KEY,
    disposable_name TEXT NOT NULL UNIQUE
);

ALTER TABLE disposables
ADD COLUMN items_per_box INT;

ALTER TABLE disposables ADD COLUMN min_stock_qty INTEGER DEFAULT 0;

