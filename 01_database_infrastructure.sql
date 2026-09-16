import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd

# 1. Initialize active internal database session connection
session = get_active_session()

# 2. Design interface header elements
st.title("Derma-Tech Phase II Clinical Trial Sandbox")
st.markdown("### Secure HIPAA-Compliant Real-Time Analytics Portal (N = 1,000 Patients)")
st.write("This application pulls directly from an anonymized database view layer containing zero raw PHI values.")

# 3. Stream the enterprise data array using Snowpark Python
raw_query = "SELECT * FROM DERMA_CLINICAL_SANDBOX.TRIAL_DATA.patient_secure_analytics_view"
snow_df = session.sql(raw_query)
pd_df = snow_df.to_pandas() # Flatten to standard pandas data frame structure 

# 4. Interactive Sidebar Parametr Filter Controls
st.sidebar.header("Cohort Selection Filters")
selected_diagnosis = st.sidebar.selectbox(
    "Select Target Dermatology Cohort:",
    options=pd_df["MEDICAL_DIAGNOSIS"].unique()
)

# Apply dynamic matrix selection filter based on user sidebar input
filtered_df = pd_df[pd_df["MEDICAL_DIAGNOSIS"] == selected_diagnosis]

# 5. Multi-Column Analytical Layout UI Build
col1, col2 = st.columns(2)

with col1:
    st.subheader("Anonymized Patient Cohort Logs")
    st.dataframe(filtered_df, use_container_width=True)

with col2:
    st.subheader("Statistical Performance Summary")

    # Calculate real-time mean averages for the clinical metrics card
    avg_efficacy = filtered_df["EFFICACY_SCORE"].mean()
    st.metric(label="Cohort Mean Efficacy Score", value=f"{avg_efficacy:.2%}")

    # Render an interactive horizontal tracking visualization graph
    st.bar_chart(filtered_df.set_index("SECURE_TOKEN_ID")["EFFICACY_SCORE"])
