USE [Academy_Dev_Data_RFlor]
GO
/****** Object:  Trigger [dbo].[update_wifi_provider_on_fact_quotes]    Script Date: 13-Aug-21 11:14:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[update_wifi_provider_on_fact_quotes] ON [dbo].[fact_quotes] AFTER INSERT
AS
UPDATE dbo.fact_quotes SET qu_wifi_provider = (
						SELECT
						CASE 
							WHEN qu_text LIKE '%Telecentro%' THEN 2
							WHEN qu_text LIKE '%Fibertel%' THEN 1
							WHEN qu_text LIKE '%gigared%' THEN 10
							WHEN qu_text LIKE '%iplanliv%' THEN 6
							WHEN qu_text LIKE '%ClaroArgentina%' THEN 3
							WHEN qu_text LIKE '%MovistarArg%' THEN 4
							WHEN qu_text LIKE '%DIRECTVar%' THEN 5
							WHEN qu_text LIKE '%SionInternet%' THEN 7
							WHEN qu_text LIKE '%iptelargentina%' THEN 8
							WHEN qu_text LIKE '%MetrotelArg%' THEN 9
							ELSE NULL
						END 
						FROM inserted)
						WHERE qu_wifi_provider IS NULL
;


