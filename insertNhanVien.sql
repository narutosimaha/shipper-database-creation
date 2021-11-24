use Shipper
go

INSERT INTO NhanVien(ho,tenLot,ten,ngayVaoLam,luong,taiKhoan,matKhau,loaiNhanVien,chiSoUyTin) 
VALUES ( 'Tran','Luong','Vu','2015-10-30',5300000,'tranvu123','123456789','Quan ly', 4.3), 
( 'Luu','Cong','Dinh','2016-07-12',6800000,'congdinh123','123456789','Shipper', 4.5),
( 'Nguyen','Le','Hien','2010-08-20',7200000,'lehien123','123456789','Tong dai vien', 4.0),
( 'Nguyen','Van','Thuong','2015-01-15',6300000,'vanthuong123','123456789','Quan ly', 4.6),
( 'Nguyen','Quoc','Thai','2018-12-17',5800000,'quocthai123','123456789','Shipper', 4.3),
( 'Vo','Huu','Luan','2013-09-10',8200000,'huuluan123','123456789','Tong dai vien', 4.7),
( 'Nguyen','Cong','Tri','2015-05-31',3900000,'congtri123','123456789','Shipper', 3.5),
( 'Nguyen','Anh','Van','2009-05-11',4700000,'anhvan123','123456789','Shipper',3.8),
( 'Vo','Hai','Nhat','2017-09-12',3500000,'hainhat123','123456789','Shipper', 4.3),
( 'Nguyen','Tran Hai','Cong','2015-02-19',5600000,'haicong123','123456789','Quan ly', 3.9),
( 'Nguyen','Le','Khang','2017-12-21',4630000,'lekhang123','123456789','Quan ly', 4.2),
( 'Tran','Le','Minh','2016-11-23',7720000,'leminh123','123456789','Quan ly', 4.8),
( 'Dinh','Vinh','Phuoc','2016-08-09',5700000,'vinhphuoc123','123456789','Quan ly', 4.3),
( 'Tran','Huu','Huan','2014-07-12',6300000,'huuhuan123','123456789','Tong dai vien', 4.1),
( 'Le','Tan','Truong','2018-03-15',9100000,'tantruong123','123456789','Tong dai vien', 4.5),
( 'Cao','Thanh','Bang','2017-12-11',5900000,'thanhbang123','123456789','Tong dai vien', 4.7),
( 'Nguyen','Van Tan','Loc','2016-05-17',6200000,'tanloc123','123456789','Tong dai vien', 4.4)

INSERT INTO KhachHang(CCCDorVisa,ho,tenLot,Ten,ngaySinh,gioiTinh,taiKhoan,matKhau,
diaChi,ngayThamGia,loaiKhachHang) 
VALUES (12344321,'Luong','Thi','Xuong','2001-07-11','Nu','xuongthi123','123456789'
,'Phu Yen','2013-05-14','Ca nhan'), 
(23455432,'Hua','Kim','Tuyen','1998-02-13','Nu','kimtuyen123','123456789'
,'TPHCM','2015-11-03','Ca nhan'), 
(34566543,'Tran','','Nam','2002-10-21','Nam','namTran123','123456789'
,'Khanh Hoa','2014-05-28','Tu nhan'), 
(45677654,'Luong','Minh','Anh','1999-06-12','Nu','minhAnh123','123456789'
,'Phu Yen','2016-10-07','Ca nhan'), 
(56788765,'Nguyen','Thanh','Dat','2001-01-29','Nam','datthanh123','123456789'
,'Phu Yen','2009-12-09','Doanh nghiep'), 
(67899876,'Cao','Luong Xuan','Hai','1998-06-09','Nam','caohai123','123456789'
,'Khanh Hoa','2011-06-18','Ca nhan'), 
(78900987,'Tran','Kim','Chi','1998-08-18','Nu','chitran123','123456789'
,'Khanh Hoa','2017-04-19','Tu nhan'), 
(89011098,'Tran','Van','Kim','1977-11-23','Nam','trankim123','123456789'
,'Khanh Hoa','2011-07-18','Ca nhan'), 
(90122109,'Nguyen','Kim','Anh','1989-08-28','Nu','kimanh123','123456789'
,'TPHCM','2016-03-14','Ca nhan'), 
(01233210,'Vo','Kim','Bang','1999-03-16','Nam','kimbang123','123456789'
,'TPHCM','2011-02-07','Ca nhan')



INSERT INTO PhuongTien(bienKiemSoat,loaiPhuongTien) VALUES 
('12344321','Xe may'),
('23455432','Xe may'),
('34566543','Xe may'),
('45677654','Xe may'),
('56788765','Xe may'),
('67899876','Xe may'),
('78900987','Xe tai'),
('89011098','Xe ban tai'),
('90122109','Xe ban tai'),
('01233210','Xe tai')


INSERT INTO NhaHang(tenNhaHang,diaChi,maSoGPKD,taikhoan,matkhau,hoChuNhaHang,tenLotChuNhaHang,
tenChuNhaHang,trangThaiNhaHang,rating) VALUES 
('Vinh Phuc','TPHCM','12344321','vinhphuc321','123456789','Tran','Vinh','Phuc',1,4.7),
('Thien Ha','TPHCM','23455432','thienha321','123456789','Vu','Kim','Ha',1,4.3),
('Bay Linh','Khanh Hoa','34566543','baylinh321','123456789','Nguyen','Minh','Hoang',1,4.5),
('Tu Le','Khanh Hoa','45677654','tule321','123456789','Vo','Trung','Hieu',1,3.9),
('Son Nam','Khanh Hoa','56788765','namson321','123456789','Nguyen','Thai','Son',1,4.3),
('Hau Phuoc','Phu Yen','67899876','hauphuoc321','123456789','Bui','Hau','Phuoc',1,4.1),
('Van Xuan','TPHCM','78900987','vanxuan321','123456789','Trong','Xuan','Van',1,4.6),
('Anh Sao','Phu Yen','89011098','saoanh321','123456789','Tran','Cao','Anh',0,3.4),
('Phan Tien','Phu Yen','90122109','phantien321','123456789','Phan','Thanh','Tien',1,4.8),
('The Han','TPHCM','01233210','thehan321','123456789','Nguyen','The','Han',1,4.5)

INSERT INTO MonAn(tenMonAn,donGia,moTa,maNhaHangOffer)
VALUES (N'Phở bò',32000,N'Có bao gồm tái, nạm, gân va sụn',1),
(N'Cơm đùi gà',30000,N'Bao gồm đùi gà luộc và một chén canh',1),
(N'Mì xào thịt bò',35000,N'Mì hàn quốc và thịt tẩm mắm ớt',1),
(N'Cơm chân trâu',25000,N'Nhiều loại rau củ quả, thêm xúc xích và lạp xưởng',6),
(N'Cơm cá chiên',30000,N'Cá hồng chiên giòn, tẩm gia vị đặc biệt',6),
(N'Bún thịt nướng',25000,N'Đặc sản phú yên',6),
(N'Gà quay',70000,N'Phần nữa con',5),
(N'Lòng heo nướng',30000,'',5),
(N'Phần cơm thêm',5000,'',5),
(N'Cút nướng',25000,'',5),
(N'Cơm sườn',35000,N'Cơm sườn phủ thêm nước tương cực mlem',2),
(N'Cơm ba rọi',25000,N'Thịt ba rọi cắt lát nướng',2),
(N'Bún riêu cua',25000,'',3),
(N'Bún cá Nha Trang',25000,N'Đặc sản Nha Trang',3),
(N'Bánh xèo',30000,N'Gồm 3 cái, có tôm thịt trộn thập cẩm',3),
(N'Lẩu chay',70000,N'Phân 3 người, kèm nước chao',4),
(N'Lẩu kim chi',30000,N'Phần một người, bao gồm các loại nấm,xúc xích và kim chi',4),
(N'Mì Quảng Sài Gòn',33000,'',9),
(N'Lẩu mực',35000,N'Mực tươi rất ngon',10),
(N'Gà xào xả ớt',29000,'',7)

INSERT INTO UuDai(maNhaHang,maMonAn,tenUuDai,discount,moTa,ngayHetHan)
VALUES
(1,1,N'Giỗ tổ Hùng Vương',0.3,'','2021-12-15'),
(1,2,N'Giảm giá cho các bạn tên Hùng',0.5,'','2021-12-07'),
(6,4,N'Nhân dịp Nô-en',0.25,'','2021-12-24'),
(6,6,N'Ngày sinh chủ nhà hàng',0.3,'','2021-12-01'),
(5,8,N'Love day',0.333,N'Giảm giá cho cặp đôi','2021-11-15'),
(5,9,N'Best Short',0.7,N'Giảm giá cho các bạn thấp hơn 1m55','2022-01-23'),
(2,11,N'Only English',0.5,N'Giảm giá cho các bạn Ielts 7.0','2021-12-22'),
(3,14,N'No Iphone',0.2,N'Bất cứ ai không có iphone đều được giảm ','2021-11-26'),
(4,16,N'Guitar Knowledge',0.65,N'Giảm giá cực lớn cho các bạn buổi diễn guitar tại quán','2021-12-30'),
(9,18,N'Impairment Pleasure',1.00,N'Giảm 100% cho người khuyết tật','2022-01-30'),
(10,19,N'God Bless',0.5,N'Guamr nữa giá cho người theo đạo thiên chúa','2021-12-26'),
(7,20,N'Happy Mother',0.35,N'Giảm giá cho các chị em nội trợ','2021-12-15')


INSERT INTO SDTNhaHang(maNhaHang,soDienThoai)
VALUES
(1,'01234567891'),
(2,'02345678912'),
(3,'03456789123'),
(4,'04567891234'),
(5,'05678912345'),
(6,'06789123456'),
(7,'07891234567'),
(8,'08912345678'),
(9,'09123456789'),
(10,'01122334455'),
(3,'02233445568'),
(1,'09323456789'),
(6,'01122381455')



