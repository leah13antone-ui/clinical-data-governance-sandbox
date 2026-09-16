# Phase II Dermatology & Skin Cancer Clinical Trial Sandbox
### Enterprise Data Governance, HIPAA De-Identification & Real-Time Efficacy Analytics (N=1,000)

## Executive Overview
This repository contains a production-scale cloud data architecture simulating the ingestion, cryptographic de-identification, and interactive visualization of an enterprise-level pharmaceutical clinical trial. Modeling a cohort of 1,000 randomized patient profiles across four high-consequence dermatology tracks, this sandbox demonstrates a fully functional pipeline that bridges rigid healthcare compliance rules with real-time biostatistical decision making.

The project addresses two critical challenges in modern Life Sciences tech:
1. PHI Protection: Ensuring complete data privacy without stripping the utility required for tracking clinical efficacy metrics.
2. Dynamic Live Visualization: Delivering an active web canvas for executive stakeholders to isolate cohort metrics instantly.


## System Architecture & Framework Components

### 1. Data Generation & Parameter Seeding (`01_database_infrastructure.sql`)
Utilizing Snowflake's administrative engine, a data matrix was auto-generated to seed 1,000 patient rows. The dataset splits across 4 distinct clinical tracks, embedding real-world therapeutic benchmarks:
  ** Severe Psoriasis (Biologic Track)
  ** Atopic Dermatitis (JAK Inhibitor Track)
  ** Onychomycosis (Topical Antifungal Track): Hard-coded to mimic a strict 15-18% clearance curve (*Jublia efficacy model*)
  ** Basal Cell Carcinoma (Topical Immunotherapy Track): Models an oncological tumor-clearance parameter track.

### 2. The HIPAA Privacy Layer (SHA-256 Hashing View)
To fulfill strict HIPAA and PHI de-identification standards, a secure schema view applies a column-level **SHA2 cryptographic hash** that combines patient IDs and intake names into irreversible, unique 64-character tokens. Exact dates of birth are generalized to broad birth years, completely isolating sensitive patient identities before downstream exposure.

### 3. Interactive Analytical Portal (`02_dashboard_application.py`)
Developed an interactive interface utilizing **Streamlit and Snowpack Python** to pull from the anonymized view. The application provides dynamic sidebar selection filtering, rendering real-time cohort distribution charts and live mean efficacy statistical calculations simultaneously.

### 4. Live Regulatory Compliance Bridge (`03_api_ingestion_bridge.py`)
Features a Python pipeline that queries live government servers via the **OpenFDA Drug Enforcement API**. The script evaluates real-time pharmaceutical recall keywords and automatically maps data frame parameters back to the local patient cohort to proactively flag compliance risks.

---
## Impact Narrative (The SE Business Pitch)
In a live enterprise presentation, this sandbox serves as a direct proof of concept for major pharmaceutical accounts. It demonstrates that clinical research teams can monitor real-time statistical trends, such as capturing a precise 16.5% average response curve within an automated topical block, while completely mitigating global GxP data integrity risks and preventing multi-million dollar FDA audit exposures.
