using System;
using System.Data;
using System.Diagnostics;

/// <summary>
/// Admin/SoruEkle.aspx.cs
/// Yeni soru ekleme ve mevcut soruyu düzenleme sayfası.
/// Düzenleme modu: ?id=N query string ile çağrılır.
/// AdminBasePage üzerinden rol kontrolü otomatik yapılır.
/// </summary>
public partial class Admin_SoruEkle : AdminBasePage
{
    // Düzenleme modunda mevcut soru ID'si; 0 ise yeni ekleme
    private int _soruId = 0;

    // ------------------------------------------------------------------ //
    //  Page_Load
    // ------------------------------------------------------------------ //
    protected void Page_Load(object sender, EventArgs e)
    {
        // AdminBasePage.Page_Load zaten rol kontrolü yapar.
        // Burada sadece sayfa özgü işlemler:

        if (!IsPostBack)
        {
            KategorileriYukle();
            SoruIdOku();

            if (_soruId > 0)
            {
                lblBaslik.Text = "Soruyu Düzenle";
                SoruyuFormaYukle(_soruId);
            }
            else
            {
                lblBaslik.Text = "Yeni Soru Ekle";
            }
        }
        else
        {
            // Postback'te de _soruId tekrar okunmalı
            SoruIdOku();
        }
    }

    // ------------------------------------------------------------------ //
    //  Yardımcı: query string'ten soru ID oku
    // ------------------------------------------------------------------ //
    private void SoruIdOku()
    {
        if (int.TryParse(Request.QueryString["id"], out int id) && id > 0)
            _soruId = id;
    }

    // ------------------------------------------------------------------ //
    //  Kategorileri dropdown'a yükle
    // ------------------------------------------------------------------ //
    private void KategorileriYukle()
    {
        try
        {
            DataTable dt = DbHelper.GetDataTable("SELECT Id, AdTR, AdEN FROM Kategoriler ORDER BY AdTR");

            ddlKategori.Items.Clear();
            ddlKategori.Items.Add(new System.Web.UI.WebControls.ListItem("-- Kategori Seçin --", "0"));

            foreach (DataRow row in dt.Rows)
            {
                string gosterim = $"{row["AdTR"]} / {row["AdEN"]}";
                string deger    = row["Id"].ToString();
                ddlKategori.Items.Add(new System.Web.UI.WebControls.ListItem(gosterim, deger));
            }
        }
        catch (Exception ex)
        {
            Debug.WriteLine("[SoruEkle] KategorileriYukle hata: " + ex.Message);
            MesajGoster("Kategoriler yüklenirken bir hata oluştu. Lütfen sayfayı yenileyin.", "alert-danger");
        }
    }

    // ------------------------------------------------------------------ //
    //  Düzenleme modu: mevcut soruyu formdaki kontrollere doldur
    // ------------------------------------------------------------------ //
    private void SoruyuFormaYukle(int soruId)
    {
        try
        {
            string sql = @"SELECT KategoriId,
                                  SoruMetniTR, SoruMetniEN,
                                  SecenekATR, SecenekAEN,
                                  SecenekBTR, SecenekBEN,
                                  SecenekCTR, SecenekCEN,
                                  SecenekDTR, SecenekDEN,
                                  DogruCevap
                           FROM Sorular
                           WHERE Id = ?";

            DataTable dt = DbHelper.GetDataTable(sql, soruId);

            if (dt.Rows.Count == 0)
            {
                MesajGoster("Belirtilen soru bulunamadı.", "alert-warning");
                return;
            }

            DataRow row = dt.Rows[0];

            // Kategori seç
            string katId = row["KategoriId"].ToString();
            if (ddlKategori.Items.FindByValue(katId) != null)
                ddlKategori.SelectedValue = katId;

            // Soru metinleri
            txtSoruTR.Text = row["SoruMetniTR"].ToString();
            txtSoruEN.Text = row["SoruMetniEN"].ToString();

            // Şıklar
            txtSecenekATR.Text = row["SecenekATR"].ToString();
            txtSecenekAEN.Text = row["SecenekAEN"].ToString();
            txtSecenekBTR.Text = row["SecenekBTR"].ToString();
            txtSecenekBEN.Text = row["SecenekBEN"].ToString();
            txtSecenekCTR.Text = row["SecenekCTR"].ToString();
            txtSecenekCEN.Text = row["SecenekCEN"].ToString();
            txtSecenekDTR.Text = row["SecenekDTR"].ToString();
            txtSecenekDEN.Text = row["SecenekDEN"].ToString();

            // Doğru cevap radio
            string dogru = row["DogruCevap"].ToString().ToUpper();
            rbA.Checked = (dogru == "A");
            rbB.Checked = (dogru == "B");
            rbC.Checked = (dogru == "C");
            rbD.Checked = (dogru == "D");
        }
        catch (Exception ex)
        {
            Debug.WriteLine("[SoruEkle] SoruyuFormaYukle hata: " + ex.Message);
            MesajGoster("Soru verileri yüklenirken bir hata oluştu.", "alert-danger");
        }
    }

    // ------------------------------------------------------------------ //
    //  Kaydet butonu
    // ------------------------------------------------------------------ //
    protected void btnKaydet_Click(object sender, EventArgs e)
    {
        // ASP.NET Validators tetiklenmişse dur
        if (!Page.IsValid) return;

        // Doğru cevap server-side kontrolü (RadioButton grupları
        // ASP.NET Validator ile doğrudan doğrulanamaz)
        string dogruCevap = DogruCevapAl();
        if (string.IsNullOrEmpty(dogruCevap))
        {
            lblDogruCevapHata.Visible = true;
            return;
        }
        lblDogruCevapHata.Visible = false;

        // Kategori kontrolü (RequiredFieldValidator'a ek güvence)
        if (ddlKategori.SelectedValue == "0")
        {
            MesajGoster("Lütfen bir kategori seçin.", "alert-danger");
            return;
        }

        try
        {
            int kategoriId = int.Parse(ddlKategori.SelectedValue);

            if (_soruId == 0)
                SoruEkle(kategoriId, dogruCevap);
            else
                SoruGuncelle(kategoriId, dogruCevap);
        }
        catch (Exception ex)
        {
            Debug.WriteLine("[SoruEkle] btnKaydet_Click hata: " + ex.Message);
            MesajGoster("Kayıt sırasında bir hata oluştu, lütfen tekrar deneyin.", "alert-danger");
        }
    }

    // ------------------------------------------------------------------ //
    //  Yeni soru INSERT
    // ------------------------------------------------------------------ //
    private void SoruEkle(int kategoriId, string dogruCevap)
    {
        string sql = @"INSERT INTO Sorular
                       (KategoriId,
                        SoruMetniTR, SoruMetniEN,
                        SecenekATR, SecenekAEN,
                        SecenekBTR, SecenekBEN,
                        SecenekCTR, SecenekCEN,
                        SecenekDTR, SecenekDEN,
                        DogruCevap)
                       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        DbHelper.ExecuteNonQuery(sql,
            kategoriId,
            txtSoruTR.Text.Trim(),
            txtSoruEN.Text.Trim(),
            txtSecenekATR.Text.Trim(), txtSecenekAEN.Text.Trim(),
            txtSecenekBTR.Text.Trim(), txtSecenekBEN.Text.Trim(),
            txtSecenekCTR.Text.Trim(), txtSecenekCEN.Text.Trim(),
            txtSecenekDTR.Text.Trim(), txtSecenekDEN.Text.Trim(),
            dogruCevap);

        // Başarıyla eklendi → Soru listesine yönlendir
        Response.Redirect("SoruListe.aspx?mesaj=eklendi");
    }

    // ------------------------------------------------------------------ //
    //  Mevcut soruyu UPDATE
    // ------------------------------------------------------------------ //
    private void SoruGuncelle(int kategoriId, string dogruCevap)
    {
        string sql = @"UPDATE Sorular SET
                        KategoriId   = ?,
                        SoruMetniTR  = ?,
                        SoruMetniEN  = ?,
                        SecenekATR   = ?, SecenekAEN = ?,
                        SecenekBTR   = ?, SecenekBEN = ?,
                        SecenekCTR   = ?, SecenekCEN = ?,
                        SecenekDTR   = ?, SecenekDEN = ?,
                        DogruCevap   = ?
                       WHERE Id = ?";

        DbHelper.ExecuteNonQuery(sql,
            kategoriId,
            txtSoruTR.Text.Trim(),
            txtSoruEN.Text.Trim(),
            txtSecenekATR.Text.Trim(), txtSecenekAEN.Text.Trim(),
            txtSecenekBTR.Text.Trim(), txtSecenekBEN.Text.Trim(),
            txtSecenekCTR.Text.Trim(), txtSecenekCEN.Text.Trim(),
            txtSecenekDTR.Text.Trim(), txtSecenekDEN.Text.Trim(),
            dogruCevap,
            _soruId);

        Response.Redirect("SoruListe.aspx?mesaj=guncellendi");
    }

    // ------------------------------------------------------------------ //
    //  Seçili radio'dan doğru cevap harfini al
    // ------------------------------------------------------------------ //
    private string DogruCevapAl()
    {
        if (rbA.Checked) return "A";
        if (rbB.Checked) return "B";
        if (rbC.Checked) return "C";
        if (rbD.Checked) return "D";
        return string.Empty;
    }

    // ------------------------------------------------------------------ //
    //  Mesaj göster yardımcısı
    // ------------------------------------------------------------------ //
    private void MesajGoster(string mesaj, string cssClass)
    {
        lblMesaj.Text    = mesaj;
        lblMesaj.CssClass = $"alert {cssClass} d-block mb-3";
        lblMesaj.Visible  = true;
    }
}
