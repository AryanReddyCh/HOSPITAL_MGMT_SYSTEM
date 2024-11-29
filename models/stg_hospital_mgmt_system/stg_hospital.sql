{{ config(materialized='table') }}

SELECT
    hospital_id,
    hospital_name,
    address,
    city,
    state,
    zip_code,
    phone_number,
    email,
    established_year,
    num_beds,num_departments,
    director_name,
    emergency_contact,
    rating,
    accreditation
FROM {{ source('raw_data', 'RAW_HOSPITAL') }}
