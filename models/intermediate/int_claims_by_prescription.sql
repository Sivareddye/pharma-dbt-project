with claims as (

    select *
    from {{ ref('stg_claims') }}

),

aggregated as (

    select
        prescription_id,

        count(*) as claim_count,

        sum(claim_amount) as total_claim_amount,
        sum(insurance_paid) as total_insurance_paid,
        sum(patient_copay) as total_patient_copay,

        max(
            case
                when claim_status = 'APPROVED' then 1
                else 0
            end
        ) as has_approved_claim,

        max(
            case
                when claim_status = 'REJECTED' then 1
                else 0
            end
        ) as has_rejected_claim,

        max(updated_at) as latest_claim_updated_at

    from claims

    group by prescription_id

)

select *
from aggregated