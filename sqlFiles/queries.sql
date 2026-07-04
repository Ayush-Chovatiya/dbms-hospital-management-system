-- 1. List all upcoming scheduled appointments with patient and doctor names.
SELECT
    p.name AS patient_name,
    d.name AS doctor_name,
    a.appointment_date,
    a.start_time,
    a.end_time
FROM Appointment a
JOIN Patient p ON a.patient_email = p.email
JOIN Doctor d ON a.doctor_email = d.email
WHERE a.status = 'Scheduled'
ORDER BY a.appointment_date, a.start_time;

-- 2. Find all doctors and the number of appointments they have.
SELECT
    d.name AS doctor_name,
    d.specialization,
    COUNT(a.patient_email) AS total_appointments
FROM Doctor d
LEFT JOIN Appointment a
ON d.email = a.doctor_email
GROUP BY d.email, d.name, d.specialization
ORDER BY total_appointments DESC;

-- 3. Find patients who have completed appointments along with their diagnosis.
SELECT
    p.name,
    a.appointment_date,
    d.name AS doctor,
    a.diagnosis
FROM Appointment a
JOIN Patient p ON a.patient_email = p.email
JOIN Doctor d ON a.doctor_email = d.email
WHERE a.status = 'Completed';

-- 4. List every patient's medical conditions.
SELECT
    p.name,
    mc.condition_name
FROM Patient p
JOIN MedicalHistory mh
ON p.email = mh.patient_email
JOIN MedicalCondition mc
ON mh.id = mc.history_id
ORDER BY p.name;

-- 5. Find doctors who have no cancelled appointments.
SELECT
    d.name
FROM Doctor d
WHERE d.email NOT IN (
    SELECT doctor_email
    FROM Appointment
    WHERE status = 'Cancelled'
);

-- 6. Find the patient(s) taking the maximum number of medications.
SELECT
    p.name,
    COUNT(m.medicine_name) AS medicine_count
FROM Patient p
JOIN MedicalHistory mh
ON p.email = mh.patient_email
JOIN Medication m
ON mh.id = m.history_id
GROUP BY p.email, p.name
HAVING COUNT(m.medicine_name) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM Medication
        GROUP BY history_id
    ) t
);

-- 7. Show each doctor's working schedule.
SELECT
    p.name,
    s.surgery_name,
    s.surgery_date
FROM Patient p
JOIN MedicalHistory mh
ON p.email = mh.patient_email
JOIN Surgery s
ON mh.id = s.history_id
ORDER BY s.surgery_date DESC;

-- 8. Find patients who have undergone surgery.
SELECT
    p.name,
    s.surgery_name,
    s.surgery_date
FROM Patient p
JOIN MedicalHistory mh
ON p.email = mh.patient_email
JOIN Surgery s
ON mh.id = s.history_id
ORDER BY s.surgery_date DESC;

-- 9. Count appointments by status.
SELECT
    status,
    COUNT(*) AS total
FROM Appointment
GROUP BY status;

-- 10. Find doctors who have treated more than one patient.
SELECT
    d.name,
    COUNT(DISTINCT a.patient_email) AS patients_treated
FROM Doctor d
JOIN Appointment a
ON d.email = a.doctor_email
GROUP BY d.email, d.name
HAVING COUNT(DISTINCT a.patient_email) > 1;