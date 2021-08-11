CREATE TABLE dbo.fact_quotes (
	qu_id BIGINT PRIMARY KEY,
	qu_tweet_id BIGINT NOT NULL,
	qu_created_at INT NOT NULL,
	qu_text NVARCHAR(250) NOT NULL,
	qu_user BIGINT NOT NULL,
	qu_wifi_provider INT, /* HACER TRIGGER PARA QUE LO COMPLETE AUTOMATICAMENTE */
)

ALTER TABLE dbo.fact_quotes
ADD FOREIGN KEY (qu_created_at) REFERENCES dbo.dim_datetimes(ti_id); 

ALTER TABLE dbo.fact_quotes
ADD FOREIGN KEY (qu_user) REFERENCES dbo.dim_users(us_id); 

ALTER TABLE dbo.fact_quotes
ADD FOREIGN KEY (qu_wifi_provider) REFERENCES dbo.dim_wifi_providers(wp_id); 

ALTER TABLE dbo.fact_quotes
ADD FOREIGN KEY (qu_tweet_id) REFERENCES dbo.fact_tweets(tw_id); 