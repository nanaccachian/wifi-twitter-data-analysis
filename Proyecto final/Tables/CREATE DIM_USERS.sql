CREATE TABLE dbo.dim_users (
	us_id BIGINT PRIMARY KEY,
	us_name NVARCHAR(60),
	us_verified BIT,
	us_followers BIGINT
)