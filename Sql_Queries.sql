use health_care;
-- Beginner Level

-- List all patients from a specific city.
Select patient_id , name, city 
from Healthcare_dataset
where city ="San Diego" ;

-- Count the number of male and female patients.
select gender ,count(patient_id) as no_of_patients
from Healthcare_dataset
group by gender;

-- Find all appointments scheduled after '2024-06-01'.
select appointment_id,patient_id,doctor_id,appointment_date
from appoinment
where appointment_date > '2024-06-01' and status ="Scheduled"
order by appointment_id;

-- Retrieve the names of doctors with more than 10 years of experience.
select doctor_id, name, specialization, department,experience
from doctors
where experience >10;

-- Show the total number of appointments for each patient.
select patient_id,count(patient_id) as no_of_appoinment
from appoinment
group by patient_id
order by patient_id;

-- Intermediate Level

-- Show the number of completed vs cancelled appointments.
select status,count(patient_id) as no_of_appoinment
from appoinment
where status="Cancelled" or status="Completed"
group by status
;

-- Find the total billing amount per patient.
select hd.patient_id,hd.name,coalesce(sum(b.amount),0) as total_amount
from healthcare_dataset as hd
left join billing as b
on hd.patient_id = b.patient_id
group by patient_id ;

-- List doctors and how many patients they have treated.
select d.doctor_id,d.namen as doctor_name,coalesce(sum(a.doctor_id),0) as total_treated
from doctors as d
left join appoinment as a
on d.doctor_id = a.doctor_id
where a.status ="Completed"
group by doctor_id;

-- Get a list of medicines prescribed by each doctor.
SELECT 
    d.doctor_id,
    d.name AS doctor_name,
    GROUP_CONCAT(DISTINCT p.medicine ORDER BY p.medicine SEPARATOR ', ') AS medicines_prescribed
    -- Combine all unique medicine names prescribed by this doctor, sort them alphabetically, and separate them using a comma and space.
FROM 
    doctors d
LEFT JOIN 
    prescription p ON d.doctor_id = p.doctor_id
GROUP BY 
    d.doctor_id, d.name;


-- List patients who have never had an appointment.
select hd.patient_id,hd.name as patient_name
from healthcare_dataset hd
left join appoinment a
on hd.patient_id = a.patient_id
where a.appointment_id is null;


--  Advanced Level
-- Find the top 3 doctors who have issued the most prescriptions.
select p.doctor_id,d.name as doctor_name,count(p.doctor_id) as most_presciption
from doctors d
left join prescription p
on d.doctor_id= p.doctor_id
group by name , doctor_id
order by  most_presciption  desc  
limit 3;

-- Show the average billing amount for patients by city.
-- Rounds the result of AVG(...) to 2 digits after the decimal

select p.city,round(avg(b.amount),2) as Average_Amount
from healthcare_dataset p
left join billing b
on p.patient_id = b.patient_id
group by city
order by Average_Amount desc;

-- Retrieve patients who have had appointments but no billing records.
select h.patient_id,h.name as patient_name
from appoinment a
join healthcare_dataset as h on a.patient_id = h.patient_id
left join billing b
on a.patient_id = b.patient_id
where b.amount is null ;

-- Create a report showing the number of appointments, prescriptions, and total billing per patient.
SELECT 
    p.patient_id,
    p.name,
    COUNT(DISTINCT a.appointment_id) AS total_appointments,
    COUNT(DISTINCT pr.prescription_id) AS total_prescriptions,
    COALESCE(SUM(b.amount), 0) AS total_billing
FROM 
    healthcare_dataset p
LEFT JOIN 
    appoinment a ON p.patient_id = a.patient_id
LEFT JOIN 
    prescription pr ON p.patient_id = pr.patient_id
LEFT JOIN 
    billing b ON p.patient_id = b.patient_id
GROUP BY 
    p.patient_id, p.name
ORDER BY 
    total_billing DESC;


-- Find the month with the highest number of appointments and calculate the revenue for that month.
select 
	month(a.appointment_date) as appoinment_month_number,
    monthname(a.appointment_date) as appoinment_month,
    year(a.appointment_date) as appoinment_year,
    count( distinct a.patient_id) as total_appoinments,
    coalesce(sum(b.amount),0) as total_revenue
from appoinment as a 
left join billing as b on a.patient_id = b.patient_id
group by appoinment_month_number , appoinment_month,appoinment_year
order by total_appoinments desc
;