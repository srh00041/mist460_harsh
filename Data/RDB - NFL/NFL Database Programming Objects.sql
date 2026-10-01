create or alter procedure procEnterGameScores
(
    @GameID INT,
    @HomeTeamScore INT,
    @AwayTeamScore INT,
    @NFLAdminID INT
)

AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WinningTeamID INT;

    -- Determine winner based on scores
    SELECT 
        @WinningTeamID =
            CASE
                WHEN @HomeTeamScore > @AwayTeamScore THEN HomeTeamID
                WHEN @AwayTeamScore > @HomeTeamScore THEN AwayTeamID
                ELSE NULL   -- Safe fallback (ties shouldn't occur in playoffs)
            END
    FROM Game
    WHERE GameID = @GameID;

    -- Update the Game table
    UPDATE Game
    SET 
        HomeTeamScore = @HomeTeamScore,
        AwayTeamScore = @AwayTeamScore,
        WinningTeamID = @WinningTeamID
    WHERE GameID = @GameID;

    -- Log the change in AdminChangesTracker
    INSERT INTO AdminChangesTracker
        (NFLAdminID, GameID, ChangeType, ChangeDescription)
    VALUES
        (@NFLAdminID, @GameID, N'Update', 
         CONCAT('Scores updated: Home=', @HomeTeamScore, 
                ', Away=', @AwayTeamScore, 
                ', WinnerTeamID=', COALESCE(@WinningTeamID, 0)));
END;
GO


go

create or alter trigger trigUpdateTotalNumberOfWins
ON Game
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Only run if WinningTeamID changed
    IF NOT EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON i.GameID = d.GameID
        WHERE i.WinningTeamID <> d.WinningTeamID
    )
        RETURN;

    -- Recalculate wins for every team whose WinningTeamID changed
    UPDATE Team
    SET TotalPlayOffWins = (
        SELECT COUNT(*)
        FROM Game
        WHERE WinningTeamID = Team.TeamID
    )
    WHERE Team.TeamID IN (
        SELECT DISTINCT i.WinningTeamID
        FROM inserted i
        JOIN deleted d ON i.GameID = d.GameID
        WHERE i.WinningTeamID <> d.WinningTeamID
    );
END;
GO
