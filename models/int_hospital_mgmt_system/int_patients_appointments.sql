{{ config(
    materialized='incremental',
    unique_key='surrogate_key'
) }}

WITH PATIENTS_DATA AS (
    SELECT 
        A.patient_id AS p_patient_id, -- Alias added for consistency
        A.first_name,
        A.last_name,
        A.date_of_birth,
        A.gender,
        A.address,
        A.city,
        A.state,
        A.zip_code,
        A.phone_number,
        A.email,
        A.insurance_id,
        A.primary_physician_id,
        A.admission_date,
        A.discharge_date,
        CURRENT_TIMESTAMP AS src_cr_db_ts,
        CURRENT_TIMESTAMP AS src_upd_db_ts
    FROM {{ ref('stg_patients') }} AS A
),
APPOINTMENTS_DATA AS (
    SELECT    
        B.appointment_id,
        B.patient_id,
        B.physician_id,
        B.hospital_id,
        B.appointment_date,
        B.appointment_time,
        B.reason_for_visit,
        B.diagnosis,
        B.treatment_plan,
        B.follow_up_date,
        B.status,
        B.insurance_claim_id,
        B.billing_amount,
        B.copay_amount,
        B.notes,
        CURRENT_TIMESTAMP AS src_cr_db_ts,
        CURRENT_TIMESTAMP AS src_upd_db_ts
    FROM {{ ref('stg_appointments') }} AS B
),
JOINED_DATA AS (
    SELECT 
        CONCAT(MD5(CONCAT(
            C.p_patient_id, '-', D.appointment_id
        )), '-APPOINTMENT') AS surrogate_key,
        C.p_patient_id, -- Correct alias reference
        C.first_name,
        C.last_name,
        C.date_of_birth,
        C.gender,
        C.address,
        C.city,
        C.state,
        C.zip_code,
        C.phone_number,
        C.email,
        C.insurance_id,
        C.primary_physician_id,
        C.admission_date,
        C.discharge_date,
        C.src_cr_db_ts AS patient_cr_db_ts,
        C.src_upd_db_ts AS patient_upd_db_ts,
        D.appointment_id,
        D.patient_id AS a_patient_id,
        D.physician_id,
        D.hospital_id,
        D.appointment_date,
        D.appointment_time,
        D.reason_for_visit,
        D.diagnosis,
        D.treatment_plan,
        D.follow_up_date,
        D.status,
        D.insurance_claim_id,
        D.billing_amount,
        D.copay_amount,
        D.notes,
        D.src_cr_db_ts AS appointment_cr_db_ts,
        D.src_upd_db_ts AS appointment_upd_db_ts
    FROM PATIENTS_DATA C
    LEFT OUTER JOIN APPOINTMENTS_DATA D
    ON C.p_patient_id = D.patient_id -- Correct join condition
),
UPDATED_AND_NEW_DATA AS (
    SELECT
        COALESCE(JD.surrogate_key, MD5(CONCAT(JD.p_patient_id, '-', JD.insurance_id))) AS surrogate_key,
        JD.p_patient_id,
        JD.insurance_id,
        JD.primary_physician_id,
        JD.appointment_id,
        JD.physician_id,
        JD.hospital_id,
        JD.insurance_claim_id,
        JD.first_name AS P_first_name,
        JD.last_name AS P_last_name,
        JD.date_of_birth AS P_date_of_birth,
        JD.gender AS P_gender,
        JD.address AS P_address,
        JD.city AS P_city,
        JD.state AS P_state,
        JD.zip_code AS P_zip_code,
        JD.phone_number AS p_phone_number,
        JD.email AS p_email,
        JD.admission_date,
        JD.discharge_date,
        JD.appointment_date,
        JD.appointment_time,
        JD.reason_for_visit,
        JD.diagnosis,
        JD.treatment_plan,
        JD.follow_up_date,
        JD.status,
        JD.billing_amount,
        JD.copay_amount,
        JD.notes,
        -- Create timestamp logic
        CASE
            WHEN T.surrogate_key IS NULL THEN JD.patient_cr_db_ts  -- New records
            ELSE T.cr_db_ts  -- Retain original create timestamp
        END AS cr_db_ts,
        -- Update timestamp logic
        CASE
            WHEN T.surrogate_key IS NULL THEN JD.patient_upd_db_ts  -- New records
            ELSE CURRENT_TIMESTAMP  -- Updated timestamp for existing records
        END AS upd_db_ts
    FROM JOINED_DATA JD
    LEFT JOIN {{ this }} T
    ON T.surrogate_key = CONCAT(MD5(CONCAT(
        JD.p_patient_id, '-', JD.appointment_id
    )), '-APPOINTMENT')
    WHERE
        T.surrogate_key IS NULL  -- Include new records
        OR (
            JD.patient_upd_db_ts > T.upd_db_ts  -- Updated based on timestamp
            OR JD.first_name != T.P_first_name  -- Changes in demographics
            OR JD.last_name != T.P_last_name
            OR JD.address != T.P_address
            OR JD.email != T.p_email
        )
)

SELECT * FROM UPDATED_AND_NEW_DATA
