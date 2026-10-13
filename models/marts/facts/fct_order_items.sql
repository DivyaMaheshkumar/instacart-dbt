with order_products as (
    select
        order_id,
        product_id,
        add_to_cart_sequence,
        is_reordered
    from {{ ref('int_instacart__order_products_combined') }}
)

select
    order_id,
    product_id,
    add_to_cart_sequence,
    is_reordered
from order_products