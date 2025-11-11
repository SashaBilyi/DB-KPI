SELECT 
    Specialization, 
    COUNT(DoctorID) AS number_of_doctors
FROM Doctor
GROUP BY Specialization;


SELECT 
    PatientID, 
    COUNT(AppointmentID) AS total_appointments
FROM Appointment
GROUP BY PatientID
ORDER BY total_appointments DESC;


SELECT 
    MedicationID, 
    COUNT(PrescriptionID) AS prescription_count
FROM Prescription
GROUP BY MedicationID
ORDER BY prescription_count DESC;
