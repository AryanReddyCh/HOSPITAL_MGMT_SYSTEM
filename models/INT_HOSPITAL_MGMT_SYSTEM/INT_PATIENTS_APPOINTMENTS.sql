{{ config(
    materialized='incremental', 
    unique_key='surrogate_key' 
) }}

WITH PATIENTS_DATA AS (
    SELECT 
        A.patient_id,
        A.first_name,
        A.last_name,
        A.date_of_birth,
        A.gender,
        A.address AS patient_address,
        A.city AS patient_city,
        A.state AS patient_state,
        A.zip_code AS patient_zip_code,
        A.phone_number AS patient_phone_number,
        A.email AS patient_email,
        A.insurance_id,
        A.primary_physician_id,
        A.admission_date,
        A.discharge_date
    FROM
    {{ ref('STG_PATIENTS') }} AS A
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
        B.notes
    FROM
    {{ ref('STG_APPOINTMENTS') }} AS B
),
JOINED_DATA AS (
    SELECT 
        C.patient_id AS p_patient_id,
        C.first_name,
        C.last_name,
        C.date_of_birth,
        C.gender,
        C.patient_address,
        C.patient_city,
        C.patient_state,
        C.patient_zip_code,
        C.patient_phone_number,
        C.patient_email,
        C.insurance_id,
        C.primary_physician_id,
        C.admission_date,
        C.discharge_date,
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
        D.notes
    FROM PATIENTS_DATA C
    LEFT OUTER JOIN
    APPOINTMENTS_DATA D
    ON C.patient_id = D.patient_id
)

SELECT
    CONCAT(MD5(CONCAT(
        JD.p_patient_id, '-', JD.appointment_id
    )), '-APPOINTMENT') AS surrogate_key,
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
    JD.patient_address AS P_address,
    JD.patient_city AS P_city,
    JD.patient_state AS P_state,
    JD.patient_zip_code AS P_zip_code,
    JD.patient_phone_number AS P_phone_number,
    JD.patient_email AS P_email,
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
    CURRENT_TIMESTAMP AS cr_db_ts,
    CURRENT_TIMESTAMP AS upd_db_ts,
    CASE
        WHEN T.surrogate_key IS NULL THEN 'new'
        WHEN T.surrogate_key IS NOT NULL AND (
            T.P_first_name != JD.first_name OR
            T.P_last_name != JD.last_name OR
            T.P_address != JD.patient_address OR
            T.P_email != JD.patient_email
        ) THEN 'updated'
        ELSE NULL
    END AS record_status
FROM JOINED_DATA JD
LEFT JOIN {{ this }} T
ON T.surrogate_key = CONCAT(MD5(CONCAT(
    JD.p_patient_id, '-', JD.appointment_id
)), '-APPOINTMENT')

WHERE record_status IS NOT NULL
