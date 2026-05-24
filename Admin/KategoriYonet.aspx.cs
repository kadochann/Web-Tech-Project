using System;
using System.Data;
using System.Diagnostics;

/// <summary>
/// Admin/KategoriYonet.aspx.cs
/// Tek sayfada kategori CRUD:
///   - Sol panel  : Ekle / Düzenle formu (hfDuzenleId = 0 → INSERT, > 0 → UPDATE)
///   - Sağ panel  : GridView liste
///   - Modal      : Cascade-delete uyarılı silme onayı
/// AdminBasePage üzerinden rol kontrolü otomatik yapılır.
/// </summary>
public partial class Admin_KategoriYonet : AdminBasePage
{
    // ------------------------------------------------------------------ //
    //  Page_Load
    // ------------------------------------------------------------------ //
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            KategorileriYukle();
        }
    }

    // ------------------------------------------------------------------ //
    //  GridView doldur
    // ------------------------------------------------------------------ //
    private void KategorileriYukle()
    {
        try
        {
            DataTable dt = DbHelper.GetDataTable(
                "SELECT Id, AdTR, AdEN, SoruSayisi, SureSaniye FROM Kategoriler ORDER BY AdTR");

            gvKategoriler.DataSource = dt;
            gvKategoriler.DataBind();
        }
        catch (Exception ex)
        {
            Debug.WriteLine("[KategoriYonet] KategorileriYukle hata: " + ex.Message);
            MesajGoster("Kategoriler yüklenirken bir hata oluştu.", "alert-danger");
        }
    }

    // ------------------------------------------------------------------ //
    //  GridView RowCommand
    // ------------------------------------------------------------------ //
    protected void gvKategoriler_RowCommand(object sender,
        System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        int id = int.Parse(e.CommandArgument.ToString());

        if (e.CommandName == "Duzenle")
        {
            FormaDoldur(id);
        }
        else if (e.CommandName == "SilIste")
        {
            // ID'yi HiddenField'e yaz, modal'ı aç
            hfSilinecekId.Value = id.ToString();
            System.Web.UI.ScriptManager.RegisterStartupScript(
                this, GetType(), "silModal",
                $"kategoriSilModalAc('{id}');", true);
        }
    }

    // ------------------------------------------------------------------ //
    //  Düzenle: seçili kategoriyi forma doldur
    // ------------------------------------------------------------------ //
    private void FormaDoldur(int katId)
    {
        try
        {
            DataTable dt = DbHelper.GetDataTable(
                "SELECT Id, AdTR, AdEN, SoruSayisi, SureSaniye FROM Kategoriler WHERE Id = ?",
                katId);

            if (dt.Rows.Count == 0)
            {
                MesajGoster("Kategori bulunamadı.", "alert-warning");
                return;
            }

            DataRow row = dt.Rows[0];

            hfDuzenleId.Value    = row["Id"].ToString();
            txtAdTR.Text         = row["AdTR"].ToString();
            txtAdEN.Text         = row["AdEN"].ToString();
            txtSoruSayisi.Text   = row["SoruSayisi"].ToString();
            txtSureSaniye.Text   = row["SureSaniye"].ToString();

            lblFormBaslik.Text   = "Kategoriyi Düzenle";

            // Sayfanın form paneline scroll — startup script ile
            System.Web.UI.ScriptManager.RegisterStartupScript(
                this, GetType(), "scrollForm",
                "window.scrollTo({top:0, behavior:'smooth'});", true);
        }
        catch (Exception ex)
        {
            Debug.WriteLine("[KategoriYonet] FormaDoldur hata: " + ex.Message);
            MesajGoster("Kategori bilgileri yüklenirken bir hata oluştu.", "alert-danger");
        }
    }

    // ------------------------------------------------------------------ //
    //  Kaydet (Ekle veya Güncelle)
    // ------------------------------------------------------------------ //
    protected void btnKaydet_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        // Sayısal alanlar zaten RangeValidator ile kontrol edildi;
        // yine de güvenli parse yapalım.
        if (!int.TryParse(txtSoruSayisi.Text.Trim(), out int soruSayisi) ||
            !int.TryParse(txtSureSaniye.Text.Trim(), out int sureSaniye))
        {
            MesajGoster("Soru sayısı ve süre geçerli tam sayı olmalıdır.", "alert-danger");
            return;
        }

        try
        {
            int duzenleId = int.Parse(hfDuzenleId.Value);

            if (duzenleId == 0)
                KategoriEkle(soruSayisi, sureSaniye);
            else
                KategoriGuncelle(duzenleId, soruSayisi, sureSaniye);
        }
        catch (Exception ex)
        {
            Debug.WriteLine("[KategoriYonet] btnKaydet_Click hata: " + ex.Message);
            MesajGoster("Kayıt sırasında bir hata oluştu, lütfen tekrar deneyin.", "alert-danger");
        }
    }

    // ------------------------------------------------------------------ //
    //  INSERT
    // ------------------------------------------------------------------ //
    private void KategoriEkle(int soruSayisi, int sureSaniye)
    {
        string sql = @"INSERT INTO Kategoriler (AdTR, AdEN, SoruSayisi, SureSaniye)
                       VALUES (?, ?, ?, ?)";

        DbHelper.ExecuteNonQuery(sql,
            txtAdTR.Text.Trim(),
            txtAdEN.Text.Trim(),
            soruSayisi,
            sureSaniye);

        FormuSifirla();
        KategorileriYukle();
        MesajGoster("Kategori başarıyla eklendi.", "alert-success");
    }

    // ------------------------------------------------------------------ //
    //  UPDATE
    // ------------------------------------------------------------------ //
    private void KategoriGuncelle(int katId, int soruSayisi, int sureSaniye)
    {
        string sql = @"UPDATE Kategoriler
                       SET AdTR       = ?,
                           AdEN       = ?,
                           SoruSayisi = ?,
                           SureSaniye = ?
                       WHERE Id = ?";

        DbHelper.ExecuteNonQuery(sql,
            txtAdTR.Text.Trim(),
            txtAdEN.Text.Trim(),
            soruSayisi,
            sureSaniye,
            katId);

        FormuSifirla();
        KategorileriYukle();
        MesajGoster("Kategori başarıyla güncellendi.", "alert-success");
    }

    // ------------------------------------------------------------------ //
    //  İptal butonu — formu temizle
    // ------------------------------------------------------------------ //
    protected void btnIptal_Click(object sender, EventArgs e)
    {
        FormuSifirla();
        KategorileriYukle();
    }

    // ------------------------------------------------------------------ //
    //  Modal "Evet, Sil" — CASCADE DELETE (Access'te ilişki tanımlıysa
    //  Sorular + SinavSonuclari + YarimSinavlar otomatik silinir;
    //  yoksa kod tarafında sırayla sileriz.)
    // ------------------------------------------------------------------ //
    protected void btnSilOnayla_Click(object sender, EventArgs e)
    {
        if (!int.TryParse(hfSilinecekId.Value, out int katId) || katId <= 0)
        {
            MesajGoster("Silinecek kategori belirlenemedi.", "alert-warning");
            KategorileriYukle();
            return;
        }

        try
        {
            // Access Relationships'te Cascade Delete tanımlıysa tek DELETE yeterli.
            // Tanımlı değilse aşağıdaki sıra ile manuel sil:

            // 1) YarimSinavlar
            DbHelper.ExecuteNonQuery(
                "DELETE FROM YarimSinavlar WHERE KategoriId = ?", katId);

            // 2) SinavSonuclari
            DbHelper.ExecuteNonQuery(
                "DELETE FROM SinavSonuclari WHERE KategoriId = ?", katId);

            // 3) Sorular
            DbHelper.ExecuteNonQuery(
                "DELETE FROM Sorular WHERE KategoriId = ?", katId);

            // 4) Kategori
            DbHelper.ExecuteNonQuery(
                "DELETE FROM Kategoriler WHERE Id = ?", katId);

            hfSilinecekId.Value = "0";
            FormuSifirla();
            KategorileriYukle();
            MesajGoster(
                "Kategori ve ona bağlı tüm sorular / sınav sonuçları başarıyla silindi.",
                "alert-success");
        }
        catch (Exception ex)
        {
            Debug.WriteLine("[KategoriYonet] btnSilOnayla_Click hata: " + ex.Message);
            MesajGoster("Silme işlemi sırasında bir hata oluştu.", "alert-danger");
            KategorileriYukle();
        }
    }

    // ------------------------------------------------------------------ //
    //  Formu sıfırla (ekle moduna dön)
    // ------------------------------------------------------------------ //
    private void FormuSifirla()
    {
        hfDuzenleId.Value  = "0";
        txtAdTR.Text       = string.Empty;
        txtAdEN.Text       = string.Empty;
        txtSoruSayisi.Text = string.Empty;
        txtSureSaniye.Text = string.Empty;
        lblFormBaslik.Text = "Yeni Kategori Ekle";
    }

    // ------------------------------------------------------------------ //
    //  Saniye → "Xdak Ysn" formatla (GridView TemplateField'den çağrılır)
    // ------------------------------------------------------------------ //
    protected string SaniyeFormatla(object saniyeObj)
    {
        if (saniyeObj == null || saniyeObj == DBNull.Value) return "-";
        int s = Convert.ToInt32(saniyeObj);
        int dk = s / 60;
        int sn = s % 60;
        return dk > 0
            ? (sn > 0 ? $"{dk}dk {sn}sn" : $"{dk}dk")
            : $"{sn}sn";
    }

    // ------------------------------------------------------------------ //
    //  Mesaj göster
    // ------------------------------------------------------------------ //
    private void MesajGoster(string mesaj, string cssClass)
    {
        lblMesaj.Text     = mesaj;
        lblMesaj.CssClass = $"alert {cssClass} d-block mb-3";
        lblMesaj.Visible  = true;
    }
}
