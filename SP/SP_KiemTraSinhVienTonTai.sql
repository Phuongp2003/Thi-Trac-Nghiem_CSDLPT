﻿USE [TN_CSDLPT]
GO
/****** Object:  StoredProcedure [dbo].[SP_KiemTraSinhVienTonTai]    Script Date: 24/06/2024 3:41:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROC [dbo].[SP_KiemTraSinhVienTonTai]
@MASV NCHAR(15)
AS
BEGIN
    IF EXISTS(SELECT MASV FROM LINK2.TN_CSDLPT.DBO.SINHVIEN WHERE MASV = @MASV)
    RAISERROR('Mã sinh viên này đã tồn tại', 16, 1) 
END