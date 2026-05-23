-- =========================================
-- HEALTHCARE ANALYTICS DATABASE
-- PostgreSQL Schema
-- =========================================

CREATE DATABASE healthcare_analytics;

-- Connect to database before running next commands


-- ======================
-- HOSPITALS TABLE
-- ======================

CREATE TABLE hospitals (
    hospital_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    address TEXT,
    phone VARCHAR(30),
    email VARCHAR(255),
    website TEXT,
    rating DECIMAL(2,1),
    emergency_services BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ======================
-- DOCTORS TABLE
-- ======================

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    hospital_id INT REFERENCES hospitals(hospital_id),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    specialty VARCHAR(100),
    phone VARCHAR(30),
    email VARCHAR(255),
    experience_years INT,
    consultation_fee DECIMAL(10,2),
    available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ======================
-- PATIENTS TABLE
-- ======================

CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    gender VARCHAR(10),
    birth_date DATE,
    phone VARCHAR(30),
    email VARCHAR(255),
    city VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ======================
-- APPOINTMENTS TABLE
-- ======================

CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    hospital_id INT REFERENCES hospitals(hospital_id),
    appointment_date TIMESTAMP NOT NULL,
    appointment_status VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ======================
-- MEDICAL RECORDS TABLE
-- ======================

CREATE TABLE medical_records (
    record_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    diagnosis TEXT,
    treatment TEXT,
    prescription TEXT,
    visit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ======================
-- COMPETITORS TABLE
-- ======================

CREATE TABLE competitors (
    competitor_id SERIAL PRIMARY KEY,
    company_name VARCHAR(255),
    city VARCHAR(100),
    services TEXT,
    pricing_model TEXT,
    mobile_app BOOLEAN DEFAULT FALSE,
    online_booking BOOLEAN DEFAULT FALSE,
    home_visit BOOLEAN DEFAULT FALSE,
    rating DECIMAL(2,1),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ======================
-- SPECIALTIES TABLE
-- ======================

CREATE TABLE specialties (
    specialty_id SERIAL PRIMARY KEY,
    specialty_name VARCHAR(100) UNIQUE NOT NULL
);


-- ======================
-- DOCTOR SPECIALTIES TABLE
-- ======================

CREATE TABLE doctor_specialties (
    doctor_id INT REFERENCES doctors(doctor_id),
    specialty_id INT REFERENCES specialties(specialty_id),
    PRIMARY KEY (doctor_id, specialty_id)
);


-- ======================
-- INSERT SAMPLE HOSPITALS
-- ======================

INSERT INTO hospitals (
    name,
    city,
    address,
    phone,
    email,
    website,
    rating,
    emergency_services
)
VALUES
(
    'Cairo Medical Center',
    'Cairo',
    'Nasr City, Cairo',
    '+20-1000000001',
    'info@cmc.com',
    'https://cmc.com',
    4.5,
    TRUE
),
(
    'Alex Health Hospital',
    'Alexandria',
    'Smouha, Alexandria',
    '+20-1000000002',
    'info@alexhealth.com',
    'https://alexhealth.com',
    4.2,
    TRUE
);


-- ======================
-- INSERT SAMPLE DOCTORS
-- ======================

INSERT INTO doctors (
    hospital_id,
    first_name,
    last_name,
    specialty,
    phone,
    email,
    experience_years,
    consultation_fee
)
VALUES
(
    1,
    'Ahmed',
    'Hassan',
    'Cardiology',
    '+20-1011111111',
    'ahmed@cmc.com',
    10,
    500
),
(
    2,
    'Mona',
    'Ali',
    'Dermatology',
    '+20-1022222222',
    'mona@alexhealth.com',
    7,
    350
);


-- ======================
-- INSERT SAMPLE PATIENTS
-- ======================

INSERT INTO patients (
    first_name,
    last_name,
    gender,
    birth_date,
    phone,
    email,
    city
)
VALUES
(
    'Omar',
    'Mahmoud',
    'Male',
    '1995-03-10',
    '+20-1033333333',
    'omar@gmail.com',
    'Cairo'
),
(
    'Sara',
    'Ibrahim',
    'Female',
    '2000-07-15',
    '+20-1044444444',
    'sara@gmail.com',
    'Giza'
);


-- ======================
-- INSERT SAMPLE APPOINTMENTS
-- ======================

INSERT INTO appointments (
    patient_id,
    doctor_id,
    hospital_id,
    appointment_date,
    appointment_status,
    notes
)
VALUES
(
    1,
    1,
    1,
    '2026-05-25 10:00:00',
    'Completed',
    'Routine heart checkup'
),
(
    2,
    2,
    2,
    '2026-05-26 14:00:00',
    'Scheduled',
    'Skin allergy consultation'
);


-- ======================
-- INSERT SAMPLE COMPETITORS
-- ======================

INSERT INTO competitors (
    company_name,
    city,
    services,
    pricing_model,
    mobile_app,
    online_booking,
    home_visit,
    rating
)
VALUES
(
    'Seha Clinics',
    'Cairo',
    'General Medicine, Cardiology, Pediatrics',
    'Subscription',
    TRUE,
    TRUE,
    FALSE,
    4.3
),
(
    'MediCare Egypt',
    'Alexandria',
    'Dermatology, Dental, ENT',
    'Pay Per Visit',
    TRUE,
    TRUE,
    TRUE,
    4.1
);


-- ======================
-- USEFUL INDEXES
-- ======================

CREATE INDEX idx_doctors_specialty
ON doctors(specialty);

CREATE INDEX idx_patients_city
ON patients(city);

CREATE INDEX idx_appointments_date
ON appointments(appointment_date);

CREATE INDEX idx_hospitals_city
ON hospitals(city);


-- ======================
-- SAMPLE ANALYTICS QUERIES
-- ======================

-- Top Rated Hospitals
SELECT
    name,
    city,
    rating
FROM hospitals
ORDER BY rating DESC;


-- Doctors With More Than 5 Years Experience
SELECT
    first_name,
    last_name,
    specialty,
    experience_years
FROM doctors
WHERE experience_years > 5;


-- Upcoming Appointments
SELECT
    a.appointment_id,
    p.first_name AS patient_name,
    d.first_name AS doctor_name,
    a.appointment_date
FROM appointments a
JOIN patients p
ON a.patient_id = p.patient_id
JOIN doctors d
ON a.doctor_id = d.doctor_id
ORDER BY a.appointment_date;


-- Competitors With Mobile Apps
SELECT
    company_name,
    city,
    rating
FROM competitors
WHERE mobile_app = TRUE;