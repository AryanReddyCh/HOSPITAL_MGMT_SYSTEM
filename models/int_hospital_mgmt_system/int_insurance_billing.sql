    {{ config(materialized='view') }}
    SELECT a.*
    FROM {{ ref('int_emp_insurance_billing') }}  as a
    inner join
    {{ ref('int_patients_appointments') }} as b
    on a.insurance_id=b.insurance_id