with expected_count as (
select count(*) as stg_count
from {{ ref('stg_insurance') }} as i
left outer JOIN
{{ ref('stg_billing') }} as b
ON i.insurance_id = b.billing_insurance_id
),

actual_count as (
select count(*) as int_count
from {{ ref('int_emp_insurance_billing') }}
)

select * from expected_count,actual_count
where stg_count < int_count;