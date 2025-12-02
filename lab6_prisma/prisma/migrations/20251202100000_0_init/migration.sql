-- CreateTable
CREATE TABLE "appointment" (
    "appointmentid" SERIAL NOT NULL,
    "appointmentdate" TIMESTAMP(6) NOT NULL,
    "symptoms" TEXT,
    "diagnosis" TEXT,
    "patientid" INTEGER NOT NULL,
    "doctorid" INTEGER NOT NULL,

    CONSTRAINT "appointment_pkey" PRIMARY KEY ("appointmentid")
);

-- CreateTable
CREATE TABLE "department" (
    "departmentid" SERIAL NOT NULL,
    "departmentname" VARCHAR(100) NOT NULL,
    "location" VARCHAR(255),

    CONSTRAINT "department_pkey" PRIMARY KEY ("departmentid")
);

-- CreateTable
CREATE TABLE "doctor" (
    "doctorid" SERIAL NOT NULL,
    "firstname" VARCHAR(100) NOT NULL,
    "lastname" VARCHAR(100) NOT NULL,
    "specialization" VARCHAR(100),
    "availabilitystatus" VARCHAR(50),
    "departmentid" INTEGER NOT NULL,

    CONSTRAINT "doctor_pkey" PRIMARY KEY ("doctorid")
);

-- CreateTable
CREATE TABLE "lab_test" (
    "testid" SERIAL NOT NULL,
    "appointmentid" INTEGER NOT NULL,
    "testname" VARCHAR(100) NOT NULL,
    "testdate" DATE,
    "results" TEXT,

    CONSTRAINT "lab_test_pkey" PRIMARY KEY ("testid")
);

-- CreateTable
CREATE TABLE "medical_record" (
    "recordid" SERIAL NOT NULL,
    "patientid" INTEGER NOT NULL,
    "allergies" TEXT,
    "chronicconditions" TEXT,
    "bloodtype" VARCHAR(3),

    CONSTRAINT "medical_record_pkey" PRIMARY KEY ("recordid")
);

-- CreateTable
CREATE TABLE "medication" (
    "medicationid" SERIAL NOT NULL,
    "medicationname" VARCHAR(100) NOT NULL,
    "manufacturer" VARCHAR(100),
    "description" TEXT,

    CONSTRAINT "medication_pkey" PRIMARY KEY ("medicationid")
);

-- CreateTable
CREATE TABLE "patient" (
    "patientid" SERIAL NOT NULL,
    "firstname" VARCHAR(100) NOT NULL,
    "lastname" VARCHAR(100) NOT NULL,
    "dateofbirth" DATE NOT NULL,
    "phonenumber" VARCHAR(20),
    "address" TEXT,

    CONSTRAINT "patient_pkey" PRIMARY KEY ("patientid")
);

-- CreateTable
CREATE TABLE "prescription" (
    "prescriptionid" SERIAL NOT NULL,
    "appointmentid" INTEGER NOT NULL,
    "medicationid" INTEGER NOT NULL,
    "dosage" VARCHAR(100) NOT NULL,
    "instructions" TEXT,

    CONSTRAINT "prescription_pkey" PRIMARY KEY ("prescriptionid")
);

-- CreateTable
CREATE TABLE "schedule" (
    "scheduleid" SERIAL NOT NULL,
    "doctorid" INTEGER NOT NULL,
    "dayofweek" VARCHAR(20) NOT NULL,
    "starttime" TIME(6) NOT NULL,
    "endtime" TIME(6) NOT NULL,

    CONSTRAINT "schedule_pkey" PRIMARY KEY ("scheduleid")
);

-- CreateIndex
CREATE UNIQUE INDEX "department_departmentname_key" ON "department"("departmentname");

-- CreateIndex
CREATE UNIQUE INDEX "medical_record_patientid_key" ON "medical_record"("patientid");

-- CreateIndex
CREATE UNIQUE INDEX "medication_medicationname_key" ON "medication"("medicationname");

-- CreateIndex
CREATE UNIQUE INDEX "patient_phonenumber_key" ON "patient"("phonenumber");

-- AddForeignKey
ALTER TABLE "appointment" ADD CONSTRAINT "appointment_doctorid_fkey" FOREIGN KEY ("doctorid") REFERENCES "doctor"("doctorid") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "appointment" ADD CONSTRAINT "appointment_patientid_fkey" FOREIGN KEY ("patientid") REFERENCES "patient"("patientid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "doctor" ADD CONSTRAINT "doctor_departmentid_fkey" FOREIGN KEY ("departmentid") REFERENCES "department"("departmentid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "lab_test" ADD CONSTRAINT "lab_test_appointmentid_fkey" FOREIGN KEY ("appointmentid") REFERENCES "appointment"("appointmentid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "medical_record" ADD CONSTRAINT "medical_record_patientid_fkey" FOREIGN KEY ("patientid") REFERENCES "patient"("patientid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "prescription" ADD CONSTRAINT "prescription_appointmentid_fkey" FOREIGN KEY ("appointmentid") REFERENCES "appointment"("appointmentid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "prescription" ADD CONSTRAINT "prescription_medicationid_fkey" FOREIGN KEY ("medicationid") REFERENCES "medication"("medicationid") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "schedule" ADD CONSTRAINT "schedule_doctorid_fkey" FOREIGN KEY ("doctorid") REFERENCES "doctor"("doctorid") ON DELETE CASCADE ON UPDATE NO ACTION;