/*8.	Delete the duplicates in “table_youtube_final“ by using “table_youtube_duplicates”.*/

DELETE FROM table_youtube_final
WHERE ID IN (SELECT ID FROM table_youtube_duplicates);
