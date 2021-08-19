from sqlalchemy import create_engine
import pandas as pd
from nltk.sentiment import SentimentIntensityAnalyzer

server = 'hxsqldev02\sql2016'
database = 'Academy_Dev_Data_RFlor'
driver = 'SQL Server'
engine = create_engine(f'mssql+pyodbc://{server}/{database}?driver={driver}')

# Obtengo a partir de los datos de la BD la información de todos los tweets,  quotes y replies para poder
# analizar la severidad de cada uno.
df_replies = pd.read_sql_query('SELECT * FROM fact_replies JOIN dim_wifi_providers dwp on fact_replies.rp_wifi_provider = dwp.wp_id', engine)
df_quotes = pd.read_sql_query('SELECT * FROM fact_quotes JOIN dim_wifi_providers dwp on fact_quotes.qu_wifi_provider = dwp.wp_id', engine)
df_tweets = pd.read_sql_query('SELECT * FROM fact_tweets JOIN dim_wifi_providers dwp on dwp.wp_id = fact_tweets.tw_wifi_provider', engine)

# Instancio al SentimentIntensityAnalyzer que me permite calcular la severidad
sia = SentimentIntensityAnalyzer()

# Aplico la función a cada dataframe
df_tweets['severity'] = df_tweets.apply(lambda row: sia.polarity_scores(str(row.tw_text))['compound'], axis=1)
df_replies['severity'] = df_replies.apply(lambda row: sia.polarity_scores(str(row.rp_text))['compound'], axis=1)
df_quotes['severity'] = df_quotes.apply(lambda row: sia.polarity_scores(str(row.qu_text))['compound'], axis=1)

# Creo un dataframe que concentre toda la información
df_severity = pd.DataFrame(columns=['wp_name', 'severity'])
df_severity = df_severity.append(df_tweets[['wp_name', 'severity']])
df_severity = df_severity.append(df_replies[['wp_name', 'severity']])
df_severity = df_severity.append(df_quotes[['wp_name', 'severity']])

# Droppeo los que sean mayores iguales a 0
index_names = df_severity[df_severity['severity'] >= 0].index

df_severity.drop(index_names, inplace=True)

# Agrupo el dataframe por empresa y calculo el promedio
df_severity = df_severity.groupby(by="wp_name", dropna=True).mean()

print(df_severity)
