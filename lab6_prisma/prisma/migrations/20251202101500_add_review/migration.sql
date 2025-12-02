-- CreateTable
CREATE TABLE "Review" (
    "id" SERIAL NOT NULL,
    "rating" INTEGER NOT NULL,
    "comment" TEXT,
    "doctorid" INTEGER NOT NULL,

    CONSTRAINT "Review_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review_doctorid_fkey" FOREIGN KEY ("doctorid") REFERENCES "doctor"("doctorid") ON DELETE RESTRICT ON UPDATE CASCADE;