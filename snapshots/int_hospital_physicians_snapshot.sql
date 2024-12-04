/*{% snapshot int_hospital_physicians %}

{{
    config(
        target_schema='snapshot',        
        target_database='SNOWFLAKE_DBT', 
        unique_key='surrogate_key',      
        strategy='check',                
        check_cols='all'                 
    )
}}

SELECT 
    *
FROM 
    {{ source('dbt_dvakkalagadda_int', 'int_hospital_physicans') }}

{% endsnapshot %}
*/