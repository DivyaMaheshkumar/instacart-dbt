with customer_metrics as (
    select
        user_id,
        total_orders,
        max_order_number,
        days_since_last_order,
        avg_days_between_orders,
        total_items_bought,
        unique_products_bought
    from {{ ref('int_instacart__customer_order_metrics') }}
),

rfm_calculated as (
    select
        user_id,
        
        -- RFM Dimensions
        days_since_last_order as recency_days,
        total_orders as frequency,
        total_items_bought as monetary_volume,
        
        -- Advanced Behavioral Metrics (Basket Depth & Variety)
        round(cast(total_items_bought as float) / nullif(total_orders, 0), 2) as avg_basket_depth,
        round(cast(unique_products_bought as float) / nullif(total_items_bought, 0), 2) as product_variety_ratio,

        -- Behavioral Segmentation Logic
        case
            when total_orders >= 20 and total_items_bought >= 150 then 'VIP / Power Shopper'
            when total_orders >= 10 then 'Loyal Regular'
            when days_since_last_order > 30 then 'At-Risk / Churning'
            when (cast(total_items_bought as float) / nullif(total_orders, 0)) >= 15 then 'Bulk / Stock-up Shopper'
            when total_orders >= 3 then 'Active Shopper'
            else 'New / Occasional'
        end as customer_segment

    from customer_metrics
)

select * from rfm_calculated