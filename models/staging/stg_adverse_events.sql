with source as (

    select *
    from {{ source('pharma_raw', 'raw_adverse_events') }}

),

renamed as (

    select
        event_id,
        patient_id,
        product_id,
        event_date,
        trim(event_type) as event_type,
        trim(event_description) as event_description,
        upper(severity) as severity,
        hospitalized_flag,
        upper(outcome) as outcome,
        reported_date,
        updated_at

    from source

)

select *
from renamed