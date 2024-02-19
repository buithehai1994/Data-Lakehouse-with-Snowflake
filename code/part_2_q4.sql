/*4.	Update the table_youtube_final to replace the NULL values in category_title with the answer from the previous question.*/
UPDATE table_youtube_final
SET category_title = (
    SELECT CATEGORY_TITLE FROM table_youtube_category
    GROUP BY CATEGORY_TITLE
    HAVING COUNT(DISTINCT COUNTRY)=1
)
WHERE category_title IS NULL;
