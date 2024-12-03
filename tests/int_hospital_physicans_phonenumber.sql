-- Custom test for validating phone number lengths
SELECT *
FROM {{ ref('int_hospital_physicians') }}
WHERE
    LENGTH(HOSPITAL_PHONE_NUMBER) != 10 OR
    LENGTH(EMERGENCY_CONTACT) != 10 OR
    LENGTH(PHONE_NUMBER) != 10;
