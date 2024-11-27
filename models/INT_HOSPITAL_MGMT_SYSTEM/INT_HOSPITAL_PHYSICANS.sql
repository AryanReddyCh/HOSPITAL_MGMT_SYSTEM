{{ config(materialized='table') }}

WITH hospital_data AS (
    SELECT 
        a.hospital_id,
        a.hospital_name,
        a.address,
        a.city,
        a.state,
        a.zip_code,
        a.phone_number,
        a.email,
        a.established_year,
        a.num_beds,
        a.num_departments,
        a.director_name,
        a.emergency_contact,
        a.rating,
        a.accreditation
    FROM {{ ref('STG_HOSPITAL') }} AS a
),
physicians_data AS (
    SELECT 
        b.physician_id,
        b.first_name,
        b.last_name,
        b.specialty,
        b.phone_number,
        b.email,
        b.department,
        b.years_of_experience,
        b.license_number,
        b.clinic_address,
        b.city,
        b.state,
        b.zip_code,
        b.hospital_id,
        b.shift_timing
    FROM {{ ref('STG_PHYSICIANS') }} AS b
),
joined_data AS (
    SELECT 
        c.hospital_id AS h_hospital_id,  -- Alias to clarify source
        c.hospital_name,
        c.address,
        c.city AS hospital_city,
        c.state AS hospital_state,
        c.zip_code AS hospital_zip_code,
        c.phone_number AS hospital_phone_number,
        c.email AS hospital_email,
        c.established_year,
        c.num_beds,
        c.num_departments,
        c.director_name,
        c.emergency_contact,
        c.rating,
        c.accreditation,
        d.physician_id,
        d.first_name,
        d.last_name,
        d.specialty,
        d.phone_number AS physician_phone_number,
        d.email AS physician_email,
        d.department,
        d.years_of_experience,
        d.license_number,
        d.clinic_address,
        d.city AS physician_city,
        d.state AS physician_state,
        d.zip_code AS physician_zip_code,
        d.hospital_id AS physician_hospital_id,  -- Alias to clarify source
        d.shift_timing
    FROM hospital_data c
    LEFT OUTER JOIN physicians_data d
        ON c.hospital_id = d.hospital_id
)

SELECT 
    ROW_NUMBER() OVER (ORDER BY h_hospital_id, physician_hospital_id) AS surrogate_key,
    h_hospital_id,               
    physician_id,
    hospital_name,
    address,
    hospital_city,
    hospital_state,
    hospital_zip_code,
    hospital_phone_number,
    hospital_email,
    established_year,
    num_beds,
    num_departments,
    director_name,
    emergency_contact,
    rating,
    accreditation,
    CONCAT(first_name, ' ', last_name) AS P_FULL_NAME,
    specialty,
    physician_phone_number AS phone_number,
    physician_email,
    department,
    years_of_experience,
    license_number,
    clinic_address,
    physician_city,
    physician_state,
    physician_zip_code,
    shift_timing,
    CURRENT_TIMESTAMP AS cr_db_ts,
    CURRENT_TIMESTAMP AS upd_db_ts
FROM joined_data
