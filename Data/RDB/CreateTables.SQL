
drop table if exists Room;
drop table if exists RoomAvailability;

go

create table Room
(
    RoomID int identity(1,1) primary key,
    RoomNumber varchar(10) not null,
    Whiteboard bit not null
);

create table RoomAvailability
(
    RoomAvailabilityID int identity(1,1) primary key,
    RoomID int not null,
    AvailableDate date not null, 
    AvailableStartTime time not null,
    AvailableEndTime time not null,
    constraint FK_RoomAvailability_Room foreign key (RoomID) references Room(RoomID)
);