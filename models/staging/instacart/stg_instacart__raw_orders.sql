with 

source as (

    select * from {{ source('instacart', 'raw_orders') }}

),

renamed as (

    select
        cast(order_id as integer),
        cast(user_id as integer),
        cast(eval_set as varchar) as evaluation_set,
        cast(order_number as integer),
        cast(order_dow as integer) as order_day_of_week,
        cast(order_hour_of_day as integer),
        cast(days_since_prior_order as integer)

    from source

)

select * from renamed