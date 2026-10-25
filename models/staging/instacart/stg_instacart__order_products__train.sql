with 

source as (

    select * from {{ source('instacart', 'raw_order_products__train') }}

),

renamed as (

    select
        cast(order_id as integer) as order_id,
        cast(product_id as integer) as product_id,
        cast(add_to_cart_order as integer) as add_to_cart_sequence,
        cast(reordered as integer) as is_reordered,
        'train' as order_phase

    from source

)

select * from renamed