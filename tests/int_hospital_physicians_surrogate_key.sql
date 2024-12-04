-- Custom test for null values in critical columns
SELECT *
FROM {{ ref('int_hospital_physicians') }}
WHERE 
    SURROGATE_KEY IS NULL OR
    H_HOSPITAL_ID IS NULL OR
    PHYSICIAN_HOSPITAL_ID IS NULL OR
    PHYSICIAN_ID IS NULL OR
    HOSPITAL_NAME IS NULL;
