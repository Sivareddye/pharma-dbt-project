with source as (

    select *
    from {{ source('pharma_raw', 'raw_providers') }}

),

renamed as (

    select
        provider_id,
        npi_number,
        trim(provider_name) as provider_name,
        trim(specialty) as specialty,
        trim(hospital_name) as hospital_name,
        trim(city) as city,
        upper(state) as state,
        territory_id,
        upper(provider_status) as provider_status,
        created_date,
        updated_at

    from source

)

select *
from renamed