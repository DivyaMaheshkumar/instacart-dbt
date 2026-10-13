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
)

select
    order_id,
    user_id,
    evaluation_set,
    order_number,
    order_day_of_week,
    order_hour_of_day,
    days_since_prior_order
from orders