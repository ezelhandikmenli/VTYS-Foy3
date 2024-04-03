--1.Soru Veritabanýn oluþturulmasý 
CREATE DATABASE foy3 ON PRIMARY
(
NAME= vtys_data,
FILENAME = 'D:\vtyslab\foy3data.mdf',
SIZE = 8MB,
MAXSIZE = unlimited,
FILEGROWTH = 10%
)
LOG ON
(
NAME= vtys_log,
FILENAME = 'D:\vtyslab\foy3log.ldf',
SIZE = 8MB,
MAXSIZE = unlimited,
FILEGROWTH = 10%
)

CREATE TABLE birimler
(birim_id INT PRIMARY KEY NOT NULL,
   birim_ad char(25) NOT NULL
)
CREATE TABLE calisanlar
(calisan_id INT PRIMARY KEY NOT NULL,
   ad char(25)  NULL,
   soyad char(25)  NULL,
   maas INT NULL,
   katilmaTarihi DateTime  NULL,
   calisan_birim_id INT NOT NULL
)
CREATE TABLE ikramiye
(ikramiye_calisan_id INT  NOT NULL,
   ikramiye_ucret INT Null,
   ikramiye_tarih DateTime  NULL,
)
CREATE TABLE unvan
(unvan_calisan_id INT  NOT NULL,
   unvan_calisan char(25) Null,
   unvan_tarih DateTime  NULL,
)

--2.Soru
Insert into birimler (birim_ad) VALUES ('Yazýlým')
Insert into birimler (birim_ad) VALUES ('Donaným')
Insert into birimler (birim_ad) VALUES ('Güvenlik')

--Çalýþanlar tablosu kodlarla veri ekleme
INSERT INTO calisanlar (ad, soyad, maas, katilmaTarihi, calisan_birim_id) VALUES ('Ýsmail','Ýþeri','100000','02.20.2014','1')
INSERT INTO calisanlar (ad, soyad, maas, katilmaTarihi, calisan_birim_id) VALUES ('Hami','Satýlmýþ','80000','06.11.2014','1')
INSERT INTO calisanlar (ad, soyad, maas, katilmaTarihi, calisan_birim_id) VALUES ('Durmuþ','Þahin','300000','02.20.2014','2')
INSERT INTO calisanlar (ad, soyad, maas, katilmaTarihi, calisan_birim_id) VALUES ('Kaðan','Yazar','500000','02.20.2014','3')
INSERT INTO calisanlar (ad, soyad, maas, katilmaTarihi, calisan_birim_id) VALUES ('Meryem','Soysaldý','500000','06.11.2014','3')
INSERT INTO calisanlar (ad, soyad, maas, katilmaTarihi, calisan_birim_id) VALUES ('Duygu','Akþehir','200000','06.11.2014','2')
INSERT INTO calisanlar (ad, soyad, maas, katilmaTarihi, calisan_birim_id) VALUES ('Kübra','Seyhan','75000','01.20.2014','1')
INSERT INTO calisanlar (ad, soyad, maas, katilmaTarihi, calisan_birim_id) VALUES ('Gülcan','Yýldýz','90000','11.04.2014','3')

--Ýkramiye tablosuna insert komutuyla veri ekleme
INSERT INTO ikramiye (ikramiye_calisan_id, ikramiye_ucret, ikramiye_tarih) VALUES ('2','5000','02.20.2014')
INSERT INTO ikramiye (ikramiye_calisan_id, ikramiye_ucret, ikramiye_tarih) VALUES ('3','3000','06.11.2014')
INSERT INTO ikramiye (ikramiye_calisan_id, ikramiye_ucret, ikramiye_tarih) VALUES ('10','4000','02.20.2014')
INSERT INTO ikramiye (ikramiye_calisan_id, ikramiye_ucret, ikramiye_tarih) VALUES ('2','4500','02.20.2014')
INSERT INTO ikramiye (ikramiye_calisan_id, ikramiye_ucret, ikramiye_tarih) VALUES ('3','3500','06.11.2014')

--Unvan tablosuna insert komutuyla veri ekleme
INSERT INTO unvan (unvan_calisan_id, unvan_calisan, unvan_tarih) VALUES ('2','Yonetici','02.20.2016')
INSERT INTO unvan (unvan_calisan_id, unvan_calisan, unvan_tarih) VALUES ('3','Personel','06.11.2016')
INSERT INTO unvan (unvan_calisan_id, unvan_calisan, unvan_tarih) VALUES ('14','Personel','06.11.2016')
INSERT INTO unvan (unvan_calisan_id, unvan_calisan, unvan_tarih) VALUES ('6','Müdür','06.11.2016')
INSERT INTO unvan (unvan_calisan_id, unvan_calisan, unvan_tarih) VALUES ('11','Yonetici Yardýmcýsý','06.11.2016')
INSERT INTO unvan (unvan_calisan_id, unvan_calisan, unvan_tarih) VALUES ('13','Personel','06.11.2016')
INSERT INTO unvan (unvan_calisan_id, unvan_calisan, unvan_tarih) VALUES ('7','Takým Lideri','06.11.2016')
INSERT INTO unvan (unvan_calisan_id, unvan_calisan, unvan_tarih) VALUES ('10','Takým Lideri','06.11.2016')

--3. soru
SELECT p.ad, p.soyad, p.maas FROM calisanlar p INNER JOIN birimler b ON p.calisan_birim_id = b.birim_id WHERE b.birim_ad = 'Yazýlým' OR b.birim_ad = 'Donaným';

--4.soru
SELECT ad, soyad, maas FROM Calisanlar WHERE maas = (SELECT MAX(maas) FROM Calisanlar);


--5.Soru
SELECT b.birim_ad, COUNT(*) AS calisan_sayisi FROM birimler b INNER JOIN calisanlar c ON b.birim_id = c.calisan_birim_id GROUP BY b.birim_ad;

--6.soru
SELECT unvan_calisan, COUNT(*) AS calisan_sayisi FROM unvan GROUP BY unvan_calisan HAVING COUNT(*) > 1;

--7.soru
SELECT ad, soyad, maas FROM calisanlar WHERE maas BETWEEN 50000 AND 100000;


--8.soru
SELECT c.ad, c.soyad, b.birim_ad, u.unvan_calisan, i.ikramiye_ucret
FROM Calisanlar c
INNER JOIN birimler b ON c.calisan_birim_id = b.birim_id
INNER JOIN unvan u ON c.calisan_id = u.unvan_calisan_id
INNER JOIN ikramiye i ON c.calisan_id = i.ikramiye_calisan_id;

--9.Soru
SELECT c.ad, c.soyad, u.unvan_calisan FROM calisanlar c INNER JOIN unvan u ON c.calisan_id = u.unvan_calisan_id WHERE u.unvan_calisan IN ('Yonetici', 'Müdür');

--10.Soru
SELECT ad, soyad, maas
FROM (
    SELECT c.ad, c.soyad, c.maas, b.birim_ad,
           ROW_NUMBER() OVER (PARTITION BY b.birim_id ORDER BY c.maas DESC) AS siralama
    FROM Calisanlar c
    INNER JOIN birimler b ON c.calisan_birim_id = b.birim_id
) as alt_sorgu
WHERE siralama = 1;


