create or alter procedure procRecordEvent

    @SensorID int,
    @EventType nvarchar(5)

as
begin
    insert into SensorLog (SensorID, EventType, EventDateTime)
    values (@SensorID, @EventType, SYSDATETIMEOFFSET() AT TIME ZONE 'Eastern Standard Time')
end;

--select * from SensorLog;
--execute procRecordEvent 1, 'Enter';

GO

create or alter trigger trgUpdateRoomStatus
on SensorLog
after insert
as
begin
    declare @EventType nvarchar(5), @RoomID int

    select @EventType = I.EventType, @RoomID = S.RoomID
    from inserted I inner join Sensor S
        on I.SensorID = S.SensorID;

    --trigger action
    if( @EventType = 'Enter')
    begin
        execute procUpdateRoomStatus @RoomID, 'Enter'
    end

    if( @EventType = 'Exit')
    begin
        execute procUpdateRoomStatus @RoomID, 'Exit'
    end
end;

--select * from Room;
--select * from SensorLog;
--execute procRecordEvent 1, 'Enter';

go

create or alter procedure procUpdateRoomStatus
    @RoomID int,
    @EventType nvarchar(5)
as
begin
    update room
    set currentStatus = @EventType
    where RoomID = @RoomID
end;

--execute procUpdateRoomStatus 1, 'Enter';