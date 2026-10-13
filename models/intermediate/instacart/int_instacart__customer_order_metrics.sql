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

customer_aggregates as (
    select
        user_id,
        count(distinct order_id) as total_orders,
        max(order_number) as max_order_number,
        avg(days_since_prior_order) as avg_days_between_orders
    from orders
    group by user_id
)

select * from customer_aggregates