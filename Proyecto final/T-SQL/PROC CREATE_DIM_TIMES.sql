CREATE PROC [dbo].[create_dim_times]
AS

declare @Time datetime
set @Time = convert(varchar,'12:00:00 AM',108)

while @Time <= '11:59:59 PM' begin
   exec InsertarHora @Time
   -- Podemos incrementar contador en Horas, Minutos o Segundos
   -- poniendo hour, minute o second en la función dateadd
   set @Time = dateadd(SECOND,1,@Time)
end
