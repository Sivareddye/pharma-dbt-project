with adverse_events as (

    select
        product_id,

        count(*) as total_adverse_events,

        count_if(severity = 'MILD')
            as mild_events,

        count_if(severity = 'MODERATE')
            as moderate_events,

        count_if(severity = 'SEVERE')
            as severe_events,

        count_if(hospitalized_flag = true)
            as hospitalization_events

    from {{ ref('fct_adverse_events') }}

    group by product_id

),

prescriptions as (

    select
        product_id,

        count(*) as total_prescriptions,

        count(distinct patient_id)
            as patients_exposed

    from {{ ref('fct_prescriptions') }}

    where prescription_status = 'FILLED'

    group by product_id

),

products as (

    select *
    from {{ ref('dim_product') }}

)

select
    p.product_id,
    p.product_name,
    p.therapeutic_area,

    coalesce(rx.total_prescriptions, 0)
        as total_prescriptions,

    coalesce(rx.patients_exposed, 0)
        as patients_exposed,

    coalesce(a.total_adverse_events, 0)
        as total_adverse_events,

    coalesce(a.mild_events, 0)
        as mild_events,

    coalesce(a.moderate_events, 0)
        as moderate_events,

    coalesce(a.severe_events, 0)
        as severe_events,

    coalesce(a.hospitalization_events, 0)
        as hospitalization_events,

    round(
        coalesce(a.total_adverse_events, 0) * 1000.0 /
        nullif(rx.total_prescriptions, 0),
        2
    ) as adverse_events_per_1000_prescriptions

from products p

left join adverse_events a
    on p.product_id = a.product_id

left join prescriptions rx
    on p.product_id = rx.product_id