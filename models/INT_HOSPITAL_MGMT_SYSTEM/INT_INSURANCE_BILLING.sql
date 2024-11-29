    {{ config(materialized='view') }}
    SELECT 
    a.surrogate_key,
    a.insurance_id,
    a.insurance_name,
    a.policy_number,
    a.policy_holder,
    a.coverage_start_date,
    a.coverage_end_date,
    a.monthly_premium,
    b.hospital_id,
    b.hospital_name
    FROM {{ ref('INT_EMP_INSURANCE_BILLING') }}  a
    left outer join
    {{ ref('INT_HOSPITAL_PHYSICANS') }} b
    on a.insurance_id=b.insurance_id;