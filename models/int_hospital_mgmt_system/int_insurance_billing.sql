    {{ config(materialized='view') }}
    SELECT 
    a.surrogate_key,
    a.insurance_id,
    a.insurance_name,
    a.policy_number,
    a.policy_holder,
    a.coverage_start_date,
    a.coverage_end_date,
    a.monthly_premium
    FROM {{ ref('int_emp_insurance_billing') }}  a
    left outer join
    {{ ref('int_hospital_physicans') }} b
    on a.insurance_id=b.insurance_id