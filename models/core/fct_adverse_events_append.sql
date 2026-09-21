{{
    config(
        materialized='incremental',
        incremental_strategy='append'
    )
}}

with source_data as (

    select *
    from {{ ref('stg_adverse_events') }}

),

final as (

    select
        event_id,
        patient_id,
        product_id,
        event_date,
        event_type,
        event_description,
        severity,
        hospitalized_flag,
        outcome,
        reported_date,
        updated_at

    from source_data

    {% if is_incremental() %}

        where updated_at >
        (
            select coalesce(
                max(updated_at),
                '1900-01-01'::timestamp
            )
            from {{ this }}
        )

    {% endif %}

)

select *
from final