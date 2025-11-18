CREATE TABLE Patient_Log (
    LogID SERIAL PRIMARY KEY, 
    PatientName VARCHAR(100),
    PatientPhone VARCHAR(20),
    PatientAddress TEXT,
    PatientBirthDate DATE,
    PatientAllergies TEXT,    
    AppointmentDate TIMESTAMP,
    DoctorName VARCHAR(100),  
    Diagnosis TEXT,
    PrescribedMedications TEXT  
);

CREATE TABLE Doctor_Log (
    StaffID SERIAL PRIMARY KEY,
    DoctorName VARCHAR(100),
    Specialization VARCHAR(100),
    DepartmentName VARCHAR(100),
    DepartmentLocation VARCHAR(255), 
    AvailabilityStatus VARCHAR(50)
);
