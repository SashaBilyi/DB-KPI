# Звіт з нормалізації бази даних (Лабораторна робота №5)

## 1. Вступ

Метою цієї лабораторної роботи є аналіз та вдосконалення схеми бази даних шляхом нормалізації. Оскільки моя фінальна схема (розроблена в Лабораторних роботах 1-4) вже відповідає третій нормальній формі (3NF), у цьому звіті я **змоделюю процес нормалізації** на прикладі "сирих" даних.

Ми припустимо, що на початку проектування дані зберігалися у двох неструктурованих таблицях:
1.  **`Patient_Log`** (Містить змішані дані про пацієнтів, їхні візити та лікування).
2.  **`Doctor_Log`** (Містить дані про лікарів та їхні відділення).

---

## 2. Оригінальний дизайн (Ненормалізований)

Нижче наведено структуру початкових таблиць, які містять надлишковість та порушують правила нормалізації.

### Таблиця 1: `Patient_Log`
Ця таблиця намагається зберігати все одразу: хто пацієнт, коли прийшов, який діагноз отримав і які ліки йому виписали.

```sql
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
```

### Таблиця 2: `Doctor_Log`
Ця таблиця поєднує дані про лікаря з даними про його місце роботи.

```sql
CREATE TABLE Doctor_Log (
    StaffID SERIAL PRIMARY KEY,
    DoctorName VARCHAR(100),
    Specialization VARCHAR(100),
    DepartmentName VARCHAR(100),
    DepartmentLocation VARCHAR(255), 
    AvailabilityStatus VARCHAR(50)
);
```

---

## 3. Аналіз аномалій

Через погану структуру в наведених вище таблицях присутні суттєві аномалії:

1.  **Аномалія вставки (Insertion Anomaly):**
    * Ми не можемо додати нового лікаря в систему, якщо ще не знаємо, у якому відділенні він працює (або якщо відділення ще не створене), оскільки атрибути відділення "приклеєні" до лікаря.
    * Ми не можемо зареєструвати нового пацієнта без запису на прийом (бо дані пацієнта зберігаються в рядку візиту).

2.  **Аномалія оновлення (Update Anomaly):**
    * Якщо відділення "Кардіологія" переїжджає в інший корпус, нам потрібно оновити поле `DepartmentLocation` у всіх рядках таблиці `Doctor_Log`, де є кардіологи. Якщо пропустити хоч один рядок, виникне неузгодженість даних.
    * Якщо пацієнт змінив телефон, треба оновлювати всі його старі записи в `Patient_Log`.

3.  **Аномалія видалення (Deletion Anomaly):**
    * Якщо ми видалимо єдиний запис про візит пацієнта, ми втратимо всю інформацію про нього (телефон, адресу), оскільки вона не зберігається окремо.

---

## 4. Функціональні залежності (Functional Dependencies)

Я визначив такі залежності, які вказують на проблеми нормалізації:

**Для таблиці `Patient_Log`:**
* `PatientName` -> `PatientPhone`, `PatientAddress`, `PatientBirthDate` (Часткова залежність: ці дані залежать від особи пацієнта, а не від конкретного візиту `LogID`).
* `LogID` -> `PrescribedMedications` (Порушення атомарності: одне поле містить множину значень).

**Для таблиці `Doctor_Log`:**
* `DoctorName` -> `Specialization`, `DepartmentName`.
* `DepartmentName` -> `DepartmentLocation` (Транзитивна залежність: Локація залежить від Відділення, а Лікар залежить від Відділення).

---

## 5. Покрокова нормалізація

Процес переходу від ненормалізованого стану до 3NF.

### Крок 1: Перехід до Першої нормальної форми (1NF)
**Вимога:** Усі атрибути мають бути атомарними (без списків).

* **Проблема:** Поля `PrescribedMedications` та `PatientAllergies` містять списки значень через кому.
* **Рішення:** Виносимо ці дані в окремі таблиці.
    * Створено таблицю **`Medication`** (довідник ліків).
    * Створено таблицю **`Prescription`** (зв'язок "один-до-багатьох" між візитом та ліками).
    * Створено таблицю **`Medical_Record`** для зберігання алергій.

### Крок 2: Перехід до Другої нормальної форми (2NF)
**Вимога:** Таблиця в 1NF і відсутні часткові залежності (неключові атрибути залежать від усього ключа).

* **Проблема:** У `Patient_Log` особисті дані пацієнта (`Phone`, `Address`) дублюються при кожному візиті. Вони залежать від сутності Пацієнта, а не від події Візиту.
* **Рішення:** Декомпозиція таблиці на дві:
    1.  **`Patient`**: Зберігає унікальні дані про особу (`Name`, `Phone`, `Address`, `DateOfBirth`).
    2.  **`Appointment`**: Зберігає дані про подію (`Date`, `Symptoms`, `Diagnosis`) і посилається на `PatientID`.

### Крок 3: Перехід до Третьої нормальної форми (3NF)
**Вимога:** Таблиця в 2NF і відсутні транзитивні залежності (неключові атрибути залежать тільки від ключа, а не від інших атрибутів).

* **Проблема:** У `Doctor_Log` поле `DepartmentLocation` залежить від `DepartmentName`, яке, в свою чергу, залежить від `DoctorName`. Це транзитивна залежність (`Doctor -> Department -> Location`).
* **Рішення:** Декомпозиція таблиці:
    1.  **`Department`**: Зберігає дані про відділення (`Name`, `Location`).
    2.  **`Doctor`**: Зберігає дані лікаря і містить лише зовнішній ключ `DepartmentID`.

---

## 6. Фінальна схема (Результат)

У результаті нормалізації ми отримали набір таблиць, які відповідають 3NF. Нижче наведено SQL-код для створення фінальної структури.

```sql
-- 1. Department 
CREATE TABLE IF NOT EXISTS Department (
    DepartmentID SERIAL PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(255)
);

-- 2. Patient 
CREATE TABLE IF NOT EXISTS Patient (
    PatientID SERIAL PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    PhoneNumber VARCHAR(20) UNIQUE,
    Address TEXT
);

-- 3. Doctor 
CREATE TABLE IF NOT EXISTS Doctor (
    DoctorID SERIAL PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100),
    AvailabilityStatus VARCHAR(50) CHECK (AvailabilityStatus IN ('Доступний', 'На прийомі', 'Не на роботі')),
    DepartmentID INTEGER NOT NULL REFERENCES Department(DepartmentID)
);

-- 4. Medication 
CREATE TABLE IF NOT EXISTS Medication (
    MedicationID SERIAL PRIMARY KEY,
    MedicationName VARCHAR(100) NOT NULL UNIQUE,
    Manufacturer VARCHAR(100),
    Description TEXT
);

-- 5. Medical_Record 
CREATE TABLE IF NOT EXISTS Medical_Record (
    RecordID SERIAL PRIMARY KEY,
    PatientID INTEGER NOT NULL UNIQUE REFERENCES Patient(PatientID) ON DELETE CASCADE,
    Allergies TEXT,
    ChronicConditions TEXT,
    BloodType VARCHAR(3)
);

-- 6. Schedule 
CREATE TABLE IF NOT EXISTS Schedule (
    ScheduleID SERIAL PRIMARY KEY,
    DoctorID INTEGER NOT NULL REFERENCES Doctor(DoctorID) ON DELETE CASCADE,
    DayOfWeek VARCHAR(20) NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL
);

-- 7. Appointment
CREATE TABLE IF NOT EXISTS Appointment (
    AppointmentID SERIAL PRIMARY KEY,
    AppointmentDate TIMESTAMP NOT NULL,
    Symptoms TEXT,
    Diagnosis TEXT,
    PatientID INTEGER NOT NULL REFERENCES Patient(PatientID) ON DELETE CASCADE,
    DoctorID INTEGER NOT NULL REFERENCES Doctor(DoctorID) ON DELETE SET NULL
);

-- 8. Lab_Test 
CREATE TABLE IF NOT EXISTS Lab_Test (
    TestID SERIAL PRIMARY KEY,
    AppointmentID INTEGER NOT NULL REFERENCES Appointment(AppointmentID) ON DELETE CASCADE,
    TestName VARCHAR(100) NOT NULL,
    TestDate DATE,
    Results TEXT
);

-- 9. Prescription 
CREATE TABLE IF NOT EXISTS Prescription (
    PrescriptionID SERIAL PRIMARY KEY,
    AppointmentID INTEGER NOT NULL REFERENCES Appointment(AppointmentID) ON DELETE CASCADE,
    MedicationID INTEGER NOT NULL REFERENCES Medication(MedicationID) ON DELETE RESTRICT,
    Dosage VARCHAR(100) NOT NULL,
    Instructions TEXT
);
```

Ця структура повністю усуває описані вище аномалії, забезпечує цілісність даних та відповідає вимогам 3NF.

