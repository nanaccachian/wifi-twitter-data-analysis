CREATE TABLE dbo.dim_wifi_providers (
	wp_id INT PRIMARY KEY IDENTITY(1,1),
	wp_name NVARCHAR(30),
	wp_num_users BIGINT
)