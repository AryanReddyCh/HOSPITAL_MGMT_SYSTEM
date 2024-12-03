select sum(monthly_premium)as total_premium,avg(final_amount) as average_amount,coverage_type
from {{ ref('int_emp_insurance_billing') }}
group by coverage_type;