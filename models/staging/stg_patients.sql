with source as (

    select *
    from {{ source('pharma_raw', 'raw_patients') }}

),

renamed as (

    select
        patient_id,
        first_name,
        last_name,
        date_of_birth,
        gender,
        state,
        city,
        zip_code,
        insurance_type,
        enrollment_date,
        patient_status,
        updated_at
    from source

)

select *
from renamed