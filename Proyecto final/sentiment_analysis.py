import pyodbc
import sqlalchemy as sal
from sqlalchemy import create_engine
import pandas as pd

server = 'hxsqldev02\sql2016'
database = 'Academy_Dev_Data_RFlor'
driver = 'SQL Server'
engine = create_engine(f'mssql+pyodbc://{server}/{database}?driver={driver}')
conn = engine.connect()

df_replies = pd.read_sql_query('SELECT * FROM fact_quotes', engine)
print(df_replies.describe())
df_quotes = pd.read_sql_query('SELECT * FROM fact_retweets', engine)
print(df_quotes.describe())
df_retweets = pd.read_sql_query('SELECT * FROM fact_replies', engine)
print(df_retweets.describe())
df_tweets = pd.read_sql_query('SELECT * FROM fact_tweets', engine)
print(df_tweets.describe())




