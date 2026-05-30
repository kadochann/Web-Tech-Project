<%@ Page Title="<%$ Resources:Resources, HataTitle %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Hata.aspx.cs" Inherits="OnlineSinavSistemi.Hata" %>

<asp:Content ID="HataContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="row justify-content-center" style="padding-top:64px;">
    <div class="col-md-6 col-lg-5 text-center">

        <div style="font-size:5rem;line-height:1;margin-bottom:24px;">⚠️</div>

        <h2 style="font-weight:800;font-size:1.8rem;color:var(--danger);margin-bottom:12px;">
            <asp:Literal ID="ltHataBaslik" runat="server" Text="<%$ Resources:Resources, HataBaslik %>" />
        </h2>

        <p style="color:var(--text-secondary);font-size:1rem;margin-bottom:36px;">
            <asp:Literal ID="ltHataMesaj" runat="server" Text="<%$ Resources:Resources, HataMesaj %>" />
        </p>

        <a href="Default.aspx" class="btn btn-primary btn-lg">
            <i class="bi bi-house-fill me-2"></i>
            <asp:Literal ID="ltAnaSayfa" runat="server" Text="<%$ Resources:Resources, AnaSayfa %>" />
        </a>

    </div>
</div>
</asp:Content>