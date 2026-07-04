-- HOSPITAL MANAGEMENT SYSTEM

-- PATIENT
CREATE TABLE Patient (
    email VARCHAR(100) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) NOT NULL
        CHECK (gender IN ('Male', 'Female', 'Other')),
    address TEXT NOT NULL,
    phone VARCHAR(15) UNIQUE
);

-- DOCTOR
CREATE TABLE Doctor (
    email VARCHAR(100) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) NOT NULL
        CHECK (gender IN ('Male', 'Female', 'Other')),
    specialization VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE
);

-- DOCTOR SCHEDULE
-- One doctor -> many schedule entries
CREATE TABLE Schedule (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    doctor_email VARCHAR(100) NOT NULL,
    day_of_week VARCHAR(10) NOT NULL
        CHECK (day_of_week IN
        ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    break_start TIME,
    break_end TIME,

    FOREIGN KEY (doctor_email)
        REFERENCES Doctor(email)
        ON DELETE CASCADE,

    CHECK (start_time < end_time)
);

-- APPOINTMENT
-- One patient <-> One doctor
CREATE TABLE Appointment (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    patient_email VARCHAR(100) NOT NULL,
    doctor_email VARCHAR(100) NOT NULL,

    appointment_date DATE NOT NULL,

    start_time TIME NOT NULL,
    end_time TIME NOT NULL,

    status VARCHAR(20) NOT NULL
        CHECK (status IN
        ('Scheduled','Completed','Cancelled')),

    concerns TEXT,

    symptoms TEXT,

    diagnosis TEXT,

    prescription TEXT,

    FOREIGN KEY (patient_email)
        REFERENCES Patient(email)
        ON DELETE CASCADE,

    FOREIGN KEY (doctor_email)
        REFERENCES Doctor(email)
        ON DELETE CASCADE,

    CHECK (start_time < end_time)
);

-- MEDICAL HISTORY
-- One patient -> many history records
CREATE TABLE MedicalHistory (

    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    patient_email VARCHAR(100) NOT NULL,

    visit_date DATE NOT NULL,

    notes TEXT,

    FOREIGN KEY (patient_email)
        REFERENCES Patient(email)
        ON DELETE CASCADE
);

-- CONDITIONS
-- One history -> many conditions
CREATE TABLE MedicalCondition (

    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    history_id INT NOT NULL,

    condition_name VARCHAR(100) NOT NULL,

    FOREIGN KEY (history_id)
        REFERENCES MedicalHistory(id)
        ON DELETE CASCADE
);

-- SURGERIES
-- One history -> many surgeries
CREATE TABLE Surgery (

    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    history_id INT NOT NULL,

    surgery_name VARCHAR(100) NOT NULL,

    surgery_date DATE,

    FOREIGN KEY (history_id)
        REFERENCES MedicalHistory(id)
        ON DELETE CASCADE
);

-- MEDICATIONS
-- One history -> many medicines
CREATE TABLE Medication (

    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    history_id INT NOT NULL,

    medicine_name VARCHAR(100) NOT NULL,

    dosage VARCHAR(100),

    FOREIGN KEY (history_id)
        REFERENCES MedicalHistory(id)
        ON DELETE CASCADE
);