CREATE TRIGGER [dbo].[update_wifi_provider_on_fact_replies] ON [dbo].[fact_replies] AFTER INSERT
AS
UPDATE dbo.fact_replies SET rp_wifi_provider = (
						SELECT
						CASE 
							WHEN rp_text LIKE '%Telecentro%' THEN 2
							WHEN rp_text LIKE '%Fibertel%' THEN 1
							WHEN rp_text LIKE '%gigared%' THEN 10
							WHEN rp_text LIKE '%iplanliv%' THEN 6
							WHEN rp_text LIKE '%ClaroArgentina%' THEN 3
							WHEN rp_text LIKE '%MovistarArg%' THEN 4
							WHEN rp_text LIKE '%DIRECTVar%' THEN 5
							WHEN rp_text LIKE '%SionInternet%' THEN 7
							WHEN rp_text LIKE '%iptelargentina%' THEN 8
							WHEN rp_text LIKE '%MetrotelArg%' THEN 9
							ELSE NULL
						END 
						FROM inserted)
						WHERE rp_wifi_provider IS NULL