use ShipperTest;
GO;
--Bang Nhan Vien
CREATE OR ALTER PROCEDURE insertNhanVien
@ho nvarchar(20),@tenLot nvarchar(20) ='',@ten nvarchar(20), @luong decimal,@taiKhoan nvarchar(50)='',
@matKhau nvarchar(50) ='',@loaiNhanVien nvarchar(20)='',@chiSoUyTin int=5
AS
	IF(@chiSoUyTin>5 OR @chiSoUyTin<1)
		BEGIN 
		--RAISERROR('Chi so uy tin phai la so nguyen tu 1 den 5',16,1);
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
	IF(@taiKhoan IN ((SELECT taikhoan FROM NhanVien UNION SELECT taiKhoan FROM NhaHang) UNION SELECT taiKhoan FROM KhachHang))
		BEGIN
			RAISERROR('Tai khoan trung, xin thu lai bang ten khac',16,1);
			RETURN
		END
	INSERT INTO NhanVien (ho, tenLot,ten,luong, taiKhoan,matKhau,loaiNhanVien,chiSoUyTin)
	VALUES (@ho,@tenLot,@ten,@luong, @taiKhoan,@matKhau,@loaiNhanVien,@chiSoUyTin)
GO
EXEC insertNhanVien @ho='Ho',@ten='Thuong'
,@luong='1000', @taiKhoan='thuong1232423434534',@matKhau='123456789',@loaiNhanVien=NUll
GO

-------------------Cau1:PROCEDURE INSERT BẢNG ChiNhanh--------------------------

CREATE OR ALTER PROCEDURE Insert_Chinhanh 
			@masothue int, @diachi nvarchar(50), @maNVQuanLy uniqueidentifier,@maChiNhanhCha int
AS
	IF (@maChiNhanhCha <=0)
		BEGIN 
			RAISERROR(N'Mã Chi nhánh phải là số nguyên dương',16,1);
			RETURN;
		END;
	IF(@maNVQuanLy  NOT IN (SELECT maNhanVien FROM NhanVien))
		BEGIN
			RAISERROR(N'Không tồn tại nhân viên trên',16,1);
			RETURN
		END
	ELSE IF(@maNVQuanLy  NOT IN (SELECT maNhanVien FROM QuanLi) and @maNVQuanLy is not null )
		BEGIN
			INSERT INTO QuanLi values(@maNVQuanLy);
		END
	INSERT INTO ChiNhanh (maSoThue,diaChi,maNVQuanLy,maChiNhanhCha)
	VALUES(@masothue,@diachi,@maNVQuanLy,@maChiNhanhCha);

GO;
EXEC Insert_Chinhanh 1,N'Khánh Hoà',Null,NULL;
GO;

-------------------Cau 2: TRIGGER FOR INSERT,UPDATE,DELETE
--Vào bảng ChiNhanh:
	--Khi insert vào bảng Chi nhánh:
	--	+tự insert hay update mã nhân viên quản lý vào bảng Quanli nếu chưa tồn tại. 
	--	+trên bảng NhanVien, tự động tăng 20% lương cho nhân viên được bổ nhiệm làm quản lý & update @loaiNhanVien=’quan ly’.

--Cau2.1 a) Trigger for insert
CREATE OR ALTER TRIGGER updateQuanly ON ChiNhanh 
AFTER INSERT
AS
	DECLARE @maQL  uniqueidentifier;
	SELECT  @maQL=maNVQuanLy FROM inserted;
	IF (@maQL IN (SELECT maNhanVien FROM NhanVien))
		BEGIN 
			UPDATE NhanVien 
			set luong=luong*1.2,loaiNhanVien='quan ly' 
			WHERE maNhanVien=@maQL and (loaiNhanVien is null OR loaiNhanVien!='quan ly');
		END
GO
ALTER TABLE ChiNhanh
	ADD soLuongNhanVien int DEFAULT 0;
GO;

--Cau2.1 b) Trigger for update
-- Kiểm tra
--Cau2.1 c) Trigger for delete

--Vào bảng NhanVienChiNhanh:
	--Khi insert, update,delete vào bảng Chi nhánh x:
		-- Cập nhật số nhân viên đang làm việc cho chi nhánh đó
CREATE OR ALTER TRIGGER Cal_soLuongNhanVien_Insert
ON NhanVienChiNhanh 
FOR INSERT
AS BEGIN
	DECLARE @maDV int;
	SELECT @maDV = maDonVi from INSERTED;
	UPDATE ChiNhanh
	SET soLuongNhanVien=soLuongNhanVien+1
	WHERE maDonVi = @maDV;
	END;

GO
-- create trigger for delete
CREATE OR ALTER TRIGGER Cal_soLuongNhanVien_Del
ON NhanVienChiNhanh 
FOR DELETE
AS BEGIN
	DECLARE @maDV int;
	SELECT @maDV = maDonVi from DELETED;

	UPDATE ChiNhanh
	SET soLuongNhanVien=soLuongNhanVien-1
	WHERE maDonVi = @maDV;
	END;
GO

-- create trigger for update
CREATE OR ALTER TRIGGER Cal_soLuongNhanVien_Update
ON NhanVienChiNhanh 
FOR UPDATE
AS 
	IF (UPDATE(maDonVi))
BEGIN
	DECLARE @maDV_old int;
	DECLARE @maDV_new int;
	SELECT @maDV_old = maDonVi from DELETED;
	SELECT @maDV_new = maDonVi from inserted;

	UPDATE ChiNhanh
	SET soLuongNhanVien=soLuongNhanVien-1
	WHERE maDonVi = @maDV_old;

	UPDATE ChiNhanh
	SET soLuongNhanVien=soLuongNhanVien+1
	WHERE maDonVi = @maDV_new;

END;

GO
INsert into NhanVienChiNhanh values('8FFA671B-F031-45BD-BDF9-6CF79E7859C7',1);
INsert into NhanVienChiNhanh values('8FFA671B-F031-45BD-BDF9-6CF79E7859C8',2);
Update NhanVienChiNhanh
Set maDonVi=2
where maNhanVien='8FFA671B-F031-45BD-BDF9-6CF79E7859C7'
Delete from NhanVienChiNhanh
where maNhanVien='8FFA671B-F031-45BD-BDF9-6CF79E7859C7'


ALTER TABLE ChiNhanh
	ADD soLuongNhanVien int DEFAULT 0;
GO;
ALTER TABLE ChiNhanh
	ADD ngayQLyBatDauLamViec date default GETDATE();
GO;
ALTER TABLE ChiNhanh
	ADD ngayQLyBatDauLamViec date default GETDATE();
GO;
--update notnut
ALTER TABLE ChiNhanh
	ADD tenChiNhanh nvarchar(30) null;
GO;

-------------------Cau 3: Store Procedure
--3a)Hiển thị danh sách shipper làm việc tại chi nhánh X (nhớ sửa cho lọc theo tên) sắp xếp  descending theo ngày vào làm 

CREATE OR ALTER PROCEDURE DanhsachShipperChiNhanhX
@maDonVi int
AS
	SELECT C.ho+' '+C.tenLot +' '+C.ten as HovaTen,C.loaiNhanVien , C.luong , C.ngayVaoLam
	FROM NhanVienChiNhanh A, Shipper B, NhanVien C
	WHERE A.maNhanVien=B.maNhanVien and B.maNhanVien=C.maNhanVien and A.maDonVi=@maDonVi
	ORDER by  C.ngayVaoLam DESC;
GO;
EXEC DanhsachShipperChiNhanhX 1;

--3b)Procedure lấy danh sách chi nhánh thuộc quản lý có chỉ số uy tín trên X.
Go;
CREATE OR ALTER PROCEDURE DSChiNhanhQLUytinX
@csuytin int
AS
	Select  A.maDonVi,A.tenChiNhanh,A.maSoThue,A.diaChi,A.soLuongNhanVien
	From ChiNhanh A,QuanLi B,NhanVien C
	Where A.maNVQuanLy=B.maNhanVien and B.maNhanVien=C.maNhanVien and C.chiSoUyTin>@csuytin
	order by A.soLuongNhanVien ASC;
GO;
EXEC DSChiNhanhQLUytinX 2;

