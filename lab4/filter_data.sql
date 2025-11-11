SELECT 
    Specialization, 
    COUNT(DoctorID) AS number_of_doctors
FROM Doctor
GROUP BY Specialization
HAVING COUNT(DoctorID) > 1;


SELECT 
    PatientID, 
    COUNT(AppointmentID) AS total_appointments
FROM Appointment
GROUP BY PatientID
HAVING COUNT(AppointmentID) > 1;


