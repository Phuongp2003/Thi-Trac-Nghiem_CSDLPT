﻿USE [TN_CSDLPT]
GO
/****** Object:  StoredProcedure [dbo].[SP_KiemTraBoDeTonTai]    Script Date: 24/06/2024 3:43:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROC [dbo].[SP_KiemTraBoDeTonTai]
@CAUHOI INT
AS
BEGIN
    IF EXISTS(SELECT CAUHOI FROM BODE WHERE CAUHOI = @CAUHOI)
    RAISERROR('Mã câu hỏi này đã tồn tại', 16, 1) 
END