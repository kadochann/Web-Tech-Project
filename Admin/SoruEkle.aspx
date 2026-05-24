<%@ Page Title="Soru Ekle / Düzenle" Language="C#" MasterPageFile="~/MasterPage.Master"
    AutoEventWireup="true" CodeFile="SoruEkle.aspx.cs" Inherits="Admin_SoruEkle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="container my-4">

    <div class="d-flex align-items-center justify-content-between mb-3">
        <h4 class="mb-0">
            <asp:Label ID="lblBaslik" runat="server" Text="Yeni Soru Ekle"></asp:Label>
        </h4>
        <a href="SoruListe.aspx" class="btn btn-outline-secondary btn-sm">
            &larr; Soru Listesine Dön
        </a>
    </div>

    <%-- Bildirim mesajı --%>
    <asp:Label ID="lblMesaj" runat="server" Visible="false" CssClass="alert d-block mb-3" Text=""></asp:Label>

    <div class="card shadow-sm">
        <div class="card-body">

            <%-- KATEGORİ --%>
            <div class="mb-3">
                <label for="ddlKategori" class="form-label fw-semibold">
                    Kategori <span class="text-danger">*</span>
                </label>
                <asp:DropDownList ID="ddlKategori" runat="server" CssClass="form-select">
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvKategori" runat="server"
                    ControlToValidate="ddlKategori"
                    InitialValue="0"
                    CssClass="text-danger small"
                    ErrorMessage="Lütfen bir kategori seçin."
                    Display="Dynamic">
                </asp:RequiredFieldValidator>
            </div>

            <hr class="my-4" />

            <%-- SORU METİNLERİ --%>
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Soru Metni (TR) <span class="text-danger">*</span>
                    </label>
                    <asp:TextBox ID="txtSoruTR" runat="server" TextMode="MultiLine"
                        Rows="4" CssClass="form-control"
                        placeholder="Türkçe soru metnini buraya girin...">
                    </asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSoruTR" runat="server"
                        ControlToValidate="txtSoruTR"
                        CssClass="text-danger small"
                        ErrorMessage="Türkçe soru metni zorunludur."
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold text-secondary">
                        Soru Metni (EN) <span class="text-muted small fw-normal">(opsiyonel)</span>
                    </label>
                    <asp:TextBox ID="txtSoruEN" runat="server" TextMode="MultiLine"
                        Rows="4" CssClass="form-control"
                        placeholder="English question text (optional)...">
                    </asp:TextBox>
                </div>
            </div>

            <hr class="my-4" />

            <%-- ŞIKLAR — BAŞLIK --%>
            <div class="row mb-2">
                <div class="col-1 text-center fw-bold text-muted"></div>
                <div class="col-5 fw-semibold">Türkçe Şık <span class="text-danger">*</span></div>
                <div class="col-5 fw-semibold text-secondary">
                    İngilizce Şık <span class="text-muted small fw-normal">(opsiyonel)</span>
                </div>
                <div class="col-1 text-center fw-semibold text-success">Doğru</div>
            </div>

            <%-- ŞIK A --%>
            <div class="row align-items-center mb-2">
                <div class="col-1 text-center">
                    <span class="badge bg-primary rounded-pill">A</span>
                </div>
                <div class="col-5">
                    <asp:TextBox ID="txtSecenekATR" runat="server" CssClass="form-control"
                        placeholder="A şıkkı (TR)"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvATR" runat="server"
                        ControlToValidate="txtSecenekATR"
                        CssClass="text-danger small" ErrorMessage="A şıkkı (TR) zorunludur."
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="col-5">
                    <asp:TextBox ID="txtSecenekAEN" runat="server" CssClass="form-control"
                        placeholder="Option A (EN)"></asp:TextBox>
                </div>
                <div class="col-1 text-center">
                    <asp:RadioButton ID="rbA" runat="server" GroupName="DogruCevap" value="A" />
                </div>
            </div>

            <%-- ŞIK B --%>
            <div class="row align-items-center mb-2">
                <div class="col-1 text-center">
                    <span class="badge bg-primary rounded-pill">B</span>
                </div>
                <div class="col-5">
                    <asp:TextBox ID="txtSecenekBTR" runat="server" CssClass="form-control"
                        placeholder="B şıkkı (TR)"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvBTR" runat="server"
                        ControlToValidate="txtSecenekBTR"
                        CssClass="text-danger small" ErrorMessage="B şıkkı (TR) zorunludur."
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="col-5">
                    <asp:TextBox ID="txtSecenekBEN" runat="server" CssClass="form-control"
                        placeholder="Option B (EN)"></asp:TextBox>
                </div>
                <div class="col-1 text-center">
                    <asp:RadioButton ID="rbB" runat="server" GroupName="DogruCevap" value="B" />
                </div>
            </div>

            <%-- ŞIK C --%>
            <div class="row align-items-center mb-2">
                <div class="col-1 text-center">
                    <span class="badge bg-primary rounded-pill">C</span>
                </div>
                <div class="col-5">
                    <asp:TextBox ID="txtSecenekCTR" runat="server" CssClass="form-control"
                        placeholder="C şıkkı (TR)"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCTR" runat="server"
                        ControlToValidate="txtSecenekCTR"
                        CssClass="text-danger small" ErrorMessage="C şıkkı (TR) zorunludur."
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="col-5">
                    <asp:TextBox ID="txtSecenekCEN" runat="server" CssClass="form-control"
                        placeholder="Option C (EN)"></asp:TextBox>
                </div>
                <div class="col-1 text-center">
                    <asp:RadioButton ID="rbC" runat="server" GroupName="DogruCevap" value="C" />
                </div>
            </div>

            <%-- ŞIK D --%>
            <div class="row align-items-center mb-2">
                <div class="col-1 text-center">
                    <span class="badge bg-primary rounded-pill">D</span>
                </div>
                <div class="col-5">
                    <asp:TextBox ID="txtSecenekDTR" runat="server" CssClass="form-control"
                        placeholder="D şıkkı (TR)"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDTR" runat="server"
                        ControlToValidate="txtSecenekDTR"
                        CssClass="text-danger small" ErrorMessage="D şıkkı (TR) zorunludur."
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="col-5">
                    <asp:TextBox ID="txtSecenekDEN" runat="server" CssClass="form-control"
                        placeholder="Option D (EN)"></asp:TextBox>
                </div>
                <div class="col-1 text-center">
                    <asp:RadioButton ID="rbD" runat="server" GroupName="DogruCevap" value="D" />
                </div>
            </div>

            <%-- Doğru cevap validasyon mesajı (server-side) --%>
            <asp:Label ID="lblDogruCevapHata" runat="server" Visible="false"
                CssClass="text-danger small d-block mt-1"
                Text="Lütfen doğru cevabı işaretleyin (A / B / C / D).">
            </asp:Label>

            <hr class="my-4" />

            <%-- KAYDET / İPTAL --%>
            <div class="d-flex gap-2">
                <asp:Button ID="btnKaydet" runat="server" Text="Kaydet"
                    CssClass="btn btn-success px-4"
                    OnClick="btnKaydet_Click" />
                <a href="SoruListe.aspx" class="btn btn-outline-secondary px-4">İptal</a>
            </div>

        </div>
    </div>
</div>

</asp:Content>
