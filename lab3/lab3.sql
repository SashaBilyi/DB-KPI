--SELECT * FROM Patient

--INSERT INTO Patient (FirstName, LastName, DateOfBirth, PhoneNumber, Address)
--VALUES ('Олена', 'Коваль', '1995-03-08', '+380995556677', 'м. Київ, вул. Перемоги, 25');

--SELECT * FROM Patient WHERE LastName = 'Коваль';

--INSERT INTO Medical_Record (PatientID, Allergies, ChronicConditions, BloodType)
--VALUES (4, 'Немає', 'Немає', 'B+');

--SELECT * FROM Medical_Record WHERE PatientID = 4;

-----------------------------------------------------------------------------
--SELECT DoctorID, FirstName, LastName, AvailabilityStatus
--FROM Doctor
--WHERE Specialization = 'Кардіолог' AND AvailabilityStatus = 'Доступний';

--INSERT INTO Appointment (AppointmentDate, Symptoms, PatientID, DoctorID)
--VALUES ('2025-10-29 14:00:00', 'Скарги на підвищений тиск, плановий огляд', 1, 1);

--SELECT * FROM Appointment
-----------------------------------------------------------------------------

--SELECT * FROM Appointment 
--WHERE AppointmentID = 4;

--UPDATE Appointment
--SET 
--    Diagnosis = 'Гіпертонічна хвороба, початкова стадія'
--WHERE 
--    AppointmentID = 4;


--INSERT INTO Prescription (AppointmentID, MedicationID, Dosage, Instructions)
--VALUES (4, 3, '10 мг', 'Приймати 1 таблетку щоранку');

--SELECT * FROM Prescription WHERE AppointmentID = 4;
------------------------------------------------------------------------------

--SELECT * FROM Appointment 
--WHERE AppointmentID = 3 AND PatientID = 3;

--DELETE FROM Appointment
--WHERE AppointmentID = 3;

--SELECT * FROM Appointment 


