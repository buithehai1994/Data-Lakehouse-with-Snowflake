WITH VideoStats AS (
    SELECT
        country,
        category_title,
        RANK() OVER (PARTITION BY country, EXTRACT(YEAR FROM trending_date), EXTRACT(MONTH FROM trending_date) ORDER BY view_count DESC) AS video_rank
    FROM
        table_youtube_final
    WHERE
        category_title NOT IN ('Music', 'Entertainment')
)
SELECT
    country,
    category_title,
    COUNT(*) AS top_ranked_videos_count
FROM
    VideoStats
WHERE
    video_rank = 1
GROUP BY
    country,
    category_title
ORDER BY
    country,
    top_ranked_videos_count DESC;
