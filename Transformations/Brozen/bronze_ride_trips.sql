
CREATE OR REFRESH STREAMING TABLE bronze_ride_trips AS

SELECT
    *,
    _metadata.file_name AS source_file,
    current_timestamp() AS loaded_at

FROM STREAM read_files(
    '/Volumes/mobility_catalog/trips/raw_files/',
    format => 'csv',
    header => true
);
