SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Preston Hale
-- Create Date: 10/26/2024
-- =============================================
CREATE PROCEDURE [dbo].[InsertAddress]
(
    @locationName Varchar(200),
	@address Varchar(150),
    @lat decimal(18,15),
	@lng decimal(18,15)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
	
	INSERT INTO [dbo].[ProximityMap]
		([LocationName]
		,[Address]
		,[geo]
		,[lat]
		,[long])
	VALUES
		(@locationName,
		@address,
		geography::Point(@lat, @lng, 4326),
		@lat,
		@lng)

END
GO
