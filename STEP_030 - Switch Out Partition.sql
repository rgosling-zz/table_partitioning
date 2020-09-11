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
-- Declare local variables. @NextDate and @FutureDate are the two areas where the 
-- partition scheme will change
--==================================================================
-- 
DECLARE @SwitchDate date = '2020-01-01'
DECLARE	@PartitionNumber int=0;
DECLARE @RowCount int=0;
DECLARE @FutureDate date = '2021-01-01'
--
-- Get the Partition Number associated with the Switch
SELECT @PartitionNumber = boundary_id
FROM sys.partition_range_values
WHERE [value]  = @SwitchDate 
----
PRINT 'Partition Number: ' + CAST(@PartitionNumber as char(1))
--
-- Get the row count to decide if we're doing this
SELECT @rowCount = count(*) FROM hist.TransactionHistory  
WHERE $PARTITION.pfnTranHistByMonth(TranDate) = @PartitionNumber ;

--print 'Boundary: ' + cast(@MergeBoundary as varchar)
--print 'Rowcount: '+cast(@RowCount AS VARCHAR)
--
--Prep the switch table - has to be empty
TRUNCATE TABLE hist.TransactionHistory_SWITCH
--
-- Switch the Partition
ALTER TABLE hist.TransactionHistory 
SWITCH PARTITION @PartitionNumber TO hist.TransactionHistory_SWITCH 
-- 
--SELECT COUNT(*) FROM hist.TransactionHistory 
--SELECT * FROM hist.TransactionHistory_SWITCH

-- Merge the old partition as it's now empty
ALTER PARTITION FUNCTION pfnTranHistByMonth () MERGE RANGE (@SwitchDate); 
--
-- and split the empty future range to make room: At least one empty partition at the begining and end
ALTER PARTITION FUNCTION pfnTranHistByMonth () SPLIT RANGE (@FutureDate);
