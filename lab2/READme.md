# Звіт Lab2"

## 1. Список таблиць та їх опис

### Таблиця `Department`
Зберігає інформацію про відділення клініки.

* `DepartmentID` (SERIAL): **PRIMARY KEY**. Унікальний ідентифікатор відділення.
* `DepartmentName` (VARCHAR): Назва відділення. [cite_start]Має обмеження **UNIQUE** та **NOT NULL**, щоб уникнути дублікатів[cite: 26, 34].
* `Location` (VARCHAR): Фізичне розташування (наприклад, корпус, поверх).

### Таблиця `Patient`
Зберігає основну демографічну інформацію про пацієнтів.

* `PatientID` (SERIAL): **PRIMARY KEY**. Унікальний ідентифікатор пацієнта.
* `FirstName`, `LastName` (VARCHAR): Ім'я та прізвище. [cite_start]Мають обмеження **NOT NULL**[cite: 34].
* `DateOfBirth` (DATE): Дата народження. Має обмеження **NOT NULL**.
* `PhoneNumber` (VARCHAR): Контактний номер. [cite_start]Має обмеження **UNIQUE**, щоб уникнути реєстрації дублікатів пацієнтів[cite: 34].
* `Address` (TEXT): Адреса проживання.

### Таблиця `Medication`
Довідник медикаментів, доступних для виписки.

* `MedicationID` (SERIAL): **PRIMARY KEY**.
* `MedicationName` (VARCHAR): Назва препарату. Має обмеження **UNIQUE** та **NOT NULL**.
* `Manufacturer` (VARCHAR): Виробник.
* `Description` (TEXT): Опис препарату.

### Таблиця `Doctor`
Зберігає інформацію про лікарів та їхню приналежність до відділень.

* `DoctorID` (SERIAL): **PRIMARY KEY**.
* `FirstName`, `LastName` (VARCHAR): Ім'я та прізвище. Мають обмеження **NOT NULL**.
* `Specialization` (VARCHAR): Спеціалізація лікаря.
* `AvailabilityStatus` (VARCHAR): Поточний статус. [cite_start]Має обмеження **CHECK** (дозволені значення: 'Доступний', 'На прийомі', 'Не на роботі')[cite: 33].
* `DepartmentID` (INTEGER): **FOREIGN KEY**, що посилається на `Department(DepartmentID)`. [cite_start]Реалізує зв'язок "один-до-багатьох" (одне відділення – багато лікарів)[cite: 31].

### Таблиця `Medical_Record`
Зберігає основну медичну історію пацієнта.

* `RecordID` (SERIAL): **PRIMARY KEY**.
* `PatientID` (INTEGER): **FOREIGN KEY**, що посилається на `Patient(PatientID)`. Цей стовпець також має обмеження **UNIQUE**, що реалізує зв'язок "один-до-одного" (один пацієнт – одна медична картка).
* `Allergies`, `ChronicConditions` (TEXT): Опис алергій та хронічних захворювань.
* `BloodType` (VARCHAR): Група крові. [cite_start]Має обмеження **CHECK** для перевірки коректності введених значень (напр., 'A+', 'O-' тощо)[cite: 33].

### Таблиця `Schedule`
Графік роботи лікарів.

* `ScheduleID` (SERIAL): **PRIMARY KEY**.
* `DoctorID` (INTEGER): **FOREIGN KEY**, що посилається на `Doctor(DoctorID)`.
* `DayOfWeek` (VARCHAR): День тижня. Має обмеження **CHECK** для перевірки на коректну назву дня.
* `StartTime`, `EndTime` (TIME): Час початку та кінця робочого дня.

### Таблиця `Appointment`
Зберігає інформацію про візити пацієнтів до лікарів.

* `AppointmentID` (SERIAL): **PRIMARY KEY**.
* `AppointmentDate` (TIMESTAMP): Точна дата і час прийому.
* `Symptoms`, `Diagnosis` (TEXT): Опис симптомів та діагноз.
* `PatientID` (INTEGER): **FOREIGN KEY**, що посилається на `Patient(PatientID)`.
* `DoctorID` (INTEGER): **FOREIGN KEY**, що посилається на `Doctor(DoctorID)`.

### Таблиця `Lab_Test`
Інформація про лабораторні аналізи, призначені під час прийому.

* `TestID` (SERIAL): **PRIMARY KEY**.
* `AppointmentID` (INTEGER): **FOREIGN KEY**, що посилається на `Appointment(AppointmentID)`.
* `TestName` (VARCHAR): Назва аналізу.
* `TestDate` (DATE): Дата проведення тесту.
* `Results` (TEXT): Результати аналізу.

### Таблиця `Prescription`
Рецепти, виписані під час прийому.

* `PrescriptionID` (SERIAL): **PRIMARY KEY**.
* `AppointmentID` (INTEGER): **FOREIGN KEY**, що посилається на `Appointment(AppointmentID)`.
* `MedicationID` (INTEGER): **FOREIGN KEY**, що посилається на `Medication(MedicationID)`.
* `Dosage` (VARCHAR): Дозування.
* `Instructions` (TEXT): Інструкції щодо прийому.

## 2. Важливі припущення та обмеження

* [cite_start]**Цілісність посилань (Foreign Keys):** Схема активно використовує зовнішні ключі для забезпечення цілісності даних, як того вимагає завдання[cite: 31, 32].
* **Поведінка при видаленні:**
    * **`ON DELETE CASCADE`** використовується у зв'язках, де дочірній запис не має сенсу без батьківського (наприклад, `Medical_Record` видаляється разом з `Patient`; `Lab_Test` і `Prescription` видаляються разом з `Appointment`).
    * **`ON DELETE SET NULL`** використовується для зв'язку `Appointment` -> `Doctor`. Якщо лікар звільняється (видаляється з таблиці `Doctor`), запис про прийом залишається в системі, але поле `DoctorID` стає `NULL`.
    * **`ON DELETE RESTRICT`** (поведінка за замовчуванням) використовується для зв'язку `Prescription` -> `Medication`. Це не дозволить видалити препарат з довідника `Medication`, якщо на нього існують виписані рецепти.
* [cite_start]**Первинні ключі:** Усі первинні ключі використовують тип `SERIAL` для автоматичної генерації унікальних ID[cite: 22, 28].
* [cite_start]**Обмеження:** Обмеження `NOT NULL`, `UNIQUE` та `CHECK` використовуються змістовно для забезпечення якості та узгодженості даних[cite: 33, 34, 97].
