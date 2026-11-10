
-- ==========================================
-- CPE C307 ADVANCED DATABASE
-- BRENT ANDREI C. SENARA
-- ==========================================

-- 1. CREATE 2 DATABASES

CREATE DATABASE Senara_ProfileDB;
CREATE DATABASE Senara_BackupDB;


-- 2. CREATE PROFILE TABLE IN FIRST DATABASE

USE Senara_ProfileDB;

CREATE TABLE Profile (
    Profile_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(150),
    Age INT,
    Department VARCHAR(100),
    Position VARCHAR(100)
);


-- 3. INSERT 5 DATA

INSERT INTO Profile
(Profile_ID, Name, Address, Age, Department, Position)
VALUES
(1, 'Brent Senara', 'Makati City', 20, 'Computer Engineering', 'Student'),
(2, 'Andrei Castillo', 'Pangasinan', 21, 'Information Technology', 'Programmer'),
(3, 'John Santos', 'Manila', 22, 'Computer Engineering', 'Technician'),
(4, 'Mark Reyes', 'Quezon City', 23, 'Electronics Engineering', 'Engineer'),
(5, 'Kevin Cruz', 'Pasig City', 20, 'Information Technology', 'Developer');


-- SHOW ORIGINAL DATA

SELECT * FROM Profile;


-- 4. CREATE BACKUP AND RESTORE TO SECOND DATABASE

CREATE TABLE Senara_BackupDB.Profile
LIKE Senara_ProfileDB.Profile;

INSERT INTO Senara_BackupDB.Profile
SELECT * FROM Senara_ProfileDB.Profile;


-- SHOW RESTORED DATA

SELECT * FROM Senara_BackupDB.Profile;


-- 5. ENCRYPT DATABASE DATA USING PASSWORD

SET @encryption_key = 'Senara@2026';

CREATE TABLE Senara_BackupDB.Profile_Encrypted (
    Profile_ID INT PRIMARY KEY,
    Name VARBINARY(512),
    Address VARBINARY(512),
    Age VARBINARY(512),
    Department VARBINARY(512),
    Position VARBINARY(512)
);

INSERT INTO Senara_BackupDB.Profile_Encrypted
SELECT
    Profile_ID,
    AES_ENCRYPT(Name, @encryption_key),
    AES_ENCRYPT(Address, @encryption_key),
    AES_ENCRYPT(CAST(Age AS CHAR), @encryption_key),
    AES_ENCRYPT(Department, @encryption_key),
    AES_ENCRYPT(Position, @encryption_key)
FROM Senara_BackupDB.Profile;


-- 6. SHOW DECRYPTED DATA OF 2ND AND 3RD RECORD

SELECT
    Profile_ID,
    CAST(AES_DECRYPT(Name, @encryption_key) AS CHAR) AS Name,
    CAST(AES_DECRYPT(Address, @encryption_key) AS CHAR) AS Address,
    CAST(AES_DECRYPT(Age, @encryption_key) AS CHAR) AS Age,
    CAST(AES_DECRYPT(Department, @encryption_key) AS CHAR) AS Department,
    CAST(AES_DECRYPT(Position, @encryption_key) AS CHAR) AS Position
FROM Senara_BackupDB.Profile_Encrypted
WHERE Profile_ID IN (2, 3);


-- 7. SHOW ALL ENCRYPTED DATA

SELECT
    Profile_ID,
    HEX(Name) AS Encrypted_Name,
    HEX(Address) AS Encrypted_Address,
    HEX(Age) AS Encrypted_Age,
    HEX(Department) AS Encrypted_Department,
    HEX(Position) AS Encrypted_Position
FROM Senara_BackupDB.Profile_Encrypted;
