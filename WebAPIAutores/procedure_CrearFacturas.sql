USE [WebApisSuscripciones]
GO
/****** Object:  StoredProcedure [dbo].[CreacionFacturas]    Script Date: 20-06-2022 17:48:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CreacionFacturas] 
	-- Add the parameters for the stored procedure here
	@fechaInicio datetime,
	@fechaFin datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		declare @montoPorCadaPeticion decimal(4,4) = 1.0/2

		insert into Facturas (UsuarioId, Monto, FechaEmision, Pagada, FechaLimiteDePago)
		select LlaveAPI.UsuarioId,
		COUNT(*) * @montoPorCadaPeticion as monto,
		getdate() as fechaEmision,
		0 as pagada,
		dateadd(d, 60, GETDATE()) as fechaLimitePago
		from Peticiones
		inner join LlaveAPI
		on LlaveAPI.Id = Peticiones.LlaveId
		where LlaveAPI.TipoLlave != 1
		and Peticiones.FechaPeticion >= @fechaInicio
		and Peticiones.FechaPeticion < @fechaFin
		group by LlaveAPI.UsuarioId

		insert into FacturasEmitidas(Mes, Año)
		select
			case MONTH(getdate())
			when 1 then 12
			else MONTH(getdate())-1 end as Mes,

			case MONTH(getdate())
			when 1 then year(getdate())-1
			else year(getdate()) end as Año
END
