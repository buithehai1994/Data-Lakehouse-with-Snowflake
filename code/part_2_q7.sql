/*7.Create a new table called “table_youtube_duplicates”  containing only the “bad” duplicates by using the row_number() function*/
CREATE OR REPLACE TABLE table_youtube_duplicates AS
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY video_id, country, trending_date ORDER BY view_count desc) AS row_num
    FROM table_youtube_final
) AS duplicates
WHERE row_num > 1;

select*from table_youtube_duplicates;
