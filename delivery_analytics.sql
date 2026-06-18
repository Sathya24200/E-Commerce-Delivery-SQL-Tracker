-- ====================================================================
-- PROJECT: HYPER-LOCAL E-COMMERCE DELIVERY PERFORMANCE TRACKER
-- ENVIRONMENT: SQLite / DBeaver (macOS)
-- DESCRIPTION: Database schema and analysis queries to track 15-min SLA breaches
-- ====================================================================

-- --------------------------------------------------------------------
-- STEP 1: CLEANUP & DATABASE ARCHITECTURE ENVIRONMENT SETUP
-- --------------------------------------------------------------------

-- Drop dependent tables first to avoid foreign key constraint errors
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Delivery_Partners;

-- 1. Create the Products Dimension Table
CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    standard_weight_g INTEGER
);

-- 2. Create the Delivery_Partners Dimension Table
CREATE TABLE Delivery_Partners (
    partner_id INTEGER PRIMARY KEY,
    partner_name TEXT,
    vehicle_type TEXT
);

-- 3. Create the Orders Fact Table (Central Transaction Table)
CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY,
    product_id INTEGER,
    partner_id INTEGER,
    order_status TEXT,
    packed_time TEXT,       -- Timestamps stored as ISO 8601 strings (YYYY-MM-DD HH:MM:SS)
    delivered_time TEXT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (partner_id) REFERENCES Delivery_Partners(partner_id)
);

-- --------------------------------------------------------------------
-- STEP 2: SEED DATA GENERATION (LOGISTICS SAMPLE RECORDS)
-- --------------------------------------------------------------------

INSERT INTO Products VALUES 
(101, 'iPhone 15 Case', 'Electronics', 150),
(102, 'Protein Whey Powder', 'Fitness', 1000),
(103, 'Stainless Steel Flask', 'Kitchen', 400);

INSERT INTO Delivery_Partners VALUES 
(1, 'Ramesh Kumar', 'Two-Wheeler'),
(2, 'Anita Das', 'EV Scooter'),
(3, 'Suresh Raj', 'Two-Wheeler');

INSERT INTO Orders VALUES 
(5001, 101, 1, 'Delivered', '2026-06-15 10:00:00', '2026-06-15 10:12:00'), -- 12 mins (On-Time)
(5002, 102, 1, 'Delivered', '2026-06-15 11:30:00', '2026-06-15 11:55:00'), -- 25 mins (Delayed)
(5003, 103, 2, 'Delivered', '2026-06-15 14:00:00', '2026-06-15 14:14:00'), -- 14 mins (On-Time)
(5004, 101, 3, 'Delivered', '2026-06-15 15:10:00', '2026-06-15 15:32:00'), -- 22 mins (Delayed)
(5005, 102, 3, 'Delivered', '2026-06-15 16:00:00', '2026-06-15 16:26:00'); -- 26 mins (Delayed)


-- --------------------------------------------------------------------
-- STEP 3: LOGISTICS ANALYTICS & BUSINESS INSIGHT QUERIES
-- --------------------------------------------------------------------

-- QUERY 1: Basic Delivery Duration Calculation
-- Purpose: Convert text timestamps to unix epochs to find individual trip lengths.
SELECT 
    order_id,
    partner_id,
    packed_time,
    delivered_time,
    (strftime('%s', delivered_time) - strftime('%s', packed_time)) / 60 AS delivery_time_minutes
FROM Orders;


-- QUERY 2: SLA Breach Matrix (The Executive Tracker)
-- Purpose: Identifies which riders frequently exceed the company's 15-minute delivery promise.
SELECT 
    p.partner_name AS rider_name,
    p.vehicle_type,
    COUNT(o.order_id) AS total_deliveries,
    SUM(CASE WHEN (strftime('%s', o.delivered_time) - strftime('%s', o.packed_time)) / 60 > 15 THEN 1 ELSE 0 END) AS delayed_deliveries
FROM Orders o
JOIN Delivery_Partners p ON o.partner_id = p.partner_id
GROUP BY p.partner_name, p.vehicle_type;


-- QUERY 3: Vehicle Fleet Efficiency Optimization Analysis
-- Purpose: Measures whether green fleet assets (EV Scooters) improve fulfillment speed over gas bikes.
SELECT 
    p.vehicle_type,
    COUNT(o.order_id) AS total_trips,
    AVG((strftime('%s', o.delivered_time) - strftime('%s', o.packed_time)) / 60.0) AS avg_delivery_minutes
FROM Orders o
JOIN Delivery_Partners p ON o.partner_id = p.partner_id
GROUP BY p.vehicle_type;


-- QUERY 4: Inventory Management & Categorical Priority Actions
-- Purpose: Builds automated text alerts checking supply line attributes.
SELECT 
    product_name,
    category,
    CASE 
        WHEN category = 'Electronics' THEN 'Priority Restock (High Value Asset)'
        ELSE 'Standard Restock Queue'
    END AS operational_action
FROM Products;