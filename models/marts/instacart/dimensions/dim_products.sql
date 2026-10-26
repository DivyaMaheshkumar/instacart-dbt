{{
    config(
        materialized='table',
        tags=['marts', 'products']
    )
}}

with products as (
    select
        product_id,
        product_name,
        aisle_id,
        department_id
    from {{ ref('stg_instacart__products') }}
),

aisles as (
    select
        aisle_id,
        aisle_name
    from {{ ref('stg_instacart__aisles') }}
),

departments as (
    select
        department_id,
        department_name
    from {{ ref('stg_instacart__departments') }}
),

final as (
    select
        p.product_id,
        p.product_name,
        a.aisle_name,
        d.department_name
    from products as p
    left join aisles as a
        on p.aisle_id = a.aisle_id
    left join departments as d
        on p.department_id = d.department_id
)

select * from final