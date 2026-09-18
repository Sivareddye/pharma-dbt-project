with source as (

    select *
    from {{ source('pharma_raw', 'raw_prescriptions') }}

),

renamed as (

    select
        prescription_id,
        patient_id,
        provider_id,
        product_id,
        prescription_date,
        quantity,
        days_supply,
        refill_number,
        upper(prescription_status) as prescription_status,
        updated_at

    from source

)

select *
from renamed