USE [WebApisSuscripciones]
GO
/****** Object:  StoredProcedure [dbo].[SetearMalaPaga]    Script Date: 20-06-2022 17:47:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SetearMalaPaga]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE AspNetUsers
	set MalaPaga = 'True'
	from Facturas
	inner join AspNetUsers on AspNetUsers.Id = Facturas.UsuarioId
	where Pagada = 'False'
	and FechaLimiteDePago < GETDATE()
END
