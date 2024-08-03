USE [TN_CSDLPT]
GO
/****** Object:  StoredProcedure [dbo].[SP_KiemTraTrangThaiThi]    Script Date: 27/06/2024 18:14:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_KiemTraTrangThaiThi]
    @MASV NVARCHAR(50),
    @MAMH NVARCHAR(50),
    @LAN INT
AS
BEGIN
    DECLARE @DIEM FLOAT, @NGAYTHI DATETIME, @Result NVARCHAR(50);

    -- Check if the row exists and get the DIEM and NGAYTHI value
    SELECT @DIEM = DIEM, @NGAYTHI = NGAYTHI
    FROM BANGDIEM
    WHERE MASV = @MASV AND MAMH = @MAMH AND LAN = @LAN;

    -- Determine the result based on the DIEM value
    IF @DIEM IS NULL
    BEGIN
        IF @NGAYTHI IS NOT NULL
        BEGIN
            DECLARE @tgt INT;
            SET @tgt = (SELECT THOIGIAN 
                        FROM GIAOVIEN_DANGKY 
                        WHERE MAMH = @MAMH AND LAN = @LAN
                          AND MALOP = (SELECT MALOP FROM SINHVIEN WHERE MASV = @MASV));

            DECLARE @hanThi DATETIME = DATEADD(MINUTE, @tgt, @NGAYTHI);

            IF @hanThi > CURRENT_TIMESTAMP
                SET @Result = 'DANGTHI';
            ELSE
                SET @Result = 'DATHI';
        END
        ELSE
        BEGIN
            SET @Result = 'CHUATHI';
        END
    END
    ELSE
    BEGIN
        SET @Result = 'DATHI';
    END

    SELECT @Result AS 'TRANGTHAI';
END;


