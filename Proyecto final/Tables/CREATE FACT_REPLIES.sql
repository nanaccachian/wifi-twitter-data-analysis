CREATE TABLE dbo.fact_replies (
	rp_id BIGINT PRIMARY KEY,
	rp_tweet_id BIGINT NOT NULL,
	rp_created_at INT NOT NULL,
	rp_text NVARCHAR(250) NOT NULL,
	rp_user BIGINT NOT NULL,
	rp_wifi_provider INT, /* HACER TRIGGER PARA QUE LO COMPLETE AUTOMATICAMENTE */
)

ALTER TABLE dbo.fact_replies
ADD FOREIGN KEY (rp_created_at) REFERENCES dbo.dim_datetimes(ti_id); 

ALTER TABLE dbo.fact_replies
ADD FOREIGN KEY (rp_user) REFERENCES dbo.dim_users(us_id); 

ALTER TABLE dbo.fact_replies
ADD FOREIGN KEY (rp_wifi_provider) REFERENCES dbo.dim_wifi_providers(wp_id); 

ALTER TABLE dbo.fact_replies
ADD FOREIGN KEY (rp_tweet_id) REFERENCES dbo.fact_tweets(tw_id); 