with providers as (

    select *
    from {{ ref('dim_provider') }}

),

prescriptions as (

    select
        provider_id,

        count(*) as total_prescriptions,

        count_if(prescription_type = 'NEW')
            as new_prescriptions,

        count_if(prescription_type = 'REFILL')
            as refill_prescriptions,

        count(distinct patient_id)
            as unique_patients,

        count(distinct product_id)
            as products_prescribed

    from {{ ref('fct_prescriptions') }}

    group by provider_id

),

sales as (

    select
        provider_id,

        sum(quantity_sold)
            as quantity_sold,

        sum(net_sales_amount)
            as net_sales

    from {{ ref('fct_sales') }}

    group by provider_id

)

select
    p.provider_id,
    p.provider_name,
    p.npi_number,
    p.specialty,
    p.hospital_name,
    p.city,
    p.state,
    p.territory_id,

    coalesce(rx.total_prescriptions, 0)
        as total_prescriptions,

    coalesce(rx.new_prescriptions, 0)
        as new_prescriptions,

    coalesce(rx.refill_prescriptions, 0)
        as refill_prescriptions,

    coalesce(rx.unique_patients, 0)
        as unique_patients,

    coalesce(rx.products_prescribed, 0)
        as products_prescribed,

    coalesce(s.quantity_sold, 0)
        as quantity_sold,

    coalesce(s.net_sales, 0)
        as net_sales

from providers p

left join prescriptions rx
    on p.provider_id = rx.provider_id

left join sales s
    on p.provider_id = s.provider_id