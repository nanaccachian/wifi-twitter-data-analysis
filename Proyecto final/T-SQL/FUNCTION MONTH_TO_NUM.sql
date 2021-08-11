ALTER FUNCTION dbo.month_to_num(@str NVARCHAR(4)) RETURNS INT
AS
BEGIN
	RETURN CASE @str 
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
			ELSE -1
			END
END
 