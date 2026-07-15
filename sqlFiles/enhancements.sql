-- INDEXES
-- Targeted at the actual query patterns in queries.sql

-- Speeds up "appointments for doctor X on date Y" lookups
CREATE INDEX IF NOT EXISTS idx_appointment_doctor_date
    ON Appointment(doctor_email, appointment_date);

-- Speeds up "appointments for patient X" lookups
CREATE INDEX IF NOT EXISTS idx_appointment_patient
    ON Appointment(patient_email);

-- Speeds up status-filtered queries (Scheduled/Completed/Cancelled)
CREATE INDEX IF NOT EXISTS idx_appointment_status
    ON Appointment(status);

-- Speeds up "all history for patient X" (feeds Condition/Surgery/Medication joins)
CREATE INDEX IF NOT EXISTS idx_medicalhistory_patient
    ON MedicalHistory(patient_email);

-- Speeds up "doctor's weekly schedule" lookups
CREATE INDEX IF NOT EXISTS idx_schedule_doctor
    ON Schedule(doctor_email);


-- AUDIT COLUMNS (needed for the updated_at trigger below)

ALTER TABLE Patient        ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE Doctor         ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE Appointment    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE MedicalHistory ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;


-- TRIGGER: auto-update updated_at on any row change

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_patient_updated_at ON Patient;
CREATE TRIGGER trg_patient_updated_at
    BEFORE UPDATE ON Patient
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_doctor_updated_at ON Doctor;
CREATE TRIGGER trg_doctor_updated_at
    BEFORE UPDATE ON Doctor
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_appointment_updated_at ON Appointment;
CREATE TRIGGER trg_appointment_updated_at
    BEFORE UPDATE ON Appointment
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_medicalhistory_updated_at ON MedicalHistory;
CREATE TRIGGER trg_medicalhistory_updated_at
    BEFORE UPDATE ON MedicalHistory
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- TRIGGER: prevent double-booking a doctor
-- Blocks INSERT/UPDATE if the new appointment's time range
-- overlaps an existing non-cancelled appointment for the
-- same doctor on the same date.

CREATE OR REPLACE FUNCTION prevent_appointment_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Appointment a
        WHERE a.doctor_email = NEW.doctor_email
          AND a.appointment_date = NEW.appointment_date
          AND a.status <> 'Cancelled'
          AND a.id IS DISTINCT FROM NEW.id
          AND NEW.start_time < a.end_time
          AND NEW.end_time   > a.start_time
    ) THEN
        RAISE EXCEPTION
            'Doctor % already has an overlapping appointment on % between % and %',
            NEW.doctor_email, NEW.appointment_date, NEW.start_time, NEW.end_time;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_prevent_appointment_overlap ON Appointment;
CREATE TRIGGER trg_prevent_appointment_overlap
    BEFORE INSERT OR UPDATE ON Appointment
    FOR EACH ROW EXECUTE FUNCTION prevent_appointment_overlap();


-- TRIGGER: enforce appointments fall within the doctor's
-- working hours and outside their break window (Schedule table).

CREATE OR REPLACE FUNCTION validate_appointment_within_schedule()
RETURNS TRIGGER AS $$
DECLARE
    appointment_day VARCHAR(10);
BEGIN
    -- Map the appointment_date to a day name matching Schedule.day_of_week
    appointment_day := TRIM(TO_CHAR(NEW.appointment_date, 'FMDay'));

    IF NOT EXISTS (
        SELECT 1
        FROM Schedule s
        WHERE s.doctor_email = NEW.doctor_email
          AND s.day_of_week = appointment_day
          AND NEW.start_time >= s.start_time
          AND NEW.end_time   <= s.end_time
          AND (
                s.break_start IS NULL
                OR s.break_end IS NULL
                OR NOT (NEW.start_time < s.break_end AND NEW.end_time > s.break_start)
              )
    ) THEN
        RAISE EXCEPTION
            'Doctor % is not scheduled to work % between % and % (or it falls in their break)',
            NEW.doctor_email, appointment_day, NEW.start_time, NEW.end_time;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validate_appointment_within_schedule ON Appointment;
CREATE TRIGGER trg_validate_appointment_within_schedule
    BEFORE INSERT OR UPDATE ON Appointment
    FOR EACH ROW EXECUTE FUNCTION validate_appointment_within_schedule();


-- VIEWS

-- Doctor workload: appointment count + specialization per doctor
CREATE OR REPLACE VIEW doctor_workload AS
SELECT
    d.email            AS doctor_email,
    d.name             AS doctor_name,
    d.specialization,
    COUNT(a.id)        AS total_appointments,
    COUNT(a.id) FILTER (WHERE a.status = 'Completed')  AS completed_appointments,
    COUNT(a.id) FILTER (WHERE a.status = 'Cancelled')  AS cancelled_appointments
FROM Doctor d
LEFT JOIN Appointment a ON d.email = a.doctor_email
GROUP BY d.email, d.name, d.specialization
ORDER BY total_appointments DESC;

-- Upcoming scheduled appointments with patient/doctor names
CREATE OR REPLACE VIEW upcoming_appointments AS
SELECT
    a.id               AS appointment_id,
    p.name             AS patient_name,
    p.email            AS patient_email,
    d.name             AS doctor_name,
    d.specialization,
    a.appointment_date,
    a.start_time,
    a.end_time
FROM Appointment a
JOIN Patient p ON a.patient_email = p.email
JOIN Doctor  d ON a.doctor_email  = d.email
WHERE a.status = 'Scheduled'
ORDER BY a.appointment_date, a.start_time;

-- Per-patient medical summary: conditions, surgeries, and
-- medications rolled up across all of their history records
CREATE OR REPLACE VIEW patient_medical_summary AS
SELECT
    p.email AS patient_email,
    p.name  AS patient_name,
    (SELECT STRING_AGG(DISTINCT mc.condition_name, ', ')
       FROM MedicalHistory mh
       JOIN MedicalCondition mc ON mc.history_id = mh.id
      WHERE mh.patient_email = p.email)                    AS conditions,
    (SELECT STRING_AGG(DISTINCT s.surgery_name, ', ')
       FROM MedicalHistory mh
       JOIN Surgery s ON s.history_id = mh.id
      WHERE mh.patient_email = p.email)                    AS surgeries,
    (SELECT STRING_AGG(DISTINCT m.medicine_name, ', ')
       FROM MedicalHistory mh
       JOIN Medication m ON m.history_id = mh.id
      WHERE mh.patient_email = p.email)                    AS medications
FROM Patient p;