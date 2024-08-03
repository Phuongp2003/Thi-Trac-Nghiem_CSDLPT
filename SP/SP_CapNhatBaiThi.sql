USE [TN_CSDLPT]
GO
/****** Object:  StoredProcedure [dbo].[SP_CapNhatBaiThi]    Script Date: 26/06/2024 22:24:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   proc [dbo].[SP_CapNhatBaiThi]
(@masv char(8),
@mamh char(5),
@lanthi smallint,
@cauhoi int,
@traloi char(1))
AS
BEGIN
	UPDATE CTBAITHI
	SET DAPANSV = CASE 
                    WHEN @traloi = '' THEN NULL 
                    ELSE @traloi 
                END
	WHERE 
		MABANGDIEM = 
			(SELECT MABANGDIEM FROM BANGDIEM WHERE MASV = @masv and MAMH = @mamh and LAN = @lanthi) 
		and CAUHOI = @cauhoi
END;