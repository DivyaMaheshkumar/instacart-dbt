{{
    config(
        materialized='incremental',
        unique_key=['order_id', 'product_id']
    )
}}

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

{% if is_incremental() %}
  where order_id > (select max(order_id) from {{ this }})
{% endif %}  