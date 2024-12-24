{% macro code1_list(column_name) %}
 LISTAGG({{ column_name }},',')
{% endmacro %}