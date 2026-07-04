-- ==========================================
-- PATIENT
-- ==========================================
INSERT INTO Patient (email, password, name, gender, address, phone) VALUES
('john.doe@email.com', 'hashedpw123', 'John Doe', 'Male', '123 Elm St, New York, NY', '555-0101'),
('jane.smith@email.com', 'hashedpw456', 'Jane Smith', 'Female', '456 Oak St, Los Angeles, CA', '555-0102'),
('alex.j@email.com', 'hashedpw789', 'Alex Johnson', 'Other', '789 Pine St, Austin, TX', '555-0103'),
('michael.scott@email.com', 'pw101', 'Michael Scott', 'Male', 'Scranton, PA', '555-0301'),
('pam.beesly@email.com', 'pw102', 'Pam Beesly', 'Female', 'Scranton, PA', '555-0302'),
('dwight.s@email.com', 'pw103', 'Dwight Schrute', 'Male', 'Schrute Farms, PA', '555-0303'),
('kelly.k@email.com', 'pw104', 'Kelly Kapoor', 'Female', 'Scranton, PA', '555-0304'),
('taylor.swift@email.com', 'pw105', 'Taylor Swift', 'Female', 'Nashville, TN', '555-0305'),
('jordan.lee@email.com', 'pw106', 'Jordan Lee', 'Other', 'Portland, OR', '555-0306');

-- ==========================================
-- DOCTOR
-- ==========================================
INSERT INTO Doctor (email, password, name, gender, specialization, phone) VALUES
('house@hospital.com', 'docpw1', 'Dr. Gregory House', 'Male', 'Diagnostic Medicine', '555-0201'),
('grey@hospital.com', 'docpw2', 'Dr. Meredith Grey', 'Female', 'General Surgery', '555-0202'),
('watanabe@hospital.com', 'docpw3', 'Dr. Ken Watanabe', 'Male', 'Cardiology', '555-0203'),
('strange@hospital.com', 'docpw4', 'Dr. Stephen Strange', 'Male', 'Neurology', '555-0401'),
('quinn@hospital.com', 'docpw5', 'Dr. Harleen Quinzel', 'Female', 'Psychiatry', '555-0402'),
('hibbert@hospital.com', 'docpw6', 'Dr. Julius Hibbert', 'Male', 'Pediatrics', '555-0403'),
('zoidberg@hospital.com', 'docpw7', 'Dr. John Zoidberg', 'Other', 'General Practice', '555-0404'),
('karev@hospital.com', 'docpw8', 'Dr. Alex Karev', 'Male', 'Pediatric Surgery', '555-0405');

-- ==========================================
-- SCHEDULE
-- ==========================================
INSERT INTO Schedule (doctor_email, day_of_week, start_time, end_time, break_start, break_end) VALUES
('house@hospital.com', 'Monday', '09:00:00', '17:00:00', '13:00:00', '14:00:00'),
('house@hospital.com', 'Wednesday', '09:00:00', '17:00:00', '13:00:00', '14:00:00'),
('grey@hospital.com', 'Tuesday', '08:00:00', '16:00:00', '12:00:00', '13:00:00'),
('grey@hospital.com', 'Thursday', '08:00:00', '16:00:00', '12:00:00', '13:00:00'),
('watanabe@hospital.com', 'Friday', '10:00:00', '18:00:00', '14:00:00', '15:00:00'),
('strange@hospital.com', 'Monday', '08:00:00', '16:00:00', '12:00:00', '12:30:00'),
('strange@hospital.com', 'Tuesday', '08:00:00', '16:00:00', '12:00:00', '12:30:00'),
('quinn@hospital.com', 'Wednesday', '10:00:00', '19:00:00', '14:00:00', '15:00:00'),
('hibbert@hospital.com', 'Thursday', '09:00:00', '17:00:00', '13:00:00', '14:00:00'),
('zoidberg@hospital.com', 'Saturday', '10:00:00', '14:00:00', NULL, NULL),
('zoidberg@hospital.com', 'Sunday', '10:00:00', '14:00:00', NULL, NULL),
('karev@hospital.com', 'Friday', '07:00:00', '19:00:00', '13:00:00', '14:00:00');

-- ==========================================
-- APPOINTMENT
-- ==========================================
INSERT INTO Appointment (patient_email, doctor_email, appointment_date, start_time, end_time, status, concerns, symptoms, diagnosis, prescription) VALUES
('john.doe@email.com', 'house@hospital.com', '2023-10-15', '10:00:00', '10:30:00', 'Completed', 'Severe leg pain', 'Limping, muscle ache, swelling', 'Muscle tear in right calf', 'Ibuprofen 400mg, Rest'),
('jane.smith@email.com', 'grey@hospital.com', '2023-11-20', '09:00:00', '10:00:00', 'Scheduled', 'Post-op checkup', 'Mild discomfort at incision site', NULL, NULL),
('alex.j@email.com', 'watanabe@hospital.com', '2023-10-16', '14:00:00', '14:30:00', 'Cancelled', 'Heart palpitations', 'Racing heart, slight dizziness', NULL, NULL),
('michael.scott@email.com', 'strange@hospital.com', '2023-12-01', '09:00:00', '10:00:00', 'Completed', 'Frequent headaches', 'Migraines, light sensitivity', 'Tension Migraines', 'Sumatriptan 50mg'),
('pam.beesly@email.com', 'zoidberg@hospital.com', '2023-12-05', '11:00:00', '11:30:00', 'Completed', 'Annual physical', 'None', 'Healthy', 'None'),
('kelly.k@email.com', 'quinn@hospital.com', '2023-12-06', '15:00:00', '16:00:00', 'Cancelled', 'Anxiety', 'Stress, insomnia', NULL, NULL),
('dwight.s@email.com', 'grey@hospital.com', '2023-12-10', '08:00:00', '09:30:00', 'Completed', 'Laceration from farming equipment', 'Bleeding, pain', 'Deep tissue laceration on left arm', 'Cephalexin 500mg, Painkillers'),
('taylor.swift@email.com', 'zoidberg@hospital.com', '2024-01-15', '12:00:00', '12:45:00', 'Scheduled', 'Throat feels scratchy', 'Hoarseness after singing', NULL, NULL),
('jordan.lee@email.com', 'karev@hospital.com', '2024-01-20', '09:00:00', '10:30:00', 'Scheduled', 'Consult for childs appendectomy', 'Abdominal pain', NULL, NULL);

-- ==========================================
-- MEDICAL HISTORY
-- ==========================================
INSERT INTO MedicalHistory (patient_email, visit_date, notes) VALUES
('john.doe@email.com', '2022-05-10', 'Annual physical examination. Patient reported occasional joint pain and elevated blood pressure.'),
('jane.smith@email.com', '2021-08-22', 'Emergency room visit for severe abdominal pain. Referred to surgery immediately.'),
('michael.scott@email.com', '2021-02-14', 'Patient burned foot on a George Foreman grill.'),
('pam.beesly@email.com', '2020-05-10', 'Routine pregnancy follow-up. Vitals normal.'),
('dwight.s@email.com', '2019-11-20', 'Concussion evaluation after car accident.'),
('kelly.k@email.com', '2022-01-15', 'Reported passing out after an extreme diet.'),
('taylor.swift@email.com', '2018-09-01', 'Vocal cord evaluation. Minor swelling observed.'),
('jordan.lee@email.com', '2023-03-12', 'Complained of chronic back pain. MRI ordered.');

-- ==========================================
-- MEDICAL CONDITION
-- ==========================================
INSERT INTO MedicalCondition (history_id, condition_name) VALUES
(1, 'Hypertension'),
(1, 'Mild Osteoarthritis'),
(2, 'Acute Appendicitis'),
(3, 'Second-degree burn'),
(4, 'Normal Pregnancy'),
(5, 'Mild Concussion'),
(6, 'Malnutrition / Dehydration'),
(7, 'Vocal Fold Nodules'),
(8, 'Herniated Disc (L4-L5)');

-- ==========================================
-- SURGERY
-- ==========================================
INSERT INTO Surgery (history_id, surgery_name, surgery_date) VALUES
(2, 'Laparoscopic Appendectomy', '2021-08-23'),
(3, 'Wound Debridement and Skin Graft', '2021-02-15'),
(7, 'Microlaryngoscopy (Nodule Removal)', '2018-09-10'),
(8, 'Lumbar Microdiscectomy', '2023-04-05');

-- ==========================================
-- MEDICATION
-- ==========================================
INSERT INTO Medication (history_id, medicine_name, dosage) VALUES
(1, 'Lisinopril', '10mg daily'),
(1, 'Meloxicam', '15mg as needed for pain'),
(2, 'Amoxicillin', '500mg every 8 hours for 7 days'),
(2, 'Oxycodone', '5mg every 6 hours as needed for severe pain'),
(3, 'Silver Sulfadiazine Cream', 'Apply topically twice daily'),
(4, 'Prenatal Vitamins', '1 tablet daily'),
(5, 'Acetaminophen', '500mg every 6 hours as needed'),
(6, 'Intravenous Fluids (Saline)', '1 Liter IV stat'),
(7, 'Prednisone', '20mg daily for 5 days (Steroid pack)'),
(8, 'Gabapentin', '300mg three times a day');