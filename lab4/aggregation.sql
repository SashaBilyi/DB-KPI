SELECT COUNT(*) AS total_patients
FROM Patient;


SELECT 
    MAX(DateOfBirth) AS youngest_patient_dob,
    MIN(DateOfBirth) AS oldest_patient_dob
FROM Patient;


SELECT COUNT(AppointmentID) AS total_appointments
FROM Appointment;
