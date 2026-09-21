{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='prescription_id'
    )
}}

with prescriptions as (

    select *
    from {{ ref('int_prescription_enriched') }}

),

final as (

    select
        prescription_id,
        patient_id,
        provider_id,
        product_id,
        prescription_date,
        quantity,
        days_supply,
        refill_number,
        prescription_status,
        prescription_type,

        claim_count,
        total_claim_amount,
        total_insurance_paid,
        total_patient_copay,

        overall_claim_status,
        prescription_updated_at

    from prescriptions

    {% if is_incremental() %}

        where prescription_updated_at >=
        (
            select dateadd(
                day,
                -2,
                max(prescription_updated_at)
            )
            from {{ this }}
        )

    {% endif %}

)

select *
from final