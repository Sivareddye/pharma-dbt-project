with source as (

    select *
    from {{ source('pharma_raw', 'raw_sales') }}

),

renamed as (

    select
        sales_id,
        product_id,
        territory_id,
        provider_id,
        sales_date,
        quantity_sold,
        unit_price,
        discount_amount,
        net_sales_amount,
        updated_at

    from source

)

select *
from renamed