with prescriptions as (

    select *
    from {{ ref('fct_prescriptions') }}

    where prescription_status = 'FILLED'

),

aggregated as (

    select
        patient_id,
        product_id,

        min(prescription_date)
            as first_fill_date,

        max(prescription_date)
            as latest_fill_date,

        count(*)
            as total_fills,

        sum(days_supply)
            as total_days_supply,

        max(refill_number)
            as max_refill_number

    from prescriptions

    group by
        patient_id,
        product_id

),

final as (

    select
        patient_id,
        product_id,
        first_fill_date,
        latest_fill_date,
        total_fills,
        total_days_supply,
        max_refill_number,

        datediff(
            day,
            first_fill_date,
            latest_fill_date
        ) + 30 as observation_days,

        least(
            1,
            total_days_supply /
            nullif(
                datediff(
                    day,
                    first_fill_date,
                    latest_fill_date
                ) + 30,
                0
            )
        ) as medication_possession_ratio

    from aggregated

)

select *
from final