CREATE TABLE disposable_usage_log (
  log_id SERIAL PRIMARY KEY,
  log_date DATE DEFAULT CURRENT_DATE,
  disposable_id INTEGER REFERENCES disposables(id),
  quantity_used INTEGER NOT NULL
);

alter table disposable_usage_log
add column disposable_name TEXT

alter table disposable_usage_log
add constraint uniq_usage_per_day unique(disposable_id, log_date)
