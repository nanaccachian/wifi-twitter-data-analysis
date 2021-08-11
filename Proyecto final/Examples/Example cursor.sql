/*
DECLARE @datetime NVARCHAR(100)
DECLARE @yy INT, @mm INT, @dd NVARCHAR(10), @time TIME, @uso_hor NVARCHAR(10), @weekday NVARCHAR(10)

DECLARE insertados CURSOR FOR SELECT tw_created_at FROM inserted

OPEN insertados

FETCH NEXT FROM insertados INTO @datetime, @id, @name, @verified, @followers

WHILE @@FETCH_STATUS = 0
BEGIN

	/*IF NOT EXISTS (SELECT tw_id FROM dbo.users where @id = tw_id)
	BEGIN
		INSERT INTO dbo.users VALUES (@id,@name,@verified,@followers)
	END
	
	(SELECT STR(ti_year)+STR(ti_month)+STR(ti_day)+CONVERT(NVARCHAR(15,ti_time)
					FROM dbo.datetimes 
					WHERE @yy = ti_year AND @mm = ti_month AND @dd = ti_day AND @time = ti_time)

	IF NOT EXISTS (SELECT ti_year,ti_month,ti_day,ti_time
					FROM dbo.tw_datetimes 
					WHERE @yy = STR(ti_year) AND @mm = STR(ti_month) AND @dd = STR(ti_day) AND @time = CONVERT(NVARCHAR(15),ti_time))
	BEGIN
	/* "Fri Sep 18 18:36:15 +0000 2020" */
	/* "012345678901234567890123456789" */
		SET @yy = CONVERT(INT,SUBSTRING(@datetime,26,4))
		SET @mm = (CASE SUBSTRING(@datetime,4,3)
						WHEN 'Jan' then 1
						WHEN 'Feb' then 2
						WHEN 'Mar' then 3
						WHEN 'Apr' then 4
						WHEN 'May' then 5
						WHEN 'Jun' then 6
						WHEN 'Jul' then 7
						WHEN 'Aug' then 8
						WHEN 'Sep' then 9
						WHEN 'Oct' then 10
						WHEN 'Nov' then 11
						WHEN 'Dec' then 12
						END)
		SET @dd = CONVERT(INT,SUBSTRING(@datetime,8,2))
		SET @time = CONVERT(TIME,SUBSTRING(@datetime,11,8))

		INSERT INTO dbo.tw_datetimes VALUES(@yy,@mm,@dd,@time)
	END

	*/
	FETCH NEXT FROM insertados INTO @id, @name, @verified, @followers
END

DEALLOCATE insertados

*/
