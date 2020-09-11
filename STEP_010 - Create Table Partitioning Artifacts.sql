-- ////////////////////////////////////////////////////////////////////////////
-- //
-- //  Description: 
-- //  -----------------------------------
-- //  Create the Table Partitioning Artifacts 
-- // 
-- //
-- //  Modification ory:
-- //  Rev#  Date        Author     Description
-- //   ----- --------   ---------  --------------------------------------------
-- //  1.0   2020-Sep-10 R Gosling  Original Release 
-- ////////////////////////////////////////////////////////////////////////////
--IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = '')
--BEGIN
--	EXEC('CREATE SCHEMA ')
--END
--==================================================================
-- Drop everything if it exists
--==================================================================
IF (EXISTS (SELECT *
  FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_NAME = 'TransactionHistory'))
DROP TABLE dbo.TransactionHistory
GO
IF (EXISTS (SELECT * 
  FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_NAME = 'TransactionHistory_SWITCH'))
DROP TABLE dbo.TransactionHistory_SWITCH
GO
IF EXISTS(SELECT * FROM SYS.PARTITION_SCHEMES where name='psTranByMonth')
	drop partition SCHEME psTranByMonth
go
IF EXISTS (SELECT * FROM SYS.PARTITION_FUNCTIONS)
	drop partition function pfnTranByMonth
--==================================================================
-- Create the Partition Function
--==================================================================
CREATE PARTITION FUNCTION pfnTranByMonth(date) 
AS RANGE RIGHT 
FOR VALUES (
 N'2019-12-01'
,N'2020-01-01'
,N'2020-02-01'
,N'2020-03-01'
,N'2020-04-01'
,N'2020-05-01'
,N'2020-06-01'
,N'2020-07-01'
,N'2020-08-01'
,N'2020-09-01'
,N'2020-10-01'
,N'2020-11-01'
,N'2020-12-01'
,N'2021-01-01'
)
GO
--==================================================================
-- Create the Partition Scheme
--==================================================================
CREATE PARTITION SCHEME psTranByMonth AS PARTITION pfnTranByMonth ALL TO ([PRIMARY])
GO
 
 --==================================================================
-- Create the dev.Transactionory Table
--==================================================================
CREATE TABLE dbo.TransactionHistory(
	TransactionID bigint NOT NULL
   ,TranDate DATE NOT NULL

) ON psTranByMonth(TranDate)
GO
ALTER TABLE dbo.TransactionHistory
   ADD CONSTRAINT PK_TRANSACTION_HISTORY_TransactionID PRIMARY KEY NONCLUSTERED (TranDate,TransactionID)
   GO
CREATE CLUSTERED INDEX CX_TRANSACTION_HISTORY_TRANDATE ON dbo.TransactionHistory(TranDate,TransactionID)

--go
 --==================================================================
-- Create the Switch Table
--==================================================================
CREATE TABLE dbo.TransactionHistory_SWITCH(
	TransactionID bigint NOT NULL
   ,TranDate DATE NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE dbo.TransactionHistory_SWITCH
   ADD CONSTRAINT PK__TRANSACTIONHISTORY_SWITCH_TransactionID PRIMARY KEY NONCLUSTERED (TranDate,TransactionID)
   GO
CREATE CLUSTERED INDEX CX__TRANSACTIONHISTORY_SWITCH_TRANDATE ON dbo.TransactionHistory_SWITCH(TranDate,TransactionID)




