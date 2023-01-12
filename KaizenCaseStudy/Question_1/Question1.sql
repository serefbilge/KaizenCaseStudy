CREATE PROCEDURE [dbo].[generate_codes]
AS
BEGIN

DECLARE @Counter INT = 1
DECLARE @Code VARCHAR(8);
DECLARE @x1 VARCHAR(3) = 'A2T';
DECLARE @x2 VARCHAR(3) = 'Z9C';
DECLARE @x3 VARCHAR(3) = 'K4H';
DECLARE @x4 VARCHAR(3) = 'EFR';
DECLARE @x5 VARCHAR(4) = 'YTD3';
DECLARE @x6 VARCHAR(3) = 'G5M';
DECLARE @x7 VARCHAR(3) = 'PLN';
DECLARE @x8 VARCHAR(3) = 'X7R';
--ACDEFGHKLMNPRTXYZ234579

IF OBJECT_ID(N'dbo.MyCodes', N'U') IS NULL
CREATE TABLE dbo.MyCodes (
    Code varchar(8)
);

WHILE (@Counter <= 1000)
BEGIN
	select @Code =
			substring(@x1,(abs(checksum(newid()))%3)+1,1)+
			substring(@x2,(abs(checksum(newid()))%3)+1,1)+
			substring(@x3,(abs(checksum(newid()))%3)+1,1)+
			substring(@x4,(abs(checksum(newid()))%3)+1,1)+
			substring(@x5,(abs(checksum(newid()))%4)+1,1)+
			substring(@x6,(abs(checksum(newid()))%3)+1,1)+
			substring(@x7,(abs(checksum(newid()))%3)+1,1)+
			substring(@x8,(abs(checksum(newid()))%3)+1,1);

   IF NOT EXISTS 
    (   SELECT  1
        FROM    MyCodes 
        WHERE   Code = @Code
    )
    BEGIN
        INSERT INTO MyCodes
        VALUES (@Code);

		PRINT 'The ' + CONVERT(VARCHAR,@Counter) + '. code is: ' + @Code;

		SET @Counter  = @Counter  + 1;
    END;
END


END
GO

-----------------------------------

CREATE procedure [dbo].[check_code]
@Code varchar(8),
@IsValid int out
as
begin

DECLARE @x1 VARCHAR(3) = 'A2T';
DECLARE @x2 VARCHAR(3) = 'Z9C';
DECLARE @x3 VARCHAR(3) = 'K4H';
DECLARE @x4 VARCHAR(3) = 'EFR';
DECLARE @x5 VARCHAR(4) = 'YTD3';
DECLARE @x6 VARCHAR(3) = 'G5M';
DECLARE @x7 VARCHAR(3) = 'PLN';
DECLARE @x8 VARCHAR(3) = 'X7R';
--ACDEFGHKLMNPRTXYZ234579

select @IsValid = case when charindex(substring(@Code, 1, 1), @x1) *
                            charindex(substring(@Code, 2, 1), @x2) *
	                        charindex(substring(@Code, 3, 1), @x3) *
	                        charindex(substring(@Code, 4, 1), @x4) *
	                        charindex(substring(@Code, 5, 1), @x5) *
	                        charindex(substring(@Code, 6, 1), @x6) *
	                        charindex(substring(@Code, 7, 1), @x7) *
	                        charindex(substring(@Code, 8, 1), @x8) > 0 then 1 else 0 end;
end



--Sample Usage:

--select * from MyCodes
--drop table MyCodes

--EXEC generate_codes;

--DECLARE @isValid int,@code varchar(8) = 'TCHFYMP7'
--EXEC [dbo].[check_code] @code,@isValid OUTPUT
--SELECT 'isValid' = @isValid