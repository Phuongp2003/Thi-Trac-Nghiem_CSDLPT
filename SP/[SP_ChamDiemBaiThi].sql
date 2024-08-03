USE [TN_CSDLPT]
GO
/****** Object:  StoredProcedure [dbo].[SP_ChamDiemBaiThi]    Script Date: 28/06/2024 01:10:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROC [dbo].[SP_ChamDiemBaiThi]
@masv char(8), @mamh char(5), @lan smallint
AS
BEGIN TRY
    DECLARE @maBangDiem nchar(10), @soluong int, @tmp float, @soCauDung float, @diemSV float

    SELECT @maBangDiem = MABANGDIEM, @diemSV = DIEM FROM BANGDIEM WHERE MASV = @masv AND MAMH = @mamh AND LAN = @lan

    IF (@maBangDiem IS NULL)
        BEGIN
            RAISERROR('Thí sinh này chưa thi!',16,1)
        END

    IF (@diemSV IS NOT NULL)
        BEGIN
            RAISERROR('Bài thi của sinh viên này đã được chấm',16,1)
        END

    SELECT CAUHOI, DAPANSV INTO #BAITHI FROM CTBAITHI WHERE MABANGDIEM = @maBangDiem
    SELECT @soluong = COUNT(CAUHOI) FROM #BAITHI

    SELECT @soCauDung= (@soluong*2- COUNT(CAUHOI)) FROM
        (SELECT CAUHOI, DAPANSV FROM #BAITHI
        UNION 
        SELECT CAUHOI, DAP_AN FROM BODE WHERE CAUHOI IN (SELECT CAUHOI FROM #BAITHI)) DAPANDUNG

    SET @diemSV = (@soCauDung / @soluong) * 10
    UPDATE BANGDIEM
        SET DIEM = @diemSV WHERE MABANGDIEM = @maBangDiem and MAMH = @mamh and MASV = @masv and LAN = @lan
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(2000)
    SELECT @ErrorMessage = N'Lỗi: ' + ERROR_MESSAGE()
    RAISERROR(@ErrorMessage, 16, 1)
END CATCH