select *
from {{ ref('fct_sales') }}

where net_sales_amount < 0