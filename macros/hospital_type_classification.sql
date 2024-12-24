{% macro hospital_type_classification() %}
    CASE 
        WHEN rating < 3.5 OR num_beds < 150 THEN 'basic hospital'
        ELSE 'critical care hospital'
    END
{% endmacro %}
