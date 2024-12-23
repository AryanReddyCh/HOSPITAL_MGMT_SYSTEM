{% macro column_product(any_value,column_name,table_name,any_value1) %}
CASE 
        WHEN '{{ any_value }}' IN (SELECT {{column_name}} FROM {{table_name}}) THEN '{{ any_value1 }}'
        ELSE NULL
    END
{% endmacro %}