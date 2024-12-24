{{ config(materialized='view') }}

select
SURROGATE_KEY,
H_HOSPITAL_ID,
PHYSICIAN_HOSPITAL_ID,
PHYSICIAN_ID,
HOSPITAL_NAME,
ADDRESS,
HOSPITAL_PHONE_NUMBER,
HOSPITAL_EMAIL,
NUM_BEDS,
NUM_DEPARTMENTS,
EMERGENCY_CONTACT,
P_FULL_NAME,
SPECIALTY,
PHONE_NUMBER,
PHYSICIAN_EMAIL,
DEPARTMENT,
YEARS_OF_EXPERIENCE,
LICENSE_NUMBER,
CLINIC_ADDRESS,
PHYSICIAN_CITY,
PHYSICIAN_STATE,
PHYSICIAN_ZIP_CODE,
SHIFT_TIMING
from
{{ ref('int_hospital_physicians') }}