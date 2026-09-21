with products as (

    select *
    from {{ ref('stg_products') }}

)

select

    md5(coalesce(product_id, '')) as product_key,

    product_id,
    product_name,
    brand_name,
    generic_name,
    therapeutic_area,
    dosage_form,
    strength,
    manufacturer,
    launch_date,
    list_price,
    product_status,
    updated_at

from products