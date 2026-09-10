INSERT INTO AppUser (AppUserName, Email, Password)
VALUES
('Alice Johnson', 'alice@example.com', 'Pass123!'),
('Ben Smith', 'ben@example.com', 'Pass123!'),
('Carla Davis', 'carla@example.com', 'Pass123!'),
('David Lee', 'david@example.com', 'Pass123!'),
('Emma Brown', 'emma@example.com', 'Pass123!');


INSERT INTO Room (RoomNumber, Floor, Seats, Whiteboard, CurrentStatus)
VALUES
('401', 4, 20, 1, 'Available'),
('402', 4, 15, 0, 'Available'),
('403', 4, 25, 1, 'In Use'),
('501', 5, 30, 1, 'Available'),
('502', 5, 40, 0, 'Available');


INSERT INTO RoomAvailability (RoomID, AvailableDate, AvailableStartTime, AvailableEndTime, AvailabilityStatus)
VALUES
-- Room 1 (RoomID = 1)
(1, '2026-09-10', '09:00', '10:00', 'Available'),
(1, '2026-09-10', '10:00', '11:00', 'Available'),
(1, '2026-09-10', '11:00', '12:00', 'Reserved'),
(1, '2026-09-11', '09:00', '10:00', 'Available'),
(1, '2026-09-11', '10:00', '11:00', 'Available'),

-- Room 2 (RoomID = 2)
(2, '2026-09-10', '09:00', '10:00', 'Available'),
(2, '2026-09-10', '10:00', '11:00', 'Reserved'),
(2, '2026-09-10', '11:00', '12:00', 'Available'),
(2, '2026-09-11', '09:00', '10:00', 'Available'),
(2, '2026-09-11', '10:00', '11:00', 'Available'),

-- Room 3 (RoomID = 3)
(3, '2026-09-10', '09:00', '10:00', 'Available'),
(3, '2026-09-10', '10:00', '11:00', 'Available'),
(3, '2026-09-10', '11:00', '12:00', 'Reserved'),
(3, '2026-09-11', '09:00', '10:00', 'Available'),
(3, '2026-09-11', '10:00', '11:00', 'Available'),

-- Room 4 (RoomID = 4)
(4, '2026-09-10', '09:00', '10:00', 'Reserved'),
(4, '2026-09-10', '10:00', '11:00', 'Available'),
(4, '2026-09-10', '11:00', '12:00', 'Available'),
(4, '2026-09-11', '09:00', '10:00', 'Available'),
(4, '2026-09-11', '10:00', '11:00', 'Reserved'),

-- Room 5 (RoomID = 5)
(5, '2026-09-10', '09:00', '10:00', 'Available'),
(5, '2026-09-10', '10:00', '11:00', 'Available'),
(5, '2026-09-10', '11:00', '12:00', 'Reserved'),
(5, '2026-09-11', '09:00', '10:00', 'Available'),
(5, '2026-09-11', '10:00', '11:00', 'Available');


INSERT INTO Reservation (AppUserID, RoomAvailabilityID, ReservationDateTime, CheckInDateTime, CheckOutDateTime, TotalTime, ReservationStatus)
VALUES
(1, 3, '2026-09-10 08:55', '2026-09-10 09:00', '2026-09-10 10:00', 60, 'Completed'),
(2, 7, '2026-09-10 09:50', '2026-09-10 10:00', '2026-09-10 11:00', 60, 'Completed'),
(3, 13, '2026-09-10 10:55', '2026-09-10 11:00', '2026-09-10 12:00', 60, 'Completed'),
(4, 16, '2026-09-10 08:45', '2026-09-10 09:00', '2026-09-10 10:00', 60, 'Completed'),
(5, 20, '2026-09-11 08:55', '2026-09-11 09:00', '2026-09-11 10:00', 60, 'Completed'),

(1, 2, '2026-09-10 09:30', '2026-09-10 10:00', '2026-09-10 11:00', 60, 'Completed'),
(2, 8, '2026-09-10 10:30', '2026-09-10 11:00', '2026-09-10 12:00', 60, 'Completed'),
(3, 12, '2026-09-10 08:50', '2026-09-10 09:00', '2026-09-10 10:00', 60, 'Completed'),
(4, 18, '2026-09-10 09:40', '2026-09-10 10:00', '2026-09-10 11:00', 60, 'Completed'),
(5, 23, '2026-09-11 08:50', '2026-09-11 09:00', '2026-09-11 10:00', 60, 'Completed');

/*SELECT * FROM AppUser;
SELECT * FROM Room;
SELECT * FROM RoomAvailability;
SELECT * FROM Reservation;*/
