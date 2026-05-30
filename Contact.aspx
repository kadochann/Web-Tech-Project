<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="Project.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="row justify-content-center" style="padding-top:48px;">
    <div class="col-md-6 col-lg-5">

        <div class="mb-4">
            <p style="font-size:.8rem;color:var(--text-muted);font-weight:600;text-transform:uppercase;letter-spacing:.8px;margin-bottom:4px;">Sayfa</p>
            <h2 style="font-weight:800;font-size:1.8rem;letter-spacing:-.5px;"><%: Title %></h2>
        </div>

        <div class="card">
            <div class="card-body">

                <h5 style="font-weight:700;margin-bottom:16px;color:var(--text-secondary);">
                    <i class="bi bi-geo-alt-fill me-2" style="color:var(--primary);"></i>Adres
                </h5>
                <address style="font-style:normal;color:var(--text-secondary);line-height:1.8;margin-bottom:24px;">
                    One Microsoft Way<br />
                    Redmond, WA 98052-6399<br />
                    <span style="color:var(--text-muted);font-size:.875rem;"><abbr title="Phone">P:</abbr> 425.555.0100</span>
                </address>

                <h5 style="font-weight:700;margin-bottom:16px;color:var(--text-secondary);">
                    <i class="bi bi-envelope-fill me-2" style="color:var(--primary);"></i>E-posta
                </h5>
                <address style="font-style:normal;line-height:2;">
                    <span style="color:var(--text-muted);font-size:.85rem;font-weight:600;">Destek:</span>
                    <a href="mailto:Support@example.com" style="color:var(--primary);text-decoration:none;margin-left:8px;">Support@example.com</a><br />
                    <span style="color:var(--text-muted);font-size:.85rem;font-weight:600;">Pazarlama:</span>
                    <a href="mailto:Marketing@example.com" style="color:var(--primary);text-decoration:none;margin-left:8px;">Marketing@example.com</a>
                </address>

            </div>
        </div>
    </div>
</div>
</asp:Content>