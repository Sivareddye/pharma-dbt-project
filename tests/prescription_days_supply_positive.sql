select *
from {{ ref('fct_prescriptions') }}

where days_supply <= 0