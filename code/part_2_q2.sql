/*2.	In “table_youtube_category” which category_title only appears in one country?*/

SELECT CATEGORY_TITLE FROM table_youtube_category
GROUP BY CATEGORY_TITLE
HAVING COUNT(DISTINCT COUNTRY)=1;
