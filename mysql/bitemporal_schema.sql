SET sql_mode = 'STRICT_ALL_TABLES';

-- sudo mysql -u root -p
-- SHOW DATABASES; TO SHOW ALL DB
-- SELECT DATABASE(); TO SHOW CURRENT DB
-- USE no_temporal_extensions;
-- source ./bitemporal_schema.sql;
-- DROP DATABASE no_temporal_extensions;
-- CREATE DATABASE no_temporal_extensions;
-- ---------------VIEWS-------------------
-- SELECT * FROM current_valid_product_prices;
-- SELECT * FROM product_price_history;
-- SELECT * FROM temporal_conflicts;
-- CALL movements_valid_during('2025-08-01 00:00:00', '2025-09-05 00:00:00');
-- CALL records_known_at('2025-11-05 00:00:00');

-- show all the triggers:
-- SELECT TRIGGER_NAME, EVENT_MANIPULATION, EVENT_OBJECT_TABLE, ACTION_TIMING 
-- FROM information_schema.TRIGGERS 
-- WHERE TRIGGER_SCHEMA = 'no_temporal_extensions';

-- =========================
-- TABLES
-- =========================

CREATE TABLE supplier (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    contact_email VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE warehouse (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    location VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE product_price (
    pp_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    product_id INT NOT NULL,
    supplier_id INT,
    price DECIMAL(10,2) NOT NULL,
    currency CHAR(3) NOT NULL DEFAULT 'USD',

    -- VALID TIME
    valid_start DATETIME NOT NULL,
    valid_end DATETIME NOT NULL,

    -- TRANSACTION TIME
    transaction_start DATETIME NOT NULL,
    transaction_end DATETIME NOT NULL,

    CHECK (valid_start < valid_end),

    CONSTRAINT fk_pp_product
        FOREIGN KEY (product_id) REFERENCES product(product_id),
    CONSTRAINT fk_pp_supplier
        FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
) ENGINE=InnoDB;

CREATE TABLE inventory_movement (
    im_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT NOT NULL,

    movement_type ENUM(
        'receipt',
        'shipment',
        'transfer_in',
        'transfer_out',
        'adjustment'
    ) NOT NULL,

    -- VALID TIME
    valid_start DATETIME NOT NULL,
    valid_end DATETIME NOT NULL,

    -- TRANSACTION TIME
    transaction_start DATETIME NOT NULL,
    transaction_end DATETIME NOT NULL,

    CHECK (valid_start < valid_end),

    CONSTRAINT fk_im_product
        FOREIGN KEY (product_id) REFERENCES product(product_id),
    CONSTRAINT fk_im_warehouse
        FOREIGN KEY (warehouse_id) REFERENCES warehouse(warehouse_id)
) ENGINE=InnoDB;



INSERT INTO supplier (name, contact_email) VALUES
('Global Supplies Inc.', 'sales@globalsupplies.example'),
('FastParts Ltd.', 'contact@fastparts.example'),
('Quality Goods Co.', 'info@qualitygoods.example'),
('Regional Distributors', 'hello@regional.example'),
('DirectSource', 'orders@directsource.example');


-- =========================
-- WAREHOUSES (6)
-- =========================
INSERT INTO warehouse (name, location) VALUES
('WH-East', 'Bucharest East'),
('WH-West', 'Bucharest West'),
('WH-North', 'Cluj-North'),
('WH-South', 'Craiova-South'),
('WH-Central', 'Timisoara-Central'),
('WH-Overflow', 'Ploiesti');
