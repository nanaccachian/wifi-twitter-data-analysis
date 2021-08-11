CREATE TABLE dbo.fact_tweets (
	tw_id BIGINT PRIMARY KEY,
	tw_created_at INT NOT NULL,
	tw_text NVARCHAR(250) NOT NULL,
	tw_user BIGINT NOT NULL,
	tw_wifi_provider INT,
	tw_severity INT
)

ALTER TABLE dbo.fact_tweets
ADD FOREIGN KEY (tw_created_at) REFERENCES dbo.dim_datetimes(ti_id); 

ALTER TABLE dbo.fact_tweets
ADD FOREIGN KEY (tw_user) REFERENCES dbo.dim_users(us_id); 

ALTER TABLE dbo.fact_tweets
ADD FOREIGN KEY (tw_wifi_provider) REFERENCES dbo.dim_wifi_providers(wp_id); 