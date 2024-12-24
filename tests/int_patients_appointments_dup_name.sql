select P_FIRST_NAME,count(*) FROM
{{ ref('int_patients_appointments') }}
group by 1 having count(P_FIRST_NAME)>1;