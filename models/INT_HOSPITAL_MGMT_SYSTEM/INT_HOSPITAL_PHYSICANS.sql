{{ config(materialized='table') }}

with hospital_data as (
select 
    hospital_id,
    hospital_name,
    address,
    city,
    state,
    zip_code,
    phone_number,
    email,
    established_year,
    num_beds,num_departments,
    director_name,
    emergency_contact,
    rating,
    accreditation
    from {{ref('STG_HOSPITAL')}}
),
physicians_data as (
select 
    physician_id,
    first_name,
    last_name,
    specialty,
    phone_number,
    email,
    department,
    years_of_experience,
    license_number,
    clinic_address,
    city,
    state,
    zip_code,
    hospital_id,
    shift_timing
    from {{ref('STG_PHYSICIANS')}}
),
joined_data as(
    select 
    a.hospital_id,
    a.hospital_name,
    a.address,
    a.city,
    a.state,
    a.zip_code,
    a.phone_number,
    a.email,
    a.established_year,
    a.num_beds,num_departments,
    a.director_name,
    a.emergency_contact,
    a.rating,
    a.accreditation
    b.physician_id,
    b.first_name,
    b.last_name,
    b.specialty,
    b.phone_number,
    b.email,
    b.department,
    b.years_of_experience,
    b.license_number,
    b.clinic_address,
    b.city,
    b.state,
    b.zip_code,
    b.hospital_id,
    b.shift_timing
    from hospital_data a
    left outer join
    physicians_data b
    on a.hospital_id = b.hospital_id
)

    select 
    row_number() over(order by hospital_id,physician_id)
    hospital_id,
    physician_id,
    hospital_name,
    address,
    city,
    state,
    zip_code,
    phone_number,
    email,
    established_year,
    num_beds,num_departments,
    director_name,
    emergency_contact,
    rating,
    accreditation,
    concat(first_name,' ',last_name) as P_FULL_NAME,
    specialty,
    phone_number,
    email,
    department,
    years_of_experience,
    license_number,
    clinic_address,
    city,
    state,
    zip_code,
    hospital_id,
    shift_timing,
    current_timestamp as cr_db_ts,
    current_timestamp as upd_db_ts
    from joined_data