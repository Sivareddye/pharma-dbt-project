with claims as (

    select *
    from {{ ref('fct_claims') }}

),

products as (

    select *
    from {{ ref('dim_product') }}

),

aggregated as (

    select
        product_id,

        count(*) as total_claims,

        count_if(claim_status = 'APPROVED')
            as approved_claims,

        count_if(claim_status = 'REJECTED')
            as rejected_claims,

        sum(claim_amount)
            as total_claim_amount,

        sum(insurance_paid)
            as total_insurance_paid,

        sum(patient_copay)
            as total_patient_copay,

        avg(patient_copay)
            as average_patient_copay

    from claims

    group by product_id

)

select
    p.product_id,
    p.product_name,
    p.therapeutic_area,

    a.total_claims,
    a.approved_claims,
    a.rejected_claims,

    round(
        a.approved_claims * 100.0 /
        nullif(a.total_claims, 0),
        2
    ) as approval_rate_pct,

    round(
        a.rejected_claims * 100.0 /
        nullif(a.total_claims, 0),
        2
    ) as rejection_rate_pct,

    a.total_claim_amount,
    a.total_insurance_paid,
    a.total_patient_copay,
    round(a.average_patient_copay, 2)
        as average_patient_copay

from aggregated a

left join products p
    on a.product_id = p.product_id