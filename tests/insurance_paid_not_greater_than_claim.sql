select *
from {{ ref('fct_claims') }}

where insurance_paid > claim_amount