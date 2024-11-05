SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProximityMap](
	[Id] [uniqueidentifier] NOT NULL,
	[LocationName] [varchar](200) NOT NULL,
	[Address] [varchar](150) NOT NULL,
	[geo] [geography] NOT NULL,
	[lat] [float] NOT NULL,
	[long] [float] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProximityMap] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProximityMap] ADD  CONSTRAINT [DF_ProximityMap_Id]  DEFAULT (newid()) FOR [Id]
GO

ALTER TABLE [dbo].[ProximityMap] ADD  CONSTRAINT [DF_ProximityMap_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
