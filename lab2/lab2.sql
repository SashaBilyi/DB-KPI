-- СТВОРЕННЯ ТАБЛИЦЬ

CREATE TABLE Department (
    DepartmentID SERIAL PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(255)
);

CREATE TABLE Patient (
    PatientID SERIAL PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    PhoneNumber VARCHAR(20) UNIQUE,
    Address TEXT
);

CREATE TABLE Medication (
    MedicationID SERIAL PRIMARY KEY,
    MedicationName VARCHAR(100) NOT NULL UNIQUE,
    Manufacturer VARCHAR(100),
    Description TEXT
);

CREATE TABLE Doctor (
    DoctorID SERIAL PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100),
    AvailabilityStatus VARCHAR(50) CHECK (AvailabilityStatus IN ('Доступний', 'На прийомі', 'Не на роботі')),
    DepartmentID INTEGER NOT NULL REFERENCES Department(DepartmentID)
);

CREATE TABLE Medical_Record (
    RecordID SERIAL PRIMARY KEY,
    PatientID INTEGER NOT NULL UNIQUE REFERENCES Patient(PatientID) ON DELETE CASCADE, 
    Allergies TEXT,
    ChronicConditions TEXT,
    BloodType VARCHAR(3) CHECK (BloodType IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'))
);

CREATE TABLE Schedule (
    ScheduleID SERIAL PRIMARY KEY,
    DoctorID INTEGER NOT NULL REFERENCES Doctor(DoctorID) ON DELETE CASCADE,
    DayOfWeek VARCHAR(20) NOT NULL CHECK (DayOfWeek IN ('Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П''ятниця', 'Субота', 'Неділя')),
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL
);

CREATE TABLE Appointment (
    AppointmentID SERIAL PRIMARY KEY,
    AppointmentDate TIMESTAMP NOT NULL,
    Symptoms TEXT,
    Diagnosis TEXT,
    PatientID INTEGER NOT NULL REFERENCES Patient(PatientID) ON DELETE CASCADE,
    DoctorID INTEGER NOT NULL REFERENCES Doctor(DoctorID) ON DELETE SET NULL
);

CREATE TABLE Lab_Test (
    TestID SERIAL PRIMARY KEY,
    AppointmentID INTEGER NOT NULL REFERENCES Appointment(AppointmentID) ON DELETE CASCADE,
    TestName VARCHAR(100) NOT NULL,
    TestDate DATE,
    Results TEXT
);

CREATE TABLE Prescription (
    PrescriptionID SERIAL PRIMARY KEY,
    AppointmentID INTEGER NOT NULL REFERENCES Appointment(AppointmentID) ON DELETE CASCADE,
    MedicationID INTEGER NOT NULL REFERENCES Medication(MedicationID) ON DELETE RESTRICT,
    Dosage VARCHAR(100) NOT NULL,
    Instructions TEXT
);


-- ВСТАВКА ДАНИХ 

INSERT INTO Department (DepartmentName, Location) VALUES
('Кардіологія', 'Корпус А, 3 поверх'),
('Терапія', 'Корпус Б, 1 поверх'),
('Хірургія', 'Корпус А, 5 поверх');

INSERT INTO Patient (FirstName, LastName, DateOfBirth, PhoneNumber, Address) VALUES
('Іван', 'Петренко', '1985-06-15', '+380501234567', 'м. Київ, вул. Хрещатик, 10'),
('Марія', 'Сидоренко', '1992-11-30', '+380679876543', 'м. Львів, пл. Ринок, 5'),
('Петро', 'Коваленко', '1978-03-22', '+380931112233', 'м. Одеса, вул. Дерибасівська, 1');

INSERT INTO Medication (MedicationName, Manufacturer, Description) VALUES
('Аспірин', 'Bayer', 'Протизапальний засіб'),
('Парацетамол', 'Дарниця', 'Жарознижуючий засіб'),
('Лізиноприл', 'Pfizer', 'Засіб від тиску');

INSERT INTO Doctor (FirstName, LastName, Specialization, AvailabilityStatus, DepartmentID) VALUES
('Ольга', 'Іванова', 'Кардіолог', 'Доступний', 1),
('Андрій', 'Мельник', 'Терапевт', 'На прийомі', 2),
('Сергій', 'Воронін', 'Хірург', 'Не на роботі', 3);

INSERT INTO Medical_Record (PatientID, Allergies, ChronicConditions, BloodType) VALUES
(1, 'Пеніцилін', 'Гіпертонія', 'A+'),
(2, 'Немає', 'Немає', 'O-'),
(3, 'Амброзія', 'Астма', 'B+');

INSERT INTO Schedule (DoctorID, DayOfWeek, StartTime, EndTime) VALUES
(1, 'Понеділок', '09:00', '15:00'),
(1, 'Середа', '09:00', '15:00'),
(2, 'Вівторок', '10:00', '16:00'),
(2, 'Четвер', '10:00', '16:00'),
(3, 'Понеділок', '08:00', '14:00');

INSERT INTO Appointment (AppointmentDate, Symptoms, Diagnosis, PatientID, DoctorID) VALUES
('2025-10-28 10:00:00', 'Біль у грудях', 'Підозра на стенокардію', 1, 1),
('2025-10-28 11:00:00', 'Висока температура, кашель', 'ГРВІ', 2, 2),
('2025-10-29 09:30:00', 'Консультація перед операцією', 'Планова госпіталізація', 3, 3);

INSERT INTO Lab_Test (AppointmentID, TestName, TestDate, Results) VALUES
(1, 'Аналіз крові (загальний)', '2025-10-28', 'Гемоглобін 140, лейкоцити 5.5'),
(1, 'ЕКГ', '2025-10-28', 'Ритм синусовий, без відхилень'),
(2, 'Аналіз крові (загальний)', '2025-10-28', 'Лейкоцити 9.0');

INSERT INTO Prescription (AppointmentID, MedicationID, Dosage, Instructions) VALUES
(1, 3, '10 мг', 'Приймати 1 раз на день вранці'),
(2, 2, '500 мг', 'Приймати 3 рази на день при температурі вище 38.0');
