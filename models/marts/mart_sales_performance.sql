with sales as (

    select *
    from {{ ref('fct_sales') }}

),

products as (

    select *
    from {{ ref('dim_product') }}

),

territories as (

    select *
    from {{ ref('dim_territory') }}

)

select
    s.sales_date,

    s.product_id,
    p.product_name,
    p.brand_name,
    p.therapeutic_area,

    s.territory_id,
    t.territory_name,
    t.region_name,
    t.district_name,
    t.sales_rep_name,

    sum(s.quantity_sold)
        as quantity_sold,

    sum(s.gross_sales_amount)
        as gross_sales,

    sum(s.discount_amount)
        as discount_amount,

    sum(s.net_sales_amount)
        as net_sales,

    round(
        sum(s.discount_amount) * 100.0 /
        nullif(sum(s.gross_sales_amount), 0),
        2
    ) as discount_rate_pct

from sales s

left join products p
    on s.product_id = p.product_id

left join territories t
    on s.territory_id = t.territory_id

group by
    s.sales_date,
    s.product_id,
    p.product_name,
    p.brand_name,
    p.therapeutic_area,
    s.territory_id,
    t.territory_name,
    t.region_name,
    t.district_name,
    t.sales_rep_name