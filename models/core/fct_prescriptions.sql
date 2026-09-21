with prescriptions as (

    select *
    from {{ ref('int_prescription_enriched') }}

)

select

    md5(coalesce(prescription_id, '')) as prescription_key,

    prescription_id,

    md5(coalesce(patient_id, '')) as patient_key,
    md5(coalesce(provider_id, '')) as provider_key,
    md5(coalesce(product_id, '')) as product_key,

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

    has_approved_claim,
    has_rejected_claim,
    overall_claim_status,

    patient_age_at_prescription,

    prescription_updated_at

from prescriptions