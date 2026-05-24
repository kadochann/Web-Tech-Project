# Proje Spesifikasyon Dokümanı (SPEC.md) - Çok Dilli Online Sınav Sistemi

## 1. Proje Özeti ve Kapsamı
[cite_start]Bu proje, **ASP.NET Web Forms (v4.7.2)** teknolojisi kullanılarak geliştirilecek, çok dilli (Türkçe, İngilizce, Arapça) bir **Online Sınav / Quiz Sistemi** uygulamasıdır[cite: 1, 3]. [cite_start]Kullanıcılar sisteme kayıt olup giriş yapabilecek, seçtikleri kategorideki sınavlara katılabilecek ve geçmiş sınav sonuçlarını görüntüleyebileceklerdir[cite: 1, 2, 3]. [cite_start]Yönetici (Admin) ise sisteme çok dilli sorular ekleyip listeleyebilecektir.

---

## 2. Kullanılacak Teknolojiler ve Kütüphaneler
* [cite_start]**Framework:** .NET Framework 4.7.2 veya üzeri (ASP.NET Web Forms) [cite: 3]
* [cite_start]**Veritabanı:** SQL Server veya LocalDB [cite: 3]
* [cite_start]**Veri Erişim Katmanı:** ADO.NET [cite: 3]
* [cite_start]**Arayüz (UI):** Bootstrap 5 ve CSS [cite: 3]
* [cite_start]**Durum Yönetimi:** ASP.NET Session State [cite: 3]
* [cite_start]**Yerelleştirme (Localization):** Resource (.resx) Dosyaları ve Globalization mimarisi [cite: 3]

---

## 3. Klasör ve Dosya Yapısı (Project Architecture)
[cite_start]Proje mimarisi, belgede belirtilen hiyerarşiye uygun olarak şu şekilde yapılandırılacaktır[cite: 2]:

```text
OnlineSinavSistemi/
├── App_GlobalResources/          # Merkezi dil dosyaları
│   ├── Resources.resx            # Varsayılan dil (Türkçe)
│   ├── Resources.en.resx         # İngilizce çeviriler
│   └── Resources.ar.resx         # Arapça çeviriler
├── App_Data/                     # Yerel veritabanı klasörü
│   └── Database.mdf              # SQL Express / LocalDB Veritabanı
├── App_Code/                     # Ortak kod sınıfları
│   ├── DbHelper.cs               # ADO.NET veritabanı bağlantı sınıfı
│   └── BasePage.cs               # Dil yönetimini sağlayan temel sayfa sınıfı
├── MasterPage.Master             # Ortak tasarım ve navbar şablonu
├── Default.aspx                  # Ana sayfa ve dil seçimi ekranı
├── Login.aspx                    # Kullanıcı giriş sayfası
├── Register.aspx                 # Kullanıcı kayıt sayfası
├── SinavBasla.aspx               # Sınav kategori seçimi ve başlangıç ekranı
├── Soru.aspx                     # Canlı sınav akışı ve soru gösterim ekranı
├── Sonuc.aspx                    # Sınav sonuç raporu ekranı
├── Gecmis.aspx                   # Kullanıcının geçmiş sınav istatistikleri
├── Admin/                        # Yönetici yönetim paneli klasörü
│   ├── SoruEkle.aspx             # Çok dilli yeni soru ekleme formu
│   └── SoruListe.aspx            # Eklenen soruların listelenmesi ve yönetimi
└── Web.config                    # Uygulama konfigürasyon dosyası
--- 
```

## 4. Veritabanı Şeması (SQL Data Definition)
Uygulamanın veri tabanı mimarisi aşağıdaki 4 tablodan oluşmaktadır:  

SQLCREATE TABLE Kullanicilar (
    Id INT PRIMARY KEY IDENTITY,
    KullaniciAdi NVARCHAR(50),
    Sifre NVARCHAR(100),
    Email NVARCHAR(100),
    KayitTarihi DATETIME DEFAULT GETDATE()
);

CREATE TABLE Kategoriler (
    Id INT PRIMARY KEY IDENTITY,
    AdTR NVARCHAR(100),
    AdEN NVARCHAR(100),
    AdAR NVARCHAR(100)
);

CREATE TABLE Sorular (
    Id INT PRIMARY KEY IDENTITY,
    KategoriId INT FOREIGN KEY REFERENCES Kategoriler(Id),
    SoruMetniTR NVARCHAR(500),
    SoruMetniEN NVARCHAR(500),
    SoruMetniAR NVARCHAR(500),
    SecenekATR NVARCHAR(200), SecenekAEN NVARCHAR(200), SecenekAAR NVARCHAR(200),
    SecenekBTR NVARCHAR(200), SecenekBEN NVARCHAR(200), SecenekBAR NVARCHAR(200),
    SecenekCTR NVARCHAR(200), SecenekCEN NVARCHAR(200), SecenekCAR NVARCHAR(200),
    SecenekDTR NVARCHAR(200), SecenekDEN NVARCHAR(200), SecenekDAR NVARCHAR(200),
    DogruCevap CHAR(1) -- 'A', 'B', 'C', 'D'
);

CREATE TABLE SinavSonuclari (
    Id INT PRIMARY KEY IDENTITY,
    KullaniciId INT FOREIGN KEY REFERENCES Kullanicilar(Id),
    KategoriId INT FOREIGN KEY REFERENCES Kategoriler(Id),
    DogruSayisi INT,
    YanlisSayisi INT,
    SinavTarihi DATETIME DEFAULT GETDATE(),
    SureSaniye INT
);
---
## 5. Teknik Gereksinimler ve Mimari Detaylar
# 5.1. Yerelleştirme ve Dil Yönetimi (Localization)UI Çevirileri:
<ol>
Statik metinler (Butonlar, etiketler, mesajlar) App_GlobalResources altındaki .resx dosyalarından okunacaktır.  
Dinamik İçerik: Veritabanındaki çok dilli veriler (Örn: SoruMetniTR, SoruMetniEN) seçili olan dile göre kod tarafında dinamik seçilerek ekrana basılacaktır.  Kültür Yönetimi: BasePage.cs sınıfı InitializeCulture metodunu override edecek ve tüm sayfalar bu sınıftan türeyecektir.  
</ol>

# 5.2. Durum Yönetimi (Session State)Uygulama boyunca aşağıdaki Session anahtarları aktif olarak yönetilecektir:  
<ol>
<li>Session["KullaniciId"]: Oturum açan kullanıcının benzersiz kimliği.  
<li>Session["Dil"]: Seçilen aktif kültür bilgisi (Örn: "tr-TR", "en-US").  
<li>Session["Sorular"]: Sınav anında veritabanından çekilen aktif soru listesi.  
<li>Session["Cevaplar"]: Kullanıcının sorulara verdiği yanıtları tutan Dictionary<int, string> yapısı.  
<li>Session["MevcutSoruIndex"]: Kullanıcının o anda kaçıncı soruda olduğunu tutan sayaç.  
</ol>

## 6. İş Bölümü ve Görev Dağılımı (2 Kişilik Takım) 
Geliştirici 1: 
<ol>
     <li>Veritabanı, Altyapı ve Yönetim Paneli (Back-End)[ ] 
     <li>Database.mdf veritabanının oluşturulması ve SQL tablolarının ayağa kaldırılması.  [ ] 
     <li>DbHelper.cs sınıfının ADO.NET mimarisine uygun olarak yazılması (Bağlantı yönetimi, veri çekme ve CRUD komutları).  [ ] 
     <li>BasePage.cs sınıfının kodlanması ve Session["Dil"] entegrasyonunun sağlanması.  [ ] 
     <li>Login.aspx ve Register.aspx sayfalarının arka plan kodlarının (.cs) yazılması ve kullanıcı kimlik doğrulama sisteminin kurulması.  [ ] 
     <li>Admin/SoruEkle.aspx ve Admin/SoruListe.aspx sayfalarının geliştirilerek çok dilli soru yönetim paneli altyapısının tamamlanması. 
</ol>
Geliştirici 2:
<ol>
     <li>Kullanıcı Deneyimi, Sınav Akışı ve Yerelleştirme (Front-End & UI)[ ] 
     <li>Bootstrap 5 entegrasyonunun yapılması ve MasterPage.Master genel site tasarımının (Navbar, dil seçim dropdown'ı vb.) hazırlanması.  [ ] 
     <li>App_GlobalResources altında Resources.resx, Resources.en.resx ve Resources.ar.resx dosyalarının oluşturularak tüm arayüz kelimelerinin eşleştirilmesi[ ] <li>Default.aspx ve SinavBasla.aspx sayfalarının arayüz ve kategori listeleme işlevlerinin tasarlanması.  [ ] 
     <li>Soru.aspx sayfasının tasarlanması; sonraki/önceki soru geçişleri, işaretlenen şıkların Session'da toplanması ve sınav süresinin dinamik takibi.  [ ] 
     <li>Sonuc.aspx ve Gecmis.aspx ekranlarının kodlanarak sınav bitiminde verilerin analiz edilmesi ve veritabanına raporlanması. 
</ol>