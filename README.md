Healthcare Operations
Emergency Department Operations Analysis
> \*\*How efficiently is the emergency department handling patient flow, and where are the major bottlenecks affecting waiting time, admissions, and patient satisfaction?\*\*
This project analyzes emergency department visit records to understand patient flow, admission patterns, waiting times, referral activity, and patient satisfaction. The analysis combines Python/Pandas for data preparation, PostgreSQL for business-focused SQL analysis, and Power BI for interactive reporting.
The goal was not simply to visualize patient data, but to turn operational data into insights that could help an emergency department identify pressure points, understand demand patterns, and prioritize areas for operational review.
---
📌 Project Snapshot
Metric	Value
Patient Records	9,216
Data Fields	12
Admitted Records	4,612
Non-Admitted Records	4,604
Overall Admission Rate	50.04%
Average Wait Time	35.26 min
Average Satisfaction Score*	4.99 / 10
Data Period	Apr 2023 – Oct 2024
* Satisfaction is calculated only from records where a satisfaction score was available.
---
🏥 Business Problem
Emergency departments need to balance patient demand, waiting times, admissions, referrals, and patient experience.
A high-level patient count alone does not explain where operational pressure exists. This analysis therefore investigates several dimensions of the patient journey:
How many patients are being handled?
What proportion are admitted?
How long are patients waiting?
Which referred departments have higher waiting times?
Does waiting time show any relationship with admission rates?
When is patient demand highest?
How does satisfaction differ across age groups?
The analysis is designed to answer these questions from an operations and decision-making perspective.
---
❓ Key Business Questions
The SQL analysis was structured around 10 business questions:
How many patients visited the emergency department in total?
How many patients were admitted vs. not admitted?
What is the average patient wait time overall, and how does it differ between admitted and non-admitted patients?
What is the patient volume by month?
Which departments receive the most patient referrals?
Which age groups have the highest number of patients and admission rates?
Which departments have the highest average patient wait time?
Does longer waiting time appear to be associated with a higher admission rate?
How does patient satisfaction vary across different age groups?
When does the emergency department experience the highest patient demand, and do those periods also have longer waiting times?
---
📊 Dataset
The dataset contains 9,216 emergency department patient records across 12 fields.
Key Fields
Field	Description
`patient\_id`	Patient record identifier
`patient\_admission\_date`	Date and time of the emergency department visit
`patient\_gender`	Recorded gender
`patient\_age`	Patient age
`patient\_race`	Recorded race category
`department\_referral`	Referred department, where recorded
`patient\_admission\_flag`	Whether the patient was admitted
`patient\_satisfaction\_score`	Patient satisfaction score
`patient\_waittime`	Patient waiting time in minutes
`patients\_cm`	Binary field included in the source dataset
The dataset covers visits from April 2023 through October 2024.
---
🧹 Data Quality & Preparation
The initial dataset was inspected in Python using Pandas before being loaded into PostgreSQL.
Preparation performed
Standardized column names by removing spaces, converting them to lowercase, and replacing spaces with underscores.
Converted `patient\_admission\_date` from text into a proper datetime field.
Created a combined `patient\_name` field from the first initial and last name.
Checked for duplicate records.
Reviewed categorical distributions.
Checked missing values.
Reviewed numerical ranges and descriptive statistics.
Investigated whether missing referral and satisfaction values showed an obvious relationship with admission status.
Data quality findings
There were no duplicate rows in the dataset.
Two fields contained substantial missing values:
`department\_referral`: 5,400 missing records
`patient\_satisfaction\_score`: 6,699 missing records
Rather than blindly imputing these values, the missingness was investigated. Satisfaction scores were not filled based on admission status because the available scores were similar across admitted and non-admitted records. Missing referral values were also retained rather than assuming that a missing value necessarily meant the patient was not referred.
This preserves the original information instead of introducing unsupported assumptions.
---
🗄️ SQL Analysis
After preparation, the cleaned dataset was loaded into PostgreSQL and analyzed using SQL.
The analysis included:
Patient volume & admissions
Total patient records
Admitted vs. non-admitted records
Overall and admission-status-specific average waiting time
Demand patterns
Monthly patient volume
Hourly patient volume
Average wait time during each hour
Referral operations
Referral volume by department
Average waiting time by referred department
Patient groups
Age-group patient volume
Age-group admission rates
Age-group satisfaction scores
Wait-time analysis
Patients divided into four wait-time groups using `NTILE(4)`
Admission rates compared across increasing wait-time groups
Using quartile-based grouping allowed the analysis to compare similarly sized patient groups instead of relying on arbitrary age or wait-time boundaries.
---
📈 Power BI Dashboard
The final analysis was presented as a single-page Emergency Department Operations Dashboard.
Dashboard title
Emergency Department Operations Dashboard
Subtitle
Patient Flow, Operational Efficiency & Patient Experience
KPI Cards
Total Patients
Admission Rate
Avg Wait Time (min)
Avg Satisfaction Score
Main Visuals
Visual	Purpose
Patient Volume by Month	Track changes in demand over time
Patient Volume by Hour	Identify periods of higher patient demand
Average Wait Time by Department	Highlight departments with higher average waits
Admission Rate by Wait-Time Group	Examine the relationship between waiting time and admissions
Average Satisfaction Score by Age Group	Compare patient experience across age groups
The dashboard was designed to keep the analysis focused on operational questions rather than filling the page with unnecessary charts.
---
🖼️ Dashboard Preview
![Emergency Department Operations Dashboard](Dashboard/emergency_department_dashboard.png)
---
💡 Key Business Insights
1. Patient volume is relatively consistent over the observed period
Monthly patient volume remains within a fairly narrow range, although some months show noticeable increases. August 2024 recorded the highest monthly volume at 530 records, while February 2024 recorded the lowest at 431.
This suggests that demand is not dominated by a single extreme month, but there are still periods where capacity planning may need additional attention.
2. Admissions are almost evenly split with non-admissions
Out of 9,216 records:
4,612 were admitted
4,604 were not admitted
This results in an overall admission rate of approximately 50.04%, indicating a nearly even split between the two outcomes.
3. Average waiting time is approximately 35 minutes
The overall average patient wait time is 35.26 minutes.
Interestingly, admitted patients had an average wait of 34.97 minutes, compared with 35.55 minutes for non-admitted patients.
The difference is small, so the data does not indicate a meaningful difference in average waiting time based solely on admission outcome.
4. Neurology has the highest average wait among referred departments
Among records with a department referral, Neurology has the highest average wait time at approximately 36.80 minutes, followed by:
Physiotherapy — 36.57 min
Gastroenterology — 35.83 min
Cardiology — 35.35 min
Orthopedics — 34.98 min
General Practice — 34.91 min
Renal — 34.70 min
Neurology therefore stands out as a potential area for further operational review.
5. Longer waits do not consistently correspond to higher admission rates
The wait-time quartile analysis does not show a consistent upward relationship between waiting time and admission rate.
Admission rates were approximately:
Low wait: 51.13%
Medium wait: 50.22%
High wait: 47.96%
Very high wait: 50.87%
The highest-wait group does not have the highest admission rate. Therefore, the analysis does not support the assumption that longer waits automatically correspond to more admissions.
6. The highest hourly demand occurs at 11 PM
The emergency department records its highest hourly volume at 11 PM, with 436 patient records.
The average wait time during that hour is 36.25 minutes, which is slightly above the overall average.
This makes late-evening demand a useful area to consider when reviewing staffing and capacity planning.
7. Satisfaction scores are available for only a subset of records
Only 2,517 of the 9,216 records contain a satisfaction score. The overall average among available scores is approximately 4.99/10.
When satisfaction is compared across age quartiles, the oldest group has the lowest average score at approximately 4.80/10, compared with approximately 5.02–5.13 in the other groups.
Because most records do not contain satisfaction scores, this finding should be interpreted as a pattern within the available responses rather than a conclusion about all patients.
---
🚀 Business Recommendations
Based on the analysis, several operational actions could be considered:
1. Review Neurology referral operations
Neurology has the highest average waiting time among referred departments. The department could be reviewed for referral processing, staffing availability, or patient handoff delays.
2. Evaluate late-evening staffing
The highest hourly patient volume occurs at 11 PM. Staffing schedules could be compared with hourly demand to determine whether late-evening capacity is aligned with patient volume.
3. Monitor waiting time independently from admission
The analysis does not show a consistent relationship between longer waits and admission rates. Waiting time should therefore be treated as an operational efficiency metric rather than using admission rate alone as a proxy for waiting-time pressure.
4. Improve satisfaction data capture
With satisfaction scores available for only 2,517 records, the large amount of missing feedback limits the strength of patient-experience analysis.
Improving survey completion or feedback capture would provide a more representative view of patient satisfaction.
5. Use demand patterns for capacity planning
Monthly and hourly demand patterns can be monitored to identify periods where staffing and resources may need adjustment rather than relying only on overall averages.
---
🛠️ Tools Used
Python
Pandas
NumPy
Matplotlib
PostgreSQL / pgAdmin
SQL
Power BI
DAX
Data modeling
KPI cards
Interactive visual reporting
GitHub
---
🏁 Project Outcome
This project demonstrates an end-to-end approach to operational data analysis:
Raw Data → Python Data Preparation → PostgreSQL SQL Analysis → Power BI Dashboard → Business Insights → Recommendations
The final result is a focused emergency department operations analysis that connects patient-level data with practical questions around demand, waiting time, admissions, referrals, and patient experience.
