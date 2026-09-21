{{
    config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='claim_id',
        tmp_relation_type='table'
    )
}}

with claims as (

    select *
    from {{ ref('stg_claims') }}

),

final as (

    select
        claim_id,
        prescription_id,
        patient_id,
        product_id,
        claim_date,
        claim_amount,
        insurance_paid,
        patient_copay,
        claim_status,
        rejection_reason,
        updated_at

    from claims

    {% if is_incremental() %}

        where updated_at >=
        (
            select dateadd(
                day,
                -3,
                max(updated_at)
            )
            from {{ this }}
        )

    {% endif %}

)

select *
from final