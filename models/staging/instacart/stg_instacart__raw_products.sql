with 

source as (

    select * from {{ source('instacart', 'raw_products') }}

),

renamed as (

    select
        cast(product_id as integer),
        cast(product_name as varchar),
        cast(aisle_id as integer),
        cast(department_id as integer)

    from source

)

select * from renamed