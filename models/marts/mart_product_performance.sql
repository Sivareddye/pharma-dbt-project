with products as (

    select *
    from {{ ref('dim_product') }}

),

prescriptions as (

    select
        product_id,

        count(*) as total_prescriptions,

        count_if(prescription_type = 'NEW')
            as new_prescriptions,

        count_if(prescription_type = 'REFILL')
            as refill_prescriptions,

        count(distinct patient_id)
            as unique_patients,

        sum(quantity)
            as total_prescribed_quantity

    from {{ ref('fct_prescriptions') }}

    group by product_id

),

claims as (

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
            as insurance_paid,

        sum(patient_copay)
            as patient_copay

    from {{ ref('fct_claims') }}

    group by product_id

),

sales as (

    select
        product_id,

        sum(quantity_sold)
            as quantity_sold,

        sum(gross_sales_amount)
            as gross_sales,

        sum(discount_amount)
            as discount_amount,

        sum(net_sales_amount)
            as net_sales

    from {{ ref('fct_sales') }}

    group by product_id

),

final as (

    select
        p.product_id,
        p.product_name,
        p.brand_name,
        p.generic_name,
        p.therapeutic_area,
        p.manufacturer,
        p.list_price,

        coalesce(rx.total_prescriptions, 0)
            as total_prescriptions,

        coalesce(rx.new_prescriptions, 0)
            as new_prescriptions,

        coalesce(rx.refill_prescriptions, 0)
            as refill_prescriptions,

        coalesce(rx.unique_patients, 0)
            as unique_patients,

        coalesce(c.total_claims, 0)
            as total_claims,

        coalesce(c.approved_claims, 0)
            as approved_claims,

        coalesce(c.rejected_claims, 0)
            as rejected_claims,

        case
            when coalesce(c.total_claims, 0) = 0 then 0
            else round(
                c.approved_claims * 100.0 /
                c.total_claims,
                2
            )
        end as claim_approval_rate_pct,

        coalesce(s.quantity_sold, 0)
            as quantity_sold,

        coalesce(s.gross_sales, 0)
            as gross_sales,

        coalesce(s.discount_amount, 0)
            as discount_amount,

        coalesce(s.net_sales, 0)
            as net_sales

    from products p

    left join prescriptions rx
        on p.product_id = rx.product_id

    left join claims c
        on p.product_id = c.product_id

    left join sales s
        on p.product_id = s.product_id

)

select *
from final