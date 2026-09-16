-- PROJECT: ENTERPRISE LIFE SCIENCES DATA GOVERNANCE & ANONYMIZATION SANDBOX
-- TARGET COHORTS: DERMATOLOGY & ONCOLOGY SKIN CANCER CLINICAL TRAILS (N=1000)
-- AUTHORIZATIONN: USE ROLE ACCOUNTADMIN

USE ROLE ACCOUNTADMIN;

-- 1. CLOUD STORAGE CONTAINERS
CREATE OR REPLACE DATABASE DERMA_CLINICAL_SANDBOX;
CREATE OR REPLACE SCHEMA DERMA_CLINICAL_SANDBOX.TRIAL_DATA;

-- 2. RAW PATIENT INTAKE SCHEMA (CONTAINS SENSITIVE PROTECTED HEALTH INFORMATION / PHI)
CREATE OR REPLACE TABLE DERMA_CLINICAL_SANDBOX.TRIAL_DATA.patient_intake_raw (
    patient_id INT,
    first_name STRING,
    last_name STRING,
    date_of_birth DATE,
    medical_diagnosis STRING,
    systolic_blood_pressure INT,
    efficacy_score FLOAT
);

-- 3. PROPS-DRIVEN ENTERPRISE SEED GENERATOR (1,000 ROWS OUT OF THIN AIR)
TRUNCATE TABLE DERMA_CLINICAL_SANDBOX.TRIAL_DATA.patient_intake_raw;

INSERT INTO DERMA_CLINICAL_SANDBOX.TRIAL_DATA.patient_intake_raw
SELECT
    1000 + ROW_NUMBER() OVER (ORDER BY SEQ4()) AS patient_id,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Sarah' WHEN 1 THEN 'Josh' WHEN 2 THEN 'Amanda' WHEN 3 THEN 'Kevin' ELSE 'Patricia'
    END AS first_name,
    CASE MOD (SEQ4(), 6)
        WHEN 0 THEN 'Jenkins' WHEN 1 THEN 'Chang' WHEN 2 THEN 'Ross' WHEN 3 THEN 'Gomez' WHEN 4 THEN 'Davis' ELSE 'Wallace'
    END AS last_name,
    -- Simulates a clean demographic range of realistic adult patient birthdays
    DATEADD(day, -UNIFORM(7000, 22000, RANDOM()), CURRENT_DATE()) AS date_of_birth,

    -- Split 1,000 patients across 4 distinct inflammatory and oncological dermatology tracks
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Severe Psoriasis (Biologic)'
        WHEN 1 THEN 'Atopic Dermatitis (JAK Inhibitor)'
        WHEN 2 THEN 'Onychomycosis (Topical Antifungals)'
        ELSE 'Basal Cell Carcinoma (Topical Immunotherapy)' -- Skin cancer cohort
    END AS medical_diagnosis,

    -- Blood pressure metrics mapping vital signs fluctuations
    UNIFORM(110, 150, RANDOM()) AS systolic_blood_pressure,

    -- Enforce real-world clinical benchmarks: Onychomycosis mirrors low Jublia topical thresholds
    CASE MOD(SEQ4(), 4)
        WHEN 2 THEN ROUND(UNIFORM(0.15, 0.18, RANDOM()), 2) -- Strict 15-18% Jublia curve
        WHEN 3 THEN ROUND(UNIFORM(0.70, 0.82, RANDOM()), 2) -- Standard Aldara topical clearance rate
        ELSE ROUND(UNIFORM(0.45, 0.94, RANDOM()), 2)        -- Modern systemic/biologic clearances
    END AS efficacy_score
FROM TABLE(GENERATOR(ROWCOUNT => 1000));

-- 4. THE HIPAA PRIVACY LAYER: CRYPTOGRAPHIC SHA-256 SCHEMA MASKING VIEW
CREATE OR REPLACE VIEW DERMA_CLINICAL_SANDBOX.TRIAL_DATA.patient_secure_analytics_view AS
SELECT
    -- Irreversible cryptographic token hides names while maintaining unique identification data arrays
    SHA2(CONCAT(patient_id, first_name, last_name)) AS secure_token_id,
    YEAR(date_of_birth) AS birth_year,
    medical_diagnosis,
    systolic_blood_pressure,
    efficacy_score
FROM DERMA_CLINICAL_SANDBOX.TRIAL_DATA.patient_intake_raw;

-- 5. AUDIT ENGINE VERIFICATION CHECKS
SELECT COUNT(*) AS total_generated_records 
FROM DERMA_CLINICAL_SANDBOX.TRIAL_DATA.patient_intake_raw;

SELECT * FROM DERMA_CLINICAL_SANDBOX.TRIAL_DATA.patient_secure_analytics_view
LIMIT 5;
