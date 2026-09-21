with claims as (

    select *
    from {{ ref('stg_claims') }}

)

select

    md5(coalesce(claim_id, '')) as claim_key,

    claim_id,

    md5(coalesce(prescription_id, '')) as prescription_key,
    md5(coalesce(patient_id, '')) as patient_key,
    md5(coalesce(product_id, '')) as product_key,

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