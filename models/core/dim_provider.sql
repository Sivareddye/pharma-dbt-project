with providers as (

    select *
    from {{ ref('stg_providers') }}

)

select

    md5(coalesce(provider_id, '')) as provider_key,

    provider_id,
    npi_number,
    provider_name,
    specialty,
    hospital_name,
    city,
    state,
    territory_id,
    provider_status,
    created_date,
    updated_at

from providers