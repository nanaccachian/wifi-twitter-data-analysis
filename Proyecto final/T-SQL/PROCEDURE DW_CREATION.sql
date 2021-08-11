CREATE PROCEDURE dbo.dw_creation
AS

CREATE TABLE dbo.dim_datetimes (
	ti_id INT PRIMARY KEY IDENTITY(1,1),
	ti_year DECIMAL(4,0),
	ti_month DECIMAL(2,0),
	ti_day DECIMAL(2,0),
	ti_time TIME
)

CREATE TABLE dbo.dim_users (
	us_id BIGINT PRIMARY KEY,
	us_name NVARCHAR(60),
	us_verified BIT,
	us_followers BIGINT
)

CREATE TABLE dbo.dim_wifi_providers (
	wp_id INT PRIMARY KEY IDENTITY(1,1),
	wp_name NVARCHAR(30),
	wp_num_users BIGINT
)

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