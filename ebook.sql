CREATE DATABASE ebook;
USE
    ebook;
CREATE TABLE UserTypes(
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(128) NOT NULL
) CHARACTER SET utf8;
CREATE TABLE Disciplines(
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(512) NOT NULL,
    TeacherId INT NOT NULL
) CHARACTER SET utf8;
CREATE TABLE Specialities(
    Id INT PRIMARY KEY NOT NULL,
    Title VARCHAR(512) NOT NULL
) CHARACTER SET utf8;
CREATE TABLE Groups(
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(32) NOT NULL UNIQUE,
    SpecialityId INT NOT NULL,
    CuratorId INT NOT NULL,
    Course INT NOT NULL DEFAULT 1,
    FOREIGN KEY(SpecialityId) REFERENCES Specialities(Id)
) CHARACTER SET utf8;
CREATE TABLE Accounts(
    Id INT PRIMARY KEY AUTO_INCREMENT,
    LastName VARCHAR(128) NOT NULL,
    FirstName VARCHAR(128) NOT NULL,
    MiddleName VARCHAR(128) NOT NULL,
    Login VARCHAR(128) NOT NULL UNIQUE,
    Email VARCHAR(128) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(24) NOT NULL UNIQUE,
    `Password` VARCHAR(255) NOT NULL,
    UserTypeId INT NOT NULL,
    GroupId INT,
    IsActive TINYINT NOT NULL DEFAULT 1,
    Token VARCHAR(255),
    FOREIGN KEY(UserTypeId) REFERENCES UserTypes(Id),
    FOREIGN KEY(GroupId) REFERENCES Groups(Id)
) CHARACTER SET utf8;
CREATE TABLE DisciplineToTeacher(
    Id INT PRIMARY KEY AUTO_INCREMENT,
    TeacherId INT NOT NULL,
    DisciplineId INT NOT NULL,
    FOREIGN KEY(TeacherId) REFERENCES Accounts(Id),
    FOREIGN KEY(DisciplineId) REFERENCES Disciplines(Id)
) CHARACTER SET utf8;
CREATE TABLE DisciplineToGroup(
    Id INT PRIMARY KEY AUTO_INCREMENT,
    DisciplineTeacherId INT NOT NULL,
    GroupId INT NOT NULL,
    Passed TINYINT NOT NULL DEFAULT 0,
    FOREIGN KEY(DisciplineTeacherId) REFERENCES DisciplineToTeacher(Id),
    FOREIGN KEY(GroupId) REFERENCES Groups(Id)
) CHARACTER SET utf8;
CREATE TABLE WorkingProgram(
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Theme VARCHAR(1024) NOT NULL,
    DisciplineId INT NOT NULL,
    GroupId INT NOT NULL,
    FOREIGN KEY(DisciplineId) REFERENCES Disciplines(Id),
    FOREIGN KEY(GroupId) REFERENCES Groups(Id)
) CHARACTER SET utf8;
CREATE TABLE LessonTypes(
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(128) NOT NULL,
    External VARCHAR(128) NOT NULL
) CHARACTER SET utf8;
CREATE TABLE Lessons(
    Id INT PRIMARY KEY AUTO_INCREMENT,
    `Datetime` TIMESTAMP NOT NULL,
    DisciplineTeId INT NOT NULL,
    GroupId INT NOT NULL,
    LessonTypeId INT NOT NULL,
    FOREIGN KEY(DisciplineId) REFERENCES Disciplines(Id),
    FOREIGN KEY(GroupId) REFERENCES Groups(Id),
    FOREIGN KEY(LessonTypeId) REFERENCES LessonTypes(Id)
) CHARACTER SET utf8;
CREATE TABLE Grades(
    Id INT PRIMARY KEY AUTO_INCREMENT,
    LessonId INT NOT NULL,
    StudentId INT NOT NULL,
    Grade INT,
    FOREIGN KEY(LessonId) REFERENCES Lessons(Id),
    FOREIGN KEY(StudentId) REFERENCES Accounts(Id)
) CHARACTER SET utf8;
-- CREATE TABLE ProgramToGroup(
--     Id INT PRIMARY KEY AUTO_INCREMENT,
--     GroupId INT NOT NULL,
--     ProgramId INT NOT NULL,
--     FOREIGN KEY(GroupId) REFERENCES Groups(Id),
--     FOREIGN KEY(ProgramId) REFERENCES WorkingProgram(Id)
-- ) CHARACTER SET utf8;
CREATE TABLE Report(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    GradeId INT NOT NULL,
    Grade INT,
    `Datetime` TIMESTAMP NOT NULL,
    FOREIGN KEY(GradeId) REFERENCES Grades(Id)
) CHARACTER SET utf8;
CREATE TABLE RequestsToAdmin(
    Id INT PRIMARY KEY AUTO_INCREMENT,
    TeacherId INT NOT NULL,
    DisciplineId INT NOT NULL,
    GroupId INT NOT NULL,
    FOREIGN KEY(TeacherId) REFERENCES Accounts(Id),
    FOREIGN KEY(DisciplineId) REFERENCES Disciplines(Id),
    FOREIGN KEY(GroupId) REFERENCES Groups(Id)
);
CREATE TABLE Notifications(
    Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    TeacherId INT NOT NULL,
    DisciplineId INT NOT NULL,
    GroupId INT NOT NULL,
    `Text` TEXT(1024) NOT NULL,
    FOREIGN KEY(TeacherId) REFERENCES Accounts(Id),
    FOREIGN KEY(DisciplineId) REFERENCES Disciplines(Id),
    FOREIGN KEY(GroupId) REFERENCES Groups(Id)
);
ALTER TABLE
	Disciplines ADD CONSTRAINT FOREIGN KEY(TeacherId) REFERENCES Accounts(Id);
ALTER TABLE
    Groups ADD CONSTRAINT FOREIGN KEY(CuratorId) REFERENCES Accounts(Id);
ALTER TABLE
    DisciplineToGroup ADD UNIQUE unique_index(DisciplineId, GroupId);
ALTER TABLE
    DisciplineToTeacher ADD UNIQUE unique_index(TeacherId, DisciplineId);
DELIMITER
    //
CREATE TRIGGER OnInsertLesson AFTER
INSERT
ON
    Lessons FOR EACH ROW
INSERT
INTO
    Grades(LessonId, StudentId, Grade)
SELECT NEW
    .Id AS LessonId,
    a.Id AS StudentId,
    NULL AS Grade
FROM
    Accounts AS a
WHERE
    GroupId = NEW.GroupId ; //
DELIMITER
    //
CREATE TRIGGER OnGradeUpdate AFTER
UPDATE
ON
    Grades FOR EACH ROW
INSERT
INTO
    Report(GradeId, Grade)
VALUES(NEW.Id, NEW.Grade) //
INSERT
INTO
    UserTypes(Title)
VALUES('administrator'),('operator'),('teacher'),('student');
