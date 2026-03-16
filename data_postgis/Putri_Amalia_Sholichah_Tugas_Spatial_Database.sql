-- Buat tabel admin_keluarahan
CREATE TABLE "Tugas_Akhir".norm_admin_kelurahan (
    id_kelurahan SERIAL PRIMARY KEY,
    nama_kelurahan TEXT,
    nama_kecamatan TEXT,
    geom GEOMETRY(POLYGON,4326)
);

-- Buat tabel  kategori usaha
CREATE TABLE "Tugas_Akhir".norm_kategori_fnb (
    id_kategori SERIAL PRIMARY KEY,
	nama_kategori VARCHAR (50),
	sumber_tag VARCHAR (20)
);

-- Tabel tipe cuisine
CREATE TABLE "Tugas_Akhir".norm_tipe_cuisine (
    id_cuisine SERIAL PRIMARY KEY,
	nama_cuisine VARCHAR (100)
);

-- Tabel lokasi usaha (tabel utama)
CREATE TABLE "Tugas_Akhir".norm_lokasi_fnb (
 	id_fnb SERIAL PRIMARY KEY,
    nama VARCHAR(200),
    telepon VARCHAR(50),
    alamat TEXT,
    id_kelurahan INTEGER,
    id_kategori INTEGER,
    geom GEOMETRY(POINT,4326),
	-- untuk memastikan kesamaan referensi id 2 tabel
    CONSTRAINT fk_kelurahan
        FOREIGN KEY (id_kelurahan)
        REFERENCES "Tugas_Akhir".norm_admin_kelurahan(id_kelurahan),

    CONSTRAINT fk_category
        FOREIGN KEY (id_kategori)
        REFERENCES "Tugas_Akhir".norm_kategori_fnb(id_kategori)
);	
SELECT * FROM "Tugas_Akhir".norm_lokasi_fnb
-- Tabel relasi cuisine
CREATE TABLE "Tugas_Akhir".norm_fnb_cuisine (
    id_fnb INTEGER,
    id_cuisine INTEGER,

    CONSTRAINT fk_fnb
        FOREIGN KEY (id_fnb)
        REFERENCES "Tugas_Akhir".norm_lokasi_fnb(id_fnb),

    CONSTRAINT fk_cuisine
        FOREIGN KEY (id_cuisine)
        REFERENCES "Tugas_Akhir".norm_tipe_cuisine(id_cuisine)
);

--LAKUKAN POPULASI
--1.Populasi kelurahan
INSERT INTO "Tugas_Akhir".norm_admin_kelurahan (nama_kelurahan,nama_kecamatan,geom)
SELECT 
name_4,
name_3,
geom
FROM "Tugas_Akhir"."Balikpapan"

SELECT * FROM "Tugas_Akhir".norm_admin_kelurahan

--2.Populasi kategori
INSERT INTO "Tugas_Akhir".norm_kategori_fnb (nama_kategori, sumber_tag)

SELECT DISTINCT amenity AS nama_kategori,
       'amenity' AS sumber_tag
FROM "Tugas_Akhir"."UsahaFnB_Balikpapan"
WHERE amenity IS NOT NULL

UNION --untuk gabungkan 2 kolom yg berbeda dr sumber data asal

SELECT DISTINCT shop AS nama_kategori,
       'shop' AS sumber_tag
FROM "Tugas_Akhir"."UsahaFnB_Balikpapan"
WHERE shop IS NOT NULL;

SELECT * FROM "Tugas_Akhir".norm_kategori_fnb

--3.Populasi lokasi usaha
INSERT INTO "Tugas_Akhir".norm_lokasi_fnb
(nama, telepon, alamat, id_kelurahan, id_kategori, geom) --harusnya ada id_cuisine

SELECT
u.name,
u.phone,
COALESCE(u."addr:full", u."addr:street") AS alamat,
k.id_kelurahan,
c.id_kategori,
u.geom

FROM "Tugas_Akhir"."UsahaFnB_Balikpapan" u

LEFT JOIN "Tugas_Akhir".norm_admin_kelurahan k
ON ST_Within(u.geom, k.geom) --ST_Within untuk liat geometry 
							-- yg beneran tumpang tindih

LEFT JOIN "Tugas_Akhir".norm_kategori_fnb c
ON COALESCE (u.amenity, u.shop) = c.nama_kategori; 
--COALESCE = mengambil nilai pertama yang tidak NULL dari beberapa kolom atau ekspresi.

SELECT * FROM "Tugas_Akhir".norm_lokasi_fnb

--4.Populasi tabel tipe cuisine
--pecah cuisine >1 di tiap baris dengan pisahkan berdasarkan ";"
INSERT INTO "Tugas_Akhir".norm_tipe_cuisine(nama_cuisine)
SELECT DISTINCT trim(value)
FROM "Tugas_Akhir"."UsahaFnB_Balikpapan",
LATERAL unnest(string_to_array(cuisine,';')) AS value
WHERE cuisine IS NOT NULL;

UPDATE "Tugas_Akhir".norm_tipe_cuisine
SET nama_cuisine = LOWER(nama_cuisine);
SELECT * FROM "Tugas_Akhir".norm_tipe_cuisine

--5.Populasi tabel fnb cuisine
--ambil dulu cuisine untuk setiap cafe & jdkan temporary tabel
CREATE TEMP TABLE cuisine_split AS

SELECT
name,
TRIM(unnest(string_to_array(cuisine,';'))) AS nama_cuisine
FROM "Tugas_Akhir"."UsahaFnB_Balikpapan"
WHERE cuisine IS NOT NULL;

--masukkan ke tabel norm_fnb_cuisine
INSERT INTO "Tugas_Akhir".norm_fnb_cuisine (id_fnb, id_cuisine)
SELECT
f.id_fnb,
c.id_cuisine
FROM cuisine_split s
JOIN "Tugas_Akhir".norm_lokasi_fnb f
ON f.nama = s.name
JOIN "Tugas_Akhir".norm_tipe_cuisine c
ON c.nama_cuisine = s.nama_cuisine;

Select * FROM "Tugas_Akhir".norm_fnb_cuisine

--SPATIAL INDEXING GIST
--Spatial indexing untuk lokasi fnb
CREATE INDEX idx_lokasi_fnb_geom
ON "Tugas_Akhir".norm_lokasi_fnb
USING GIST (geom);

--Spatial indexing untuk polygon admin_kelurahan
CREATE INDEX idx_lokasi_kelurahan_geom
ON "Tugas_Akhir".norm_admin_kelurahan
USING GIST (geom);

SELECT *
FROM pg_indexes
WHERE schemaname = 'Tugas_Akhir';

--Trial query setelag dibuat indexing
SELECT *
FROM "Tugas_Akhir".norm_lokasi_fnb f
JOIN "Tugas_Akhir".norm_admin_kelurahan k
ON ST_Within(f.geom, k.geom);