CREATE procedure [dbo].[InsertarHora]
   @Time datetime
as
   declare @Hora tinyint,
           @Minuto tinyint, 
		   @Segundo tinyint, 
		   @Momento nvarchar(15)

   --Calcular columnas mínimas necesarias
   set @Hora = datepart(hour, @Time)
   set @Minuto = datepart(minute, @Time)
   set @Segundo = datepart(second, @Time)
   SET @Momento = CASE
		WHEN @Hora >= 0 AND @Hora <= 5 THEN 'Madrugada'
		WHEN @Hora >= 6 AND @Hora <= 12 THEN 'Mañana'
		WHEN @Hora >= 13 AND @Hora <= 18 THEN 'Tarde'
		WHEN @Hora >= 19 AND @Hora <= 23 THEN 'Noche'
		END
   
   insert into dbo.dim_times (ti_hour, ti_min, ti_sec, ti_part_of_day)
      select @Hora, @Minuto, @Segundo, @Momento
