{{ config(materialized='table') }}

SELECT
    appointment_id,
    patient_id,
    physician_id,
    hospital_id,
    appointment_date,
    reason_for_visit,
    diagnosis,
    treatment_plan,
    follow_up_date,
    status
FROM {{ source('raw_data', 'RAW_APPOINTMENTS') }}
