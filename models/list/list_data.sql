{{ config(materialized='view') }}

with string1 as (
select {{ code1_list('code') }} as code_list from {{ ref('lists') }}
)
select code_list,
{{column_product('cd','code',ref('lists'),'code1' )}} as column_porduct
from
string1
