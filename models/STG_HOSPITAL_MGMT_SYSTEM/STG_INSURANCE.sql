{{ config(materialized='table') }}

SELECT
insurance_id,
insurance_name,
policy_number,
policy_holder,
coverage_start_date,
coverage_end_date,
monthly_premium,
deductible,
coverage_type,
contact_number,
email,
address,
city,
state,
zip_code,
hospital_id
FROM {{ source('raw_data', 'RAW_INSURANCE') }}
