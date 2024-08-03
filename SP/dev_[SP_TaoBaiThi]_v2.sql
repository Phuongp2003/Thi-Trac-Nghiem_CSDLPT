USE [TN_CSDLPT]
GO
/****** Object:  StoredProcedure [dbo].[SP_TaoBaiThi]    Script Date: 27/06/2024 00:05:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_TaoBaiThi] @masv char(8),
	@malop NCHAR(15),
	@ngayThi datetime, @soCauThi int, @trinhDo nchar(1),
	@maMH nchar(5),
	@lan smallint = 1
AS
BEGIN
--Uu tien lay de cua giao vien o co so  ma lop do dang hoc
--khong phai la lay de theo giao vien day lop do!!!
SELECT  @ngayThi = NGAYTHI, @soCauThi = SOCAUTHI, @trinhDo = TRINHDO FROM GIAOVIEN_DANGKY WHERE MAMH = @maMH AND MALOP = @maLop AND LAN = @lan

DECLARE @soluong int, @giothi datetime = DATEADD(MINUTE, 1, CURRENT_TIMESTAMP)
SELECT @soluong = COUNT(CAUHOI) FROM BODE 
	WHERE MAMH = @maMH AND TRINHDO = @trinhDo AND MAGV IN (SELECT MAGV FROM GIAOVIEN WHERE MAKH IN (SELECT MAKH FROM KHOA))

	--Tu dong tao bang diem khi thi, diem = null
	DECLARE @maBangDiem nchar(10) = TRIM(@masv) + TRIM(@maMH) + STR(@lan,1,0)
	IF EXISTS (select 1 from BANGDIEM where MABANGDIEM=@maBangDiem)
		BEGIN
			RAISERROR('Bang diem nay da ton tai',16,1)
		END

	IF (@soluong > @soCauThi)
		BEGIN 
			INSERT INTO BANGDIEM(MASV, MAMH, LAN, NGAYTHI, DIEM, MABANGDIEM)
			VALUES (@masv, @maMH, @lan, @giothi, NULL, @maBangDiem)
			
			
			--Tao bai thi (duoc luu trong CTBAITHI)
			INSERT INTO CTBAITHI (CAUHOI, MABANGDIEM)
			SELECT TOP (@soCauThi) CAUHOI, @maBangDiem FROM BODE
			WHERE BODE.MAMH = @maMH AND TRINHDO = @trinhDo AND MAGV IN (SELECT MAGV FROM GIAOVIEN WHERE MAKH IN (SELECT MAKH FROM KHOA))
			
			--Danh sach cau hoi cua bai thi
			SELECT NOIDUNG, BODE.CAUHOI, A, B, C, D FROM (SELECT CAUHOI FROM CTBAITHI WHERE CTBAITHI.MABANGDIEM=@maBangDiem) BAITHI, BODE WHERE BODE.CAUHOI = BAITHI.CAUHOI
				
		END
	ELSE
		BEGIN
			DECLARE @soluongCSkhac int
			SELECT @soluongCSkhac = COUNT(CAUHOI) FROM BODE 
				WHERE MAMH = @maMH AND TRINHDO = @trinhDo AND MAGV NOT IN (SELECT MAGV FROM GIAOVIEN WHERE MAKH IN (SELECT MAKH FROM KHOA))
	
			IF (@soluong + @soluongCSkhac < @soCauThi)
				BEGIN
					RAISERROR ('So luong cau hoi khong du',16,1)
				END
			ELSE
				BEGIN 
					INSERT INTO BANGDIEM(MASV, MAMH, LAN, NGAYTHI, DIEM, MABANGDIEM)
					VALUES (@masv, @maMH, @lan, @giothi, NULL, @maBangDiem)
			
			
					--Tao bai thi (duoc luu trong CTBAITHI)
					INSERT INTO CTBAITHI (CAUHOI, MABANGDIEM)
					SELECT TOP (@soCauThi) CAUHOI, @maBangDiem FROM BODE
					WHERE BODE.MAMH = @maMH AND TRINHDO = @trinhDo AND MAGV IN (SELECT MAGV FROM GIAOVIEN WHERE MAKH NOT IN (SELECT MAKH FROM KHOA))
			
					--Danh sach cau hoi cua bai thi
					SELECT NOIDUNG, BODE.CAUHOI, A, B, C, D FROM (SELECT CAUHOI FROM CTBAITHI WHERE CTBAITHI.MABANGDIEM=@maBangDiem) BAITHI, BODE WHERE BODE.CAUHOI = BAITHI.CAUHOI
				
				END
			END
END