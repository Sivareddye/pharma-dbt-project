with events as (

    select *
    from {{ ref('stg_adverse_events') }}

)

select

    md5(coalesce(event_id, '')) as adverse_event_key,

    event_id,

    md5(coalesce(patient_id, '')) as patient_key,
    md5(coalesce(product_id, '')) as product_key,

    patient_id,
    product_id,

    event_date,
    event_type,
    event_description,

    severity,
    hospitalized_flag,
    outcome,

    reported_date,

    datediff(
        day,
        event_date,
        reported_date
    ) as reporting_delay_days,

    updated_at

from events