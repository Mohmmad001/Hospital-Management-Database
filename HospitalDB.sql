-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: hostpital
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment` (
  `AppointmentID` int NOT NULL,
  `PatientID` int NOT NULL,
  `AppointmentDate` datetime NOT NULL,
  `AppointmentType` varchar(50) DEFAULT 'Check-up',
  PRIMARY KEY (`AppointmentID`),
  KEY `fk_Appointment_Patient` (`PatientID`),
  CONSTRAINT `fk_Appointment_Patient` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `appointment_chk_1` CHECK ((`AppointmentType` in (_utf8mb4'Check-up',_utf8mb4'Emergency',_utf8mb4'Surgery',_utf8mb4'Follow-up visit')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment`
--

LOCK TABLES `appointment` WRITE;
/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
INSERT INTO `appointment` VALUES (301,101,'2025-09-01 09:00:00','Check-up'),(302,102,'2025-09-01 11:00:00','Emergency'),(303,103,'2025-09-02 14:30:00','Surgery'),(304,101,'2025-09-03 10:15:00','Follow-up visit'),(305,104,'2025-09-04 12:00:00','Check-up');
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointment_doctor`
--

DROP TABLE IF EXISTS `appointment_doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment_doctor` (
  `AppointmentID` int NOT NULL,
  `DoctorID` int NOT NULL,
  PRIMARY KEY (`AppointmentID`,`DoctorID`),
  KEY `fk_AppDoc_Doctor` (`DoctorID`),
  CONSTRAINT `fk_AppDoc_Appointment` FOREIGN KEY (`AppointmentID`) REFERENCES `appointment` (`AppointmentID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_AppDoc_Doctor` FOREIGN KEY (`DoctorID`) REFERENCES `doctor` (`DoctorID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment_doctor`
--

LOCK TABLES `appointment_doctor` WRITE;
/*!40000 ALTER TABLE `appointment_doctor` DISABLE KEYS */;
INSERT INTO `appointment_doctor` VALUES (301,201),(303,201),(304,201),(305,202),(303,203),(302,204),(304,204);
/*!40000 ALTER TABLE `appointment_doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointment_symptom`
--

DROP TABLE IF EXISTS `appointment_symptom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment_symptom` (
  `AppointmentID` int NOT NULL,
  `SymptomID` int NOT NULL,
  PRIMARY KEY (`AppointmentID`,`SymptomID`),
  KEY `fk_AppSym_Symptom` (`SymptomID`),
  CONSTRAINT `fk_AppSym_Appointment` FOREIGN KEY (`AppointmentID`) REFERENCES `appointment` (`AppointmentID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_AppSym_Symptom` FOREIGN KEY (`SymptomID`) REFERENCES `symptoms` (`SymptomID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment_symptom`
--

LOCK TABLES `appointment_symptom` WRITE;
/*!40000 ALTER TABLE `appointment_symptom` DISABLE KEYS */;
INSERT INTO `appointment_symptom` VALUES (302,401),(304,402),(301,403),(305,403),(303,404),(302,405),(305,405);
/*!40000 ALTER TABLE `appointment_symptom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `appointment_symptoms_overview`
--

DROP TABLE IF EXISTS `appointment_symptoms_overview`;
/*!50001 DROP VIEW IF EXISTS `appointment_symptoms_overview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `appointment_symptoms_overview` AS SELECT 
 1 AS `firstName`,
 1 AS `lastName`,
 1 AS `AppointmentID`,
 1 AS `AppointmentDate`,
 1 AS `Description`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `billing`
--

DROP TABLE IF EXISTS `billing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing` (
  `BillID` int NOT NULL,
  `AppointmentID` int DEFAULT NULL,
  `BillDate` date NOT NULL,
  `TotalAmount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`BillID`),
  UNIQUE KEY `AppointmentID` (`AppointmentID`),
  CONSTRAINT `fk_Billing_Appointment` FOREIGN KEY (`AppointmentID`) REFERENCES `appointment` (`AppointmentID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `billing_chk_1` CHECK ((`TotalAmount` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing`
--

LOCK TABLES `billing` WRITE;
/*!40000 ALTER TABLE `billing` DISABLE KEYS */;
INSERT INTO `billing` VALUES (501,301,'2025-09-01',50.00),(502,302,'2025-09-01',200.00),(503,303,'2025-09-02',1500.00),(504,304,'2025-09-03',75.00),(505,305,'2025-09-04',60.00);
/*!40000 ALTER TABLE `billing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor` (
  `DoctorID` int NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Specialty` varchar(50) NOT NULL,
  `Phone` varchar(15) NOT NULL,
  `Email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`DoctorID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
INSERT INTO `doctor` VALUES (201,'Ahmad','Yousef','Cardiology','0791111111','ahmad.yousef@clinic.com'),(202,'Lina','Khalil','Dermatology','0792222222','lina.khalil@clinic.com'),(203,'Sami','Nasser','General Surgery','0793333333','sami.nasser@clinic.com'),(204,'Huda','Tariq','Internal Medicine','0794444444','huda.tariq@clinic.com');
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `PatientID` int NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Gender` char(1) NOT NULL,
  PRIMARY KEY (`PatientID`),
  CONSTRAINT `patient_chk_1` CHECK ((`Gender` in (_utf8mb4'M',_utf8mb4'F')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (101,'Ali','Hassan','1990-03-15','M'),(102,'Sara','Omar','1985-07-21','F'),(103,'Khalid','Saleh','2000-01-05','M'),(104,'Lina','Mahmoud','1992-11-12','F');
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `patient_appointment_overview`
--

DROP TABLE IF EXISTS `patient_appointment_overview`;
/*!50001 DROP VIEW IF EXISTS `patient_appointment_overview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patient_appointment_overview` AS SELECT 
 1 AS `FirstName`,
 1 AS `LastName`,
 1 AS `AppointmentType`,
 1 AS `AppointmentDate`,
 1 AS `doctor_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `patient_billing_overview`
--

DROP TABLE IF EXISTS `patient_billing_overview`;
/*!50001 DROP VIEW IF EXISTS `patient_billing_overview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patient_billing_overview` AS SELECT 
 1 AS `BillID`,
 1 AS `AppointmentID`,
 1 AS `FirstName`,
 1 AS `LastName`,
 1 AS `BillDate`,
 1 AS `TotalAmount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `patient_contact`
--

DROP TABLE IF EXISTS `patient_contact`;
/*!50001 DROP VIEW IF EXISTS `patient_contact`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patient_contact` AS SELECT 
 1 AS `PatientID`,
 1 AS `FirstName`,
 1 AS `LastName`,
 1 AS `Phone`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `patient_phone`
--

DROP TABLE IF EXISTS `patient_phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_phone` (
  `PatientID` int NOT NULL,
  `Phone` varchar(15) NOT NULL,
  PRIMARY KEY (`PatientID`,`Phone`),
  CONSTRAINT `fk_Phone_Patient` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_phone`
--

LOCK TABLES `patient_phone` WRITE;
/*!40000 ALTER TABLE `patient_phone` DISABLE KEYS */;
INSERT INTO `patient_phone` VALUES (101,'0779876543'),(101,'0791234567'),(102,'0785554444'),(103,'0798882222'),(104,'0781122334');
/*!40000 ALTER TABLE `patient_phone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `symptoms`
--

DROP TABLE IF EXISTS `symptoms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `symptoms` (
  `SymptomID` int NOT NULL,
  `Description` varchar(200) NOT NULL,
  PRIMARY KEY (`SymptomID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `symptoms`
--

LOCK TABLES `symptoms` WRITE;
/*!40000 ALTER TABLE `symptoms` DISABLE KEYS */;
INSERT INTO `symptoms` VALUES (401,'Fever'),(402,'Cough'),(403,'Headache'),(404,'Chest Pain'),(405,'Rash');
/*!40000 ALTER TABLE `symptoms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'hostpital'
--
/*!50003 DROP PROCEDURE IF EXISTS `Appointment_Insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Appointment_Insert`( IN Patient_ID INT, IN Appointment_Date DATETIME, IN Appointment_Type VARCHAR(50), IN Doctor_ID INT)
BEGIN
    DECLARE Last_Appointment_ID INT;

    SELECT AppointmentID INTO Last_Appointment_ID
    FROM Appointment
    ORDER BY AppointmentID DESC
    LIMIT 1;

    -- Insert new appointment using +1 inline
    INSERT INTO Appointment (AppointmentID, PatientID, AppointmentDate, AppointmentType)
    VALUES (Last_Appointment_ID + 1, Patient_ID, Appointment_Date, Appointment_Type);

    INSERT INTO Appointment_Doctor (AppointmentID, DoctorID)
    VALUES (Last_Appointment_ID + 1, Doctor_ID);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Appointment_Update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Appointment_Update`( IN Appointment_ID INT, IN Appointment_Type VARCHAR(50))
BEGIN

    UPDATE Appointment
    SET AppointmentType = Appointment_Type
    WHERE AppointmentID = Appointment_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `BILL_GENERATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `BILL_GENERATE`( IN Appointment_ID INT,IN Bill_Date DATE, IN Total_Amount DECIMAL(10,2)
)
BEGIN
    DECLARE new_billID INT;

    SELECT BillID
    INTO new_billID
    FROM billing
    ORDER BY BillID DESC
    LIMIT 1;

    INSERT INTO billing (BillID, AppointmentID, BillDate, TotalAmount)
    VALUES (new_billID + 1, Appointment_ID, Bill_Date, Total_Amount);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `PATIENT_PHONE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `PATIENT_PHONE`( IN first_name VARCHAR(50), IN last_name VARCHAR(50), IN date_of_birth DATE, gender CHAR(1),phone VARCHAR(15))
BEGIN
    DECLARE patient_id INT;

    SELECT PatientID INTO patient_id
    FROM Patient
    ORDER BY PatientID DESC
    LIMIT 1;

    INSERT INTO Patient (PatientID, FirstName, LastName, DateOfBirth, Gender)
    VALUES (patient_id + 1, first_name, last_name, date_of_birth, gender);

    INSERT INTO Patient_Phone (PatientID, Phone)
    VALUES (patient_id + 1, phone);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `appointment_symptoms_overview`
--

/*!50001 DROP VIEW IF EXISTS `appointment_symptoms_overview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `appointment_symptoms_overview` AS select `patient`.`FirstName` AS `firstName`,`patient`.`LastName` AS `lastName`,`appointment`.`AppointmentID` AS `AppointmentID`,`appointment`.`AppointmentDate` AS `AppointmentDate`,`symptoms`.`Description` AS `Description` from (((`appointment` join `patient` on((`appointment`.`PatientID` = `patient`.`PatientID`))) join `appointment_symptom` on((`appointment`.`AppointmentID` = `appointment_symptom`.`AppointmentID`))) join `symptoms` on((`symptoms`.`SymptomID` = `appointment_symptom`.`SymptomID`))) order by `appointment`.`AppointmentDate` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `patient_appointment_overview`
--

/*!50001 DROP VIEW IF EXISTS `patient_appointment_overview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `patient_appointment_overview` AS select `patient`.`FirstName` AS `FirstName`,`patient`.`LastName` AS `LastName`,`appointment`.`AppointmentType` AS `AppointmentType`,`appointment`.`AppointmentDate` AS `AppointmentDate`,concat(`doctor`.`FirstName`,' ',`doctor`.`LastName`) AS `doctor_name` from (((`appointment` join `patient` on((`appointment`.`PatientID` = `patient`.`PatientID`))) join `appointment_doctor` on((`appointment`.`AppointmentID` = `appointment_doctor`.`AppointmentID`))) join `doctor` on((`doctor`.`DoctorID` = `appointment_doctor`.`DoctorID`))) order by `appointment`.`AppointmentDate` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `patient_billing_overview`
--

/*!50001 DROP VIEW IF EXISTS `patient_billing_overview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `patient_billing_overview` AS select `billing`.`BillID` AS `BillID`,`appointment`.`AppointmentID` AS `AppointmentID`,`patient`.`FirstName` AS `FirstName`,`patient`.`LastName` AS `LastName`,`billing`.`BillDate` AS `BillDate`,`billing`.`TotalAmount` AS `TotalAmount` from ((`appointment` join `patient` on((`appointment`.`PatientID` = `patient`.`PatientID`))) join `billing` on((`billing`.`AppointmentID` = `appointment`.`AppointmentID`))) order by `billing`.`BillDate` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `patient_contact`
--

/*!50001 DROP VIEW IF EXISTS `patient_contact`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `patient_contact` AS select `patient`.`PatientID` AS `PatientID`,`patient`.`FirstName` AS `FirstName`,`patient`.`LastName` AS `LastName`,`patient_phone`.`Phone` AS `Phone` from (`patient` join `patient_phone` on((`patient`.`PatientID` = `patient_phone`.`PatientID`))) order by `patient`.`FirstName` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-08 17:31:57
