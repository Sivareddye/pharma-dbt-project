with prescriptions as (

    select *
    from {{ ref('stg_prescriptions') }}

),

patients as (

    select *
    from {{ ref('stg_patients') }}

),

providers as (

    select *
    from {{ ref('stg_providers') }}

),

products as (

    select *
    from {{ ref('stg_products') }}

),

claims as (

    select *
    from {{ ref('int_claims_by_prescription') }}

),

joined as (

    select

        -- Prescription
        rx.prescription_id,
        rx.prescription_date,
        rx.quantity,
        rx.days_supply,
        rx.refill_number,
        rx.prescription_status,

        -- Patient
        rx.patient_id,
        p.first_name,
        p.last_name,
        p.date_of_birth,
        p.gender,
        p.state as patient_state,
        p.city as patient_city,
        p.insurance_type,
        p.patient_status,

        -- Provider
        rx.provider_id,
        prv.provider_name,
        prv.specialty,
        prv.hospital_name,
        prv.territory_id,
        prv.state as provider_state,

        -- Product
        rx.product_id,
        prod.product_name,
        prod.brand_name,
        prod.generic_name,
        prod.therapeutic_area,
        prod.dosage_form,
        prod.strength,
        prod.manufacturer,
        prod.list_price,

        -- Claims
        coalesce(c.claim_count, 0) as claim_count,
        coalesce(c.total_claim_amount, 0) as total_claim_amount,
        coalesce(c.total_insurance_paid, 0) as total_insurance_paid,
        coalesce(c.total_patient_copay, 0) as total_patient_copay,
        coalesce(c.has_approved_claim, 0) as has_approved_claim,
        coalesce(c.has_rejected_claim, 0) as has_rejected_claim,

        -- Derived business fields
        case
            when rx.refill_number = 0 then 'NEW'
            else 'REFILL'
        end as prescription_type,

        case
            when c.prescription_id is null then 'NO CLAIM'
            when c.has_approved_claim = 1 then 'APPROVED'
            when c.has_rejected_claim = 1 then 'REJECTED'
            else 'UNKNOWN'
        end as overall_claim_status,

        floor(
            datediff(
                day,
                p.date_of_birth,
                rx.prescription_date
            ) / 365.25
        ) as patient_age_at_prescription,

        rx.updated_at as prescription_updated_at,
        c.latest_claim_updated_at

    from prescriptions rx

    left join patients p
        on rx.patient_id = p.patient_id

    left join providers prv
        on rx.provider_id = prv.provider_id

    left join products prod
        on rx.product_id = prod.product_id

    left join claims c
        on rx.prescription_id = c.prescription_id

)

select *
from joined