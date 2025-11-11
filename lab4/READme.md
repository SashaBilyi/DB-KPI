# Лабораторна робота №4: Аналітичні SQL-запити (OLAP)

Аналітичні SQL-запити (OLAP), розроблені для бази даних "Система лікарняних записів".

---

## 1. Базова агрегація

### 1.1: Загальна кількість пацієнтів
Підраховує загальну кількість пацієнтів у базі даних.
```sql
SELECT COUNT(*) AS total_patients
FROM Patient;
```

### 1.2: Найстарший та наймолодший пацієнт
Знаходить дату народження наймолодшого та найстаршого пацієнта.
```sql
SELECT 
    MAX(DateOfBirth) AS youngest_patient_dob,
    MIN(DateOfBirth) AS oldest_patient_dob
FROM Patient;
```

### 1.3: Загальна кількість прийомів
Підраховує загальну кількість прийомів (Appointment), запланованих у системі.
```sql
SELECT COUNT(AppointmentID) AS total_appointments
FROM Appointment;
```

---

## 2. Групування даних (GROUP BY)

### 2.1: Кількість лікарів за спеціалізацією
Групує лікарів за їхньою спеціалізацією та рахує кількість у кожній групі.
```sql
SELECT 
    Specialization, 
    COUNT(DoctorID) AS number_of_doctors
FROM Doctor
GROUP BY Specialization;
```

### 2.2: Кількість прийомів у кожного пацієнта
Групує прийоми за PatientID та рахує їх для кожного пацієнта
```sql
SELECT 
    PatientID, 
    COUNT(AppointmentID) AS total_appointments
FROM Appointment
GROUP BY PatientID
ORDER BY total_appointments DESC;
```

### 2.3: Який препарат виписували найчастіше?
Групує рецепти за MedicationID та рахує, скільки разів виписували кожні ліки.
```sql
SELECT 
    MedicationID, 
    COUNT(PrescriptionID) AS prescription_count
FROM Prescription
GROUP BY MedicationID
ORDER BY prescription_count DESC;
```

---

## 3. Фільтрування груп (HAVING)

### 3.1: Спеціалізації, де працює більше 1 лікаря
Знаходить спеціалізації, де працює більше 1 лікаря, фільтруючи згруповані результати.
```sql
SELECT 
    Specialization, 
    COUNT(DoctorID) AS number_of_doctors
FROM Doctor
GROUP BY Specialization
HAVING COUNT(DoctorID) > 1;
```

### 3.2: Пацієнти, які мали більше одного прийому
Знаходить пацієнтів, які мали більше одного прийому.
```sql
SELECT 
    PatientID, 
    COUNT(AppointmentID) AS total_appointments
FROM Appointment
GROUP BY PatientID
HAVING COUNT(AppointmentID) > 1;
```

---

## 4. Об'єднання таблиць (JOIN)

### 4.1: INNER JOIN (Пацієнти та їхні прийоми)
(INNER JOIN) Повертає список пацієнтів та дати їхніх прийомів. Покаже лише тих пацієнтів, у яких був прийом.
```sql
SELECT 
    P.FirstName,
    P.LastName,
    A.AppointmentDate,
    A.Symptoms
FROM Patient AS P
INNER JOIN Appointment AS A ON P.PatientID = A.PatientID;
```

### 4.2: LEFT JOIN (Всі пацієнти та їхні прийоми)
(LEFT JOIN) Повертає список ВСІХ пацієнтів, і якщо у них були прийоми, показує їх дати. [cite_start]Якщо прийомів не було, поле дати буде `NULL`.
```sql
SELECT 
    P.FirstName,
    P.LastName,
    A.AppointmentDate
FROM Patient AS P
LEFT JOIN Appointment AS A ON P.PatientID = A.PatientID;
```

### 4.3: RIGHT JOIN (Всі лікарі та їхні графіки)
(RIGHT JOIN) Повертає список ВСІХ лікарів, навіть тих, у кого немає графіка. Якщо графіка немає, поля графіка будуть `NULL`.
```sql
SELECT 
    D.FirstName, 
    D.LastName,
    D.Specialization,
    S.DayOfWeek,
    S.StartTime,
    S.EndTime
FROM Schedule AS S
RIGHT JOIN Doctor AS D ON S.DoctorID = D.DoctorID;
```

---

## 5. Багатотаблична агрегація (JOIN + GROUP BY)

### 5.1: Кількість лікарів у кожному відділенні
Показує назву кожного відділення та кількість лікарів у ньому, включаючи відділення з 0 лікарів.
```sql
SELECT 
    D.DepartmentName,
    COUNT(Doc.DoctorID) AS number_of_doctors
FROM Department AS D
LEFT JOIN Doctor AS Doc ON D.DepartmentID = Doc.DepartmentID
GROUP BY D.DepartmentName
ORDER BY number_of_doctors DESC;
```

### 5.2: Скільки прийомів провів кожен лікар?
Показує, скільки прийомів провів кожен лікар, для аналізу продуктивності.
```sql
SELECT 
    D.FirstName,
    D.LastName,
    D.Specialization,
    COUNT(A.AppointmentID) AS total_appointments
FROM Doctor AS D
JOIN Appointment AS A ON D.DoctorID = A.DoctorID
GROUP BY D.DoctorID, D.FirstName, D.LastName, D.Specialization
ORDER BY total_appointments DESC;
```

---

## 6. Підзапити (Subqueries)

### 6.1: Підзапит у WHERE (Пацієнти у кардіолога)
(Підзапит у WHERE) Знаходить всіх пацієнтів, які були на прийомі у Кардіолога.
```sql
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
```

### 6.2: Підзапит у WHERE (Ліки, які не виписували)
(Підзапит у WHERE) Знаходить ліки, які ніколи не виписували, використовуючи `NOT IN`.
```sql
SELECT 
    MedicationName, 
    Manufacturer
FROM Medication
WHERE MedicationID NOT IN (
    SELECT DISTINCT MedicationID 
    FROM Prescription
);
```

### 6.3: Корельований підзапит у SELECT
(Корельований підзапит у SELECT) Виводить список ВСІХ пацієнтів та обчислює кількість їхніх прийомів в окремому стовпці.
```sql
SELECT 
    P.FirstName,
    P.LastName,
    (
        SELECT COUNT(*) 
        FROM Appointment AS A 
        WHERE A.PatientID = P.PatientID
    ) AS total_appointments
FROM Patient AS P;
```

