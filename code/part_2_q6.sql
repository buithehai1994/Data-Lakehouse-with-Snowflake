/*6.	Delete from “table_youtube_final“, any record with video_id = “#NAME?”*/
/*The “table_youtube_final“ contains duplicates with the same video_id, country and trending_date however their metrics (likes, dislikes, etc..) can be different. E.g:.We can assume that the highest number of view_count will be the record to keep when we have duplicates.*/


DELETE FROM table_youtube_final
WHERE video_id = '#NAME?';
