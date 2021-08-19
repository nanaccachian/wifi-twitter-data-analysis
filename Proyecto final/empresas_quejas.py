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
total = 7248280

df_totales.loc[df_totales.index[2], 'cant_usuarios'] = fib_tot = 0.46*total
df_totales.loc[df_totales.index[1], 'cant_usuarios'] = fib_tot = 0.01*total
df_totales.loc[df_totales.index[7], 'cant_usuarios'] = fib_tot = 0.17*total
df_totales.loc[df_totales.index[9], 'cant_usuarios'] = fib_tot = 0.12*total

df_totales['total'] = df_totales.apply(lambda row: row.cant_tweets + row.cant_replies + row.cant_quotes + row.cant_rts, axis=1)
df_totales['porcentaje'] = df_totales.apply(lambda row: "{:.3%}".format(row.total / row.cant_usuarios), axis=1)
print(df_totales)

