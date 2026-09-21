with territories as (

    select *
    from {{ ref('stg_territories') }}

)

select

    md5(coalesce(territory_id, '')) as territory_key,

    territory_id,
    territory_name,
    region_name,
    district_name,
    sales_rep_id,
    sales_rep_name,
    state

from territories