﻿USE [TN_CSDLPT]
GO
/****** Object:  StoredProcedure [dbo].[SP_KiemTraLopTonTai]    Script Date: 24/06/2024 3:38:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROC [dbo].[SP_KiemTraLopTonTai]
@MALOP NCHAR(15), @TENLOP NVARCHAR(50)
AS
BEGIN
    IF EXISTS(SELECT MALOP FROM LINK2.TN_CSDLPT.DBO.LOP WHERE MALOP = @MALOP)
    RAISERROR('Mã lớp này đã tồn tại', 16, 1) 
    IF EXISTS(SELECT TENLOP FROM LINK2.TN_CSDLPT.DBO.LOP WHERE TENLOP = @TENLOP)
    RAISERROR('Tên lớp này đã tồn tại', 16, 1)
END