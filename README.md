# SnowflakeRAGChatbot
This is a project guiding how to create a Chatbot using Snowflake, as outlined in [Tasty Bytes - RAG Chatbot Using Cortex and Streamlit quickstart](https://quickstarts.snowflake.com/guide/tasty_bytes_rag_chatbot_using_cortex_and_streamlit). The chatbot uses Snowflake's Cortex to access various LLMs and is displayed using Streamlit.

This projects also includes creation of the warehouse and database, as well as populating the database. 

A requirement of this project is that the user must have a Snowflake account to follow the setup. If the user doesn't have a Snowflake account, create a trial account [here](https://signup.snowflake.com/).

## Set up
1. In Snowsight, create a worksheet.
    - In the left pane, click on the Projects tab, then Worksheets. 
    - Click on `+` in the upper right to create a SQL worksheet. 
2. Copy the text in `Tasty Bytes Setup.sql` to the created worksheet. This outlines the database and warehouse  creation.
3. In the upper right, click on `Run All`
4. In Snowsight, create a Streamlit file.
    - In the left pane, click on the Projects tab, then Streamlit. 
    - Click on `+ Streamlit App` in the upper right to create a Streamlit file.
    - Connect to the previously create warehouse and database.
        - Database: `TASTY_BYTES_CHATBOT`
        - Schema: `APP`
        - Warehouse: `TASTY_BYTES_CHATBOT_WH`
5. In the packages tab, which can be found in the top of the editor pane, add `snowflake-ml-python`.
6. Copy the text in the `streamlit_app.py`.
7. Click on `Run` in the upper right corner.
8. Explore the generated Streamlit app.

## Exploration
In the preview pane, you should be able to see this view.
![Initial View](assets/Chatbot%20Initial%20View.PNG)

You can click on the Settings to choose the model that you want. You can also enter your message below in the message box.
![Sample Question](assets/Sample%20Question.PNG)