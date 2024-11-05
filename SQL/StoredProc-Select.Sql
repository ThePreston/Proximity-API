SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Preston Hale
-- Create Date: 10/25/2024
-- =============================================
	CREATE PROCEDURE [dbo].[GetAddressWithinRange]
(
	@lat decimal(18,15),
	@lng decimal(18,15),
	@Distance INT
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
	
	SELECT * FROM 
		(SELECT [Id], 
			[LocationName], 
			[Address], 
			CAST([geo] as varchar(100)) as geo,
			Geography::Point([lat], [long], 4326).STDistance(Geography::Point(@lat, @lng, 4326))  / 1609.344 as Miles,
			ROUND([geo].STDistance(geography::Point(@lat, @lng, 4326))  / 1609.344 , 1)  as DistanceInMiles,
			geo.Lat as GeoLat,
			geo.Long as GeoLong,
			[lat], 
			[long], 
			[CreatedDate]
		  FROM [dbo].[ProximityMap]) AS Proximity
	WHERE
		Proximity.Miles < @Distance
	ORDER BY DistanceInMiles ASC
	FOR JSON AUTO
END
GO
