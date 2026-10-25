with order_products_prior as (
    select
        order_id,
        product_id,
        add_to_cart_sequence,
        is_reordered,
        order_phase
    from {{ ref('stg_instacart__order_products__prior') }}
),

order_products_train as (
    select
        order_id,
        product_id,
        add_to_cart_sequence,
        is_reordered,
        order_phase
    from {{ ref('stg_instacart__order_products__train') }}
),

unioned as (
    select * from order_products_prior
    union all
    select * from order_products_train
)

select * from unioned