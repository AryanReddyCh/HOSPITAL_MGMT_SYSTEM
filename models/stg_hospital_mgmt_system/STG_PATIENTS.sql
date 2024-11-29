{{ config(materialized='table') }}

SELECT
patient_id,
first_name,
last_name,
date_of_birth,
gender,
address,
city,
state,
zip_code,
phone_number,
email,
insurance_id,
primary_physician_id,
admission_date,
discharge_date
FROM {{ source('raw_data', 'RAW_PATIENTS') }}
