CREATE TRIGGER [dbo].[raw_tweets_to_DW] ON [dbo].[raw_tweets] AFTER INSERT
AS

DECLARE @tw_id NVARCHAR(60),@tw_created_at NVARCHAR(60),@tw_text NVARCHAR(300),@tw_full_text NVARCHAR(300),@tw_truncated NVARCHAR(10),@tw_user NVARCHAR(60), @rp_id NVARCHAR(60),
		@tw_qu_id NVARCHAR(60),@tw_qu_created_at NVARCHAR(60),@tw_qu_text NVARCHAR(300),@tw_qu_full_text NVARCHAR(300),@tw_qu_truncated NVARCHAR(10),@tw_qu_user NVARCHAR(60),
		@tw_rt_id NVARCHAR(60),@tw_rt_created_at NVARCHAR(60),@tw_rt_text NVARCHAR(300),@tw_rt_full_text NVARCHAR(300),@tw_rt_truncated NVARCHAR(10),@tw_rt_user NVARCHAR(60),
		@tw_user_id NVARCHAR(60), @tw_user_name NVARCHAR(60), @tw_user_verified NVARCHAR(60), @tw_user_follower NVARCHAR(60),
		@tw_qu_user_id NVARCHAR(60), @tw_qu_user_name NVARCHAR(60), @tw_qu_user_verified NVARCHAR(60), @tw_qu_user_follower NVARCHAR(60),
		@tw_rt_user_id NVARCHAR(60), @tw_rt_user_name NVARCHAR(60), @tw_rt_user_verified NVARCHAR(60), @tw_rt_user_follower NVARCHAR(60)

DECLARE insertados CURSOR FOR 
	SELECT tw_id ,tw_created_at ,tw_text ,tw_full_text ,tw_truncated ,tw_user_id , tw_reply_id,
		tw_qu_id ,tw_qu_created_at ,tw_qu_text ,tw_qu_full_text ,tw_qu_truncated ,tw_qu_user_id ,
		tw_rt_id ,tw_rt_created_at ,tw_rt_text ,tw_rt_full_text ,tw_rt_truncated ,tw_rt_user_id,
		tw_user_id,tw_user_name ,tw_user_verified ,tw_user_follower,
		tw_qu_user_id , tw_qu_user_name , tw_qu_user_verified , tw_qu_user_follower ,
		tw_rt_user_id , tw_rt_user_name , tw_rt_user_verified , tw_rt_user_follower 
	FROM inserted

OPEN insertados

FETCH NEXT FROM insertados INTO @tw_id ,@tw_created_at ,@tw_text ,@tw_full_text ,@tw_truncated ,@tw_user , @rp_id ,
		@tw_qu_id ,@tw_qu_created_at ,@tw_qu_text ,@tw_qu_full_text ,@tw_qu_truncated ,@tw_qu_user ,
		@tw_rt_id ,@tw_rt_created_at ,@tw_rt_text ,@tw_rt_full_text ,@tw_rt_truncated ,@tw_rt_user,
		@tw_user_id, @tw_user_name ,@tw_user_verified, @tw_user_follower,
		@tw_qu_user_id, @tw_qu_user_name, @tw_qu_user_verified, @tw_qu_user_follower,
		@tw_rt_user_id, @tw_rt_user_name, @tw_rt_user_verified, @tw_rt_user_follower 

WHILE @@FETCH_STATUS = 0
BEGIN

	/* INSERCION USUARIOS */
	IF NOT EXISTS (SELECT us_id FROM dbo.dim_users WHERE us_id = CAST(@tw_user_id AS BIGINT))
	BEGIN
		INSERT INTO dbo.dim_users (us_id,us_name,us_verified,us_followers) 
		VALUES (@tw_user_id, @tw_user_name, CASE WHEN @tw_user_verified ='true' THEN 1 ELSE 0 END, @tw_user_follower)
	END

	IF @tw_qu_user_id <> '' AND NOT EXISTS (SELECT us_id FROM dbo.dim_users WHERE us_id = CAST(@tw_qu_user_id AS BIGINT))
	BEGIN
		INSERT INTO dbo.dim_users (us_id,us_name,us_verified,us_followers) 
		VALUES (@tw_qu_user_id, @tw_qu_user_name ,CASE WHEN @tw_qu_user_verified ='true' THEN 1 ELSE 0 END , @tw_qu_user_follower)
	END

	IF @tw_rt_user_id <> '' AND NOT EXISTS (SELECT us_id FROM dbo.dim_users WHERE us_id = CAST(@tw_rt_user_id AS BIGINT))
	BEGIN
		INSERT INTO dbo.dim_users (us_id,us_name,us_verified,us_followers) 
		VALUES (@tw_rt_user_id, @tw_rt_user_name ,CASE WHEN @tw_rt_user_verified ='true' THEN 1 ELSE 0 END , @tw_rt_user_follower)
	END

	IF @tw_text <> ''
	BEGIN
		/* INSERCIÓN DE TWEETS NORMALES */
		IF @rp_id = '' AND @tw_qu_id = '' AND @tw_rt_id = '' AND NOT EXISTS (SELECT tw_id FROM dbo.fact_tweets WHERE CAST(@tw_id AS BIGINT) = tw_id)
		BEGIN
			INSERT INTO dbo.fact_tweets (tw_id,tw_date,tw_time,tw_text,tw_user)
			VALUES (@tw_id,
					(SELECT dt_id FROM dbo.dim_dates
						WHERE CAST(SUBSTRING(@tw_created_at,9,2) AS INT) = dt_day 
								AND dbo.month_to_num(SUBSTRING(@tw_created_at,5,3)) = dt_month
								AND CAST(SUBSTRING(@tw_created_at,27,4) AS INT) = dt_year),
					(SELECT ti_id FROM dbo.dim_times
						WHERE CAST(SUBSTRING(@tw_created_at,12,2) AS INT) = ti_hour 
								AND CAST(SUBSTRING(@tw_created_at,15,2) AS INT) = ti_min
								AND CAST(SUBSTRING(@tw_created_at,18,2) AS INT) = ti_sec),
					CASE WHEN @tw_truncated = 'true' THEN @tw_full_text ELSE @tw_text END,
					@tw_user_id)
		END

		/* INSERCION DE QUOTES */
		IF @tw_qu_id <> ''  AND NOT EXISTS (SELECT qu_id FROM dbo.fact_quotes WHERE CAST(@tw_id AS BIGINT) = qu_id)
		BEGIN
			IF NOT EXISTS (SELECT tw_id FROM dbo.fact_tweets where CAST(@tw_qu_id AS BIGINT) = tw_id)
			BEGIN
				INSERT INTO dbo.fact_tweets (tw_id,tw_date,tw_time,tw_text,tw_user)
				VALUES(
						@tw_qu_id,
						ISNULL((SELECT dt_id FROM dbo.dim_dates
							WHERE CAST(SUBSTRING(@tw_qu_created_at,9,2) AS INT) = dt_day 
									AND dbo.month_to_num(SUBSTRING(@tw_qu_created_at,5,3)) = dt_month
									AND CAST(SUBSTRING(@tw_qu_created_at,27,4) AS INT) = dt_year),32),
						ISNULL((SELECT ti_id FROM dbo.dim_times
							WHERE CAST(SUBSTRING(@tw_qu_created_at,12,2) AS INT) = ti_hour 
									AND CAST(SUBSTRING(@tw_qu_created_at,15,2) AS INT) = ti_min
									AND CAST(SUBSTRING(@tw_qu_created_at,18,2) AS INT) = ti_sec),86402),
						@tw_qu_text,
						@tw_qu_user_id)
			END

			INSERT INTO dbo.fact_quotes (qu_id,qu_tweet_id,qu_text,qu_user,qu_date,qu_time)
				VALUES(
					@tw_id,
					@tw_qu_id,
					CASE WHEN @tw_truncated = 'true' THEN @tw_full_text ELSE @tw_text END,
					@tw_user_id,
					(SELECT dt_id FROM dbo.dim_dates
						WHERE CAST(SUBSTRING(@tw_created_at,9,2) AS INT) = dt_day 
								AND dbo.month_to_num(SUBSTRING(@tw_created_at,5,3)) = dt_month
								AND CAST(SUBSTRING(@tw_created_at,27,4) AS INT) = dt_year),
					(SELECT ti_id FROM dbo.dim_times
						WHERE CAST(SUBSTRING(@tw_created_at,12,2) AS INT) = ti_hour 
								AND CAST(SUBSTRING(@tw_created_at,15,2) AS INT) = ti_min
								AND CAST(SUBSTRING(@tw_created_at,18,2) AS INT) = ti_sec))
		END

		/* INSERCIÓN DE RETWEETS */
		IF @tw_rt_id <> ''  AND NOT EXISTS (SELECT rt_id FROM dbo.fact_retweets WHERE CAST(@tw_id AS BIGINT) = rt_id)
		BEGIN
			IF NOT EXISTS (SELECT tw_id FROM dbo.fact_tweets where CAST(@tw_rt_id AS BIGINT) = tw_id)
			BEGIN
				INSERT INTO dbo.fact_tweets (tw_id,tw_date,tw_time,tw_text,tw_user)
					VALUES(
						@tw_rt_id,
						isnull((SELECT dt_id FROM dbo.dim_dates
							WHERE CAST(SUBSTRING(@tw_rt_created_at,9,2) AS INT) = dt_day 
									AND dbo.month_to_num(SUBSTRING(@tw_rt_created_at,5,3)) = dt_month
									AND CAST(SUBSTRING(@tw_rt_created_at,27,4) AS INT) = dt_year),32),
						isnull((SELECT ti_id FROM dbo.dim_times
							WHERE CAST(SUBSTRING(@tw_rt_created_at,12,2) AS INT) = ti_hour 
									AND CAST(SUBSTRING(@tw_rt_created_at,15,2) AS INT) = ti_min
									AND CAST(SUBSTRING(@tw_rt_created_at,18,2) AS INT) = ti_sec),86402),
						@tw_rt_text,
						@tw_rt_user_id)
			END

			INSERT INTO dbo.fact_retweets (rt_id,rt_tweet_id,rt_user,rt_date,rt_time)
				VALUES(
					@tw_id,
					@tw_rt_id,
					@tw_user_id,
					(SELECT dt_id FROM dbo.dim_dates
						WHERE CAST(SUBSTRING(@tw_created_at,9,2) AS INT) = dt_day 
								AND dbo.month_to_num(SUBSTRING(@tw_created_at,5,3)) = dt_month
								AND CAST(SUBSTRING(@tw_created_at,27,4) AS INT) = dt_year),
					(SELECT ti_id FROM dbo.dim_times
						WHERE CAST(SUBSTRING(@tw_created_at,12,2) AS INT) = ti_hour 
								AND CAST(SUBSTRING(@tw_created_at,15,2) AS INT) = ti_min
								AND CAST(SUBSTRING(@tw_created_at,18,2) AS INT) = ti_sec))
		END

		/* INSERCION DE REPLIES */
		IF @rp_id <> '' AND NOT EXISTS (SELECT rp_id FROM dbo.fact_replies WHERE CAST(@tw_id AS BIGINT) = rp_id)
		BEGIN
			INSERT INTO dbo.fact_replies (rp_id,rp_tweet_id,rp_text,rp_user,rp_date,rp_time)
				VALUES(
					@tw_id,
					@rp_id,
					CASE WHEN @tw_truncated = 'true' THEN @tw_full_text ELSE @tw_text END,
					@tw_user_id,
					(SELECT dt_id FROM dbo.dim_dates
						WHERE CAST(SUBSTRING(@tw_created_at,9,2) AS INT) = dt_day 
								AND dbo.month_to_num(SUBSTRING(@tw_created_at,5,3)) = dt_month
								AND CAST(SUBSTRING(@tw_created_at,27,4) AS INT) = dt_year),
					(SELECT ti_id FROM dbo.dim_times
						WHERE CAST(SUBSTRING(@tw_created_at,12,2) AS INT) = ti_hour 
								AND CAST(SUBSTRING(@tw_created_at,15,2) AS INT) = ti_min
								AND CAST(SUBSTRING(@tw_created_at,18,2) AS INT) = ti_sec))
		END
	END

	FETCH NEXT FROM insertados INTO @tw_id ,@tw_created_at ,@tw_text ,@tw_full_text ,@tw_truncated ,@tw_user , @rp_id ,
		@tw_qu_id ,@tw_qu_created_at ,@tw_qu_text ,@tw_qu_full_text ,@tw_qu_truncated ,@tw_qu_user ,
		@tw_rt_id ,@tw_rt_created_at ,@tw_rt_text ,@tw_rt_full_text ,@tw_rt_truncated ,@tw_rt_user,
		@tw_user_id , @tw_user_name , @tw_user_verified , @tw_user_follower ,
		@tw_qu_user_id , @tw_qu_user_name , @tw_qu_user_verified , @tw_qu_user_follower ,
		@tw_rt_user_id , @tw_rt_user_name , @tw_rt_user_verified , @tw_rt_user_follower 
END

DEALLOCATE insertados