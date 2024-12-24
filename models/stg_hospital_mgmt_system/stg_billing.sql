{{ config(materialized='table') }}

SELECT
    billing_id,
    appointment_id,
    patient_id,
    insurance_id,
    hospital_id,
    billing_date,
    amount,
    discount,
    tax,
    final_amount,
    status,
    payment_method,
    payment_date,
    processed_by,
    remarks
FROM {{ source('raw_data', 'RAW_BILLING') }}
