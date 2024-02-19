/*3.	For each country, year and month (in a single column), which video is the most viewed and what is its likes_ratio (defined as the percentage of likes against view_count) truncated to 2 decimals. Order the result by year_month and country. */
WITH VideoStats AS (
    SELECT
        country,
        EXTRACT(YEAR FROM trending_date) AS year,
        EXTRACT(MONTH FROM trending_date) AS month,
        video_id,
        title,
        channel_title,
        category_title,
        view_count,
        likes,
        dislikes,
        CASE
            WHEN view_count = 0 THEN 0
            ELSE ROUND((likes::NUMERIC / view_count) * 100, 2)
        END AS likes_ratio,
        RANK() OVER (PARTITION BY country, EXTRACT(YEAR FROM trending_date), EXTRACT(MONTH FROM trending_date) ORDER BY view_count DESC) AS video_rank
    FROM
        table_youtube_final
)
SELECT
    country,
    TO_DATE(year || '-' || TO_CHAR(month, 'FM00') || '-01', 'YYYY-MM-DD') AS year_month,
    title,
    channel_title AS CHANNELTITLE,
    category_title,
    view_count,
    likes_ratio
FROM
    VideoStats
WHERE
    video_rank = 1
ORDER BY
    year_month,
    country;
