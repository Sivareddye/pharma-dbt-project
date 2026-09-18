with source as (

    select *
    from {{ source('pharma_raw', 'raw_products') }}

),

renamed as (

    select
        product_id,
        trim(product_name) as product_name,
        trim(brand_name) as brand_name,
        trim(generic_name) as generic_name,
        trim(therapeutic_area) as therapeutic_area,
        trim(dosage_form) as dosage_form,
        trim(strength) as strength,
        trim(manufacturer) as manufacturer,
        launch_date,
        list_price,
        upper(product_status) as product_status,
        updated_at

    from source

)

select *
from renamed