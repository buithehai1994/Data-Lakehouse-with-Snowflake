/*5.	Which channeltitle has produced the most distinct videos and what is this number? */
WITH ChannelVideoCounts AS (
    SELECT
        channel_title,
        COUNT(DISTINCT video_id) AS distinct_video_count
    FROM
        table_youtube_final
    GROUP BY
        channel_title
)
SELECT
    channel_title,
    distinct_video_count
FROM
    ChannelVideoCounts
WHERE
    distinct_video_count = (SELECT MAX(distinct_video_count) FROM ChannelVideoCounts);