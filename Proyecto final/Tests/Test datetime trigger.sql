TRUNCATE TABLE dbo.raw_tweets

INSERT INTO raw_tweets(
    tw_id,
    tw_created_at,
    tw_text,
    tw_full_text,
    tw_truncated,
    tw_reply_id,
    tw_user_id,
    tw_user_name,
    tw_user_verified,
    tw_user_follower,
    tw_location,
    tw_quoted_status_id,
    tw_is_quote_status,
    tw_qu_id,
    tw_qu_created_at,
    tw_qu_text,
    tw_qu_full_text,
    tw_qu_truncated,
	tw_qu_user_id,
	tw_qu_user_name,
	tw_qu_user_verified,
	tw_qu_user_follower
)
VALUES (
'1422555819267211276',
'Tue Aug 03 13:51:51 +0000 2021',
'RT @JuliaVillacampa: Chicos me ayudan a pedirle a @CableFibertel que me restablezca internet porque No puedo trabajar!!! Por favor!',
'',
'false',
'',
'44392202',
'Joan Sebástian',
'true',
'291',
'No soy de aquí, ni soy de allá',
'1422211374722207745',
'',
'1422211374722207745',
'Mon Aug 02 15:03:09 +0000 2021',
'@kibudi 🤦‍♀️    ',
'',
'false',
'43424343',
'@Persona',
'false',
'1234'
);

select * from dbo.raw_tweets

select * from dbo.dim_datetimes
select * from dbo.dim_users


select * from dbo.fact_quotes
select * from dbo.fact_tweets
select * from dbo.fact_replies
select * from dbo.fact_retweets