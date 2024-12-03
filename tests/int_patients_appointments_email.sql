select * FROM
{{ ref('int_patients_appointments') }}
where P_EMAIL not like '%@%';