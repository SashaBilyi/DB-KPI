# Лабораторна робота №6: Міграції схем з Prisma ORM

## 1. Вступ
Метою цієї лабораторної роботи було налаштування Prisma ORM для існуючої бази даних PostgreSQL та виконання ряду міграцій для зміни структури бази.

### Початковий стан
Спочатку була виконана команда `npx prisma db pull`, яка зчитала існуючу схему (таблиці `patient`, `doctor`, `appointment` і т.д.) у файл `schema.prisma`.
Для фіксації цього стану було створено початкову міграцію `0_init` за допомогою `prisma migrate resolve`.

## 2. Виконані Міграції

### Міграція 1: Додавання таблиці відгуків (`add_review`)
**Мета:** Додати можливість пацієнтам залишати відгуки про лікарів.
**Зміни в `schema.prisma`:**
```prisma
model Review {
  id       Int     @id @default(autoincrement())
  rating   Int
  comment  String?
  doctorid Int
  doctor   doctor  @relation(fields: [doctorid], references: [doctorid])
}

model doctor {
  // ...
  reviews Review[]
}
```
**Результат (SQL):** Створено таблицю `Review` із зовнішнім ключем на `doctor`.

### Міграція 2: Оновлення таблиці пацієнтів (`add_email`)
**Мета:** Розширити дані про пацієнта, додавши поле для електронної пошти.
**Зміни в `schema.prisma`:**
```prisma
model patient {
  // ...
  email String?
}
```
**Результат (SQL):** `ALTER TABLE "patient" ADD COLUMN "email" TEXT;`

### Міграція 3: Оптимізація таблиці ліків (`drop_desc`)
**Мета:** Видалити поле `description` з таблиці `medication`, оскільки воно не використовується в новій версії системи.
**Зміни в `schema.prisma`:**
Рядок `description String?` було видалено з моделі `medication`.
**Результат (SQL):** `ALTER TABLE "medication" DROP COLUMN "description";`

## 3. Перевірка роботи (Prisma Client)

Для перевірки роботи міграцій було використано скрипт на Node.js для вставки та вибірки даних.

**Приклад коду:**
```javascript
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  // Створення відгуку
  const review = await prisma.review.create({
    data: {
      rating: 5,
      comment: "Відмінний спеціаліст!",
      doctorid: 1
    }
  });
  console.log('Created review:', review);

  // Отримання лікаря разом з відгуками
  const doctorWithReviews = await prisma.doctor.findUnique({
    where: { doctorid: 1 },
    include: { reviews: true }
  });
  console.log(doctorWithReviews);
}

main();
```

## Висновок
У ході роботи було успішно налаштовано Prisma ORM, проведено синхронізацію з існуючою базою даних та виконано 3 міграції для еволюції схеми. Всі зміни зафіксовані в історії міграцій.