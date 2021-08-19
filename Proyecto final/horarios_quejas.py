from sqlalchemy import create_engine
import pandas as pd
import matplotlib.pyplot as plt

server = 'hxsqldev02\sql2016'
database = 'Academy_Dev_Data_RFlor'
driver = 'SQL Server'
engine = create_engine(f'mssql+pyodbc://{server}/{database}?driver={driver}')

df_horarios = pd.read_sql_query("""SELECT 
                                        wp_name as 'nombre',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_tweets
                                            JOIN dim_times dt on fact_tweets.tw_time = dt.ti_id
                                            where tw_wifi_provider = wp_id AND ti_hour >= 0 and ti_hour <= 5) as 'cant_madrugada',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_tweets
                                            JOIN dim_times dt on fact_tweets.tw_time = dt.ti_id
                                            where tw_wifi_provider = wp_id AND ti_hour >= 6 and ti_hour <= 12) as 'cant_maniana',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_tweets
                                            JOIN dim_times dt on fact_tweets.tw_time = dt.ti_id
                                            where tw_wifi_provider = wp_id AND ti_hour >= 13 and ti_hour <= 18) as 'cant_tarde',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_tweets
                                            JOIN dim_times dt on fact_tweets.tw_time = dt.ti_id
                                            where tw_wifi_provider = wp_id AND ti_hour >= 19 and ti_hour <= 23) as 'cant_noche'
                                  FROM dbo.dim_wifi_providers
                                  ORDER BY 1 """, engine)

df_rt_horarios = pd.read_sql_query("""SELECT 
                                        wp_name as 'nombre',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_retweets
                                            JOIN dim_times dt on fact_retweets.rt_time = dt.ti_id
                                            where rt_wifi_provider = wp_id AND ti_hour >= 0 and ti_hour <= 5) as 'cant_madrugada',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_retweets
                                            JOIN dim_times dt on fact_retweets.rt_time = dt.ti_id
                                            where rt_wifi_provider = wp_id AND ti_hour >= 6 and ti_hour <= 12) as 'cant_maniana',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_retweets
                                            JOIN dim_times dt on fact_retweets.rt_time = dt.ti_id
                                            where rt_wifi_provider = wp_id AND ti_hour >= 13 and ti_hour <= 18) as 'cant_tarde',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_retweets
                                            JOIN dim_times dt on fact_retweets.rt_time = dt.ti_id
                                            where rt_wifi_provider = wp_id AND ti_hour >= 19 and ti_hour <= 23) as 'cant_noche'
                                  FROM dbo.dim_wifi_providers
                                  ORDER BY 1 """, engine)
df_rt_horarios = pd.read_sql_query("""SELECT 
                                        wp_name as 'nombre',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_retweets
                                            JOIN dim_times dt on fact_retweets.rt_time = dt.ti_id
                                            where rt_wifi_provider = wp_id AND ti_hour >= 0 and ti_hour <= 5) as 'cant_madrugada',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_retweets
                                            JOIN dim_times dt on fact_retweets.rt_time = dt.ti_id
                                            where rt_wifi_provider = wp_id AND ti_hour >= 6 and ti_hour <= 12) as 'cant_maniana',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_retweets
                                            JOIN dim_times dt on fact_retweets.rt_time = dt.ti_id
                                            where rt_wifi_provider = wp_id AND ti_hour >= 13 and ti_hour <= 18) as 'cant_tarde',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_retweets
                                            JOIN dim_times dt on fact_retweets.rt_time = dt.ti_id
                                            where rt_wifi_provider = wp_id AND ti_hour >= 19 and ti_hour <= 23) as 'cant_noche'
                                  FROM dbo.dim_wifi_providers
                                  ORDER BY 1 """, engine)
df_rp_horarios = pd.read_sql_query("""SELECT 
                                        wp_name as 'nombre',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_replies
                                            JOIN dim_times dt on fact_replies.rp_time = dt.ti_id
                                            where rp_wifi_provider = wp_id AND ti_hour >= 0 and ti_hour <= 5) as 'cant_madrugada',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_replies
                                            JOIN dim_times dt on fact_replies.rp_time = dt.ti_id
                                            where rp_wifi_provider = wp_id AND ti_hour >= 6 and ti_hour <= 12) as 'cant_maniana',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_replies
                                            JOIN dim_times dt on fact_replies.rp_time = dt.ti_id
                                            where rp_wifi_provider = wp_id AND ti_hour >= 13 and ti_hour <= 18) as 'cant_tarde',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_replies
                                            JOIN dim_times dt on fact_replies.rp_time = dt.ti_id
                                            where rp_wifi_provider = wp_id AND ti_hour >= 19 and ti_hour <= 23) as 'cant_noche'
                                  FROM dbo.dim_wifi_providers
                                  ORDER BY 1 """, engine)

df_qu_horarios = pd.read_sql_query("""SELECT 
                                        wp_name as 'nombre',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_quotes
                                            JOIN dim_times dt on fact_quotes.qu_time = dt.ti_id
                                            where qu_wifi_provider = wp_id AND ti_hour >= 0 and ti_hour <= 5) as 'cant_madrugada',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_quotes
                                            JOIN dim_times dt on fact_quotes.qu_time = dt.ti_id
                                            where qu_wifi_provider = wp_id AND ti_hour >= 6 and ti_hour <= 12) as 'cant_maniana',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_quotes
                                            JOIN dim_times dt on fact_quotes.qu_time = dt.ti_id
                                            where qu_wifi_provider = wp_id AND ti_hour >= 13 and ti_hour <= 18) as 'cant_tarde',
                                        (SELECT COUNT(*) 
                                            FROM dbo.fact_quotes
                                            JOIN dim_times dt on fact_quotes.qu_time = dt.ti_id
                                            where qu_wifi_provider = wp_id AND ti_hour >= 19 and ti_hour <= 23) as 'cant_noche'
                                  FROM dbo.dim_wifi_providers
                                  ORDER BY 1 """, engine)

df_horarios = df_horarios.append(df_rt_horarios)
df_horarios = df_horarios.append(df_rp_horarios)
df_horarios = df_horarios.append(df_qu_horarios)
df_horarios = df_horarios.groupby(by='nombre').sum()

df_horarios.sort_values('cant_madrugada',inplace=True)

df_horarios.plot(kind='bar',
             stacked=False,
             figsize=(20, 10))

plt.title('Cantidad de tweets por hora por empresa')
plt.ylabel('Empresa')
plt.xlabel('Cantidad')

plt.show()
