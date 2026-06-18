# E-Commerce-Delivery-SQL-Tracker
A relational database project using SQL to track logistics fulfillment times and flag delivery delays.

# Hyper-Local E-Commerce Delivery Performance Tracker

## 📌 Project Overview
In quick-commerce configurations, maintaining a tight delivery window is critical for customer retention. This project focuses on building an operational database schema using SQL to monitor delivery timelines, evaluate rider performance, and isolate operational infrastructure delays against a strict 15-minute Service Level Agreement (SLA).

## 🛠️ Tech Stack & Environment
* **Database Engine:** SQLite (Internal Sandbox)
* **Database Client Management Tool:** DBeaver (macOS native environment)
* **Language:** SQL

## 📊 Relational Database Architecture
The project applies a standard data warehouse star schema optimization structure:
* **Orders (Fact Table):** Collects order transactions, statuses, and precise step timestamps.
* **Products (Dimension Table):** Contains structural package data and categorical classifications.
* **Delivery_Partners (Dimension Table):** Registers logistics personnel tracking data and vehicle types.

## 🚀 Key Business Insights Extracted
1. **SLA Breach Monitoring:** Built a conditional time-difference calculation string using `strftime` to isolate delivery partners consistently exceeding the 15-minute fulfillment benchmark.
2. **Vehicle Class Optimization:** Written aggregated `AVG` matrix scripts grouping results by vehicle categories to identify if electric vehicles (EVs) clear urban traffic queues faster than regular combustion bikes.

## 📂 How to Run the Scripts
1. Open DBeaver or any SQL client tool.
2. Copy and execute the contents of `delivery_analytics.sql` to initialize the database architecture, load sample logistical records, and review output data frames.
