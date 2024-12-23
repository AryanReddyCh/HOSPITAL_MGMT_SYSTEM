{% snapshot int_hospital_physicians %}

{{
    config(
        target_schema='snapshot',         
        target_database='SNOWFLAKE_DBT', 
        unique_key='surrogate_key',      
        strategy='check',                
        check_cols=['SURROGATE_KEY','H_HOSPITAL_ID','HOSPITAL_NAME','ADDRESS','HOSPITAL_CITY']                 
    )
}}

SELECT 
    *
FROM 
    {{ source('dbt_dvakkalagadda_int', 'int_hospital_physicians') }}

{% endsnapshot %}
