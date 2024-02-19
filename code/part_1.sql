/*1*/
/* Create the database `assignment 1`*/

create or replace database assignment_1;

/* Switch to the database `assignment 1`*/
use database assignment_1;


/*Create a storage integration called `azure_assginment_1`*/
CREATE OR REPLACE STORAGE INTEGRATION azure_assignment_1
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  AZURE_TENANT_ID = 'e8911c26-cf9f-4a9c-878e-527807be8791'
  STORAGE_ALLOWED_LOCATIONS = ('azure://thehaibui94.blob.core.windows.net/assignment1');


/*Use the `DESC STORAGE INTEGRATION` command to retrieve the `AZURE_CONSENT_URL*/

DESC STORAGE INTEGRATION azure_assignment_1;    

/*2. Loading data from Azure into Snowflake*/

/*2.1 Create a Stage called `stage_assignment_1` with:

*  STORAGE_INTEGRATION = azure_assignment_1
*  URL='azure://utsbde2.blob.core.windows.net/assignment1*/

CREATE OR REPLACE STAGE stage_assignment_1
STORAGE_INTEGRATION = azure_assignment_1
URL='azure://thehaibui.blob.core.windows.net/assignment1';

/*2.2. Use the command `1ist` to list all the files inside your stage:*/

list @stage_assignment_1;

/*3. Ingest the data as external tables on Snowflake*/
/*3.1* CSV file*/
/*Create a file format called `file_format_csv` with:

*  TYPE = 'CSV'
*  FIELD_DELIMITER = ','
*  SKIP_HEADER = 1
*  NULL_IF = ('\\N', 'NULL', 'NUL', '')
*  FIELD_OPTIONALLY_ENCLOSED_BY = '"'*/



CREATE OR REPLACE FILE FORMAT file_format_csv
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
NULL_IF = ('\\N', 'NULL', 'NUL', '')
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
;
/*Create an external table called `ex_table_youtube_trending` with:

*  LOCATION = @stage_assignment_1
*  FILE_FORMAT = file_format_csv
*  PATTERN = 'FR_youtube_trending_data.csv'
*/
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_trending
WITH LOCATION = @stage_assignment_1
FILE_FORMAT = file_format_csv
PATTERN = 'FR_youtube_trending_data.csv';

/*Display the ex_table_youtube_trending */
SELECT*FROM ex_table_youtube_trending;

/*3.2 json file*/
/*Create an external table called `ex_table_youtube_category` with:

*  LOCATION = @stage_assignment_1
*  FILE_FORMAT = file_format_csv
*  PATTERN = '.*_category_id[.]json'
*/
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_category
WITH LOCATION = @stage_assignment_1
FILE_FORMAT = (TYPE = JSON)
PATTERN = '.*_category_id[.]json';

/*Display the ex_table_youtube_category */
SELECT*FROM ex_table_youtube_category;


/*4. Transfer the data from external tables into tables */
/*a.	For trending data create a table called “table_youtube_trending” */

/*Display the first 2 rows */
SELECT *FROM ex_table_youtube_trending
LIMIT 2;

/*Recreate `ex_table_youtube_trending` with a new statement containing the correct data type and name for each columns.*/
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_trending
(
    VIDEO_ID STRING AS (value:c1::string),
    TITLE STRING AS (value:c2::string),
    PUBLISHEDATE TIMESTAMP AS (value:c3::timestamp),
    CHANNEL_ID STRING AS (value:c4::string),
    CHANNEL_TITLE STRING AS (value:c5::string),
    CATEGORY_ID INT AS (value:c6::int),
    TRENDING_DATE TIMESTAMP AS (value:c7::timestamp),
    VIEW_COUNT INT AS (value:c8::int),
    LIKES INT AS (value:c9::int),
    COMMENT_COUNT INT AS (value:c10::int),
    DISLIKES INT AS (value:c11::int),
    COMMENTS_DISABLED BOOLEAN AS (value:c12::boolean),
    COUNTRY STRING AS SUBSTRING(METADATA$FILENAME, 1, 2)
)
WITH LOCATION = @stage_assignment_1
FILE_FORMAT = file_format_csv
PATTERN = '[A-Z]{2}_youtube_trending_data.csv';

/*create table_youtube_trending from ex_table_youtube_trending */
CREATE OR REPLACE TABLE table_youtube_trending AS
SELECT VIDEO_ID,TITLE,PUBLISHEDATE,CHANNEL_ID,CHANNEL_TITLE,CATEGORY_ID,TRENDING_DATE,VIEW_COUNT,LIKES,DISLIKES,COMMENT_COUNT,COMMENTS_DISABLED,
COUNTRY
FROM ex_table_youtube_trending;

/*Display table_youtube_trending*/
SELECT*FROM table_youtube_trending;

/*b.	For category data create a table called “ex_table_youtube_category” */

/*Display the first 2 rows */
SELECT *FROM ex_table_youtube_category
LIMIT 2;

/*Copy the value and paste it into the website: https://codebeautify.org/jsonviewer*/

/*Use the `lateral flatten` function to retrieve the field `category_title` and'category id' from `ex_table_youtube_category` and limit to 10 rows*/

SELECT 
  l.value:id::string as CATEGORYID,
  l.value:snippet:title::string as CATEGORY_TITLE
FROM ex_table_youtube_category, LATERAL FLATTEN(value:items) l
LIMIT 10;

/*Query the metadata field `metadata$filename` from `ex_table_youtube_category` to retrieve the filename*/
SELECT
metadata$filename
FROM ex_table_youtube_category;

/*Use the split_part function on `metadata$filename` to retrieve the country name from the filename*/
SELECT
split_part(metadata$filename,'_', 1) as country
FROM ex_table_youtube_category;

/*Recreate `table_youtube_category_data` with a new statement containing the correct data type and name for each columns.*/
CREATE OR REPLACE TABLE table_youtube_category AS

SELECT 
    split_part(metadata$filename,'_', 1) AS COUNTRY,
    l.value:id::string as CATEGORYID,
    l.value:snippet:title::string as CATEGORY_TITLE
FROM ex_table_youtube_category, LATERAL FLATTEN(value:items) l;

/*Display `table_youtube_category_data`*/

SELECT * FROM table_youtube_category;


/*5.	Create a final table called “table_youtube_final” by combining “table_youtube_trending” and  “table_youtube_category” on country and categoryid (be careful to not lose any records), while adding a new field called “id” by using the “UUID_STRING()” function :*/

CREATE OR REPLACE TABLE table_youtube_final AS
SELECT 
    UUID_STRING() AS id,
    t.VIDEO_ID AS VIDEO_ID,
    t.TITLE AS TITLE,
    t.PUBLISHEDATE AS PUBLISHEDATE,
    t.CHANNEL_ID AS CHANNEL_ID,
    t.CHANNEL_TITLE AS CHANNEL_TITLE,
    t.CATEGORY_ID AS CATEGORY_ID,
    t.TRENDING_DATE AS TRENDING_DATE,
    t.VIEW_COUNT AS VIEW_COUNT,
    t.LIKES AS LIKES,
    t.DISLIKES AS DISLIKES,
    t.COMMENT_COUNT AS COMMENT_COUNT,
    t.COMMENTS_DISABLED AS COMMENTS_DISABLED,
    t.COUNTRY AS COUNTRY,
    c.CATEGORY_TITLE AS CATEGORY_TITLE
FROM table_youtube_trending t
LEFT JOIN table_youtube_category c
    ON t.COUNTRY = c.COUNTRY AND t.CATEGORY_ID = c.CATEGORYID;

/*Display `table_youtube_final*/
SELECT*FROM TABLE_YOUTUBE_FINAL;