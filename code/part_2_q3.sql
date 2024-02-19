/*3.	In “table_youtube_final”, what is the categoryid of the missing category_title*/

SELECT DISTINCT category_id
FROM table_youtube_final
HAVING category_title IS NULL;
