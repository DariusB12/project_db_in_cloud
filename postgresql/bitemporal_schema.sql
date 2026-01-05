-- psql -U postgres -h localhost -p 5432
-- \c your_database_name;
-- \i ./bitemporal_schema.sql
-- DROP DATABASE no_temporal_extensions;
-- CREATE DATABASE no_temporal_extensions;
-----------------VIEWS-------------------
-- SELECT * FROM current_valid_product_prices;
-- SELECT * FROM product_price_history;
-- SELECT * FROM temporal_conflicts;
-- SELECT * FROM movements_valid_during('2025-08-01'::timestamp,'2025-09-05'::timestamp);
-- SELECT * FROM records_known_at('2025-11-05'::timestamp);


-- for globally unique primary keys
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- SERIAL PRIMARY KEY -> creates a sequence and the column value will be the next value from that sequence 
-- Advantages: quicker inserts
-- Disadvantage: not globally unique across tables, unique only within the db context
CREATE TABLE supplier (
supplier_id SERIAL PRIMARY KEY,
name TEXT NOT NULL UNIQUE,
contact_email TEXT
);

CREATE TABLE warehouse (
warehouse_id SERIAL PRIMARY KEY,
name TEXT NOT NULL UNIQUE,
location TEXT
);

CREATE TABLE product (
product_id SERIAL PRIMARY KEY,
--Stock Keeping Unit - unique code for each product, identifies it across systems
sku TEXT NOT NULL UNIQUE,
name TEXT NOT NULL,
category TEXT
);

-- UUID DEFAULT uuid_generate_v4() PRIMARY KEY -> globally unique across tables and dbs
-- Advantages: unique across dbs, better for distributed systems
-- Disadvantages: slightly slower inserts due to UUID generation (128 bits)
CREATE TABLE product_price (
pp_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
product_id INT NOT NULL REFERENCES product(product_id),
supplier_id INT REFERENCES supplier(supplier_id),
price NUMERIC(10,2) NOT NULL,
currency CHAR(3) NOT NULL DEFAULT 'USD',
-- VALID TIME
valid_start TIMESTAMP NOT NULL,
valid_end TIMESTAMP NOT NULL,
-- TRANSACTION TIME
transaction_start TIMESTAMP NOT NULL,
transaction_end TIMESTAMP NOT NULL,
CHECK (valid_start < valid_end)
);

CREATE TABLE inventory_movement (
im_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
product_id INT NOT NULL REFERENCES product(product_id),
warehouse_id INT NOT NULL REFERENCES warehouse(warehouse_id),
quantity INTEGER NOT NULL, -- positive for in, negative for out
-- receipt: Incoming stock — product received from supplier
-- shipment: Outgoing stock — product sent to customer
-- transfer_in: Stock received from another warehouse
-- transfer_out: Stock sent to another warehouse
-- adjustment: Manual stock correction (e.g found missing item etc.) (positive or negative - quantity adjusted)
movement_type TEXT NOT NULL CHECK (movement_type IN ('receipt','shipment','transfer_in','transfer_out','adjustment')),
-- VALID TIME: when the movement is considered to have occurred in reality
valid_start TIMESTAMP NOT NULL,
valid_end TIMESTAMP NOT NULL,
-- TRANSACTION TIME: when the system recorded the movement
transaction_start TIMESTAMP NOT NULL,
transaction_end TIMESTAMP NOT NULL,
CHECK (valid_start < valid_end)
);

-- Suppliers (5)
INSERT INTO supplier (name, contact_email) VALUES
('Global Supplies Inc.', 'sales@globalsupplies.example'),
('FastParts Ltd.', 'contact@fastparts.example'),
('Quality Goods Co.', 'info@qualitygoods.example'),
('Regional Distributors', 'hello@regional.example'),
('DirectSource', 'orders@directsource.example');


-- Warehouses (6)
INSERT INTO warehouse (name, location) VALUES
('WH-East', 'Bucharest East'),
('WH-West', 'Bucharest West'),
('WH-North', 'Cluj-North'),
('WH-South', 'Craiova-South'),
('WH-Central', 'Timisoara-Central'),
('WH-Overflow', 'Ploiesti');
