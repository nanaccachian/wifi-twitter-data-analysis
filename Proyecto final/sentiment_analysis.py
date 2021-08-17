import pyodbc
import sqlalchemy as sal
from sqlalchemy import create_engine
import pandas as pd

server = 'hxsqldev02\sql2016'
database = 'Academy_Dev_Data_RFlor'
driver = 'SQL Server'
engine = sal.create_engine(f'mssql://{server}/{database}?driver={driver}')

conn = engine.connect()