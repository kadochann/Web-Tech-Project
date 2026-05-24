<%@ Page Title="Kategori Yönetimi" Language="C#" MasterPageFile="~/MasterPage.Master"
    AutoEventWireup="true" CodeFile="KategoriYonet.aspx.cs" Inherits="Admin_KategoriYonet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .tablo-kategori td, .tablo-kategori th { vertical-align: middle; }
        .form-panel { background: #f8f9fa; border: 1px solid #dee2e6;
                      border-radius: .5rem; padding: 1.5rem; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="container my-4">

    <h4 class="mb-3">Kategori Yönetimi</h4>

    <%-- BİLDİRİM --%>
    <asp:Label ID="lblMesaj" runat="server" Visible="false"
               CssClass="alert d-block mb-3" Text=""></asp:Label>

    <div class="row g-4">

        <%-- SOL: EKLE / DÜZENLE FORMU --%>
        <div class="col-lg-4">
            <div class="form-panel shadow-sm">

                <asp:HiddenField ID="hfDuzenleId" runat="server" Value="0" />

                <h6 class="mb-3 fw-bold">
                    <asp:Label ID="lblFormBaslik" runat="server" Text="Yeni Kategori Ekle"></asp:Label>
                </h6>

                <%-- Kategori Adı TR --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold">
                        Kategori Adı (TR) <span class="text-danger">*</span>
                    </label>
                    <asp:TextBox ID="txtAdTR" runat="server" CssClass="form-control"
                        placeholder="Türkçe kategori adı" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvAdTR" runat="server"
                        ControlToValidate="txtAdTR"
                        CssClass="text-danger small"
                        ErrorMessage="Türkçe ad zorunludur."
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <%-- Kategori Adı EN --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold">
                        Kategori Adı (EN) <span class="text-danger">*</span>
                    </label>
                    <asp:TextBox ID="txtAdEN" runat="server" CssClass="form-control"
                        placeholder="English category name" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvAdEN" runat="server"
                        ControlToValidate="txtAdEN"
                        CssClass="text-danger small"
                        ErrorMessage="İngilizce ad zorunludur."
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <%-- Soru Sayısı --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold">
                        Sınavda Çıkacak Soru Sayısı <span class="text-danger">*</span>
                    </label>
                    <asp:TextBox ID="txtSoruSayisi" runat="server" CssClass="form-control"
                        TextMode="Number" placeholder="5"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSoruSayisi" runat="server"
                        ControlToValidate="txtSoruSayisi"
                        CssClass="text-danger small"
                        ErrorMessage="Soru sayısı zorunludur."
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="rvSoruSayisi" runat="server"
                        ControlToValidate="txtSoruSayisi"
                        MinimumValue="1" MaximumValue="100" Type="Integer"
                        CssClass="text-danger small"
                        ErrorMessage="1 ile 100 arasında olmalıdır."
                        Display="Dynamic">
                    </asp:RangeValidator>
                </div>

                <%-- Süre (saniye) --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold">
                        Sınav Süresi (saniye) <span class="text-danger">*</span>
                    </label>
                    <asp:TextBox ID="txtSureSaniye" runat="server" CssClass="form-control"
                        TextMode="Number" placeholder="300"></asp:TextBox>
                    <div class="form-text text-muted">Örn: 300 = 5 dakika</div>
                    <asp:RequiredFieldValidator ID="rfvSure" runat="server"
                        ControlToValidate="txtSureSaniye"
                        CssClass="text-danger small"
                        ErrorMessage="Süre zorunludur."
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="rvSure" runat="server"
                        ControlToValidate="txtSureSaniye"
                        MinimumValue="30" MaximumValue="7200" Type="Integer"
                        CssClass="text-danger small"
                        ErrorMessage="30 ile 7200 saniye arasında olmalıdır."
                        Display="Dynamic">
                    </asp:RangeValidator>
                </div>

                <%-- Butonlar --%>
                <div class="d-flex gap-2">
                    <asp:Button ID="btnKaydet" runat="server" Text="Kaydet"
                        CssClass="btn btn-success"
                        OnClick="btnKaydet_Click" />
                    <asp:Button ID="btnIptal" runat="server" Text="İptal"
                        CssClass="btn btn-outline-secondary"
                        OnClick="btnIptal_Click"
                        CausesValidation="false" />
                </div>

            </div>
        </div>

        <%-- SAĞ: KATEGORİ LİSTESİ --%>
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <asp:GridView ID="gvKategoriler" runat="server"
                        CssClass="table table-hover table-bordered tablo-kategori mb-0"
                        AutoGenerateColumns="false"
                        GridLines="None"
                        EmptyDataText="Henüz kategori eklenmemiş."
                        OnRowCommand="gvKategoriler_RowCommand">

                        <HeaderStyle CssClass="table-dark" />
                        <EmptyDataRowStyle CssClass="text-center text-muted p-4" />

                        <Columns>

                            <asp:BoundField DataField="Id" HeaderText="#"
                                ItemStyle-Width="50px"
                                ItemStyle-CssClass="text-center text-muted" />

                            <asp:BoundField DataField="AdTR" HeaderText="Ad (TR)" />

                            <asp:BoundField DataField="AdEN" HeaderText="Ad (EN)" />

                            <asp:BoundField DataField="SoruSayisi" HeaderText="Soru Sayısı"
                                ItemStyle-Width="100px" ItemStyle-CssClass="text-center" />

                            <asp:TemplateField HeaderText="Süre"
                                ItemStyle-Width="90px" ItemStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <%# SaniyeFormatla(Eval("SureSaniye")) %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="İşlemler"
                                ItemStyle-Width="110px" ItemStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <%-- Düzenle --%>
                                    <asp:LinkButton ID="lbDuzenle" runat="server"
                                        CommandName="Duzenle"
                                        CommandArgument='<%# Eval("Id") %>'
                                        CssClass="btn btn-outline-primary btn-sm me-1"
                                        title="Düzenle"
                                        CausesValidation="false">
                                        &#9998;
                                    </asp:LinkButton>
                                    <%-- Sil --%>
                                    <asp:LinkButton ID="lbSil" runat="server"
                                        CommandName="SilIste"
                                        CommandArgument='<%# Eval("Id") %>'
                                        CssClass="btn btn-outline-danger btn-sm"
                                        title="Sil"
                                        CausesValidation="false"
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

    </div><!-- /row -->
</div>

<%-- SİL ONAY MODAL --%>
<div class="modal fade" id="modalSil" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Kategoriyi Sil</h5>
                <button type="button" class="btn-close btn-close-white"
                        data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-warning mb-2">
                    <strong>&#9888; Dikkat!</strong>
                </div>
                Bu kategoriyi silerseniz <strong>tüm soruları ve sınav sonuçları</strong>
                da kalıcı olarak silinecektir. Bu işlem <strong>geri alınamaz</strong>.
                <br /><br />
                Devam etmek istediğinizden emin misiniz?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-sm"
                        data-bs-dismiss="modal">Vazgeç</button>
                <asp:Button ID="btnSilOnayla" runat="server"
                    Text="Evet, Kategoriyi Sil"
                    CssClass="btn btn-danger btn-sm"
                    OnClick="btnSilOnayla_Click"
                    CausesValidation="false" />
            </div>
        </div>
    </div>
</div>

<asp:HiddenField ID="hfSilinecekId" runat="server" Value="0" />

<script>
    function kategoriSilModalAc(id) {
        document.getElementById('<%= hfSilinecekId.ClientID %>').value = id;
        new bootstrap.Modal(document.getElementById('modalSil')).show();
    }
</script>

</asp:Content>
