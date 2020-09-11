-- ////////////////////////////////////////////////////////////////////////////
-- //
-- //  Description: 
-- //  -----------------------------------
-- //  Populate Data for Table Partitioning Example
-- //  
-- //  
-- //  Modification history:
-- //  Rev#  Date        Author     Description
-- //   ----- --------   ---------  --------------------------------------------
-- //  1.0   2020-Sep-10 R Gosling  Original Release 
-- ////////////////////////////////////////////////////////////////////////////
--==================================================================
-- Generate  rows with data for the last 6 months
--==================================================================
--truncate table hist.TransactionHistory  
DECLARE @rcount int = 364; -- 180 days from the current date
DECLARE @StartDate DATE = '2020-01-01'--DATEADD(dd,-@rcount, GETDATE());
DECLARE @CurrDate  DATE=@StartDate;
Declare @PartitionCount INT=0;
DECLARE @LastPartitionID INT = 0;
DECLARE @NextPartitionID INT=0;
DECLARE @IncrCounter int =0;
--
TRUNCATE TABLE hist.TransactionHistory 
WHILE @IncrCounter <= @rcount
BEGIN
 
	SET @CurrDate = dateadd(dd,@IncrCounter,@StartDate)
	SET @IncrCounter = @IncrCounter + 1
	--PRINT 'Row: ' + CAST(@IncrCounter as varchar(20)) 
	--PRINT 'Current Date: ' + cast(@CurrDate as varchar(20))
	INSERT INTO hist.TransactionHistory (TransactionID,TranDate) VALUES(@IncrCounter,@CurrDate)
END