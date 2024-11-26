{{ config(materialized='table') }}

SELECT
appointment_id,
patient_id,
physician_id,
hospital_id,
appointment_date,
appointment_time,
reason_for_visit,
diagnosis,
treatment_plan,
follow_up_date,
status,
insurance_claim_id,
billing_amount,
copay_amount,
notes
FROM {{ source('raw_data', 'RAW_APPOINTMENTS') }}
