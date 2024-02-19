/*4.	For each country, which category_title has the most distinct videos and what is its percentage (2 decimals) out of the total distinct number of videos of that country? Order the result by category_title and country.*/

WITH VideoCategories AS (
    SELECT
        country,
        category_title,
        COUNT(DISTINCT video_id) AS total_category_video
    FROM
        table_youtube_final
    GROUP BY
        country,
        category_title
),
TotalCountryVideos AS (
    SELECT
        country,
        COUNT(DISTINCT video_id) AS total_country_video
    FROM
        table_youtube_final
    GROUP BY
        country
)
SELECT
    vc.country,
    vc.category_title,
    vc.total_category_video,
    tc.total_country_video,
    ROUND((vc.total_category_video::NUMERIC / tc.total_country_video) * 100, 2) AS percentage
FROM
    VideoCategories vc
JOIN
    TotalCountryVideos tc
ON
    vc.country = tc.country
WHERE
    (vc.country, vc.total_category_video) IN (
        SELECT
            country,
            MAX(total_category_video)
        FROM
            VideoCategories
        GROUP BY
            country
    )
ORDER BY
    vc.country,
    vc.category_title;
