with 

source as (

    select * from {{ source('instacart', 'raw_order_products__prior') }}

),

renamed as (

    select
        cast(order_id as integer),
        cast(product_id as integer),
        cast(add_to_cart_order as integer) as add_to_cart_sequence,
        cast(reordered as integer) as is_reordered

    from source

)

select * from renamed