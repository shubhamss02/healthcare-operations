select * from hospital_er

-- Q1: How many patients visited the emergency department in total?
SELECT 
	COUNT(*) AS total_patient
FROM hospital_er

-- Q2: How many patients were admitted vs. not admitted?

SELECT
    CASE
        WHEN patient_admission_flag = TRUE THEN 'Admitted'
        ELSE 'Not Admitted'
    END AS admission_status,
    COUNT(*) AS total_patients
FROM hospital_er
GROUP BY patient_admission_flag;

-- Q3: What is the average patient wait time overall, and how does it differ between admitted and non-admitted patients?
-- PART A
SELECT 
	ROUND(AVG(patient_waittime),2)
FROM hospital_er

-- PART B
SELECT 
	CASE 
		WHEN patient_admission_flag = TRUE THEN 'Admitted'
		ELSE 'Not admitted'
	END AS admission_status,
	ROUND(AVG(patient_waittime),2) AS avg_waittime
FROM hospital_er
GROUP BY patient_admission_flag 

-- Q4: What is the patient volume by month?

SELECT
	DATE_TRUNC('Month',patient_admission_date) AS Month,
	COUNT(*) AS patient_volume
FROM hospital_er
GROUP BY DATE_TRUNC('Month',patient_admission_date)
ORDER BY Month


-- Q5: Which departments receive the most patient referrals?
SELECT
    COALESCE(department_referral, 'Not Referred / Not Recorded') AS referral_department,
    COUNT(*) AS patient_volume
FROM hospital_er
GROUP BY COALESCE(department_referral, 'Not Referred / Not Recorded')
ORDER BY patient_volume DESC;

-- Q6: Which age groups have the highest number of patients and admission rates?
WITH age_groups AS (
    SELECT
        patient_age,
        patient_admission_flag,
        NTILE(4) OVER (ORDER BY patient_age) AS age_group
    FROM hospital_er
)

SELECT
    age_group,
    MIN(patient_age) AS min_age,
    MAX(patient_age) AS max_age,
    COUNT(*) AS total_patients,
    SUM(CASE
        WHEN patient_admission_flag = TRUE THEN 1
        ELSE 0
    END) AS admitted_patients,
    ROUND(
        100.0 * SUM(CASE
            WHEN patient_admission_flag = TRUE THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS admission_rate
FROM age_groups
GROUP BY age_group
ORDER BY age_group;

-- Q7: Which departments have the highest average patient wait time?
SELECT
    department_referral AS patient_department,
    ROUND(AVG(patient_waittime), 2) AS avg_wait_time
FROM hospital_er
WHERE department_referral IS NOT NULL
GROUP BY department_referral
ORDER BY avg_wait_time DESC;

-- Q8: Does longer waiting time appear to be associated with a higher admission rate?
WITH wait_groups AS (
    SELECT
        patient_waittime,
        patient_admission_flag,
        NTILE(4) OVER (ORDER BY patient_waittime) AS wait_group
    FROM hospital_er
)

SELECT
    wait_group,
    MIN(patient_waittime) AS min_wait_time,
    MAX(patient_waittime) AS max_wait_time,
    COUNT(*) AS total_patients,
    SUM(
        CASE
            WHEN patient_admission_flag = TRUE THEN 1
            ELSE 0
        END
    ) AS admitted_patients,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN patient_admission_flag = TRUE THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS admission_rate
FROM wait_groups
GROUP BY wait_group
ORDER BY wait_group;

-- Q9: How does patient satisfaction vary across different age groups?
WITH age_groups AS (
    SELECT
        patient_age,
        patient_satisfaction_score,
        NTILE(4) OVER (ORDER BY patient_age) AS age_group
    FROM hospital_er
    WHERE patient_satisfaction_score IS NOT NULL
)

SELECT
    age_group,
    MIN(patient_age) AS min_age,
    MAX(patient_age) AS max_age,
    COUNT(*) AS patients_with_satisfaction,
    AVG(patient_satisfaction_score) AS avg_satisfaction
FROM age_groups
GROUP BY age_group
ORDER BY age_group;

-- Q10: When does the emergency department experience the highest patient demand, and do those periods also have longer waiting times?
SELECT
    EXTRACT(HOUR FROM patient_admission_date) AS admission_hour,
    COUNT(*) AS patient_volume,
    ROUND(AVG(patient_waittime), 2) AS avg_wait_time
FROM hospital_er
GROUP BY EXTRACT(HOUR FROM patient_admission_date)
ORDER BY admission_hour;