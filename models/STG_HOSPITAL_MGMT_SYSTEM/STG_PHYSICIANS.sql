{{ config(materialized='table') }}

physician_id,
first_name,
last_name,
specialty,
phone_number,
email,
department,
years_of_experience,
license_number,
clinic_address,
city,
state,
zip_code,
hospital_id,
shift_timing
FROM {{ source('raw_data', 'RAW_PHYSICIANS') }}
