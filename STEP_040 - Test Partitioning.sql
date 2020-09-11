-- ////////////////////////////////////////////////////////////////////////////
-- //
-- //  Description: 
-- //  -----------------------------------
-- //  Test to evaluate counts in partitions
-- //  
-- //  
-- //  Modification history:
-- //  Rev#  Date        Author     Description
-- //   ----- --------   ---------  --------------------------------------------
-- //  1.0   2020-Sep-10 R Gosling  Original Release 
-- ////////////////////////////////////////////////////////////////////////////
--==================================================================
-- Sanity Checks and anything else
--==================================================================
USE DISA_TEST
GO
DECLARE @SwitchDate date = '2020-01-01'
DECLARE @FutureDate date = '2021-01-01'
DECLARE @PartitionNumber int;
DECLARE @RowCount int = 0;
DECLARE @FutureRowCount int = 0;
--
-- Find the boundary number for the switch date
SELECT @PartitionNumber=$PARTITION.pfnTranByMonth(@SwitchDate) ;  
--
--
SELECT * FROM sys.partition_range_values

--SELECT @PartitionNumber = boundary_id
--FROM sys.partition_range_values
--WHERE [value] = @SwitchDate;

PRINT 'Boundary Being Switched: ' + CAST(@PartitionNumber AS varchar)
PRINT 'Row Count of Switch Partition: ' + CAST(@RowCount AS VARCHAR)
PRINT 'Row Count of Future SPLIT: ' + CAST(@FutureRowCount AS VARCHAR)

SELECT $PARTITION.pfnTranByMonth(TranDate) AS TblPartition,   
COUNT(*) AS [COUNT] FROM dbo.TransactionHistory   
GROUP BY $PARTITION.pfnTranByMonth(TranDate)  
ORDER BY TblPartition ;

select * from sys.partition_range_values
SELECT * FROM dbo.TransactionHistory  
WHERE $PARTITION.pfnTranByMonth(TranDate) =2 --@PartitionNumber ;

-- a LOT of data!
--SELECT * FROM sys.dm_db_partition_stats

select * from sys.partitions

SELECT DISTINCT o.name as table_name, rv.value as partition_range, fg.name as file_groupName, p.partition_number, p.rows as number_of_rows
FROM sys.partitions p
INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
INNER JOIN sys.objects o ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id 
LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id
WHERE o.object_id = OBJECT_ID('TransactionHistory') 

SELECT * FROM dbo.TransactionHistory