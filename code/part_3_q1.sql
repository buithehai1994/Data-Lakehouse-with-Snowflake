/*1.	What are the 3 most viewed videos for each country in the “Sports” category for the trending_date = ‘'2021-10-17'’. Order the result by country and the rank, e.g:*/

SELECT
    country,
    title,
    channel_title,
    view_count,
    RANK() OVER (PARTITION BY country ORDER BY view_count DESC) AS RK
FROM
    table_youtube_final
WHERE
    category_title = 'Sports'
    AND trending_date = '2021-10-17'
QUALIFY
    RK <= 3
ORDER BY
    country,
    RK;
