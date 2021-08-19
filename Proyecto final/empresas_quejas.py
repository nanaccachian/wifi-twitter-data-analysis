from sqlalchemy import create_engine
import pandas as pd
server = 'hxsqldev02\sql2016'
database = 'Academy_Dev_Data_RFlor'
driver = 'SQL Server'
engine = create_engine(f'mssql+pyodbc://{server}/{database}?driver={driver}')

df_totales = pd.read_sql_query("""SELECT 
                                        wp_name as 'nombre',
                                        (SELECT COUNT(*) FROM dbo.fact_tweets where tw_wifi_provider = wp_id) as 'cant_tweets',
                                        (SELECT COUNT(*) FROM dbo.fact_retweets where rt_wifi_provider = wp_id) as 'cant_rts',
                                        (SELECT COUNT(*) FROM dbo.fact_quotes where qu_wifi_provider = wp_id) as 'cant_quotes',
                                        (SELECT COUNT(*) FROM dbo.fact_replies where rp_wifi_provider = wp_id) as 'cant_replies'
                                  FROM dbo.dim_wifi_providers
                                  ORDER BY 1 """, engine)

df_totales['total'] = df_totales.apply(lambda row: row.cant_tweets + row.cant_replies + row.cant_quotes + row.cant_rts,axis=1)

print(df_totales)

