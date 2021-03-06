CREATE TRIGGER [dbo].[update_wifi_provider_on_fact_tweets] ON [dbo].[fact_tweets] AFTER INSERT
AS
UPDATE dbo.fact_tweets SET tw_wifi_provider = (
						SELECT
						CASE 
							WHEN tw_text LIKE '%Telecentro%' THEN 2
							WHEN tw_text LIKE '%Fibertel%' THEN 1
							WHEN tw_text LIKE '%gigared%' THEN 10
							WHEN tw_text LIKE '%iplanliv%' THEN 6
							WHEN tw_text LIKE '%ClaroArgentina%' THEN 3
							WHEN tw_text LIKE '%MovistarArg%' THEN 4
							WHEN tw_text LIKE '%DIRECTVar%' THEN 5
							WHEN tw_text LIKE '%SionInternet%' THEN 7
							WHEN tw_text LIKE '%iptelargentina%' THEN 8
							WHEN tw_text LIKE '%MetrotelArg%' THEN 9
							ELSE NULL
						END 
						FROM inserted)
						WHERE tw_wifi_provider IS NULL
;


