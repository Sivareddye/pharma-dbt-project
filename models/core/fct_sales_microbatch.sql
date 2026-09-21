{{
    config(
        materialized='incremental',
        incremental_strategy='microbatch',
        event_time='sales_date',
        begin='2026-01-01',
        batch_size='day',
        lookback=2,
        full_refresh=false
    )
}}

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

    quantity_sold * unit_price
        as gross_sales_amount,

    updated_at

from {{ ref('stg_sales') }}