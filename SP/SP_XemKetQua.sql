USE [TN_CSDLPT]
GO
/****** Object:  StoredProcedure [dbo].[SP_XemKetQua]    Script Date: 28/06/2024 02:14:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_XemKetQua]
    @MASV CHAR(10),
    @MAMH CHAR(10),
    @LAN INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        b.CAUHOI,
        b.NOIDUNG,
        b.A,
        b.B,
        b.C,
        b.D,
        b.DAP_AN as 'DAPAN',
        c.DAPANSV
    FROM 
        BODE b
    JOIN 
        CTBAITHI c ON b.CAUHOI = c.CAUHOI
    WHERE 
        c.MABANGDIEM = (
            SELECT MABANGDIEM 
            FROM BANGDIEM 
            WHERE MASV = @MASV AND MAMH = @MAMH AND LAN = @LAN
        );
END;
