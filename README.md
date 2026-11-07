# Data_Engineering
Ride Hailing Analytics Project

# Ride-Hailing Trip Analytics
End-to-End Data Engineering & Business Analytics with Databricks
An end-to-end ride-hailing analytics project built with Databricks SQL and a Medallion Architecture. The project ingests raw trip data, applies data-quality and cleaning rules, creates business-ready Gold datasets, and presents insights through a three-page Databricks AI/BI dashboard.

# Dashboard Preview
The Databricks dashboard is organized into three pages:
| Page | Purpose | Main analysis |
|---|---|---|
| Business Overview | Monitor overall business performance | Trips, net revenue, distance, driver payout, platform earnings, monthly revenue |
| Operational Analysis | Understand operational performance | City and region revenue, trips by vehicle type, average customer ratings |
| Payment & Data Quality | Monitor payment patterns and data reliability | Payment-method trends, pending amount, missing/invalid data, clean and rejected rows |

# Architecture
[<img width="1058" height="596" alt="image" ](src="https://github.com/user-attachments/assets/44e2b7c8-35f5-4a5c-8377-a220021cd9c8" />)

# Data flow
1. Bronze layer – ingestion
   - Reads CSV files from the Databricks Unity Catalog Volume.
   - Creates the bronze_ride_trips streaming table.
   - Captures source filename and ingestion timestamp metadata.
2. Silver layer – cleaning and validation
   - Creates silver_trips_clean for accepted, standardized records.
   - Creates silver_trips_rejected for records failing key validation rules.
   - Applies rules including positive trip distance and non-negative rate per kilometre.
   - Normalizes selected text fields and handles missing values according to the transformation SQL.
3. Gold layer – business aggregation
   - Creates summary datasets for monthly performance, cities, vehicle types, payment methods, and data quality.
4. Analytics dashboard
   - Uses the Gold datasets to support business and operational analysis.
     
# Technology Stack
- Platform: Databricks
- Query language: Databricks SQL
- Architecture: Medallion (Bronze, Silver, Gold)
- Data organization: Unity Catalog and Volumes
- Ingestion: read_files / streaming-table pattern
- Analytics: Materialized views and SQL aggregations
- Visualization: Databricks AI/BI Dashboards
  
# Catalog and Data Objects
Catalog: mobility_catalog
Schema: trips
Raw Volume: /Volumes/mobility_catalog/trips/raw_files/
## Bronze
- bronze_ride_trips
## Silver
- silver_trips_clean
- silver_trips_rejected
## Gold
- gold_monthly_trips
- gold_city_summary
- gold_vehicle_summary
- gold_payment_summary
- gold_data_quality

# Key Business Results
The following values were visible in the Databricks query and dashboard results during project development. Re-run the pipeline and queries to refresh these figures before using them as current results.

| KPI | Observed result |
|---|---:|
| Clean trips | 1,168 |
| Net revenue | 237,150.56 |
| Total distance | 15,769.10 km |
| Driver payout | 184,511.02 |
| Platform earnings | 52,639.54 |
| Pending payment amount | 18,746.18 |

# Operational observations
- Bengaluru appeared as the highest-revenue city in the city summary.
- South appeared as the highest-revenue region.
- Mini was the highest-volume vehicle type, with 304 trips in the displayed summary.
- UPI was the most frequently used payment method, with 534 trips in the displayed summary.
- Average customer ratings by vehicle type were around 4 in the displayed chart.
These are observations from the project outputs, not claims about the entire ride-hailing market.

# Data Quality and Reconciliation
The data-quality output shown during development reported:

| Measure | Observed result |
|---|---:|
| Bronze rows | 1,214 |
| Duplicate rows | 24 |
| Invalid distance rows | 13 |
| Invalid rate rows | 9 |
| Missing city rows | 12 |
| Missing payment rows | 14 |
| Missing fare rows | 18 |
| Missing rating rows | 27 |
| Clean rows | 1,168 |
| Rejected rows | 22 |
| Reconciliation status | PASS |

The displayed row reconciliation was:

1,214 = 24 + 1,168 + 22

Missing-field counts may overlap because one record can have more than one missing field. The values above are the results visible in the project screenshots; validate again after a fresh run.

# Repository Structure
```
end_to_end_ride_hailing/
├── ETL_Pipeline/
│   ├── Bronze/
│   │   └── bronze_ride_trips.sql
│   ├── Silver/
│   │   └── silver_trips_clean_rejected.sql
│   └── Gold/
│       ├── gold_monthly_trips.sql
│       ├── gold_city_summary.sql
│       ├── gold_vehicle_summary.sql
│       ├── gold_payment_summary.sql
│       └── gold_data_quality.sql
├── Images/
│   └── architecture.png
├── dashboard/
│   └── screenshots/
├── data/
├── docs/
│   ├── project_overview.md
│   ├── data_quality_rules.md
│   ├── reconciliation.md
│   └── review_questions.md
├── README.md
└── .gitignore
```

# How to Reproduce
1. In Databricks, create or select catalog mobility_catalog.
2. Create schema trips and volume raw_files.
3. Place the permitted ride-trip CSV file in the volume path shown above.
4. Run the Bronze ingestion SQL.
5. Run the complete, tested Silver transformations.
6. Run the Gold materialized-view SQL scripts.
7. Add the Gold datasets to a Databricks AI/BI dashboard.
8. Validate the counts and reconciliation status.
9. Publish the dashboard with appropriate data permissions.
10. 
# SQL export note
The Bronze script and monthly Gold aggregation in this repository reflect SQL shared during development. The Silver script and the city, vehicle, payment, and data-quality Gold scripts are marked as export placeholders where the complete final SQL was not available in the project conversation. Replace those placeholders with the exact, tested SQL exported from your Databricks workspace before presenting this repository as fully reproducible.

# Security and Data Handling
- Never commit Databricks passwords, Personal Access Tokens, API keys, or workspace credentials.
- Do not commit private or personally identifiable trip data.
- Only publish the source CSV if you own it or have permission to redistribute it.
- The .gitignore excludes common local secrets and CSV data files by default.
  
# Future Enhancements
- Automate scheduled pipeline refreshes.
- Add incremental-load monitoring and failure alerts.
- Expand data-quality checks and document each rule.
- Add date-range and cross-page dashboard filters where supported.
- Add more business metrics such as cancellation rate and on-time performance if the source data supports them.
  
# Author
Manyam Pulendra

B.Tech – Computer Science and Engineering

Focus: Data Analytics, SQL, Databricks, and Business Intelligence

