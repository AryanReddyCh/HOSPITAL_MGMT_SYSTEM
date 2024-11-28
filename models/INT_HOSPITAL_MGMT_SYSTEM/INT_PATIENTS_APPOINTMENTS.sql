{{ config(
    materialized='incremental', 
    unique_key='surrogate_key' 
) }}

WITH PATIENTS_DATA AS(
SELECT 
A.patient_id,
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
A.discharge_date
FROM
{{ ref('STG_PATIENTS') }} AS A
),
APPOINTMENTS_DATA AS (
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
D.appointment_id,
D.patient_id as a_patient_id,
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
MD5(concat(
    p_patient_id,'-',a_patient_id
)) as surrogate_key,
p_patient_id,
insurance_id,
primary_physician_id,
appointment_id,
physician_id,
hospital_id,
insurance_claim_id,
first_name as P_first_name,
last_name as P_last_name,
date_of_birth as P_date_of_birth,
gender as P_gender,
address as P_address,
city as P_city,
state as P_state,
zip_code as P_zip_code,
phone_number as p_phone_number,
email as p_email,
admission_date,
discharge_date,
appointment_id,
appointment_date,
appointment_time,
reason_for_visit,
diagnosis,
treatment_plan,
follow_up_date,
status,
billing_amount,
copay_amount,
notes
from joined_data

{% if is_incremental() %}
WHERE surrogate_key NOT IN (SELECT surrogate_key FROM {{ this }})  -- Exclude rows already in the table
{% endif %};