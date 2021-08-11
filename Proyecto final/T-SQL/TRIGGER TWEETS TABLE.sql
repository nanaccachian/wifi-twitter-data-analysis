CREATE TRIGGER [dbo].[raw_tweets_to_DW] ON [dbo].[raw_tweets] AFTER INSERT
AS

INSERT INTO dbo.dim_users 
	SELECT 
		CONVERT(BIGINT,tw_user_id),
		tw_user_name,
		CASE WHEN tw_user_verified ='true' THEN 1 ELSE 0 END,
		tw_user_follower 
	FROM inserted 
	WHERE tw_user_id NOT IN (SELECT us_id FROM dbo.dim_users)

INSERT INTO dbo.dim_users 
	SELECT 
		CONVERT(BIGINT,tw_qu_user_id), 
		tw_qu_user_name, 
		CASE WHEN tw_qu_user_verified = 'true' THEN 1 ELSE 0 END, 
		tw_qu_user_follower 
	FROM inserted 
	WHERE tw_qu_user_id NOT IN (SELECT us_id FROM dbo.dim_users)

INSERT INTO dbo.dim_users 
	SELECT
		CONVERT(BIGINT,tw_rt_user_id), 
		tw_rt_user_name, 
		CASE WHEN tw_rt_user_verified ='true' THEN 1 ELSE 0 END, 
		tw_rt_user_follower 
	FROM inserted 
	WHERE tw_rt_user_id NOT IN (SELECT us_id FROM dbo.dim_users)

INSERT INTO dbo.dim_datetimes
	SELECT 
		CONVERT(DECIMAL(4,0),SUBSTRING(tw_created_at,27,4)),
		dbo.month_to_num(SUBSTRING(tw_created_at,5,3)),
		CONVERT(DECIMAL(2,0),SUBSTRING(tw_created_at,9,2)),
		CAST(SUBSTRING(tw_created_at,12,8) AS time)
	FROM inserted
	WHERE 
		LTRIM(STR(CAST(SUBSTRING(tw_created_at,9,2) AS INT)))+CONVERT(NVARCHAR(2),dbo.month_to_num(SUBSTRING(tw_created_at,5,3)))+SUBSTRING(tw_created_at,27,4)+SUBSTRING(tw_created_at,12,8)	 
		NOT IN (SELECT LTRIM(STR(ti_day))+LTRIM(STR(ti_month))+LTRIM(STR(ti_year))+CONVERT(NVARCHAR(8),ti_time) FROM dbo.dim_datetimes)

INSERT INTO dbo.dim_datetimes 
	SELECT 
		CONVERT(DECIMAL(4,0),SUBSTRING(tw_qu_created_at,27,4)),
		dbo.month_to_num(SUBSTRING(tw_qu_created_at,5,3)),
		CONVERT(DECIMAL(2,0),SUBSTRING(tw_qu_created_at,9,2)),
		CAST(SUBSTRING(tw_qu_created_at,12,8) AS time)
	FROM inserted
	WHERE 
		LTRIM(STR(CAST(SUBSTRING(tw_qu_created_at,9,2) AS INT)))+CONVERT(NVARCHAR(2),dbo.month_to_num(SUBSTRING(tw_qu_created_at,5,3)))+SUBSTRING(tw_qu_created_at,27,4)+SUBSTRING(tw_qu_created_at,12,8)	 
		NOT IN (SELECT LTRIM(STR(ti_day))+LTRIM(STR(ti_month))+LTRIM(STR(ti_year))+CONVERT(NVARCHAR(8),ti_time) FROM dbo.dim_datetimes)

INSERT INTO dbo.dim_datetimes 
	SELECT 
		CONVERT(DECIMAL(4,0),SUBSTRING(tw_rt_created_at,27,4)),
		dbo.month_to_num(SUBSTRING(tw_rt_created_at,5,3)),
		CONVERT(DECIMAL(2,0),SUBSTRING(tw_rt_created_at,9,2)),
		CAST(SUBSTRING(tw_rt_created_at,12,8) AS time)
	FROM inserted
	WHERE 
		LTRIM(STR(CAST(SUBSTRING(tw_rt_created_at,9,2) AS INT)))+CONVERT(NVARCHAR(2),dbo.month_to_num(SUBSTRING(tw_rt_created_at,5,3)))+SUBSTRING(tw_rt_created_at,27,4)+SUBSTRING(tw_rt_created_at,12,8)	 
		NOT IN (SELECT LTRIM(STR(ti_day))+LTRIM(STR(ti_month))+LTRIM(STR(ti_year))+CONVERT(NVARCHAR(8),ti_time) FROM dbo.dim_datetimes)


INSERT INTO dbo.fact_tweets (tw_id,tw_created_at,tw_text,tw_user)
	SELECT
		tw_id,
		(SELECT TOP 1 ti_id FROM dbo.dim_datetimes 
			WHERE CAST(SUBSTRING(tw_created_at,9,2) AS INT) = ti_day 
					AND dbo.month_to_num(SUBSTRING(tw_created_at,5,3)) = ti_month
					AND CAST(SUBSTRING(tw_created_at,27,4) AS INT) = ti_year
					AND CAST(SUBSTRING(tw_created_at,12,8) AS TIME) = ti_time),
		CASE WHEN tw_truncated = 'false' THEN tw_text ELSE tw_full_text END,
		tw_user_id
	FROM inserted
	WHERE (tw_reply_id = '' OR tw_reply_id IS NULL) AND (tw_qu_id = '' OR tw_qu_id IS NULL) AND (tw_rt_id = '' OR tw_rt_id IS NULL)

/* INSERTA EN TWEETS LOS QUOTED TWEETS) */
INSERT INTO dbo.fact_tweets (tw_id,tw_created_at,tw_text,tw_user)
	SELECT
		tw_qu_id,
		(SELECT TOP 1 ti_id FROM dbo.dim_datetimes 
			WHERE CAST(SUBSTRING(tw_qu_created_at,9,2) AS INT) = ti_day 
					AND dbo.month_to_num(SUBSTRING(tw_qu_created_at,5,3)) = ti_month
					AND CAST(SUBSTRING(tw_qu_created_at,27,4) AS INT) = ti_year
					AND CAST(SUBSTRING(tw_qu_created_at,12,8) AS TIME) = ti_time),
		CASE WHEN tw_qu_truncated = 'false' THEN tw_qu_text ELSE tw_qu_full_text END,
		tw_qu_user_id
	FROM inserted
	WHERE tw_qu_id NOT IN (SELECT tw_id FROM dbo.fact_tweets)

/* INSERTA EN TWEETS LOS RETWEETED TWEETS) */
INSERT INTO dbo.fact_tweets (tw_id,tw_created_at,tw_text,tw_user)
	SELECT
		tw_rt_id,
		(SELECT TOP 1 ti_id FROM dbo.dim_datetimes 
			WHERE CAST(SUBSTRING(tw_rt_created_at,9,2) AS INT) = ti_day 
					AND dbo.month_to_num(SUBSTRING(tw_rt_created_at,5,3)) = ti_month
					AND CAST(SUBSTRING(tw_rt_created_at,27,4) AS INT) = ti_year
					AND CAST(SUBSTRING(tw_rt_created_at,12,8) AS TIME) = ti_time),
		CASE WHEN tw_rt_truncated = 'false' THEN tw_rt_text ELSE tw_rt_full_text END,
		tw_rt_user_id
	FROM inserted
	WHERE tw_rt_id NOT IN (SELECT tw_id FROM dbo.fact_tweets)

INSERT INTO dbo.fact_replies (rp_id,rp_tweet_id,rp_created_at,rp_text,rp_user)
	SELECT
		tw_id,
		tw_reply_id,
		(SELECT TOP 1 ti_id FROM dbo.dim_datetimes 
			WHERE CAST(SUBSTRING(tw_created_at,9,2) AS INT) = ti_day 
					AND dbo.month_to_num(SUBSTRING(tw_created_at,5,3)) = ti_month
					AND CAST(SUBSTRING(tw_created_at,27,4) AS INT) = ti_year
					AND CAST(SUBSTRING(tw_created_at,12,8) AS TIME) = ti_time),
		CASE WHEN tw_truncated = 'false' THEN tw_text ELSE tw_full_text END,
		tw_user_id
	FROM inserted
	WHERE tw_reply_id <> ''

INSERT INTO dbo.fact_retweets (rt_id,rt_tweet_id,rt_created_at,rt_user)
	SELECT
		tw_id,
		tw_rt_id,
		(SELECT TOP 1 ti_id FROM dbo.dim_datetimes 
			WHERE CAST(SUBSTRING(tw_created_at,9,2) AS INT) = ti_day 
					AND dbo.month_to_num(SUBSTRING(tw_created_at,5,3)) = ti_month
					AND CAST(SUBSTRING(tw_created_at,27,4) AS INT) = ti_year
					AND CAST(SUBSTRING(tw_created_at,12,8) AS TIME) = ti_time),
		tw_user_id
	FROM inserted
	WHERE tw_rt_id <> ''

INSERT INTO dbo.fact_quotes (qu_id,qu_tweet_id,qu_text,qu_user,qu_created_at)
	SELECT
		tw_id,
		tw_qu_id,
		CASE WHEN tw_truncated = 'false' THEN tw_text ELSE tw_full_text END,
		tw_user_id,
		(SELECT TOP 1 ti_id FROM dbo.dim_datetimes 
			WHERE CAST(SUBSTRING(tw_created_at,9,2) AS INT) = ti_day 
					AND dbo.month_to_num(SUBSTRING(tw_created_at,5,3)) = ti_month
					AND CAST(SUBSTRING(tw_created_at,27,4) AS INT) = ti_year
					AND CAST(SUBSTRING(tw_created_at,12,8) AS TIME) = ti_time)
	FROM inserted
	WHERE tw_qu_id <> ''
