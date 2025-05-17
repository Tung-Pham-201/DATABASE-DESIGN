CREATE DATABASE Group13;
GO 
USE Group13;

-- Tạo bảng với các ràng buộc CHECK
CREATE TABLE Customer (
    Customer_ID VARCHAR(10) PRIMARY KEY NOT NULL, 
    Customer_Name NVARCHAR(50) NOT NULL, 
    Customer_Email VARCHAR(50) NOT NULL, 
    Customer_Phone CHAR(10) NOT NULL, 
    Bank_Account_Number NUMERIC(15, 0) NOT NULL, 
    Tax_Code CHAR(10) NOT NULL CHECK (LEN(Tax_Code) = 10),
    Company_Name NVARCHAR(50), 
    Address NVARCHAR(100) NOT NULL  
);

CREATE TABLE Employee (
    Employee_ID VARCHAR(10) PRIMARY KEY NOT NULL, 
    Department_ID VARCHAR(4) NOT NULL,
    Employee_Name NVARCHAR(50) NOT NULL, 
    Employee_Phone CHAR(10) NOT NULL, 
    Employee_Email VARCHAR(50) NOT NULL, 
    Hired_Date DATE NOT NULL, 
    Salary INT NOT NULL, 
    Role NVARCHAR(30) NOT NULL,
    Manager_ID VARCHAR(10) 
);

CREATE TABLE Department (
    Department_ID VARCHAR(4) PRIMARY KEY NOT NULL, 
    Department_Name NVARCHAR(30) NOT NULL, 
    Manager_ID VARCHAR(10) 
);

CREATE TABLE Goods_Detail (
    Detail_ID VARCHAR(10) PRIMARY KEY not null, 
    Declaration_ID CHAR(12) not null , 
    Goods_ID VARCHAR(6) not null, 
    Quantity INT not null, 
    Net_Weight NUMERIC(10, 0) not null , 
    Gross_Weight NUMERIC(10, 0) not null, 
    Total_Value NUMERIC(14, 0) not null
);

CREATE TABLE Goods (
    Goods_ID VARCHAR(6) PRIMARY KEY not null, 
    Goods_Name NVARCHAR(100) NOT NULL, 
    Unit_Price NUMERIC(14, 0) not null, 
    HS_Code CHAR(8) not null, 
    Goods_Type CHAR(1) CHECK (Goods_Type IN ('G', 'H', 'P')) 
);

CREATE TABLE Perishable_Goods (
    Perishable_Goods_ID VARCHAR(6) PRIMARY KEY, 
    Exp_Date DATE, 
    Temperature VARCHAR(4), 
    Humidity VARCHAR(4) 
);

CREATE TABLE Hazardous_Goods (
    Hazardous_Goods_ID VARCHAR(6) PRIMARY KEY, 
    Hazard_Level VARCHAR(6), 
    Safety_Instructions NVARCHAR(50) 
);

CREATE TABLE General_Goods (
    General_Goods_ID VARCHAR(6) PRIMARY KEY
);

CREATE TABLE Consultation (
    Consultant_ID INT PRIMARY KEY not null, 
    Customer_ID VARCHAR(10) not null, 
    Employee_ID VARCHAR(10) not null, 
    Consultant_Date DATE not null, 
    Goods_Type VARCHAR(50) CHECK (Goods_Type IN ('General Goods', 'Hazardous', 'Perishable')), 
    Estimate_HS_Code NUMERIC(14, 0) not null, 
    Estimate_Tax_Rate NUMERIC(14, 2) not null, 
    Estimate_Cost NUMERIC(14, 0) not null, 
    Required_Permit NVARCHAR(50) not null,  
    Status NVARCHAR(50) CHECK (Status IN ('Pending', 'Processing', 'Completed', 'Rejected', 'Cancelled')) not null,
    Notes TEXT 
);

CREATE TABLE Service_Request (
    Request_ID NUMERIC(6) PRIMARY KEY not null, 
    Customer_ID VARCHAR(10) not null, 
    Service_Type NVARCHAR(20) not null, 
    Service_Charges NUMERIC(14) not null, 
    Request_Date DATE not null, 
    Status NVARCHAR(20) CHECK (Status IN ('Pending', 'Processing', 'Completed', 'Rejected', 'Cancelled')), 
    Employee_ID VARCHAR(10) not null, 
);

CREATE TABLE Goods_Inspection (
    Inspection_ID VARCHAR(10) PRIMARY KEY not null, 
    Declaration_ID CHAR(12) not null, 
    Employee_ID VARCHAR(10) not null, 
    Inspection_Type NVARCHAR(50) CHECK (Inspection_Type IN ('Physical', 'Document', 'X-ray', 'Sample Testing')), 
    Schedule_Date DATE not null, 
    Inspection_Location NVARCHAR(100) not null,
    Status NVARCHAR(50) CHECK (Status IN ('Pending', 'Processing', 'Completed', 'Rejected', 'Cancelled')), 
    Inspector_Name NVARCHAR(50) not null, 
    Result NVARCHAR(50) not null, 
    Notes TEXT 
);

CREATE TABLE Post_Clearance_Service (
    Post_Clearance_Service_ID NUMERIC(6) PRIMARY KEY not null, 
    Declaration_ID CHAR(12) not null, 
    Document_Storage_Ref VARCHAR(30) not null, 
    Consultant_Notes TEXT  , 
    Review_Date DATE not null, 
    Report VARCHAR(50) not null, 
    Improvement_Suggestion TEXT not null , 
    Status NVARCHAR(50) CHECK (Status IN ('Pending', 'Processing', 'Completed', 'Rejected', 'Cancelled')) 
);

CREATE TABLE Customer_Declaration (
    Declaration_ID CHAR(12) PRIMARY KEY not null,
    Contract_ID VARCHAR(10)   not null,
    Employee_ID VARCHAR(10) not null , 
    Declaration_Type VARCHAR(50) not null , 
    VNACCS_ID VARCHAR(15) not null,
    Inspection_Channel VARCHAR(6) not null,
    Status VARCHAR(50)CHECK (Status IN ('Pending', 'Processing', 'Completed', 'Rejected', 'Cancelled')) , 
    Submission_Date DATE 
);

CREATE TABLE Contract (
    Contract_ID VARCHAR(10) PRIMARY KEY, 
    Request_ID NUMERIC(6), 
    Contract_Date DATE, 
    Total_Value NUMERIC(14), 
    Payment_Term NVARCHAR(15), 
    Status NVARCHAR(50) CHECK (Status IN ('Pending', 'Processing', 'Completed', 'Rejected', 'Cancelled'))
);

CREATE TABLE Document_Set (
    Document_Set_ID NUMERIC(8) PRIMARY KEY,
    Contract_ID VARCHAR(10), 
    Declaration_ID CHAR(12), 
    Verification_Status NVARCHAR(20), 
    Notes TEXT, 
    Status NVARCHAR(50) CHECK (Status IN ('Pending', 'Processing', 'Completed', 'Rejected', 'Cancelled'))
);

CREATE TABLE Document (
    Document_ID NUMERIC(8) PRIMARY KEY, 
    Commercial_Invoice VARBINARY(MAX), 
    Packing_List VARBINARY(MAX), 
    Bill_Of_Lading VARBINARY(MAX),
    C_O VARBINARY(MAX), 
    Import_Permit VARBINARY(MAX), 
    Other_Certification VARBINARY(MAX), 
    Document_Set_ID NUMERIC(8) 
);

CREATE TABLE Payment (
    Payment_ID VARCHAR(15) PRIMARY KEY,
    Contract_ID VARCHAR(10), 
    Tax_Fee NUMERIC(10), 
    Amount INT, 
    Payment_Date DATE 
);


-- Employee
ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_Department FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID),
    CONSTRAINT FK_Employee_Manager FOREIGN KEY (Manager_ID) REFERENCES Employee(Employee_ID);

-- Department
ALTER TABLE Department
ADD CONSTRAINT FK_Department_Manager FOREIGN KEY (Manager_ID) REFERENCES Employee(Employee_ID);

--  Goods_Detail
ALTER TABLE Goods_Detail
ADD CONSTRAINT FK_GoodsDetail_Declaration FOREIGN KEY (Declaration_ID) REFERENCES Customer_Declaration(Declaration_ID),
    CONSTRAINT FK_GoodsDetail_Goods FOREIGN KEY (Goods_ID) REFERENCES Goods(Goods_ID);

-- 
ALTER TABLE Perishable_Goods
ADD CONSTRAINT FK_PerishableGoods_Goods FOREIGN KEY (Perishable_Goods_ID) REFERENCES Goods(Goods_ID);

ALTER TABLE Hazardous_Goods
ADD CONSTRAINT FK_HazardousGoods_Goods FOREIGN KEY (Hazardous_Goods_ID) REFERENCES Goods(Goods_ID);

ALTER TABLE General_Goods
ADD CONSTRAINT FK_GeneralGoods_Goods FOREIGN KEY (General_Goods_ID) REFERENCES Goods(Goods_ID);

-- Consultation
ALTER TABLE Consultation
ADD CONSTRAINT FK_Consultation_Customer FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    CONSTRAINT FK_Consultation_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID);

--  Service_Request
ALTER TABLE Service_Request
ADD CONSTRAINT FK_ServiceRequest_Customer FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    CONSTRAINT FK_ServiceRequest_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID);

--  Goods_Inspection
ALTER TABLE Goods_Inspection
ADD CONSTRAINT FK_GoodsInspection_Declaration FOREIGN KEY (Declaration_ID) REFERENCES Customer_Declaration(Declaration_ID),
    CONSTRAINT FK_GoodsInspection_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID);

-- Post_Clearance_Service
ALTER TABLE Post_Clearance_Service
ADD CONSTRAINT FK_PostClearanceService_Declaration FOREIGN KEY (Declaration_ID) REFERENCES Customer_Declaration(Declaration_ID);


-- Customer_Declaration
ALTER TABLE Customer_Declaration
ADD CONSTRAINT FK_CustomerDeclaration_Contract FOREIGN KEY (Contract_ID) REFERENCES Contract(Contract_ID),
    CONSTRAINT FK_CustomerDeclaration_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID);

--  Contract
ALTER TABLE Contract
ADD CONSTRAINT FK_Contract_ServiceRequest FOREIGN KEY (Request_ID) REFERENCES Service_Request(Request_ID);

--  Document_Set
ALTER TABLE Document_Set
ADD CONSTRAINT FK_DocumentSet_Contract FOREIGN KEY (Contract_ID) REFERENCES Contract(Contract_ID),
    CONSTRAINT FK_DocumentSet_Declaration FOREIGN KEY (Declaration_ID) REFERENCES Customer_Declaration(Declaration_ID);

--  Document
ALTER TABLE Document
ADD CONSTRAINT FK_Document_DocumentSet FOREIGN KEY (Document_Set_ID) REFERENCES Document_Set(Document_Set_ID);

-- Payment
ALTER TABLE Payment
ADD CONSTRAINT FK_Payment_Contract FOREIGN KEY (Contract_ID) REFERENCES Contract(Contract_ID);
