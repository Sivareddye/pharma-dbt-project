with source as (

    select *
    from {{ source('pharma_raw', 'raw_territories') }}

),

renamed as (

    select
        territory_id,
        trim(territory_name) as territory_name,
        trim(region_name) as region_name,
        trim(district_name) as district_name,
        sales_rep_id,
        trim(sales_rep_name) as sales_rep_name,
        upper(state) as state

    from source

)

select *
from renamed