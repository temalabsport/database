USE [SPORT]
GO
/****** Object:  UserDefinedTableType [dbo].[UserNameList]    Script Date: 2018. 12. 02. 22:12:10 ******/
CREATE TYPE [dbo].[UserNameList] AS TABLE(
	[UserName] [varchar](20) NULL
)
GO
/****** Object:  Table [dbo].[Events]    Script Date: 2018. 12. 02. 22:12:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Events](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SportID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Location] [geography] NOT NULL,
	[LocationName] [nvarchar](100) NOT NULL,
	[Date] [datetime2](7) NOT NULL,
	[Deadline] [datetime2](7) NOT NULL,
	[Description] [nvarchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Members]    Script Date: 2018. 12. 02. 22:12:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Members](
	[UserID] [int] NOT NULL,
	[TeamID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Participants]    Script Date: 2018. 12. 02. 22:12:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Participants](
	[EventID] [int] NOT NULL,
	[TeamID] [int] NOT NULL,
	[Points] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sports]    Script Date: 2018. 12. 02. 22:12:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sports](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[MinPlayers] [int] NOT NULL,
	[MaxPlayers] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Teams]    Script Date: 2018. 12. 02. 22:12:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Teams](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Name] [nvarchar](25) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 2018. 12. 02. 22:12:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](20) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[PasswordHash] [binary](64) NOT NULL,
	[PasswordSalt] [binary](16) NOT NULL,
	[FullName] [nvarchar](30) NOT NULL,
	[Introduction] [nvarchar](300) NULL,
	[Role] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Events]  WITH CHECK ADD FOREIGN KEY([SportID])
REFERENCES [dbo].[Sports] ([ID])
GO
ALTER TABLE [dbo].[Events]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[Members]  WITH CHECK ADD FOREIGN KEY([TeamID])
REFERENCES [dbo].[Teams] ([ID])
GO
ALTER TABLE [dbo].[Members]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[Participants]  WITH CHECK ADD FOREIGN KEY([EventID])
REFERENCES [dbo].[Events] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Participants]  WITH CHECK ADD FOREIGN KEY([TeamID])
REFERENCES [dbo].[Teams] ([ID])
GO
ALTER TABLE [dbo].[Teams]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[Sports]  WITH CHECK ADD  CONSTRAINT [CHK_MIN_MAX] CHECK  (([MinPlayers]>=(1) AND [MinPlayers]<=[MaxPlayers]))
GO
ALTER TABLE [dbo].[Sports] CHECK CONSTRAINT [CHK_MIN_MAX]
GO
/****** Object:  StoredProcedure [dbo].[ApplyForEvent]    Script Date: 2018. 12. 02. 22:12:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[ApplyForEvent]
(
    @EventID INT,
	@Creator VARCHAR(20),
	@TeamName VARCHAR(25),
	@UserNameList dbo.UserNameList READONLY,

	@ResultMessage NVARCHAR(100) = NULL OUTPUT
)
AS
BEGIN
    BEGIN TRANSACTION;
	DECLARE @Deadline DATETIME2;
	SELECT @Deadline = Deadline FROM Events WHERE ID = @EventID;
	IF ( @@ROWCOUNT != 1 )
	BEGIN
		SET @ResultMessage = 'Event not found';
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		RETURN 1;
	END
	IF ( @Deadline < SYSDATETIME() )
	BEGIN
		SET @ResultMessage = 'Deadline expired';
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		RETURN 1;
	END		

	DECLARE @CreatorID INT;
	SELECT @CreatorID = ID FROM Users WHERE Users.UserName = @Creator;
	IF ( @@ROWCOUNT != 1 )
	BEGIN
		SET @ResultMessage = 'Creator not found';
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		RETURN 1;
	END

	BEGIN TRY
		DECLARE @TeamIDList TABLE ( ID INT );
		INSERT INTO Teams ( UserID, Name ) OUTPUT INSERTED.ID INTO @TeamIDList VALUES
		(
			@CreatorID,
			@TeamName
		);
		DECLARE @TeamID INT = ( SELECT ID FROM @TeamIDList );
	END TRY
	BEGIN CATCH
		SET @ResultMessage = 'TeamName already exists';
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		RETURN 1;
	END CATCH

	DECLARE @UserCount INT = ( SELECT COUNT( DISTINCT UserName ) FROM @UserNameList );
	DECLARE @SportID INT = ( SELECT SportID FROM Events WHERE ID = @EventID );
	DECLARE @MinPlayers INT = ( SELECT MinPlayers FROM Sports WHERE ID = @SportID );
	DECLARE @MaxPlayers INT = ( SELECT MaxPlayers FROM Sports WHERE ID = @SportID );

	IF @UserCount BETWEEN @MinPlayers AND @MaxPlayers
	BEGIN
		INSERT INTO Members ( UserID, TeamID )
			SELECT DISTINCT ID, @TeamID
			FROM Users
			JOIN @UserNameList AS List ON List.UserName = Users.UserName;

		INSERT INTO Participants ( EventID, TeamID ) VALUES
		(
			@EventID,
			@TeamID
		)

		SET @ResultMessage = 'Successfully applied for Event';
		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;
		RETURN 0;
	END
	ELSE
	BEGIN
		SET @ResultMessage = 'Number of players must be between ' + CONVERT( VARCHAR(10), @MinPlayers) + ' and ' + CONVERT( VARCHAR(10), @MaxPlayers);
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		RETURN 1;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[GetEvents]    Script Date: 2018. 12. 02. 22:12:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure  [dbo].[GetEvents]
(
@UserName NVARCHAR(20),
@Sport NVARCHAR(20),
@DateFrom DATETIME2,
@DateTo DATETIME2,
@Latitude FLOAT,
@Longitude FLOAT,
@OrderBy NVARCHAR(20),
@PageSize INT,
@Page INT,

@TotalResults INT = NULL OUTPUT,
@TotalPages INT = NULL OUTPUT
)
AS
BEGIN
	IF @UserName IS NULL
	BEGIN
		SELECT @TotalResults = COUNT(*)
			FROM Events
			JOIN Users ON Users.ID = Events.UserID
			JOIN Sports ON Sports.ID = Events.SportID
			WHERE
				( @Sport is null OR Sports.Name = @Sport ) AND
				( @DateFrom is null OR Events.Date >= @DateFrom ) AND
				( @DateTo is null OR Events.Date <= @DateTo );

		SET @TotalPages = CEILING(@TotalResults / CAST( @PageSize AS FLOAT ));

		SELECT	Events.Name AS name,
				Events.ID AS eventID,
				CreatorUsers.UserName AS creator,
				Sports.Name AS sport,
				Sports.MinPlayers AS minTeamSize,
				Sports.MaxPlayers AS maxTeamSize,
				Location.Lat AS latitude,
				Location.Long AS longitude,
				Location.STDistance(geography::STPointFromText('POINT(' + CONVERT(VARCHAR, @Longitude) + ' ' + CONVERT(VARCHAR, @Latitude) + ')', 4326)) / 1000 AS distance,
				Events.LocationName AS location,
				Events.Date AS date,
				Events.Deadline AS deadline,
				Description AS description
			FROM Events
			JOIN Users AS CreatorUsers ON CreatorUsers.ID = Events.UserID
			JOIN Sports ON Sports.ID = Events.SportID
			WHERE
				( @Sport is null OR Sports.Name = @Sport ) AND
				( @DateFrom is null OR Events.Date >= @DateFrom ) AND
				( @DateTo is null OR Events.Date <= @DateTo )
			ORDER BY
				CASE @OrderBy WHEN 'date' THEN Events.Date ELSE NULL END,
				CASE @OrderBy WHEN 'deadline' THEN Events.Deadline ELSE NULL END,
				CASE @OrderBy WHEN 'name' THEN Events.Name ELSE NULL END,
				CASE @OrderBy WHEN 'location' THEN Events.LocationName ELSE NULL END,
				CASE @OrderBy WHEN 'distance' THEN Location.STDistance(geography::STPointFromText('POINT(' + CONVERT(VARCHAR, @Longitude) + ' ' + CONVERT(VARCHAR, @Latitude) + ')', 4326)) / 1000 ELSE NULL END
			OFFSET ( ( @Page - 1 ) * @PageSize ) ROWS
			FETCH NEXT @PageSize ROWS ONLY;
	END
	ELSE
	BEGIN
		SELECT @TotalResults = COUNT(*)
			FROM Events
			JOIN Users AS CreatorUsers ON CreatorUsers.ID = Events.UserID
			JOIN Sports ON Sports.ID = Events.SportID
			JOIN Participants ON Participants.EventID = Events.ID
			JOIN Members ON Members.TeamID = Participants.TeamID
			JOIN Users AS MemberUsers ON MemberUsers.ID = Members.UserID
			WHERE
				( @UserName = MemberUsers.UserName ) AND
				( @Sport is null OR Sports.Name = @Sport ) AND
				( @DateFrom is null OR Events.Date >= @DateFrom ) AND
				( @DateTo is null OR Events.Date <= @DateTo )

		SET @TotalPages = CEILING(@TotalResults / CAST( @PageSize AS FLOAT ));

		SELECT	Events.Name AS name,
				Events.ID AS eventID,
				CreatorUsers.UserName AS creator,
				Sports.Name AS sport,
				Sports.MinPlayers AS minTeamSize,
				Sports.MaxPlayers AS maxTeamSize,
				Location.Lat AS latitude,
				Location.Long AS longitude,
				Location.STDistance(geography::STPointFromText('POINT(' + CONVERT(VARCHAR, @Longitude) + ' ' + CONVERT(VARCHAR, @Latitude) + ')', 4326)) / 1000 AS distance,
				Events.LocationName AS location,
				Events.Date AS date,
				Events.Deadline AS deadline,
				Description AS description
			FROM Events
			JOIN Users AS CreatorUsers ON CreatorUsers.ID = Events.UserID
			JOIN Sports ON Sports.ID = Events.SportID
			JOIN Participants ON Participants.EventID = Events.ID
			JOIN Members ON Members.TeamID = Participants.TeamID
			JOIN Users AS MemberUsers ON MemberUsers.ID = Members.UserID
			WHERE
				( @UserName = MemberUsers.UserName ) AND
				( @Sport is null OR Sports.Name = @Sport ) AND
				( @DateFrom is null OR Events.Date >= @DateFrom ) AND
				( @DateTo is null OR Events.Date <= @DateTo )
			ORDER BY
				CASE @OrderBy WHEN 'date' THEN Events.Date ELSE NULL END,
				CASE @OrderBy WHEN 'deadline' THEN Events.Deadline ELSE NULL END,
				CASE @OrderBy WHEN 'name' THEN Events.Name ELSE NULL END,
				CASE @OrderBy WHEN 'location' THEN Events.LocationName ELSE NULL END,
				CASE @OrderBy WHEN 'distance' THEN Location.STDistance(geography::STPointFromText('POINT(' + CONVERT(VARCHAR, @Longitude) + ' ' + CONVERT(VARCHAR, @Latitude) + ')', 4326)) / 1000 ELSE NULL END
			OFFSET ( ( @Page - 1 ) * @PageSize ) ROWS
			FETCH NEXT @PageSize ROWS ONLY;
		END
END
GO
/****** Object:  StoredProcedure [dbo].[GetNotifyList]    Script Date: 2018. 12. 02. 22:12:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetNotifyList]
(
    @Date DATETIME2
)
AS
BEGIN
    SELECT DISTINCT Users.Email, Sports.Name, SameSportEvents.Name, SameSportEvents.LocationName
	FROM Users
	JOIN Members ON Users.ID = Members.UserID
	JOIN Participants ON Members.TeamID = Participants.TeamID
	JOIN Events ON Participants.EventID = Events.ID
	JOIN Sports ON Events.SportID = Sports.ID
	JOIN Events AS SameSportEvents ON Sports.ID = SameSportEvents.SportID
	WHERE
		Events.ID != SameSportEvents.ID AND
		DATEDIFF(day, SameSportEvents.Deadline, @Date) = 0;
END
GO
/****** Object:  StoredProcedure [dbo].[SearchUsers]    Script Date: 2018. 12. 02. 22:12:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SearchUsers]
(
    @KeyWord VARCHAR(30),
	@OrderBy VARCHAR(20),
	@PageSize INT,
	@Page INT,

	@TotalResults INT = NULL OUTPUT,
	@TotalPages INT = NULL OUTPUT
)
AS
BEGIN

	SELECT @TotalResults = COUNT(*)
	FROM Users
	WHERE (
		@KeyWord IS NULL OR
		Users.UserName LIKE '%' + @KeyWord + '%' OR
		Users.FullName LIKE '%' + @KeyWord + '%'
	);

	SET @TotalPages = CEILING(@TotalResults / CAST( @PageSize AS FLOAT ));


    SELECT Users.UserName AS userName, Users.FullName AS fullName
	FROM Users
	WHERE (
		@KeyWord IS NULL OR
		Users.UserName LIKE '%' + @KeyWord + '%' OR
		Users.FullName LIKE '%' + @KeyWord + '%'
	)
	ORDER BY
		CASE @OrderBy
		WHEN 'userName' THEN Users.UserName
		WHEN 'fullName' THEN Users.FullName
		ELSE NULL
		END
	OFFSET ( ( @Page - 1 ) * @PageSize ) ROWS
	FETCH NEXT @PageSize ROWS ONLY;

END
GO
