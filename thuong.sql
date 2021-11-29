use Shipper;
GO;
--Bang Nhan Vien

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
	--	+tự insert mã nhân viên quản lý vào bảng Quanli nếu chưa tồn tại. 
	--	+trên bảng NhanVien, tự động tăng 20% lương cho nhân viên được bổ nhiệm làm quản lý & update @loaiNhanVien=’quan ly’, cập nhật 
	-- isactive=1.
	--Khi update vào bảng Chi nhánh:
	--	+ Nếu ban đầu chưa có quản lý:
		--	+ tự insert mã nhân viên quản lý vào bảng Quanli nếu chưa tồn tại.
		--  + trên bảng NhanVien, tự động tăng 20% lương cho nhân viên được bổ nhiệm làm quản lý & update @loaiNhanVien=’quan ly’.
		--	+ cập nhật isactive=1.
		--	+ Kiểm tra xem quản lý có đang làm quản lý cho chi nhánh nào k, nếu có thì set maquanly ở chi nhánh cũ =null,
		
	-- + Nếu có sự thay đổi quản lý:
		--	+ Kiểm tra xem quản lý mới có đang làm quản lý cho chi nhánh nào k, nếu có thì set maquanly ở chi nhánh cũ =null,
		--	+ Set isactive của quản lý cũ =0,
	-- + Cập nhật lại ngày bắt đầu làm quản lý
	--Khi update delete record bẳng Chi nhánh:
		--	Khi một chi nhánh  dừng hoạt động, thay vì xóa ta thêm trường isActive vào relation ChiNhanh, 
		--dùng trigger tự động set biến này bằng 0 khi ta xóa ChiNhanh. Biến này default sẽ là 1.
		-- Cập nhật lại trường isactive trong bảng nhân viên làm việc cho chi nhánh đó
--Cau2.1 a) Trigger for insert
--	+tự insert mã nhân viên quản lý vào bảng Quanli nếu chưa tồn tại. 
	--	+trên bảng NhanVien, tự động tăng 20% lương cho nhân viên được bổ nhiệm làm quản lý & update @loaiNhanVien=’quan ly’, cập nhật 
	-- isactive=1.
CREATE OR ALTER TRIGGER TG_inserChiNhanh ON ChiNhanh 
AFTER INSERT
AS
	DECLARE @maQL  uniqueidentifier;
	SELECT  @maQL=maNVQuanLy FROM inserted;
	IF (@maQL Not IN (SELECT maNhanVien FROM QuanLi))
		Insert into QuanLi values(@maQL);
	IF (@maQL IN (SELECT maNhanVien FROM NhanVien))
		BEGIN 
			UPDATE NhanVien 
			set luong=luong*1.2,loaiNhanVien='Quan ly',isActive=1 
			WHERE maNhanVien=@maQL and (loaiNhanVien is null OR loaiNhanVien!='Quan ly');
		END
GO

--Cau2.1 b) Trigger for update
--	+ Nếu ban đầu chưa có quản lý:
		--	+ tự insert mã nhân viên quản lý vào bảng Quanli nếu chưa tồn tại.
		--  + trên bảng NhanVien, tự động tăng 20% lương cho nhân viên được bổ nhiệm làm quản lý & update @loaiNhanVien=’quan ly’.
		--	+ cập nhật isactive=1.
		--	+ Kiểm tra xem quản lý có đang làm quản lý cho chi nhánh nào k, nếu có thì set maquanly ở chi nhánh cũ =null,
		
	-- + Nếu có sự thay đổi quản lý:
		--	+ Kiểm tra xem quản lý mới có đang làm quản lý cho chi nhánh nào k, nếu có thì set maquanly ở chi nhánh cũ =null,
		--	+ Set isactive của quản lý cũ =0,
	-- + Cập nhật lại ngày bắt đầu làm quản lý
CREATE OR ALTER TRIGGER TG_updateChiNhanh ON ChiNhanh 
FOR Update
AS
	DECLARE @maQLnew  uniqueidentifier;
	DECLARE @maQLold  uniqueidentifier;
	DECLARE @maDonViold int
	DECLARE @maDonVinew int
	SELECT  @maQLnew=maNVQuanLy FROM inserted;
	SELECT  @maQLold=maNVQuanLy FROM deleted;
	SELECT	@maDonViold = maDonVi FROM deleted;
	SELECT	@maDonVinew = maDonVi FROM inserted;
	IF (@maQLold is null and @maQLnew is not null)
		BEGIN
			If(@maQLnew NOT IN (SELECT maNhanVien FROM QuanLi))
				Insert into QuanLi values(@maQLnew);
			IF (@maQLnew IN (SELECT maNhanVien FROM NhanVien))
			BEGIN 
				UPDATE NhanVien 
				set luong=luong*1.2,loaiNhanVien='Quan ly',isActive=1 
				WHERE maNhanVien=@maQLnew and (loaiNhanVien is null OR loaiNhanVien!='Quan ly');
			END
			IF(@maDonVinew != @maDonViold)
				Update ChiNhanh
				Set maNVQuanLy=null
				where maDonVi=@maDonViold
		END
	IF (@maQLold is not null and @maQLnew is not null)
		BEGIN 
			Update ChiNhanh
				Set maNVQuanLy=null
				where maDonVi=@maDonViold;
			UPDATE NhanVien 
			set isActive=0 
			WHERE maNhanVien=@maQLold;
		END
	Update ChiNhanh
	Set ngayQLyBatDauLamViec= GETDATE()
	Where maNVQuanLy=@maQLnew;
GO
--Cau2.1 c) Trigger for delete
--	Khi một chi nhánh  dừng hoạt động, thay vì xóa ta thêm trường isActive vào relation ChiNhanh, 
		--dùng trigger tự động set biến này bằng 0 khi ta xóa ChiNhanh. Biến này default sẽ là 1.
		-- Cập nhật lại trường isactive trong bảng nhân viên làm việc cho chi nhánh đó

Alter Table ChiNhanh
	Add isACtive bit default 1;
Go;
CREATE OR ALTER TRIGGER TG_deleteChiNhanh ON ChiNhanh
INSTEAD OF DELETE
AS
	DECLARE @idChiNhanh int;
	SELECT @idChiNhanh= maDonVi FROM deleted;
	UPDATE ChiNhanh SET isActive=0 WHERE maDonVi=@idChiNhanh
	Update NhanVien
	Set isActive=0
	Where maNhanVien IN (Select maNhanVien
						From NhanVienChiNhanh A,NhanVien B
						Where A.maNhanVien = B.maNhanVien
						);
GO
--Vào bảng NhanVienChiNhanh:
	--Khi insert, update,delete vào bảng Chi nhánh x:
		-- Cập nhật số nhân viên đang làm việc cho chi nhánh đó
-- create trigger for insert
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
Go;

-------------------Cau 3: Store Procedure
--3a1)Hiển thị danh sách shipper đang làm việc tại chi nhánh X (nhớ sửa cho lọc theo tên) sắp xếp  descending theo ngày vào làm 

CREATE OR ALTER PROCEDURE DanhsachShipperChiNhanhX
@maDonVi int
AS
	SELECT C.ho+' '+C.tenLot +' '+C.ten as HovaTen,C.loaiNhanVien , C.luong , C.ngayVaoLam
	FROM NhanVienChiNhanh A, Shipper B, NhanVien C
	WHERE A.maNhanVien=B.maNhanVien and B.maNhanVien=C.maNhanVien and A.maDonVi=@maDonVi and C.isActive=1
	ORDER by  C.ngayVaoLam DESC;
GO;
EXEC DanhsachShipperChiNhanhX 1;

--3a2)Procedure lấy danh sách chi nhánh thuộc quản lý có chỉ số uy tín trên X.xắp xếp giảm dần theo số lượng nhân viên

Go;
CREATE OR ALTER PROCEDURE DSChiNhanhQLUytinX
@csuytin decimal(2,1)
AS
	Select  A.maDonVi,A.tenChiNhanh,A.maSoThue,A.diaChi,A.soLuongNhanVien
	From ChiNhanh A,QuanLi B,NhanVien C
	Where A.maNVQuanLy=B.maNhanVien and B.maNhanVien=C.maNhanVien and C.chiSoUyTin>@csuytin
	order by A.soLuongNhanVien ASC;
GO;
EXEC DSChiNhanhQLUytinX 2.1;
GO;

--3b.1 Xuất ra danh sách shipper đang làm việc(isactive) có số lương cao nhất(max luong) của từng chi nhánh  tối thiểu X, group by (maDonVi), 
--orderby luong DESC
CREATE OR ALTER PROCEDURE ListShipperHaveMaxLuongPerChiNhanh
@mimimumluong int
AS
select K.maNhanVien,K.Hovaten,K.ngaySinh,K.ngayVaoLam,K.maDonVi,K.luong
from  (select e.maNhanVien, e.ho+' '+e.tenLot+' '+e.ten as Hovaten, e.luong, e.ngaySinh, e.ngayVaoLam, f.maDonVi
		from NhanVien e, NhanVienChiNhanh f
		where e.maNhanVien = f.maNhanVien and e.loaiNhanVien='Shipper' and e.isActive =1
		) K join (
						select B.maDonVi,max(luong) as maxluong
						from NhanVien A,NhanVienChiNhanh B
						where A.maNhanVien=B.maNhanVien and A.loaiNhanVien='Shipper'
						group by B.maDonVi
						having max(luong)>@mimimumluong
					) T on K.luong= maxluong
where K.maDonVi=T.maDonVi 
order by K.luong DESC

Go;
EXEC ListShipperHaveMaxLuongPerChiNhanh 5000000;
Go;
--3b.2 Thống kê số lượng Shipper đnag làm làm việc cho từng Chi Nhánh(Count) , chỉ giữ lại các chi nhánh có từ X shipper trở lên , group by maDonVi orderby desc.
CREATE OR ALTER PROCEDURE NumofShipperPerChiNhanh
@numShipper int
AS
SELECT maDonVi,COUNT(*) as SoluongShipper
FROM NhanVien E,NhanVienChiNhanh F
WHERE E.maNhanVien =F.maNhanVien and E.isActive=1 and E.loaiNhanVien='Shipper'
GROUP BY F.maDonVi
Having COUNT(*) >@numShipper
order by SoluongShipper DESC

Exec NumofShipperPerChiNhanh 0;
Go;

---------------------CAU 4--------------------------
--(1.5 điểm) Mỗi thành viên viết 2 hàm thỏa yêu cầu sau:
--- Chứa câu lệnh IF và/hoặc LOOP để tính toán dữ liệu được lưu trữ
--- Chứa câu lệnh truy vấn dữ liệu, lấy dữ liệu từ câu truy vấn để kiểm tra tính toán
--- Có tham số đầu vào và kiểm tra tham số đầu
--Mỗi thành viên viết 2 câu SELECT để minh họa việc gọi hàm trong câu SELECT

--Function 1:
--Do đại dịch Covid, doanh thu giảm,để giải quyết vấn đề  trên công ty quyết định cắt giảm doanh thu nhân viên trong 1 tháng, 
--mức lương quản lý giảm đi x%,mức lương mỗi nhân viên cắt giảm đi y% mức lương hiện tại. 
--Tính chênh lệch giữa tổng chi phí cắt giảm đi so với khi chưa cắt giảm trong 1 tháng.
GO;

CREATE OR ALTER FUNCTION CalulateDeltaLuongFlowsX_Y_Percent(@QL_decrease_Percent as int, @NV__decrease_Percent as int )
RETURNS @Result Table(
	Trangthai varchar(15),
	Response	nvarchar(255),
	TongchiphiTRUOCcatgiam float(3),
	TongchiphiSAUcatgiam float(3),
	Dental float(3),
	Donvi nvarchar(30)
)
AS
BEGIN
	Declare @sumbefore float(3);
	SET  @sumbefore=0;
	Declare @sumafter float(3);
	SET  @sumafter=0;
	Declare @status  varchar(15);
	Set @status ='';
	Declare @phanhoi nvarchar(255);
	Set @phanhoi ='';
	Declare @delta float(3);
	SET  @delta=0;
	Declare @donvi nvarchar(30);
	Set @donvi =N'Triệu đồng';

	If(@QL_decrease_Percent <0 or @QL_decrease_Percent >100 or @NV__decrease_Percent <0 or @NV__decrease_Percent>100)
		BEGIN
			Set @status ='ERROR';
			Set @phanhoi =N'Chỉ số cắt giảm phải là số nguyên từ 0-100';
		END
	ELSE
		BEGIN
			Set @status ='Success';
			Set @phanhoi =N'Kết quả của bạn là';


			--Cursor
				DECLARE NhanVienCursor CURSOR 
				FOR SELECT DISTINCT E.maNhanVien, E.luong,E.loaiNhanVien
					FROM NhanVien E,NhanVienChiNhanh F
					WHERE E.maNhanVien=F.maNhanVien and E.isActive=1;

				Declare @maNV uniqueidentifier
				Declare @luongNV decimal(18,0)
				Declare @loaiNV nvarchar(20)
				Declare @totalbefore bigint
				set @totalbefore =0
				Declare @totalafter bigint
				set @totalafter =0

				OPEN  NhanVienCursor
				FETCH NEXT FROM NhanVienCursor
				INTO @maNV,@luongNV,@loaiNV
				WHILE(@@FETCH_STATUS=0)
				BEGIN
					IF(@loaiNV ='Quan ly')
						BEGIN
							SET @totalbefore = @totalbefore + @luongNV;
							SET @totalafter = @totalafter + Cast((@luongNV*(100-@QL_decrease_Percent)/100) as bigint);
						END
					ELSE BEGIN
							SET @totalbefore = @totalbefore + @luongNV;
							SET @totalafter = @totalafter + Cast((@luongNV*(100-@NV__decrease_Percent)/100) as bigint);
						END
					FETCH NEXT FROM NhanVienCursor
					INTO @maNV,@luongNV,@loaiNV
				END;
				Set  @sumbefore =CAST(@totalbefore as float(3))/ CAST(1000000 AS float(1));
				Set @sumbefore = ROUND(@sumbefore,3);
				Set @sumafter = CAST(@totalafter as float(3))/ CAST(1000000 AS float(3));
				Set @sumafter = ROUND(@sumafter,3);
				Set @delta =CAST((@sumbefore -@sumafter) as float(3));
				Set @delta = ROUND(@delta,3);
				CLOSE NhanVienCursor;
				DEALLOCATE NhanVienCursor;
			--end cursor
		END;
	Insert into @Result values(@status,@phanhoi,@sumbefore,@sumafter,@delta,@donvi);
	RETURN;
END
GO;
--use Shipper
select * from CalulateDeltaLuongFlowsX_Y_Percent(20,30);
Go;
SELECT Sum(E.luong) as TongTien
					FROM NhanVien E,NhanVienChiNhanh F
					WHERE E.maNhanVien=F.maNhanVien and E.isActive=1;

--Function 2:
--Lương thưởng tháng 13 của nhân viên được tính sau: quản lý thưởng X tr, tổng đài viên thưởng Y tr, shipper thưởng Z tr. 
--Tính tổng số tiền cần chi để thưởng cho nhân viên cho toàn bộ công ty.
GO;
CREATE OR ALTER FUNCTION CalulateTotalLuongMonth13(@QL_bonus as float(1),@TDV_bonus as float(1), @SHP__bonus as float(1))
RETURNS @Result Table(
	Trangthai varchar(15),
	Response	nvarchar(255),
	Luongthang13ForQuanly float(3),
	Luongthang13ForTongdaivien float(3),
	Luongthang13ForShipper float(3),
	TongTien float(3),
	Donvi nvarchar(30)
)
AS
BEGIN
	Declare @sumQL float(3);
	SET  @sumQL=0;
	Declare @sumTDV float(3);
	SET  @sumTDV=0;
	Declare @sumSHP float(3);
	SET  @sumSHP=0;
	Declare @status  varchar(15);
	Set @status ='';
	Declare @phanhoi nvarchar(255);
	Set @phanhoi ='';
	Declare @Tongtien float(3);
	SET  @Tongtien=0;
	Declare @donvi nvarchar(30);
	Set @donvi =N'Triệu đồng';

	If(@QL_bonus <0 or @TDV_bonus <0 or @SHP__bonus<0)
		BEGIN
			Set @status ='ERROR';
			Set @phanhoi =N'Tiền thưởng phải là số dương';
		END
	ELSE
		BEGIN
			Set @status ='Success';
			Set @phanhoi =N'Số tiền cần chi của bạn là';


			--Cursor
				DECLARE NhanVienCursor CURSOR 
				FOR SELECT DISTINCT E.maNhanVien,E.loaiNhanVien
					FROM NhanVien E,NhanVienChiNhanh F
					WHERE E.maNhanVien=F.maNhanVien and E.isActive=1;

				Declare @maNV uniqueidentifier
				Declare @loaiNV nvarchar(20)
				Declare @totalbonusForQL bigint
				set @totalbonusForQL =0
				Declare @totalbonusForTDV bigint
				set @totalbonusForTDV =0
				Declare @totalbonusForSHP bigint
				set @totalbonusForSHP =0
				OPEN  NhanVienCursor
				FETCH NEXT FROM NhanVienCursor
				INTO @maNV,@loaiNV
				WHILE(@@FETCH_STATUS=0)
				BEGIN
					IF(@loaiNV = 'Quan ly')
						BEGIN
							set @totalbonusForQL = @totalbonusForQL + Cast((@QL_bonus*1000000) as bigint); 
						END
					IF(@loaiNV ='Tong dai vien')
						BEGIN
							set @totalbonusForTDV = @totalbonusForTDV + Cast((@TDV_bonus*1000000) as bigint); 
						END
					IF(@loaiNV = 'Shipper')
						BEGIN
							set @totalbonusForSHP = @totalbonusForSHP + Cast((@SHP__bonus*1000000) as bigint); 
						END
					FETCH NEXT FROM NhanVienCursor
					INTO @maNV,@loaiNV
				END;
				Set  @sumQL =CAST(@totalbonusForQL as float(3))/ CAST(1000000 AS float(3));
				Set @sumQL = ROUND(@sumQL,3);
				Set @sumTDV = CAST(@totalbonusForTDV as float(3))/ CAST(1000000 AS float(3));
				Set @sumTDV = ROUND(@sumTDV,3);
				Set @sumSHP = CAST(@totalbonusForSHP as float(3))/ CAST(1000000 AS float(3));
				Set @sumSHP = ROUND(@sumSHP,3);
				Set @Tongtien =CAST((@sumQL+@sumTDV + @sumSHP) as float(3));
				Set @Tongtien = ROUND(@Tongtien,3);
				CLOSE NhanVienCursor;
				DEALLOCATE NhanVienCursor;
			--end cursor
		END;
	Insert into @Result values(@status,@phanhoi,@sumQL,@sumTDV,@sumSHP,@Tongtien,@donvi);
	RETURN;
END
GO;
Select * FROM CalulateTotalLuongMonth13(5,4.5,4);
