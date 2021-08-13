CREATE TABLE dbo.dim_dates (
	dt_id INT PRIMARY KEY IDENTITY(1,1),
	dt_year DECIMAL(4,0),
	dt_month DECIMAL(2,0),
	dt_day DECIMAL(2,0)
)