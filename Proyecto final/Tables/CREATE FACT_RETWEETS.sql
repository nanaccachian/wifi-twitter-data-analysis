CREATE TABLE dbo.fact_retweets (
	rt_id BIGINT PRIMARY KEY,
	rt_tweet_id BIGINT NOT NULL,
	rt_created_at INT NOT NULL,
	rt_user BIGINT NOT NULL,
	rt_wifi_provider INT, /* HACER TRIGGER PARA QUE LO COMPLETE AUTOMATICAMENTE */
)

ALTER TABLE dbo.fact_retweets
ADD FOREIGN KEY (rt_created_at) REFERENCES dbo.dim_datetimes(ti_id); 

ALTER TABLE dbo.fact_retweets
ADD FOREIGN KEY (rt_user) REFERENCES dbo.dim_users(us_id); 

ALTER TABLE dbo.fact_retweets
ADD FOREIGN KEY (rt_wifi_provider) REFERENCES dbo.dim_wifi_providers(wp_id); 

ALTER TABLE dbo.fact_retweets
ADD FOREIGN KEY (rt_tweet_id) REFERENCES dbo.fact_tweets(tw_id); 