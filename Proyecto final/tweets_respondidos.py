from sqlalchemy import create_engine
import pandas as pd
import codecs

server = 'hxsqldev02\sql2016'
database = 'Academy_Dev_Data_RFlor'
driver = 'SQL Server'
engine = create_engine(f'mssql+pyodbc://{server}/{database}?driver={driver}')

codecs.register_error("strict", codecs.ignore_errors)

df_tweets = pd.read_sql_query('SELECT * FROM fact_tweets JOIN dim_wifi_providers dwp on dwp.wp_id = fact_tweets.tw_wifi_provider', engine)
df_replies = pd.read_sql_query('SELECT * FROM fact_replies JOIN dim_wifi_providers dwp on fact_replies.rp_wifi_provider = dwp.wp_id JOIN dim_users du on du.us_id = fact_replies.rp_user', engine)

df_users = pd.read_sql_query('SELECT * FROM dim_users WHERE us_verified = 1', engine)

wifi_providers = ['Movistar','Fibertel','DIRECTV','Claro','Iptel','Telecentro','Gigared','Metrotel','Sion','Telefonica','Personal','Telecom']

df_users = df_users[df_users['us_name'].str.contains("|".join(wifi_providers))]['us_id']

df_replies = df_replies[df_replies['us_name'].str.contains("|".join(wifi_providers))]

df_tweets = df_tweets.groupby(by='wp_name').count()['tw_id']

df_replies = (df_replies.groupby(by='wp_name').count()['rp_id'] / df_tweets) * 100

print(df_replies.dropna())
