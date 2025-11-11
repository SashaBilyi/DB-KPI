SELECT * FROM Patient
WHERE PatientID IN (
    SELECT PatientID 
    FROM Appointment
    WHERE DoctorID IN (
        SELECT DoctorID 
        FROM Doctor 
        WHERE Specialization = 'Кардіолог'
    )
);


SELECT 
    MedicationName, 
    Manufacturer
FROM Medication
WHERE MedicationID NOT IN (
    SELECT DISTINCT MedicationID 
    FROM Prescription
);


SELECT 
    P.FirstName,
    P.LastName,
    (
        SELECT COUNT(*) 
        FROM Appointment AS A 
        WHERE A.PatientID = P.PatientID
    ) AS total_appointments
FROM Patient AS P;
