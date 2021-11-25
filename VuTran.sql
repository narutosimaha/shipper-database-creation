

-------------------CAU1 PROCEDURE INSERT BẢNG NHÂN VIÊN--------------------------
CREATE OR ALTER PROCEDURE insertNhanVien
@ho nvarchar(20),@tenLot nvarchar(20) ='',@ten nvarchar(20), @luong decimal,@taiKhoan nvarchar(50)='',
@matKhau nvarchar(50) ='',@loaiNhanVien nvarchar(20)='',@chiSoUyTin int=5,@ngaySinh Date
AS
	IF(@chiSoUyTin>5 OR @chiSoUyTin<1)
		BEGIN 
			RAISERROR('Chi so uy tin phai la so nguyen tu 1 den 5',16,1);
			RETURN;
		END
	IF(@luong < 0)
		BEGIN
			RAISERROR('Luong phai la so duong',16,1);
			RETURN;
		END
	IF(LEN(@matkhau)<8)
		BEGIN
			RAISERROR('Mat khau phai tu 8 ky tu tro len',16,1);
			RETURN
		END
	IF(@ho LIKE '%[^a-zA-Z]%')
		BEGIN
			RAISERROR('Ho chi duoc chua cac ky tu Alphabet',16,1);
			RETURN
		END
	IF(@ten LIKE '%[^a-zA-Z]%')
		BEGIN
			RAISERROR('Ten chi duoc chua cac ky tu Alphabet',16,1);
			RETURN
		END
	IF(DATEDIFF(year,@ngaySinh,GETDATE())<18)
		BEGIN
			RAISERROR('Nhan vien phai tren 18 tuoi',16,1);
			RETURN
		END
	IF(@taiKhoan IN ((SELECT taikhoan FROM NhanVien UNION SELECT taiKhoan FROM NhaHang) UNION SELECT taiKhoan FROM KhachHang))
		BEGIN
			RAISERROR('Tai khoan trung, xin thu lai bang ten khac',16,1);
			RETURN
		END
	INSERT INTO NhanVien (ho, tenLot,ten,luong, taiKhoan,matKhau,loaiNhanVien,chiSoUyTin,ngaySinh)
	VALUES (@ho,@tenLot,@ten,@luong, @taiKhoan,@matKhau,@loaiNhanVien,@chiSoUyTin,@ngaySinh)
GO
EXEC insertNhanVien @ho='Ho',@ten='Quang'
,@luong='1000', @taiKhoan='hoQuang1234',@matKhau='123456789',@loaiNhanVien='quan ly'
GO



-------------------CAU2 TRIGGER--------------------------
--a) Trigger sau khi insert  hay update nhân viên vào bảng nhân viên, nếu trường loại nhân viên được 
--insert vào hay được update thành quản lý hoặc tổng đài viên, tự insert thêm mã nhân viên vào hai 
--bảng quản lý và tổng đài viên tương ứng. Khi một nhân viên nghĩ làm ở công ty, để lưu trữ dữ liệu 
--của các nhân viên cũ cùng với các hoạt động của nhân viên đó trên các bảng, nên thay vì xóa ta thêm 
--trường isActive vào relation nhân viên, dùng trigger tự động set biến này bằng 0 khi ta xóa nhân viên 
--đi. Biến này default sẽ là 1.

CREATE TRIGGER updateNhanVien ON NhanVien 
FOR INSERT, UPDATE
AS
	DECLARE @type  nvarchar(20);
	DECLARE @id uniqueidentifier;
	SELECT @type=loaiNhanVien,@id=maNhanVien FROM inserted;
	IF (lower(@type)='quan ly' AND @id NOT IN (SELECT maNhanVien FROM QuanLi))
		BEGIN
			INSERT INTO QuanLi (maNhanVien) VALUES (@id)
		END
	ELSE IF (lower(@type)='tong dai vien' AND @id NOT IN (SELECT maNhanVien FROM TongDaiVien))
		BEGIN
			INSERT INTO tongDaiVien (maNhanVien) VALUES (@id)
		END
GO

ALTER TABLE NhanVien
ADD isActive BIT DEFAULT 1;

GO
CREATE TRIGGER deleteNhanVien ON NhanVien 
INSTEAD OF DELETE
AS
	DECLARE @id uniqueidentifier;
	SELECT @id=maNhanVien FROM deleted;
	UPDATE NhanVien SET isActive=0 WHERE maNhanVien=@id
GO
DELETE FROM NhanVien WHERE ho like 'Tien';
GO

CREATE TRIGGER giamLuong ON QuyTrachNhiem
AFTER INSERT
AS 
	DECLARE @id uniqueidentifier;
	SELECT @id=maNhanVien FROM INSERTED;
	UPDATE NhanVien set luong=luong*0.95 WHERE maNhanVien=@id
GO



--b) Tự động tăng lương , và giảm lương cho tổng đài viên tùy theo số lần tư vấn khách hàng. Cụ thê:
--	- Tăng lên 5% lương cho cứ mỗi 3 lần phục vụ khách hàng của tổng đài viên.
--	- Giảm lương tương ứng khi xóa đi record liên quan đến tổng đài viên trong bảng tổng đài viên 
--	  tư vấn khách hàng.

CREATE OR ALTER TRIGGER tangLuongTuVan ON TuVanGiaiDap
AFTER INSERT
AS 
	DECLARE @count INT;
	DECLARE @idTongDai uniqueidentifier;
	SELECT @idTongDai=maTongDaiVien FROM inserted;
	SELECT @count=COUNT(*) FROM TuVanGiaiDap WHERE maTongDaiVien=@idTongDai;
	IF(@count%3=0)
	BEGIN
		UPDATE NhanVien set luong=luong*1.05 WHERE maNhanVien=@idTongDai
	END
GO

CREATE OR ALTER TRIGGER tangLuongTuVanUpdate ON TuVanGiaiDap
AFTER UPDATE
AS 
	DECLARE @count INT;
	DECLARE @idTongDai uniqueidentifier;
	SELECT @idTongDai=maTongDaiVien FROM inserted;
	IF (UPDATE(maTongDaiVien))
	BEGIN
		SELECT @count=COUNT(*) FROM TuVanGiaiDap WHERE maTongDaiVien=@idTongDai;
		IF(@count%3=0)
		BEGIN
			UPDATE NhanVien set luong=luong*1.05 WHERE maNhanVien=@idTongDai;
		END
	END
GO

CREATE OR ALTER TRIGGER giamLuongTuVan ON TuVanGiaiDap
AFTER DELETE
AS 
	DECLARE @count INT;
	DECLARE @idTongDai uniqueidentifier;
	SELECT @idTongDai=maTongDaiVien FROM deleted;
	IF(EXISTS (SELECT maTongDaiVien FROM TuVanGiaiDap WHERE maTongDaiVien=@idTongDai))
	BEGIN
		SELECT @count=COUNT(*) FROM TuVanGiaiDap WHERE maTongDaiVien=@idTongDai;
		IF(@count%3=2)
			BEGIN
				UPDATE NhanVien set luong=luong*0.95 WHERE maNhanVien=@idTongDai;
			END
	END
GO


-------------------CAU3--------------------------
--   3) Mỗi thành viên viết 2 thủ tục trong đó chỉ chứa các câu truy vấn đề hiển thị dữ liệu và
--tham số đầu vào là các giá trị trong mệnh đề WHERE và/hoặc Having (nếu có), gồm:
--- (a) 1 câu truy vấn từ 2 bảng trở lên có mệnh đề where, order by
--- (b) 1 câu truy vấn có aggreate function, group by, having, where và order by có liên kết từ 2
--bảng trở lên

--a) PROCEDURE hiển thị các thông tin ưu đãi của nhà hàng đối với món ăn X trong đơn hàng. (tham số id món ăn)
CREATE OR ALTER PROCEDURE thongTinUuDai
@idMonAn int
AS
	SELECT M.tenMonAn,M.donGia , M.donGia*(1-U.discount) as giaDaUuDai,U.tenUuDai,U.discount,U.moTa,U.ngayHetHan
	FROM MonAn M JOIN UuDai U ON (M.maMonAn=U.maMonAn)
	WHERE M.maMonAn=@idMonAn
	ORDER BY discount DESC

EXEC thongtinUuDai 1



-- b)Tìm các khách hàng có số đơn đặt cao nhất ở địa chỉ X. Và sắp xếp các khách hàng theo thứ tự tăng dần
-- số tiền ship thu được từ khách hàng.
go
CREATE OR ALTER PROCEDURE khachHangSop
@diaChi varchar(50)
AS
	SELECT K.maKhachHang,K.Ho,K.tenLot ,K.Ten,K.diaChi,COUNT(*) as SoDon, SUM(D.tienShip) as TongTien
	FROM KhachHang K, DonVanChuyen D
	WHERE K.maKhachHang=D.maKhachHang AND D.tienShip IS NOT NULL AND LOWER(K.diaChi)=LOWER(@diaChi)
	GROUP BY K.maKhachHang, K.diaChi,K.Ho,K.tenLot ,K.Ten
	HAVING COUNT(*) IN (SELECT MAX(T.SoDon) as soDonMax
						FROM (SELECT COUNT(*) as SoDon
							  FROM KhachHang K, DonVanChuyen D
							  WHERE K.maKhachHang=D.maKhachHang AND D.tienShip IS NOT NULL AND LOWER(K.diaChi)=LOWER(@diaChi)
							  GROUP BY K.maKhachHang) T)
	ORDER BY SUM(D.tienShip) ASC
go

EXEC khachHangSop 'pHu YEN'




---------------------CAU 4--------------------------
--(1.5 điểm) Mỗi thành viên viết 2 hàm thỏa yêu cầu sau:
--- Chứa câu lệnh IF và/hoặc LOOP để tính toán dữ liệu được lưu trữ
--- Chứa câu lệnh truy vấn dữ liệu, lấy dữ liệu từ câu truy vấn để kiểm tra tính toán
--- Có tham số đầu vào và kiểm tra tham số đầu
--Mỗi thành viên viết 2 câu SELECT để minh họa việc gọi hàm trong câu SELECT






--a) Nhân viên tổng đài viên ở chi nhánh X được thưởng tiền theo số lần  tư vấn với khách hàng, 
--ai tư vấn hơn 10 lần được thưởng 4tr, hơn 5 lần được thẳng 2.5 tr, hơn 3 lần được thưởng 2 tr. 
--Tính tổng số tiền cần thưởng của chi nhánh X.

GO
CREATE OR ALTER FUNCTION thuongLuongTuVan (@brandID as INT)
RETURNS  @tienThuong TABLE(
	maChiNhanh INT,
	tongTien INT default 0
)
AS
BEGIN
	DECLARE tuVanCursor CURSOR 
	FOR SELECT COUNT(*) as soLan
		FROM TuVanGiaiDap T,NhanVienChiNhanh N
		WHERE T.maTongDaiVien=N.maNhanVien AND N.maDonVi=@brandID
		GROUP BY maTongDaiVien

	DECLARE @tongTien INT
	SET @tongTien =0;

	DECLARE  @soLan INT;
	
	OPEN tuVanCursor
	FETCH NEXT FROM tuVanCursor
	INTO @soLan

	WHILE (@@FETCH_STATUS=0)
	BEGIN
		IF(@soLan>10)
			SET @tongTien=@tongTien+4000000;
		ELSE IF (@soLan>5)
			SET @tongTien=@tongTien+2500000;
		ELSE IF (@soLan>3)
			SET @tongTien=@tongTien+2000000;
		FETCH NEXT FROM tuVanCursor
		INTO @soLan
	END
	INSERT INTO @tienThuong(maChiNhanh,tongTien) VALUES (@brandID,@tongTien)
	CLOSE tuVanCursor;
	DEALLOCATE tuVanCursor;
	RETURN 
END
GO
SELECT * FROM dbo.thuongLuongTuVan(1)
GO

 --b) Trong một ngày lễ, công ty quyết định tặng hàng loạt mã discount 20% cho các khách hàng thân thiết 
 --của mình , là khách hàng có ngày tham gia bé hơn ngày tháng năm X. Mã này sẽ được tặng dựa theo số 
 --tiền ship thu được từ khách hàng. Số tiền này nếu lớn hơn 100 nghìn thì được tặng 3 mã. Hơn 50 nghìn 
 --được tặng 2 mã. Tính tổng số mã discount 20% mà công ty phải tặng.
 GO

CREATE OR ALTER FUNCTION tangUuDai (@dateTime as Date)
RETURNS INT
AS
BEGIN
	DECLARE uuDaiCursor CURSOR 
	FOR  SELECT SUM(D.tienShip) as tienThuDuoc
		 FROM DonVanChuyen D,KhachHang K
		 WHERE D.maKhachHang=K.maKhachHang AND K.ngayThamGia<@dateTime AND D.tienShip IS NOT NULL
		 GROUP BY K.maKhachHang

	DECLARE @tongTheUuDai INT
	SET @tongTheUuDai =0;

	DECLARE  @tienThuDuoc INT;
	
	OPEN uuDaiCursor
	FETCH NEXT FROM uuDaiCursor
	INTO @tienThuDuoc

	WHILE (@@FETCH_STATUS=0)
	BEGIN
		IF(@tienThuDuoc>100000)
			SET @tongTheUuDai=@tongTheUuDai+3;
		ELSE IF (@tienThuDuoc>50000)
			SET @tongTheUuDai=@tongTheUuDai+2;
		FETCH NEXT FROM uuDaiCursor
		INTO @tienThuDuoc
	END
	
	CLOSE uuDaiCursor;
	DEALLOCATE uuDaiCursor;
	RETURN @tongTheUuDai
END
GO
SELECT dbo.tangUuDai('2020-01-01')

Go
alter database Shipper set single_user with rollback immediate
drop database Shipper
