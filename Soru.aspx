<%@ Page Title="Soru" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Soru.aspx.cs" Inherits="Project.Soru" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="google-ad-container google-ad-top">
        <div class="google-ad-header">
            <span class="google-ad-badge">Sponsorlu</span>
            <span class="google-ad-powered">
                <svg class="google-ad-logo" viewBox="0 0 48 48" width="14" height="14"><circle cx="24" cy="24" r="22" fill="#4285F4"/><text x="50%" y="55%" text-anchor="middle" fill="white" font-size="24" font-weight="bold" dominant-baseline="middle">G</text></svg>
                Google Ads
            </span>
        </div>
        <div class="google-ad-cards">
            <div class="google-ad-card" onclick="window.open('https://mediamarkt.com.tr','_blank')">
                <div class="google-ad-card-icon"><i class="bi bi-cpu-fill"></i></div>
                <div class="google-ad-card-content">
                    <div class="google-ad-card-title">Teknoloji Fırsatları - MediaMarkt</div>
                    <div class="google-ad-card-desc">En son teknoloji ürünlerinde kaçırılmayacak fırsatlar!</div>
                    <div class="google-ad-card-link">mediamarkt.com.tr <i class="bi bi-box-arrow-up-right"></i></div>
                </div>
            </div>
            <div class="google-ad-card" onclick="window.open('https://samsung.com/tr','_blank')">
                <img src='<%= ResolveUrl("~/images/phone_1.jpg") %>' alt="Ad Icon" style="width:42px;height:42px;border-radius:8px;object-fit:cover;flex-shrink:0;" />
                <div class="google-ad-card-content">
                    <div class="google-ad-card-title">Samsung Galaxy S24 Ultra</div>
                    <div class="google-ad-card-desc">Yapay zeka destekli yeni nesil akıllı telefon.</div>
                    <div class="google-ad-card-link">samsung.com/tr <i class="bi bi-box-arrow-up-right"></i></div>
                </div>
            </div>
            <div class="google-ad-card" onclick="window.open('https://boyner.com.tr','_blank')">
                <div class="google-ad-card-icon"><i class="bi bi-percent"></i></div>
                <div class="google-ad-card-content">
                    <div class="google-ad-card-title">Sezon Sonu İndirimi - %80'e Varan</div>
                    <div class="google-ad-card-desc">Moda markalarında büyük sezon sonu indirimi!</div>
                    <div class="google-ad-card-link">boyner.com.tr <i class="bi bi-box-arrow-up-right"></i></div>
                </div>
            </div>
        </div>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <p style="font-size:.8rem;color:var(--text-muted);font-weight:600;text-transform:uppercase;letter-spacing:.8px;margin-bottom:4px;">
                <%= GetGlobalResourceObject("Resources","Question") %>
            </p>
            <h2 style="font-weight:800;font-size:1.5rem;letter-spacing:-.5px;margin:0;">
                <asp:Label ID="lblQuestionNumber" runat="server"></asp:Label>
            </h2>
        </div>
        <div class="timer-box">
            <i class="bi bi-alarm" style="color:var(--primary);"></i>
            <%= GetGlobalResourceObject("Resources","TimeLeft") %>:
            <span id="timer">05:00</span>
        </div>
    </div>

    <asp:Label ID="lblWarning" runat="server" CssClass="text-danger fw-semibold d-block mb-3"></asp:Label>

    <div class="question-card mb-4">
        <h4><asp:Label ID="lblQuestionText" runat="server"></asp:Label></h4>
        <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="mb-4" RepeatDirection="Vertical"></asp:RadioButtonList>

        <div class="d-flex justify-content-between align-items-center pt-3" style="border-top:1px solid var(--border);">
            <asp:Button ID="btnPrevious" runat="server" Text="← Geri" CssClass="btn btn-outline-secondary" OnClick="btnPrevious_Click" />
            <div class="d-flex gap-2">
                <asp:Button ID="btnNext" runat="server" Text="İleri →" CssClass="btn btn-primary" OnClick="btnNext_Click" />
                <asp:Button ID="btnFinish" runat="server" ClientIDMode="Static"
                    Text="✓ Sınavı Bitir"
                    CssClass="btn btn-success"
                    OnClientClick="sessionStorage.removeItem('remainingSeconds');"
                    OnClick="btnFinish_Click" />
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfRemainingSeconds" runat="server" ClientIDMode="Static" />

    <div class="google-ad-container google-ad-bottom">
        <div class="google-ad-header">
            <span class="google-ad-badge">Sponsorlu</span>
            <span class="google-ad-powered">
                <svg class="google-ad-logo" viewBox="0 0 48 48" width="14" height="14"><circle cx="24" cy="24" r="22" fill="#4285F4"/><text x="50%" y="55%" text-anchor="middle" fill="white" font-size="24" font-weight="bold" dominant-baseline="middle">G</text></svg>
                Google Ads
            </span>
        </div>
        <div class="google-ad-display-grid">
            <div class="google-ad-display" onclick="window.open('https://trendyol.com','_blank')">
                <img src='<%= ResolveUrl("~/images/cloth_2.jpg") %>' alt="Trendyol" style="width:100%;height:100px;object-fit:cover;display:block;" />
                <div class="google-ad-display-info"><strong>Trendyol</strong><small>%70'e varan indirim fırsatları</small></div>
            </div>
            <div class="google-ad-display" onclick="window.open('https://hepsiburada.com','_blank')">
                <img src='<%= ResolveUrl("~/images/shoes_1.jpg") %>' alt="Hepsiburada" style="width:100%;height:100px;object-fit:cover;display:block;" />
                <div class="google-ad-display-info"><strong>Hepsiburada</strong><small>50 TL anında indirim kuponu</small></div>
            </div>
            <div class="google-ad-display" onclick="window.open('https://amazon.com.tr','_blank')">
                <img src='<%= ResolveUrl("~/images/watch_1.jpg") %>' alt="Amazon" style="width:100%;height:100px;object-fit:cover;display:block;" />
                <div class="google-ad-display-info"><strong>Amazon.com.tr</strong><small>Prime üyelere özel ayrıcalıklar</small></div>
            </div>
            <div class="google-ad-display" onclick="window.open('https://n11.com','_blank')">
                <img src='<%= ResolveUrl("~/images/home_1.jpg") %>' alt="N11" style="width:100%;height:100px;object-fit:cover;display:block;" />
                <div class="google-ad-display-info"><strong>N11.com</strong><small>12 aya varan taksit seçenekleri</small></div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Scripts" runat="server">
<script>
    let remainingSeconds = sessionStorage.getItem("remainingSeconds");
    if (remainingSeconds === null) {
        remainingSeconds = typeof initialRemainingSeconds !== 'undefined' ? initialRemainingSeconds : 300;
    } else {
        remainingSeconds = parseInt(remainingSeconds);
    }

    function updateTimer() {
        let minutes = Math.floor(remainingSeconds / 60);
        let seconds = remainingSeconds % 60;
        document.getElementById("timer").innerText =
            String(minutes).padStart(2, "0") + ":" + String(seconds).padStart(2, "0");

        // Kırmızı uyarı son 60 saniyede
        if (remainingSeconds <= 60) {
            document.getElementById("timer").style.color = "var(--danger)";
        }

        let hf = document.getElementById("hfRemainingSeconds");
        if (hf) hf.value = remainingSeconds;

        if (remainingSeconds <= 0) {
            sessionStorage.removeItem("remainingSeconds");
            let btn = document.getElementById("btnFinish");
            if (btn) btn.click();
        } else {
            sessionStorage.setItem("remainingSeconds", remainingSeconds);
            remainingSeconds--;
        }
    }

    setInterval(updateTimer, 1000);
    updateTimer();

    document.addEventListener("visibilitychange", function () {
        if (document.hidden) {
            fetch('Soru.aspx/IncrementWarningCount', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=utf-8' },
                body: '{}'
            })
                .then(r => r.json())
                .then(data => {
                    let w = parseInt(data.d);
                    if (w >= 3) {
                        alert("Sınav ekranından 3 kez ayrıldığınız için sınavınız sonlandırılmıştır.");
                        sessionStorage.removeItem("remainingSeconds");
                        let btn = document.getElementById("btnFinish");
                        if (btn) btn.click();
                    } else {
                        alert("Sınav ekranından ayrıldınız! Uyarı " + w + " / 3.");
                    }
                })
                .catch(err => console.error("Warning count error", err));
        }
    });
</script>
</asp:Content>