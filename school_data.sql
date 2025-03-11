-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: school_data
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admission_form`
--

DROP TABLE IF EXISTS `admission_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admission_form` (
  `Admission_No` int NOT NULL,
  `Admission_Date` date DEFAULT NULL,
  `Student_ID` varchar(10) DEFAULT NULL,
  `Student_Name` varchar(50) DEFAULT NULL,
  `Academic_Year` int DEFAULT NULL,
  `Class` int DEFAULT NULL,
  `Section` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`Admission_No`),
  KEY `Student_ID` (`Student_ID`),
  CONSTRAINT `admission_form_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `student_master` (`Student_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admission_form`
--

LOCK TABLES `admission_form` WRITE;
/*!40000 ALTER TABLE `admission_form` DISABLE KEYS */;
INSERT INTO `admission_form` VALUES (3729,'2024-05-02','ST25009','RAVU ASWATH',2024,6,'Beta'),(3730,'2024-04-28','ST25010','PUSHPALA SUPRITH',2024,6,'Beta'),(3978,'2024-05-02','ST25006','DUVVURU CHAITHRESH KUMAR REDDY',2024,6,'Beta'),(4051,'2024-04-28','ST25007','GAVARAJU HEMA VARSHA',2024,6,'Beta'),(4057,'2024-05-02','ST25001','GAJJALA MOHAN KRISHNA',2024,6,'Spark'),(4062,'2024-05-02','ST25003','CHEMUDUGUNTA PREETHI',2024,6,'Spark'),(4070,'2024-05-19','ST25008','NAVURU JITHENDRA',2024,6,'Beta'),(4078,'2024-05-01','ST25002','DARA SIVA KUMARI',2024,6,'Spark'),(4096,'2024-05-19','ST25005','ACHANTA EKANATHA ADHITHYA',2024,6,'Spark'),(4112,'2024-04-28','ST25004','VALLEPU VENKATA SANDEEP',2024,6,'Spark');
/*!40000 ALTER TABLE `admission_form` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessment_entry`
--

DROP TABLE IF EXISTS `assessment_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assessment_entry` (
  `Student_ID` varchar(10) DEFAULT NULL,
  `Student_Name` varchar(50) DEFAULT NULL,
  `Academic_Year` int DEFAULT NULL,
  `Class` int DEFAULT NULL,
  `Section` varchar(10) DEFAULT NULL,
  `Subject` varchar(20) DEFAULT NULL,
  `Exam_Type` varchar(10) DEFAULT NULL,
  `Marks` int DEFAULT NULL,
  `Grade` varchar(2) DEFAULT NULL,
  KEY `Student_ID` (`Student_ID`),
  CONSTRAINT `assessment_entry_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `student_master` (`Student_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessment_entry`
--

LOCK TABLES `assessment_entry` WRITE;
/*!40000 ALTER TABLE `assessment_entry` DISABLE KEYS */;
INSERT INTO `assessment_entry` VALUES ('ST25001','GAJJALA MOHAN KRISHNA',2024,6,'Spark','Math Marks','FA 1',15,'B'),('ST25001','GAJJALA MOHAN KRISHNA',2024,6,'Spark','Science Marks','FA 1',12,'C'),('ST25001','GAJJALA MOHAN KRISHNA',2024,6,'Spark','Social Marks','FA 1',15,'B'),('ST25001','GAJJALA MOHAN KRISHNA',2024,6,'Spark','English Marks','FA 1',12,'C'),('ST25001','GAJJALA MOHAN KRISHNA',2024,6,'Spark','Hindi Marks','FA 1',14,'C+'),('ST25001','GAJJALA MOHAN KRISHNA',2024,6,'Spark','Telugu Marks','FA 1',13,'C+'),('ST25002','DARA SIVA KUMARI',2024,6,'Spark','Math Marks','FA 1',22,'A'),('ST25002','DARA SIVA KUMARI',2024,6,'Spark','Science Marks','FA 1',13,'C+'),('ST25002','DARA SIVA KUMARI',2024,6,'Spark','Social Marks','FA 1',21,'A'),('ST25002','DARA SIVA KUMARI',2024,6,'Spark','English Marks','FA 1',14,'C+'),('ST25002','DARA SIVA KUMARI',2024,6,'Spark','Hindi Marks','FA 1',20,'A'),('ST25002','DARA SIVA KUMARI',2024,6,'Spark','Telugu Marks','FA 1',23,'A+'),('ST25003','CHEMUDUGUNTA PREETHI',2024,6,'Spark','Math Marks','FA 1',14,'C+'),('ST25003','CHEMUDUGUNTA PREETHI',2024,6,'Spark','Science Marks','FA 1',10,'C'),('ST25003','CHEMUDUGUNTA PREETHI',2024,6,'Spark','Social Marks','FA 1',15,'B'),('ST25003','CHEMUDUGUNTA PREETHI',2024,6,'Spark','English Marks','FA 1',22,'A'),('ST25003','CHEMUDUGUNTA PREETHI',2024,6,'Spark','Hindi Marks','FA 1',19,'B+'),('ST25003','CHEMUDUGUNTA PREETHI',2024,6,'Spark','Telugu Marks','FA 1',18,'B+'),('ST25004','VALLEPU VENKATA SANDEEP',2024,6,'Spark','Math Marks','FA 1',20,'A'),('ST25004','VALLEPU VENKATA SANDEEP',2024,6,'Spark','Science Marks','FA 1',23,'A+'),('ST25004','VALLEPU VENKATA SANDEEP',2024,6,'Spark','Social Marks','FA 1',14,'C+'),('ST25004','VALLEPU VENKATA SANDEEP',2024,6,'Spark','English Marks','FA 1',10,'C'),('ST25004','VALLEPU VENKATA SANDEEP',2024,6,'Spark','Hindi Marks','FA 1',15,'B'),('ST25004','VALLEPU VENKATA SANDEEP',2024,6,'Spark','Telugu Marks','FA 1',22,'A'),('ST25005','ACHANTA EKANATHA ADHITHYA',2024,6,'Spark','Math Marks','FA 1',14,'C+'),('ST25005','ACHANTA EKANATHA ADHITHYA',2024,6,'Spark','Science Marks','FA 1',13,'C+'),('ST25005','ACHANTA EKANATHA ADHITHYA',2024,6,'Spark','Social Marks','FA 1',22,'A'),('ST25005','ACHANTA EKANATHA ADHITHYA',2024,6,'Spark','English Marks','FA 1',13,'C+'),('ST25005','ACHANTA EKANATHA ADHITHYA',2024,6,'Spark','Hindi Marks','FA 1',21,'A'),('ST25005','ACHANTA EKANATHA ADHITHYA',2024,6,'Spark','Telugu Marks','FA 1',14,'C+'),('ST25006','DUVVURU CHAITHRESH KUMAR REDDY',2024,6,'Beta','Math Marks','FA 1',10,'C'),('ST25006','DUVVURU CHAITHRESH KUMAR REDDY',2024,6,'Beta','Science Marks','FA 1',15,'B'),('ST25006','DUVVURU CHAITHRESH KUMAR REDDY',2024,6,'Beta','Social Marks','FA 1',22,'A'),('ST25006','DUVVURU CHAITHRESH KUMAR REDDY',2024,6,'Beta','English Marks','FA 1',14,'C+'),('ST25006','DUVVURU CHAITHRESH KUMAR REDDY',2024,6,'Beta','Hindi Marks','FA 1',13,'C+'),('ST25006','DUVVURU CHAITHRESH KUMAR REDDY',2024,6,'Beta','Telugu Marks','FA 1',22,'A'),('ST25007','GAVARAJU HEMA VARSHA',2024,6,'Beta','Math Marks','FA 1',15,'B'),('ST25007','GAVARAJU HEMA VARSHA',2024,6,'Beta','Science Marks','FA 1',12,'C'),('ST25007','GAVARAJU HEMA VARSHA',2024,6,'Beta','Social Marks','FA 1',15,'B'),('ST25007','GAVARAJU HEMA VARSHA',2024,6,'Beta','English Marks','FA 1',12,'C'),('ST25007','GAVARAJU HEMA VARSHA',2024,6,'Beta','Hindi Marks','FA 1',14,'C+'),('ST25007','GAVARAJU HEMA VARSHA',2024,6,'Beta','Telugu Marks','FA 1',13,'C+'),('ST25008','NAVURU JITHENDRA',2024,6,'Beta','Math Marks','FA 1',13,'C+'),('ST25008','NAVURU JITHENDRA',2024,6,'Beta','Science Marks','FA 1',21,'A'),('ST25008','NAVURU JITHENDRA',2024,6,'Beta','Social Marks','FA 1',14,'C+'),('ST25008','NAVURU JITHENDRA',2024,6,'Beta','English Marks','FA 1',22,'A'),('ST25008','NAVURU JITHENDRA',2024,6,'Beta','Hindi Marks','FA 1',14,'C+'),('ST25008','NAVURU JITHENDRA',2024,6,'Beta','Telugu Marks','FA 1',13,'C+'),('ST25009','RAVU ASWATH',2024,6,'Beta','Math Marks','FA 1',22,'A'),('ST25009','RAVU ASWATH',2024,6,'Beta','Science Marks','FA 1',15,'B'),('ST25009','RAVU ASWATH',2024,6,'Beta','Social Marks','FA 1',12,'C'),('ST25009','RAVU ASWATH',2024,6,'Beta','English Marks','FA 1',15,'B'),('ST25009','RAVU ASWATH',2024,6,'Beta','Hindi Marks','FA 1',12,'C'),('ST25009','RAVU ASWATH',2024,6,'Beta','Telugu Marks','FA 1',14,'C+'),('ST25010','PUSHPALA SUPRITH',2024,6,'Beta','Math Marks','FA 1',13,'C+'),('ST25010','PUSHPALA SUPRITH',2024,6,'Beta','Science Marks','FA 1',13,'C+'),('ST25010','PUSHPALA SUPRITH',2024,6,'Beta','Social Marks','FA 1',21,'A'),('ST25010','PUSHPALA SUPRITH',2024,6,'Beta','English Marks','FA 1',14,'C+'),('ST25010','PUSHPALA SUPRITH',2024,6,'Beta','Hindi Marks','FA 1',13,'C+'),('ST25010','PUSHPALA SUPRITH',2024,6,'Beta','Telugu Marks','FA 1',22,'A');
/*!40000 ALTER TABLE `assessment_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_master`
--

DROP TABLE IF EXISTS `student_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_master` (
  `Student_ID` varchar(10) NOT NULL,
  `Student_Name` varchar(50) DEFAULT NULL,
  `Student_Address` varchar(50) DEFAULT NULL,
  `Parent_Name` varchar(50) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  PRIMARY KEY (`Student_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_master`
--

LOCK TABLES `student_master` WRITE;
/*!40000 ALTER TABLE `student_master` DISABLE KEYS */;
INSERT INTO `student_master` VALUES ('ST25001','GAJJALA MOHAN KRISHNA','Nellore','Venkatesh','2008-04-01'),('ST25002','DARA SIVA KUMARI','Nellore','Ravi Kumar','2008-03-21'),('ST25003','CHEMUDUGUNTA PREETHI','Buchi','Preethi','2008-09-18'),('ST25004','VALLEPU VENKATA SANDEEP','Kavali','Rani','2009-01-01'),('ST25005','ACHANTA EKANATHA ADHITHYA','Dagadarthi','Srinivaasulu','2008-03-21'),('ST25006','DUVVURU CHAITHRESH KUMAR REDDY','Nellore','Kotaiah','2008-09-18'),('ST25007','GAVARAJU HEMA VARSHA','Nellore','Deepika','2009-01-21'),('ST25008','NAVURU JITHENDRA','Buchi','Siva Reddy','2008-04-20'),('ST25009','RAVU ASWATH','Kavali','Suresh Reddy','2009-05-28'),('ST25010','PUSHPALA SUPRITH','Dagadarthi','Jhon','2008-08-01');
/*!40000 ALTER TABLE `student_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'school_data'
--

--
-- Dumping routines for database 'school_data'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-08  1:06:50
