<%@ Page Title="Soru Listesi" Language="C#" MasterPageFile="~/MasterPage.Master"
    AutoEventWireup="true" CodeFile="SoruListe.aspx.cs" Inherits="Admin_SoruListe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .tablo-soru { font-size: 0.92rem; }
        .tablo-soru td, .tablo-soru th { vertical-align: middle; }
        .badge-cevap { font-size: 1rem; width: 2rem; height: 2rem;
                       display:inline-flex; align-items:center; justify-content:center; }
        .soru-metin  { max-width: 320px; white-space: nowrap;
                       overflow: hidden; text-overflow: ellipsis; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="container my-4">

    <%-- BAŞLIK + YENİ SORU BUTONU --%>
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h4 class="mb-0">Soru Listesi</h4>
        <a href="SoruEkle.aspx" class="btn btn-success btn-sm">
            &#43; Yeni Soru Ekle
        </a>
    </div>

    <%-- İŞLEM BİLDİRİMİ (redirect'ten gelen mesaj) --%>
    <asp:Label ID="lblMesaj" runat="server" Visible="false"
               CssClass="alert d-block mb-3" Text=""></asp:Label>

    <%-- FİLTRE --%>
    <div class="card mb-3 shadow-sm">
        <div class="card-body py-2">
            <div class="row g-2 align-items-end">
                <div class="col-md-4">
                    <label class="form-label mb-1 small fw-semibold">Kategoriye Göre Filtrele</label>
                    <asp:DropDownList ID="ddlFiltre" runat="server" CssClass="form-select form-select-sm"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlFiltre_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnFiltreSifirla" runat="server" Text="Tümünü Göster"
                        CssClass="btn btn-outline-secondary btn-sm w-100"
                        OnClick="btnFiltreSifirla_Click" />
                </div>
                <div class="col-md-6 text-end">
                    <asp:Label ID="lblSoruSayisi" runat="server"
                               CssClass="text-muted small"></asp:Label>
                </div>
            </div>
        </div>
    </div>

    <%-- SİL ONAY MODAL --%>
    <div class="modal fade" id="modalSil" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Soruyu Sil</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    Bu soruyu silmek istediğinizden emin misiniz?
                    Bu işlem <strong>geri alınamaz</strong>.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">İptal</button>
                    <%-- Gerçek silme buradan tetiklenir --%>
                    <asp:Button ID="btnSilOnayla" runat="server" Text="Evet, Sil"
                        CssClass="btn btn-danger btn-sm"
                        OnClick="btnSilOnayla_Click"
                        UseSubmitBehavior="true" />
                </div>
            </div>
        </div>
    </div>
    <%-- Silinecek ID hidden field --%>
    <asp:HiddenField ID="hfSilinecekId" runat="server" Value="0" />

    <%-- SORU TABLOSU --%>
    <div class="card shadow-sm">
        <div class="card-body p-0">
            <asp:GridView ID="gvSorular" runat="server"
                CssClass="table table-hover table-bordered tablo-soru mb-0"
                AutoGenerateColumns="false"
                GridLines="None"
                EmptyDataText="Gösterilecek soru bulunamadı."
                OnRowCommand="gvSorular_RowCommand">

                <HeaderStyle CssClass="table-dark" />
                <EmptyDataRowStyle CssClass="text-center text-muted p-4" />

                <Columns>

                    <%-- # --%>
                    <asp:BoundField DataField="Id" HeaderText="#"
                        ItemStyle-Width="50px" ItemStyle-CssClass="text-center text-muted" />

                    <%-- KATEGORİ --%>
                    <asp:BoundField DataField="KategoriAdTR" HeaderText="Kategori"
                        ItemStyle-Width="140px" />

                    <%-- SORU (TR) --%>
                    <asp:TemplateField HeaderText="Soru Metni (TR)">
                        <ItemTemplate>
                            <span class="soru-metin d-inline-block"
                                  title='<%# Eval("SoruMetniTR") %>'>
                                <%# Eval("SoruMetniTR") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <%-- EN ÇEVİRİ VAR MI? --%>
                    <asp:TemplateField HeaderText="EN" ItemStyle-Width="60px"
                        ItemStyle-CssClass="text-center">
                        <ItemTemplate>
                            <%# string.IsNullOrWhiteSpace(Eval("SoruMetniEN")?.ToString())
                                ? "<span class='text-danger' title='İngilizce çevirisi yok'>&#10005;</span>"
                                : "<span class='text-success' title='İngilizce mevcut'>&#10003;</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <%-- DOĞRU CEVAP --%>
                    <asp:TemplateField HeaderText="Doğru" ItemStyle-Width="70px"
                        ItemStyle-CssClass="text-center">
                        <ItemTemplate>
                            <span class="badge bg-success badge-cevap rounded-circle">
                                <%# Eval("DogruCevap") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <%-- DÜZENLE / SİL --%>
                    <asp:TemplateField HeaderText="İşlemler" ItemStyle-Width="130px"
                        ItemStyle-CssClass="text-center">
                        <ItemTemplate>
                            <%-- Düzenle → SoruEkle.aspx?id=N --%>
                            <a href='<%# "SoruEkle.aspx?id=" + Eval("Id") %>'
                               class="btn btn-outline-primary btn-sm me-1"
                               title="Düzenle">
                                &#9998;
                            </a>
                            <%-- Sil → modal tetikle --%>
                            <asp:LinkButton ID="lbSil" runat="server"
                                CommandName="SilIste"
                                CommandArgument='<%# Eval("Id") %>'
                                CssClass="btn btn-outline-danger btn-sm"
                                title="Sil"
                                OnClientClick="return false;">
                                &#128465;
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>
        </div>
    </div>

</div>

<%-- Modal tetikleyici JS --%>
<script>
    // GridView'den gelen "SilIste" komutunu yakala, modal aç
    function soruSilModalAc(soruId) {
        document.getElementById('<%= hfSilinecekId.ClientID %>').value = soruId;
        var modal = new bootstrap.Modal(document.getElementById('modalSil'));
        modal.show();
    }

    // Sayfa yüklenince query string'te mesaj varsa alert zaten server-side gösterildi;
    // ek JS işlemi gerekmiyor.
</script>

</asp:Content>
