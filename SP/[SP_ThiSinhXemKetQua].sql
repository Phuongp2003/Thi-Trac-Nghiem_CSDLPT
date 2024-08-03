USE [TN_CSDLPT]
GO
/****** Object:  StoredProcedure [dbo].[SP_ThiSinhXemKetQua]    Script Date: 28/06/2024 02:24:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[SP_ThiSinhXemKetQua]
    @MASV CHAR(10),
    @MAMH CHAR(10),
    @LAN INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Bảng 1: Thông tin sinh viên, môn học, lớp, ngày thi và lần thi
    SELECT 
        CONCAT(s.HO, ' ', s.TEN) AS HO_TEN,
        m.TENMH,
        m.MAMH,
        l.TENLOP,
        bd.NGAYTHI,
        bd.LAN,
		bd.DIEM
    FROM 
        BANGDIEM bd
    JOIN 
        SINHVIEN s ON bd.MASV = s.MASV
    JOIN 
        MONHOC m ON bd.MAMH = m.MAMH
    JOIN 
        LOP l ON s.MALOP = l.MALOP
    WHERE 
        bd.MASV = @MASV 
        AND bd.MAMH = @MAMH 
        AND bd.LAN = @LAN;
END;
