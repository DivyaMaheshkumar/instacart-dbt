with 

source as (

    select * from {{ source('instacart', 'raw_departments') }}

),

renamed as (

    select
        cast(department_id as integer) as department_id,
        cast(department as varchar) as department_name

    from source

)

select * from renamed