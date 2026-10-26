{{
    config(
        materialized='table',
        tags=['marts', 'customers']
    )
}}

with customer_rfm as (
    select
        user_id,
        recency_days,
        frequency,
        monetary_volume,
        avg_basket_depth,
        product_variety_ratio,
        customer_segment
    from {{ ref('int_instacart__customer_rfm') }}
),

customer_metrics as (
    select
        user_id,
        max_order_number,
        avg_days_between_orders,
        unique_products_bought
    from {{ ref('int_instacart__customer_order_metrics') }}
),

final as (
    select
        -- Surrogate or natural key
        r.user_id,
        
        -- Behavioral Segmentation
        r.customer_segment,
        
        -- RFM & Volume Dimensions
        r.recency_days,
        r.frequency as total_orders,
        r.monetary_volume as total_items_bought,
        m.unique_products_bought,
        
        -- Behavioral Ratios & Pacing
        r.avg_basket_depth,
        r.product_variety_ratio,
        m.avg_days_between_orders,
        
        -- Lifecycle Metadata
        m.max_order_number

    from customer_rfm r
    inner join customer_metrics m using (user_id)
)

select * from final