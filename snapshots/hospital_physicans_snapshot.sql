/*{% snapshot int_hospital_physicans %}

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
   {{ ref('int_hospital_physicans') }}
   -- {{ source('int', 'int_hospital_physicans') }}

{% endsnapshot %}