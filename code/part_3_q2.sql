/*2.	For each country, count the number of distinct video with a title containing the word “BTS” and order the result by count in a descending order, e.g:*/

SELECT
    country,
    COUNT(DISTINCT VIDEO_ID) AS CT
FROM
    table_youtube_final
WHERE
    title LIKE '%BTS%'
GROUP BY
    country
ORDER BY
    CT DESC;
