CREATE TABLE penjualan_ds (
    id_invoice VARCHAR(10),
    tanggal DATE,
    id_customer VARCHAR(10),
    id_barang VARCHAR(10),
    jumlah_barang INTEGER,
    unit VARCHAR(10),
    harga INTEGER,
    mata_uang VARCHAR(5)
);

CREATE TABLE barang_ds (
    kode_barang VARCHAR(10),
    nama_barang VARCHAR(100),
    kemasan VARCHAR(50),
    harga INTEGER,
    nama_tipe VARCHAR(50),
    kode_brand INTEGER,
    brand VARCHAR(50)
);

CREATE TABLE pelanggan_ds (
    id_customer VARCHAR(10),
    level VARCHAR(50),
    nama VARCHAR(100),
    id_cabang_sales VARCHAR(10),
    cabang_sales VARCHAR(50),
    id_distributor VARCHAR(10),
    "group" VARCHAR(50)
);

CREATE TABLE datamart_penjualan (
    id_penjualan VARCHAR(20),
    id_invoice VARCHAR(10),
    tanggal DATE,
    id_barang VARCHAR(10),
    nama_barang VARCHAR(100),
    harga INTEGER,
    unit VARCHAR(10),
    jumlah_barang INTEGER,
    total_harga_per_barang INTEGER,
    mata_uang VARCHAR(5),
    kode_brand INTEGER,
    brand VARCHAR(50),
    id_customer VARCHAR(10),
    nama_customer VARCHAR(100),
    cabang_sales VARCHAR(50),
    id_distributor VARCHAR(10),
    group_category VARCHAR(50)
);


-- membuat primary key
select
	concat(id_invoice, '_', id_barang) as id_penjualan, *
from penjualan_ds;

-- Design Datamart
-- Tabel base
SELECT 
    CONCAT(id_invoice, '_', id_barang) AS id_penjualan,
    pjl.id_invoice,
    pjl.tanggal,
    pjl.id_barang,
    brg.nama_barang,
    pjl.harga,
    pjl.unit,
    pjl.jumlah_barang,
    (jumlah_barang * pjl.harga) AS total_harga_per_barang,
    pjl.mata_uang,
    brg.kode_brand,
    brg.brand,
    pjl.id_customer,
    plg.nama AS nama_customer,
    plg.cabang_sales,
    plg.id_distributor,
    plg."group" AS group_category
FROM penjualan_ds pjl
LEFT JOIN barang_ds brg ON pjl.id_barang = brg.kode_barang
LEFT JOIN pelanggan_ds plg ON pjl.id_customer = plg.id_customer;

-- Tabel Aggregate
select
	id_invoice, tanggal,
	id_customer, nama_customer, cabang_sales,
	id_distributor, group_category,
	count(distinct id_barang) total_barang, sum(total_harga_per_barang) as total_pembelian
from datamart_penjualan
group by 1,2,3,4,5,6,7
order by 1;