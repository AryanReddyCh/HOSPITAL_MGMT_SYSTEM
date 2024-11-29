{{ config(materialized='view') }}
select * from 
{{ ref('INT_EMP_INSURANCE_BILLING') }} ;