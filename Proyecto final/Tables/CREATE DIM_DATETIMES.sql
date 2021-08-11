CREATE TABLE dbo.dim_datetimes (
	ti_id INT PRIMARY KEY IDENTITY(1,1),
	ti_year DECIMAL(4,0),
	ti_month DECIMAL(2,0),
	ti_day DECIMAL(2,0),
	ti_time TIME
)