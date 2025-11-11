SELECT 
    D.DepartmentName,
    COUNT(Doc.DoctorID) AS number_of_doctors
FROM Department AS D
LEFT JOIN Doctor AS Doc ON D.DepartmentID = Doc.DepartmentID
GROUP BY D.DepartmentName
ORDER BY number_of_doctors DESC;


SELECT 
    D.FirstName,
    D.LastName,
    D.Specialization,
    COUNT(A.AppointmentID) AS total_appointments
FROM Doctor AS D
JOIN Appointment AS A ON D.DoctorID = A.DoctorID
GROUP BY D.DoctorID, D.FirstName, D.LastName, D.Specialization
ORDER BY total_appointments DESC;


