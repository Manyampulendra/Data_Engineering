
CREATE OR REFRESH MATERIALIZED VIEW gold_monthly_trips AS

SELECT

    DATE_TRUNC('MONTH', trip_date) AS trip_month,

    COUNT(*) AS trips,

    SUM(distance_km) AS total_km,

    SUM(
        fare_amount - COALESCE(discount_amount, 0)
    ) AS net_revenue,

    SUM(driver_payout) AS driver_payout,

    SUM(
        fare_amount - COALESCE(discount_amount, 0)
    ) - SUM(driver_payout) AS platform_earnings

FROM silver_trips_clean

GROUP BY DATE_TRUNC('MONTH', trip_date);


CREATE OR REFRESH MATERIALIZED VIEW gold_city_summary AS

SELECT

    region,
    city,

    COUNT(*) AS trips,

    SUM(
        fare_amount - COALESCE(discount_amount, 0)
    ) AS net_revenue,

    AVG(
        fare_amount - COALESCE(discount_amount, 0)
    ) AS avg_fare_per_trip

FROM silver_trips_clean

GROUP BY
    region,
    city;



CREATE OR REFRESH MATERIALIZED VIEW gold_data_quality AS

WITH bronze_stats AS (

    SELECT

        COUNT(*) AS bronze_rows,

        COUNT(*) - COUNT(DISTINCT trip_id)
        AS duplicate_rows,

        SUM(
            CASE
                WHEN distance_km <= 0 THEN 1
                ELSE 0
            END
        ) AS invalid_distance_rows,

        SUM(
            CASE
                WHEN rate_per_km < 0 THEN 1
                ELSE 0
            END
        ) AS invalid_rate_rows,

        SUM(
            CASE
                WHEN city IS NULL OR TRIM(city) = ''
                THEN 1 ELSE 0
            END
        ) AS missing_city_rows,

        SUM(
            CASE
                WHEN payment_method IS NULL
                     OR TRIM(payment_method) = ''
                THEN 1 ELSE 0
            END
        ) AS missing_payment_rows,

        SUM(
            CASE
                WHEN fare_amount IS NULL THEN 1
                ELSE 0
            END
        ) AS missing_fare_rows,

        SUM(
            CASE
                WHEN customer_rating IS NULL THEN 1
                ELSE 0
            END
        ) AS missing_rating_rows

    FROM bronze_ride_trips
),

silver_stats AS (

    SELECT COUNT(*) AS clean_rows
    FROM silver_trips_clean

),

rejected_stats AS (

    SELECT COUNT(*) AS rejected_rows
    FROM silver_trips_rejected

)

SELECT

    b.*,

    s.clean_rows,

    r.rejected_rows,

    CASE

        WHEN b.bronze_rows =
             b.duplicate_rows +
             s.clean_rows +
             r.rejected_rows

        THEN 'PASS'

        ELSE 'FAIL'

    END AS reconciliation_status

FROM bronze_stats b

CROSS JOIN silver_stats s

CROSS JOIN rejected_stats r;

CREATE OR REFRESH MATERIALIZED VIEW gold_vehicle_summary AS

SELECT
    vehicle_type,
    COUNT(*) AS trips,
    SUM(distance_km) AS total_km,

    SUM(
        fare_amount - COALESCE(discount_amount, 0)
    ) AS net_revenue,

    AVG(customer_rating) AS avg_rating

FROM silver_trips_clean

GROUP BY vehicle_type;


CREATE OR REFRESH MATERIALIZED VIEW gold_payment_summary AS

SELECT

    payment_method,

    COUNT(*) AS trips,

    SUM(
        fare_amount - COALESCE(discount_amount, 0)
    ) AS net_revenue,

    SUM(
        CASE
            WHEN LOWER(TRIM(payment_status)) = 'pending'
            THEN fare_amount - COALESCE(discount_amount, 0)
            ELSE 0
        END
    ) AS pending_amount

FROM silver_trips_clean

GROUP BY payment_method;

