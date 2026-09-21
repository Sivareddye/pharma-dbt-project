with sales as (

    select *
    from {{ ref('stg_sales') }}

)

select

    md5(coalesce(sales_id, '')) as sales_key,

    sales_id,

    md5(coalesce(product_id, '')) as product_key,
    md5(coalesce(territory_id, '')) as territory_key,
    md5(coalesce(provider_id, '')) as provider_key,

    product_id,
    territory_id,
    provider_id,

    sales_date,

    quantity_sold,
    unit_price,
    discount_amount,
    net_sales_amount,

    quantity_sold * unit_price as gross_sales_amount,

    updated_at

from sales