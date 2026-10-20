if (OBJECT_ID('procGetUserTeams') is not null)
    drop procedure procGetUserTeams

if (OBJECT_ID('fncGetTeamWins') is not null)
    drop function fncGetTeamWins;

if (OBJECT_ID('fncGetTeamLosses') is not null)
    drop function fncGetTeamLosses;

if (OBJECT_ID('procEnterGameScores') is not null)
    drop procedure procEnterGameScores;

if (OBJECT_ID('trgUpdateTotalNumberOfWinsAndLosses') is not null)
    drop trigger trgUpdateTotalNumberOfWinsAndLosses;

if (OBJECT_ID('procUpdateAdminChangesTracker') is not null)
    drop procedure procUpdateAdminChangesTracker;

go

create or alter function fncGetTeamWins()
returns table
as
return
    select T.TeamName, WinningTeamID, count(WinningTeamID) as Wins
    from Game inner join Team T on Game.WinningTeamID = T.TeamID
    where WinningTeamID is not null
    group by WinningTeamID, T.TeamName

--    select * from fncGetTeamWins();

go

create or alter function fncGetTeamLosses()
returns table
as
return
    select T.TeamName, LosingTeamID, count(LosingTeamID) as Losses
    from Game inner join Team T on Game.LosingTeamID = T.TeamID
    where LosingTeamID is not null
    group by LosingTeamID, T.TeamName

--    select * from fncGetTeamLosses();

go


/*
update Team
set TotalPlayOffWins = W.Wins
    from fncGetTeamWins() W join Team T 
    on T.TeamID = W.WinningTeamID;
*/

go

/*
update Team
set TotalPlayOffLosses = L.Losses
    from fncGetTeamLosses() L join Team T 
    on T.TeamID = L.LosingTeamID;
*/

go

/*
select TeamName, TotalPlayOffWins, TotalPlayOffLosses
from Team;
*/
go



create or alter procedure procGetUserTeams
(
    @AppUserID int
)
as
begin
    select A.Firstname, A.Lastname, WT.TeamName, WT.TeamID, W.Wins
    from NFLAppUser A inner join NFLFan F on A.AppUserID = F.NFLFanID
        inner join FanTeam FT on F.NFLFanID = FT.NFLFanID
        inner join Team WT on FT.TeamID = WT.TeamID
        inner join fncGetTeamWins() W on WT.TeamID = W.WinningTeamID
    where AppUserID = @AppUserID
end;
-- execute procGetUserTeams @AppUserID = 1;
go

create or alter procedure procEnterGameScores
(
    @gameID int,
    @homeTeamScore int,
    @awayTeamScore int,
    @NFLAdminID int
)
as
begin

    -- Store the NFLAdminID in a context variable for use in the trigger
    declare @context varbinary(4) = cast(@NFLAdminID as varbinary(4));
    set context_info @context;

    update Game  
    set HomeTeamScore = @homeTeamScore,
        AwayTeamScore = @awayTeamScore,

        WinningTeamID = case 
            when @homeTeamScore > @awayTeamScore then 
                HomeTeamID
            when @homeTeamScore < @awayTeamScore then 
                AwayTeamID
            else null
        end,

        LosingTeamID = case 
            when @homeTeamScore > @awayTeamScore then 
                AwayTeamID
            when @homeTeamScore < @awayTeamScore then 
                HomeTeamID
            else null
        end

    where GameID = @gameID;    
end;

-- execute procEnterGameScores @gameID = 12, @homeTeamScore = 7, @awayTeamScore = 10, @NFLAdminID = 5;
-- select * from Game where GameID = 12;
-- select * from Team where TeamID in (11, 13);
-- select * from AdminChangesTracker;
go

/*
select TeamName, TotalPlayOffWins, TotalPlayOffLosses from Team;
*/


go

create or alter trigger trgUpdateTotalNumberOfWinsAndLosses
on Game
after update
as
begin
    --set nocount on;
    --print 'Trigger fired'
    -- Check if the update was for scores
    if (update(HomeTeamScore) or update(AwayTeamScore))
    begin
        --print 'In trigger body'
        declare @gameID int, @homeTeamScore int, @awayTeamScore int,
                @winningTeamID int, @losingTeamID int;

        select @gameID = GameID, @homeTeamScore = HomeTeamScore, @awayTeamScore = AwayTeamScore,
                @winningTeamID = WinningTeamID, @losingTeamID = LosingTeamID
        from inserted;

        update Team
        set TotalPlayOffWins = TotalPlayOffWins + 1
        where TeamID = @winningTeamID;
            /*
            in 
            (select WinningTeamID from inserted where WinningTeamID is not null);
            */

        update Team
        set TotalPlayOffLosses = TotalPlayOffLosses + 1
        where TeamID = @losingTeamID;
            /*
            in
            (select LosingTeamID from inserted where LosingTeamID is not null);
            */

        -- Insert into AdminChangesTracker
        declare @NFLAdminID int,
        @ChangeDescription nvarchar(255);
        set @ChangeDescription = 'Scores updated for game ' + cast(@gameID as nvarchar(10));

        -- Set the NFLAdminID from context_info
        --set @NFLAdminID = cast(context_info() as int);
        set @NFLAdminID = convert(int, convert(binary(4),context_info()));
        
        insert into AdminChangesTracker (NFLAdminID, GameID, ChangeDateTime, ChangeType, ChangeDescription)
        values (@NFLAdminID, @gameID, getdate(), 'Update', @ChangeDescription);
        --select @NFLAdminID, GameID, getdate(), 'Update', 'Scores updated for game' from inserted;
    end
end;
