WITH 
event_definition AS (
    SELECT * 
    FROM {schema_name}.event_definitions
    WHERE definition_active = TRUE 
),
semester_codes AS ( /* Pulls all semester codes. Used for cartesian join on semester event types. */
    SELECT 
        id,
        start_date,
        end_date
    FROM {schema_name}.semester_codes
),
years as( /* enerates last 5 years. Used for cartesian join on date event types. G*/
    SELECT EXTRACT(YEAR FROM CURRENT_DATE) - i AS year
    FROM generate_series(0, 4) AS s(i)
    ORDER BY year DESC
),
unique_not_created_events as(
    select 
        bse.*,
        /* Use CASE to handle different interval units */
        ref_date_value + (sign_value * num_value) * 
        CASE 
            WHEN unit_value = '1 day' THEN INTERVAL '1 day'
            WHEN unit_value = '1 month' THEN INTERVAL '1 month'
        END as expected_start_date
    from(
        SELECT 
            ed.definition_index, 
            ed.event_name, 
            ed.initialization_range,
            ed.definition_begin_date,
            ed.definition_end_date,
            ed.initialization_key,
            
            /* Determine whether it's "Before" (-) or "After" (+) */
            case when ed.initialization_range like '%Before%' then -1 else 1 end as sign_value,
            
            /* Extract numeric value (e.g., 14 from '14-Day-Before Start Date') */
            COALESCE(CAST(SPLIT_PART(ed.initialization_range, '-', 1) AS INTEGER), 0) as num_value,
            
            /* Determine if it's days or months based on the presence of 'Day' or 'Month' */
            case 
                when ed.initialization_range LIKE '%Day%' THEN '1 day' 
                when ed.initialization_range LIKE '%Month%' THEN '1 month'
            end as unit_value,
            
            /* Determine whether to use the start date or end date */
            case 
                when ed.initialization_range LIKE '%Start Date%' and ed.initialization_type = 'Semester' THEN sc.start_date
                when ed.initialization_range LIKE '%End Date%' and ed.initialization_type = 'Semester' THEN sc.end_date
                when ed.initialization_range LIKE '%Date%' and ed.initialization_type = 'Date' THEN TO_DATE(years.year || ' ' || ed.initialization_key, 'YYYY Month DD') 
            end as ref_date_value,

            /* Alias for instance_period moved outside of CASE expression */
            case 
                when ed.initialization_type = 'Semester' then sc.id::text
                when ed.initialization_type = 'Date' then CAST(date_part('year', TO_DATE(years.year || ' ' || ed.initialization_key, 'YYYY Month DD')) AS text)
            end as instance_period
            
        FROM event_definition ed

        /* Handles joins to semester based events */
        LEFT JOIN semester_codes sc
            ON ed.initialization_type = 'Semester'
            AND (
                (ed.initialization_key ~ '(^|,)Fall(,|$)' AND RIGHT(sc.id::text, 2) = '20') OR
                (ed.initialization_key ~ '(^|,)Spring(,|$)' AND RIGHT(sc.id::text, 2) = '40') OR
                (ed.initialization_key ~ '(^|,)Summer(,|$)' AND RIGHT(sc.id::text, 2) = '60') OR
                (ed.initialization_key ~ '(^|,)Winter Int(,|$)' AND RIGHT(sc.id::text, 2) = '30') OR
                (ed.initialization_key ~ '(^|,)Summer Int(,|$)' AND RIGHT(sc.id::text, 2) = '50')
            )
        
        /* Handles joins to date based events */
        LEFT JOIN years
            ON ed.initialization_type = 'Date'
            AND TO_DATE(years.year || ' ' || ed.initialization_key, 'YYYY Month DD') <= current_date

        /* Will use this join to exclude instances if they've already been created. See where clause for filter. */
        LEFT JOIN {schema_name}.event_instances instances
            on instances.definition_index = ed.definition_index
            and instances.instance_period = 
                case 
                    when ed.initialization_type = 'Semester' then sc.id::text 
                    when ed.initialization_type = 'Date' then CAST(date_part('year', TO_DATE(years.year || ' ' || ed.initialization_key, 'YYYY Month DD')) AS text)
                end
                
        WHERE instances.instance_index is NULL
    ) bse
)
select 
    definition_index,
    event_name,
    initialization_key,
    initialization_range,
    instance_period
from unique_not_created_events
where current_date >= expected_start_date
and current_date <= expected_start_date + INTERVAL '80 days';
