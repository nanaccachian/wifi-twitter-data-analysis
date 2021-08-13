CREATE TABLE dbo.dim_times (
	ti_id int PRIMARY KEY IDENTITY(1,1),
	ti_hour tinyint,
	ti_min tinyint,
	ti_sec tinyint,
	ti_part_of_day nvarchar(15)
)