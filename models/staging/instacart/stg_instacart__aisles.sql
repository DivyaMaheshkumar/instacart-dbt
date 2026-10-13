with 

source as (

    select * from {{ source('instacart', 'raw_aisles') }}

),

renamed as (

    select
        cast(aisle_id as integer),
        cast(aisle as varchar) as aisle_name

    from source

)

select * from renamed