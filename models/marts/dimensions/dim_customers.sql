with customer_metrics as (
    select
        user_id,
        total_orders,
        max_order_number,
        avg_days_between_orders
    from {{ ref('int_instacart__customer_order_metrics') }}
)

select
    user_id,
    total_orders,
    max_order_number,
    round(avg_days_between_orders, 1) as avg_days_between_orders
from customer_metrics