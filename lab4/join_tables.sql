SELECT 
    P.FirstName,
    P.LastName,
    A.AppointmentDate,
    A.Symptoms
FROM Patient AS P
INNER JOIN Appointment AS A ON P.PatientID = A.PatientID;


SELECT 
    P.FirstName,
    P.LastName,
    A.AppointmentDate
FROM Patient AS P
LEFT JOIN Appointment AS A ON P.PatientID = A.PatientID;


SELECT 
    D.FirstName, 
    D.LastName,
    D.Specialization,
    S.DayOfWeek,
    S.StartTime,
    S.EndTime
FROM Schedule AS S
RIGHT JOIN Doctor AS D ON S.DoctorID = D.DoctorID;
