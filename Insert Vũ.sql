
INSERT INTO DonVanChuyen(diaChiGiaoHang, thoiGianGiaoHang,thoiGianNhan, trangThaiDonHang,tienShip,
phuongThucThanhToan,maKhachHang) VALUES
(N'Ninh Hòa','2021-11-20 15:46:11','2021-11-20 16:05:12', 1, 9100,2,'E59CCDD7-7ACD-47FC-8740-9E4E8709EFCC'),
(N'Ninh Hòa','2021-11-28 10:27:36',NULL, 5, 42000,3,'E59CCDD7-7ACD-47FC-8740-9E4E8709EFCC'),
(N'Đại Lãnh','2021-01-16 13:22:50',NULL, 3, 13000,2,'7736DC86-CD02-4F6C-8FEC-A7133C118075'),
(N'Đại Lãnh','2021-04-15 8:17:58','2021-04-15 8:33:12', 1, 21000,4,'7736DC86-CD02-4F6C-8FEC-A7133C118075'),
(N'Tuy Hòa','2021-12-01 06:39:18',NULL, 4,34000,4,'E2E11940-28CD-48E5-ADD9-B588A5BBC6E2'),
(N'Tuy Hòa','2021-05-28 05:07:23','2021-05-28 05:30:23', 1,17500,3,'E2E11940-28CD-48E5-ADD9-B588A5BBC6E2'),
(N'Vũng Rô','2021-04-19 17:31:09','2021-04-19 18:30:22', 1, 12000,1,'6C8DC47B-83BD-4E07-BCBD-CBA37F03AF5E'),
(N'Vũng Rô','2021-09-11',NULL, 3, 18000,1,'6C8DC47B-83BD-4E07-BCBD-CBA37F03AF5E'),
(N'Đông Hòa','2021-11-29 8:07:31',NULL, 4, 23000,3,'DA586943-8AE6-4FD8-9CBE-EB2D06EA83F3'),
(N'Đông Hòa','2021-06-10 17:07:31','2021-06-19 14:032:15', 1, 47000,4,'DA586943-8AE6-4FD8-9CBE-EB2D06EA83F3'),
(N'Quận Bình Tân','2021-11-05 06:11:35','2021-11-18 09:05:44', 1, 16000,2,'BFF13AD4-7F4B-42E6-9D0B-EBAAACE6FDB1'),
(N'Quận Bình Tân','2021-11-26 14:23:55',NULL, 5, 35000,1,'BFF13AD4-7F4B-42E6-9D0B-EBAAACE6FDB1'),

  GO
INSERT INTO MaKhuyenMai(discount,dieuKienApDung,ngayHetHan,moTa,maKhachHangSoHuu) VALUES
(0.5,N'Cho khách hàng là nữ','2021-11-26','Chúc các chị em phụ nữ một ngày thật hạnh phúc !', '1B313134-292A-40BA-9A1E-2A6F12A3BFD8'),
(0.5,N'Cho khách hàng là nữ','2021-11-26','Chúc các chị em phụ nữ một ngày thật hạnh phúc !', 'EFE678D1-6E3F-4C52-9901-2AEF0278A75B'),
(0.5,N'Cho khách hàng là nữ','2021-11-26','Chúc các chị em phụ nữ một ngày thật hạnh phúc !', 'E6F01568-46C5-4434-9F63-6ECB195FF581'),
(0.333,N'Cho các bạn giới tính thứ 3','2021-12-02','Ngày lễ không phân biệt giới tính.', 'BFF13AD4-7F4B-42E6-9D0B-EBAAACE6FDB1'),
(0.333,N'Cho các bạn giới tính thứ 3','2021-12-02','Ngày lễ không phân biệt giới tính.', '6C8DC47B-83BD-4E07-BCBD-CBA37F03AF5E'),
(0.25,N'Cho các bạn độc thân','2021-12-14','FA vui FA khỏe :v', 'E2E11940-28CD-48E5-ADD9-B588A5BBC6E2'),
(0.25,N'Cho các bạn độc thân','2021-12-14','FA vui FA khỏe :v', 'E59CCDD7-7ACD-47FC-8740-9E4E8709EFCC'),
(0.67,N'Thanh toán bằng momo','2021-12-30','Ưu đãi khi thanh toán bằng Momo', '552D5FC2-9907-4F7E-9173-9B4E2D21B6AB'),
(0.67,N'Thanh toán bằng momo','2021-12-30','Ưu đãi khi thanh toán bằng Momo', '7736DC86-CD02-4F6C-8FEC-A7133C118075'),
(0.67,N'Thanh toán bằng momo','2021-12-30','Ưu đãi khi thanh toán bằng Momo', '6C8DC47B-83BD-4E07-BCBD-CBA37F03AF5E'),
(0.67,N'Thanh toán bằng momo','2021-12-30','Ưu đãi khi thanh toán bằng Momo', 'E59CCDD7-7ACD-47FC-8740-9E4E8709EFCC'),
(0.33,N'Khách hàng đặt 2 đơn trở lên','2021-11-26','Mua sắm thả ga không lo hết xiền', 'EFE678D1-6E3F-4C52-9901-2AEF0278A75B'),
(0.33,N'Khách hàng đặt 2 đơn trở lên','2021-11-26','Mua sắm thả ga không lo hết xiền', '7736DC86-CD02-4F6C-8FEC-A7133C118075'),
(0.33,N'Khách hàng đặt 2 đơn trở lên','2021-11-26','Mua sắm thả ga không lo hết xiền', 'E2E11940-28CD-48E5-ADD9-B588A5BBC6E2')

GO
CREATE OR ALTER PROCEDURE taoDonMonAn
AS
	DECLARE @count int
	SET @count=4;
	WHILE(@count<15)
	BEGIN
		INSERT INTO DonMonAn(maDon) VALUES (@count);
		SET @count=@count+1
	END
GO
EXEC taoDonMonAn

GO
INSERT INTO DonGiaoHangGiup(maDon,tenNguoiNhan,soDienThoaiNguoiNhan,diaChiNhan,chiTietChoGiao,dichVuDonHang
,tongKhoiLuong) VALUES
(1,N'Quốc Khánh','0967231231',N'12 đường Nguyễn Trãi Quận 10 TPHCM',N'Đối diện quán cơm bà Tân',N'Dễ vỡ',15),
(2,N'Văn Hùng','03238473831',N'21 đường Quân Sư Quận 8 TPHCM',N'Nhà sát hẻm',N'Bình thường',8),
(3,N'Thu Thơ','0317978891',N'104 đường Thi Sách Nha Trang',N'Gần sân thi đấu',N'Dễ vỡ',11),
(15,N'Xuân Tín','0387991372',N'95 đường Phú Quốc Ninh Hòa',N'Sát bên cây xăng',N'Bình thường',28),
(16,N'Hoàn Duyên','0129387482',N'35 đường Ngô Bá Quát Tuy Hòa',N'Gần đường sắt xe lửa',N'Dễ vỡ',5),
(17,N'Thu Trang','0967232331',N'22 đường Trần Quốc Sư Đông Hòa',N'Gần Thế giới di động',N'Vip',4),
(18,N'Kim Liên','0967683931',N'15 Bà Triệu Vạn Ninh',N'Đối diện quán trà sữa Rex Fox','Bình thường',6)

GO
INSERT INTO DonKhuyenMai(maKhuyenMai,maDon) VALUES
(1,2),(2,3),(12,4),(7,7),(11,8),(9,9),(5,14),(10,14),(6,12),(14,12)

ALTER TABLE MaKhuyenMai
ADD daDungChua BIT DEFAULT 0

UPDATE MaKhuyenMai SET daDungChua=0
WHERE maKhuyenMai not in (1,2,12,7,11,9,5,10,6,14)


GO
INSERT INTO TrangThaiDon(trangThai) VALUES (N'Đã giao'),(N'Đã hủy'),(N'Giao không thành công'),(N'Đang giao')
,(N'Đang ở kho')
INSERT INTO PhuongThucThanhToan(trangThai) VALUES (N'Momo'),(N'Tiền mặt'),(N'Tín dụng ngân hàng'),(N'AirPay')

