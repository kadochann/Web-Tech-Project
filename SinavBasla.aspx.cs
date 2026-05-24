using System;
using System.Data;
using System.Web.UI.WebControls;

namespace Project
{
    public partial class SinavBasla : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
            }
        }

        private void LoadCategories()
        {
            DataTable table = new DataTable();

            table.Columns.Add("Id");
            table.Columns.Add("Ad");
            table.Columns.Add("SoruSayisi");
            table.Columns.Add("SureSaniye");

            table.Rows.Add("1", "Genel Kültür", "5", "300");
            table.Rows.Add("2", "Bilgi Teknolojileri", "5", "300");
            table.Rows.Add("3", "Matematik", "5", "300");

            rptCategories.DataSource = table;
            rptCategories.DataBind();
        }

        protected void rptCategories_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "StartExam")
            {
                int kategoriId = Convert.ToInt32(e.CommandArgument);

                Session["KategoriId"] = kategoriId;
                Session["MevcutSoruIndex"] = 0;
                Session["SinavBaslangic"] = DateTime.Now;
                Session["FokusUyariSayisi"] = 0;

                Response.Redirect("Soru.aspx");
            }
        }
    }
}