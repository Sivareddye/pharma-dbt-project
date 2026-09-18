with source as (

    select *
    from {{ source('pharma_raw', 'raw_claims') }}

),

renamed as (

    select
        claim_id,
        prescription_id,
        patient_id,
        product_id,
        claim_date,
        claim_amount,
        insurance_paid,
        patient_copay,
        upper(claim_status) as claim_status,
        rejection_reason,
        updated_at

    from source

)

select *
from renamed