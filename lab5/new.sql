CREATE TABLE IF NOT EXISTS Department (
    DepartmentID SERIAL PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Patient (
    PatientID SERIAL PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    PhoneNumber VARCHAR(20) UNIQUE,
    Address TEXT
);

CREATE TABLE IF NOT EXISTS Doctor (
    DoctorID SERIAL PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100),
    AvailabilityStatus VARCHAR(50) CHECK (AvailabilityStatus IN ('Доступний', 'На прийомі', 'Не на роботі')),
    DepartmentID INTEGER NOT NULL REFERENCES Department(DepartmentID)
);

CREATE TABLE IF NOT EXISTS Medication (
    MedicationID SERIAL PRIMARY KEY,
    MedicationName VARCHAR(100) NOT NULL UNIQUE,
    Manufacturer VARCHAR(100),
    Description TEXT
);

CREATE TABLE IF NOT EXISTS Medical_Record (
    RecordID SERIAL PRIMARY KEY,
    PatientID INTEGER NOT NULL UNIQUE REFERENCES Patient(PatientID) ON DELETE CASCADE,
    Allergies TEXT,
    ChronicConditions TEXT,
    BloodType VARCHAR(3)
);

CREATE TABLE IF NOT EXISTS Schedule (
    ScheduleID SERIAL PRIMARY KEY,
    DoctorID INTEGER NOT NULL REFERENCES Doctor(DoctorID) ON DELETE CASCADE,
    DayOfWeek VARCHAR(20) NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL
);

CREATE TABLE IF NOT EXISTS Appointment (
    AppointmentID SERIAL PRIMARY KEY,
    AppointmentDate TIMESTAMP NOT NULL,
    Symptoms TEXT,
    Diagnosis TEXT,
    PatientID INTEGER NOT NULL REFERENCES Patient(PatientID) ON DELETE CASCADE,
    DoctorID INTEGER NOT NULL REFERENCES Doctor(DoctorID) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Lab_Test (
    TestID SERIAL PRIMARY KEY,
    AppointmentID INTEGER NOT NULL REFERENCES Appointment(AppointmentID) ON DELETE CASCADE,
    TestName VARCHAR(100) NOT NULL,
    TestDate DATE,
    Results TEXT
);
 
CREATE TABLE IF NOT EXISTS Prescription (
    PrescriptionID SERIAL PRIMARY KEY,
    AppointmentID INTEGER NOT NULL REFERENCES Appointment(AppointmentID) ON DELETE CASCADE,
    MedicationID INTEGER NOT NULL REFERENCES Medication(MedicationID) ON DELETE RESTRICT,
    Dosage VARCHAR(100) NOT NULL,
    Instructions TEXT
);
