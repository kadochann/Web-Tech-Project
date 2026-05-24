using System;
using System.Data;
using System.Diagnostics;
using System.Web.UI.WebControls;

/// <summary>
/// Admin/SoruListe.aspx.cs
/// Tüm soruları GridView ile listeler.
/// Kategori filtresi (dropdown, AutoPostBack).
/// Düzenle → SoruEkle.aspx?id=N  |  Sil → onay modali → DB'den sil.
/// AdminBasePage üzerinden rol kontrolü otomatik yapılır.
/// </summary>
public partial class Admin_SoruListe : AdminBasePage
{
    // ------------------------------------------------------------------ //
    //  Page_Load
    // ------------------------------------------------------------------ //
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FiltreDropdownYukle();
            SorulariYukle();
            RedirectMesajGoster();
        }
    }

    // ------------------------------------------------------------------ //
    //  Redirect'ten gelen başarı mesajını göster
    //  Örn: SoruEkle.aspx → Response.Redirect("SoruListe.aspx?mesaj=eklendi")
    // ------------------------------------------------------------------ //
    private void RedirectMesajGoster()
    {
        string mesaj = Request.QueryString["mesaj"];
        if (string.IsNullOrEmpty(mesaj)) return;

        switch (mesaj)
        {
            case "eklendi":
                MesajGoster("Soru başarıyla eklendi.", "alert-success");
                break;
            case "guncellendi":
                MesajGoster("Soru başarıyla güncellendi.", "alert-success");
                break;
            case "silindi":
                MesajGoster("Soru başarıyla silindi.", "alert-success");
                break;
        }
    }

    // ------------------------------------------------------------------ //
    //  Filtre dropdown — "Tümü" + kategori listesi
    // ------------------------------------------------------------------ //
    private void FiltreDropdownYukle()
    {
        try
        {
            DataTable dt = DbHelper.GetDataTable(
                "SELECT Id, AdTR FROM Kategoriler ORDER BY AdTR");

            ddlFiltre.Items.Clear();
            ddlFiltre.Items.Add(new ListItem("-- Tüm Kategoriler --", "0"));

            foreach (DataRow row in dt.Rows)
                ddlFiltre.Items.Add(new ListItem(row["AdTR"].ToString(), row["Id"].ToString()));
        }
        catch (Exception ex)
        {
            Debug.WriteLine("[SoruListe] FiltreDropdownYukle hata: " + ex.Message);
            MesajGoster("Filtre yüklenirken bir hata oluştu.", "alert-danger");
        }
    }

    // ------------------------------------------------------------------ //
    //  Soruları yükle — isteğe bağlı kategori filtresiyle
    // ------------------------------------------------------------------ //
    private void SorulariYukle()
    {
        try
        {
            string sql;
            DataTable dt;

            if (ddlFiltre.SelectedValue == "0")
            {
                // Tüm sorular
                sql = @"SELECT s.Id,
                               k.AdTR  AS KategoriAdTR,
                               s.SoruMetniTR,
                               s.SoruMetniEN,
                               s.DogruCevap
                        FROM Sorular s
                        INNER JOIN Kategoriler k ON s.KategoriId = k.Id
                        ORDER BY k.AdTR, s.Id";

                dt = DbHelper.GetDataTable(sql);
            }
            else
            {
                // Seçili kategoriye göre filtrele
                int katId = int.Parse(ddlFiltre.SelectedValue);

                sql = @"SELECT s.Id,
                               k.AdTR  AS KategoriAdTR,
                               s.SoruMetniTR,
                               s.SoruMetniEN,
                               s.DogruCevap
                        FROM Sorular s
                        INNER JOIN Kategoriler k ON s.KategoriId = k.Id
                        WHERE s.KategoriId = ?
                        ORDER BY s.Id";

                dt = DbHelper.GetDataTable(sql, katId);
            }

            gvSorular.DataSource = dt;
            gvSorular.DataBind();

            lblSoruSayisi.Text = $"Toplam {dt.Rows.Count} soru listeleniyor.";
        }
        catch (Exception ex)
        {
            Debug.WriteLine("[SoruListe] SorulariYukle hata: " + ex.Message);
            MesajGoster("Sorular yüklenirken bir hata oluştu.", "alert-danger");
        }
    }

    // ------------------------------------------------------------------ //
    //  Filtre dropdown değişince
    // ------------------------------------------------------------------ //
    protected void ddlFiltre_SelectedIndexChanged(object sender, EventArgs e)
    {
        SorulariYukle();
    }

    // ------------------------------------------------------------------ //
    //  "Tümünü Göster" butonu
    // ------------------------------------------------------------------ //
    protected void btnFiltreSifirla_Click(object sender, EventArgs e)
    {
        ddlFiltre.SelectedValue = "0";
        SorulariYukle();
    }

    // ------------------------------------------------------------------ //
    //  GridView RowCommand — "SilIste" komutu gelince modal aç
    // ------------------------------------------------------------------ //
    protected void gvSorular_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "SilIste")
        {
            // Silinecek ID'yi HiddenField'e yaz, ardından modal'ı aç
            hfSilinecekId.Value = e.CommandArgument.ToString();

            // Modal açma işi istemci tarafında; bir ScriptManager yoksa
            // startup script ile tetikle
            string script = $"soruSilModalAc('{hfSilinecekId.Value}');";
            System.Web.UI.ScriptManager.RegisterStartupScript(
                this, GetType(), "silModal", script, true);
        }
    }

    // ------------------------------------------------------------------ //
    //  Modal içindeki "Evet, Sil" butonu
    // ------------------------------------------------------------------ //
    protected void btnSilOnayla_Click(object sender, EventArgs e)
    {
        if (!int.TryParse(hfSilinecekId.Value, out int soruId) || soruId <= 0)
        {
            MesajGoster("Silinecek soru belirlenemedi.", "alert-warning");
            SorulariYukle();
            return;
        }

        try
        {
            DbHelper.ExecuteNonQuery("DELETE FROM Sorular WHERE Id = ?", soruId);

            // Listeyi yenile ve başarı mesajı göster
            hfSilinecekId.Value = "0";
            SorulariYukle();
            MesajGoster("Soru başarıyla silindi.", "alert-success");
        }
        catch (Exception ex)
        {
            Debug.WriteLine("[SoruListe] btnSilOnayla_Click hata: " + ex.Message);
            MesajGoster("Soru silinirken bir hata oluştu, lütfen tekrar deneyin.", "alert-danger");
            SorulariYukle();
        }
    }

    // ------------------------------------------------------------------ //
    //  Mesaj göster yardımcısı
    // ------------------------------------------------------------------ //
    private void MesajGoster(string mesaj, string cssClass)
    {
        lblMesaj.Text     = mesaj;
        lblMesaj.CssClass = $"alert {cssClass} d-block mb-3";
        lblMesaj.Visible  = true;
    }
}
