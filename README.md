# instacart-dbt
An end-to-end modern data stack (MDS) implementation using dbt, Snowflake, and the public Instacart dataset. This project transforms raw operational data into a clean, modular star schema designed for high-performance business intelligence and analytics.

## Tech Stack

* **Data Warehouse:** Snowflake (`analytics_wh` compute cluster)
* **Transformation & Modeling:** dbt (Data Build Tool)
* **Version Control:** GitHub (Branch-per-layer workflow)
* **Data Source:** Public Instacart Grocery Basket Analysis Dataset (`orders`, `products`, `aisles`, `departments`, `order_products`)

## Architectural Design & Modular Layers

This project separates business logic into distinct, manageable layers:

1. **Staging Layer (`stg_`)**: 
   * 1 to 1 lightweight transformations directly on top of raw source tables.
   * Handles column renaming, basic data type casting.
2. **Intermediate Layer (`int_`)**: 
   * Handles aggregations and transformations prior to final modeling.
   * **`int_instacart__order_products_combined`**: Unions separate `prior` and `train` line-item tables.
   * **`int_instacart__customer_order_metrics`**: Pre-aggregates user behavior metrics (total orders, order frequency).
3. **Marts Layer (`dim_` & `fct_`)**: 
   * **Dimensions**: `dim_products` (aisles/departments), `dim_customers` (customer lifetime metrics).
   * **Facts**: `fct_orders` (order grain temporal attributes), `fct_order_items` (line-item grain with reorder flags).
  
  ## Data Lineage
  The data flows cleanly from raw sources through modular transformation stages into business-ready entities:
   
<img width="1120" height="580" alt="Screenshot 2026-10-13 at 3 47 24 PM" src="https://github.com/user-attachments/assets/8df6f474-80f2-43ef-8476-9a7fec78ee16" />
