/***************************************************************************************************
  _______           _            ____          _             
 |__   __|         | |          |  _ \        | |            
    | |  __ _  ___ | |_  _   _  | |_) | _   _ | |_  ___  ___ 
    | | / _` |/ __|| __|| | | | |  _ < | | | || __|/ _ \/ __|
    | || (_| |\__ \| |_ | |_| | | |_) || |_| || |_|  __/\__ \
    |_| \__,_||___/ \__| \__, | |____/  \__, | \__|\___||___/
                          __/ |          __/ |               
                         |___/          |___/            
Quickstart:   Tasty Bytes - RAG Chatbot Using Cortex and Streamlit
Copyright(c): 2025 Snowflake Inc. All rights reserved.
****************************************************************************************************/

USE ROLE sysadmin;

/*--
 • database, schema and warehouse creation
--*/

-- Database
CREATE OR REPLACE DATABASE tasty_bytes_chatbot;

--Schema
CREATE OR REPLACE SCHEMA tasty_bytes_chatbot.app;

--Warehouse
CREATE OR REPLACE WAREHOUSE tasty_bytes_chatbot_wh
    WAREHOUSE_SIZE = 'large'
    WAREHOUSE_TYPE = 'standard'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
COMMENT = 'chatbot warehouse for tasty bytes';

USE WAREHOUSE tasty_bytes_chatbot_wh;

/*--
 • loading data
--*/

CREATE OR REPLACE FILE FORMAT tasty_bytes_chatbot.app.csv_ff 
TYPE = 'csv';

CREATE OR REPLACE STAGE tasty_bytes_chatbot.app.s3load
COMMENT = 'Quickstarts S3 Stage Connection'
url = 's3://sfquickstarts/tastybytes-cx/app/'
file_format = tasty_bytes_chatbot.app.csv_ff;

CREATE OR REPLACE TABLE tasty_bytes_chatbot.app.documents (
	RELATIVE_PATH VARCHAR(16777216),
	RAW_TEXT VARCHAR(16777216)
)
COMMENT = '{"origin":"sf_sit-is", "name":"voc", "version":{"major":1, "minor":0}, "attributes":{"is_quickstart":1, "source":"streamlit", "vignette":"rag_chatbot"}}';

COPY INTO tasty_bytes_chatbot.app.documents
FROM @tasty_bytes_chatbot.app.s3load/documents/;

-- https://docs.snowflake.com/en/sql-reference/data-types-vector#loading-and-unloading-vector-data
CREATE OR REPLACE TABLE tasty_bytes_chatbot.app.array_table (
  SOURCE VARCHAR(6),
	SOURCE_DESC VARCHAR(16777216),
	FULL_TEXT VARCHAR(16777216),
	SIZE NUMBER(18,0),
	CHUNK VARCHAR(16777216),
	INPUT_TEXT VARCHAR(16777216),
	CHUNK_EMBEDDING ARRAY
);

COPY INTO tasty_bytes_chatbot.app.array_table
FROM @tasty_bytes_chatbot.app.s3load/vector_store/;

CREATE OR REPLACE TABLE tasty_bytes_chatbot.app.vector_store (
	SOURCE VARCHAR(6),
	SOURCE_DESC VARCHAR(16777216),
	FULL_TEXT VARCHAR(16777216),
	SIZE NUMBER(18,0),
	CHUNK VARCHAR(16777216),
	INPUT_TEXT VARCHAR(16777216),
	CHUNK_EMBEDDING VECTOR(FLOAT, 768)
) AS
SELECT 
  source,
	source_desc,
	full_text,
	size,
	chunk,
	input_text,
  chunk_embedding::VECTOR(FLOAT, 768)
FROM tasty_bytes_chatbot.app.array_table;

-- display all snowflake cortex models
SHOW MODELS IN SNOWFLAKE.CORTEX;

-- check the region
SELECT CURRENT_REGION();

-- using AWS (Cross-Region)
USE ROLE accountadmin;
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';

-- display all snowflake cortex models
SHOW MODELS IN SNOWFLAKE.CORTEX;

SHOW MODELS;