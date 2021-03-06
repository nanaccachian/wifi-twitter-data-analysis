CREATE PROC [dbo].[create_dim_datetimes]
AS
DECLARE @INICIO DATE = CAST('20210801' AS DATE);

DECLARE @FIN DATE = CAST('20210831' AS DATE);

WHILE @INICIO<=@FIN

BEGIN

      INSERT INTO dbo.dim_dates (dt_year,dt_month,dt_day)

      SELECT
            DATEPART(YEAR, @INICIO) AS ti_year,
            DATEPART(MONTH, @INICIO) AS ti_month,
            DATEPART(DAY, @INICIO) AS ti_month

      SET @INICIO = DATEADD (DAY,1,@INICIO);

END;