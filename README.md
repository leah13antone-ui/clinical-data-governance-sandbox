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
To fulfill strict HIPAA and PHI de-identification standards, a secure schema view applies a column-level SHA2 cryptographic hash that combines patient IDs and intake names into irreversible, unique 64-character tokens. Exact dates of birth are generalized to broad birth years, completely isolating sensitive patient identities before downstream exposure.

