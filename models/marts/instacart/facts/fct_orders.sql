{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

with orders as (
    select
        order_id,
        user_id,
        evaluation_set,
        order_number,
        order_day_of_week,
        order_hour_of_day,
        days_since_prior_order
    from {{ ref('stg_instacart__orders') }}
    where evaluation_set in ('prior', 'train')
),

-- Aggregate item-level metrics per order to add quantitative power to the fact table
order_item_metrics as (
    select
        order_id,
        count(product_id) as total_items_in_order,
        count(distinct product_id) as unique_products_in_order,
        sum(case when is_reordered = 1 then 1 else 0 end) as reordered_items_count
    from {{ ref('int_instacart__order_products_combined') }}
    group by order_id
),

final as (
    select
        o.order_id,
        o.user_id,
        o.evaluation_set,
        o.order_number,
        o.order_day_of_week,
        o.order_hour_of_day,
        o.days_since_prior_order,
        
        -- Quantitative metrics (Facts)
        coalesce(i.total_items_in_order, 0) as total_items_in_order,
        coalesce(i.unique_products_in_order, 0) as unique_products_in_order,
        coalesce(i.reordered_items_count, 0) as reordered_items_count

    from orders o
    left join order_item_metrics i using (order_id)
)

select * from final

{% if is_incremental() %}
  where order_id > (select max(order_id) from {{ this }})
{% endif %}