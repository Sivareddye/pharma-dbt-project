with patients as (

    select *
    from {{ ref('stg_patients') }}

),

final as (

    select

        md5(coalesce(patient_id, '')) as patient_key,

        patient_id,
        first_name,
        last_name,

        first_name || ' ' || last_name as patient_name,

        date_of_birth,

        floor(
            datediff(
                day,
                date_of_birth,
                current_date()
            ) / 365.25
        ) as patient_age,

        case
            when datediff(year, date_of_birth, current_date()) < 18
                then 'Under 18'
            when datediff(year, date_of_birth, current_date()) between 18 and 35
                then '18-35'
            when datediff(year, date_of_birth, current_date()) between 36 and 50
                then '36-50'
            when datediff(year, date_of_birth, current_date()) between 51 and 65
                then '51-65'
            else '65+'
        end as age_group,

        gender,
        state,
        city,
        zip_code,
        insurance_type,
        enrollment_date,
        patient_status,
        updated_at

    from patients

)

select *
from final