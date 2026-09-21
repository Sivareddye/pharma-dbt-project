{{
    config(
        materialized='incremental',
        incremental_strategy='insert_overwrite'
    )
}}

with sales as (

    select *
    from {{ ref('stg_sales') }}

)

select

    sales_date,
    product_id,

    sum(quantity_sold) as total_quantity,

    sum(
        quantity_sold * unit_price
    ) as gross_sales,

    sum(discount_amount) as total_discount,

    sum(net_sales_amount) as net_sales

from sales

group by
    sales_date,
    product_id