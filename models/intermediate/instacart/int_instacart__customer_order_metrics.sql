with orders as (
    select
        order_id,
        user_id,
        order_number,
        days_since_prior_order
    from {{ ref('stg_instacart__orders') }}
    where evaluation_set in ('prior', 'train')
),

-- Window function to find the latest order's gap for each user
latest_customer_order as (
    select
        user_id,
        order_number,
        days_since_prior_order,
        row_number() over (partition by user_id order by order_number desc) as rn
    from orders
),

customer_aggregates as (
    select
        o.user_id,
        count(distinct o.order_id) as total_orders,
        max(o.order_number) as max_order_number,
        
        -- Recency: The exact days since their very last prior order (Fixed join key to user_id)
        max(case when l.rn = 1 then l.days_since_prior_order end) as days_since_last_order,
        
        -- Pacing: Their average gap overall
        avg(o.days_since_prior_order) as avg_days_between_orders,
        
        count(i.product_id) as total_items_bought,
        count(distinct i.product_id) as unique_products_bought
    from orders o
    left join {{ ref('int_instacart__order_products_combined') }} i using(order_id)
    left join latest_customer_order l on o.user_id = l.user_id and l.rn = 1
    group by o.user_id
)

select * from customer_aggregates