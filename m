Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964B5118
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 08:13:35 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
	id 2B02158B194F4; Sat, 25 Nov 2023 17:13:32 +0100 (CET)
X-Spam-Level: 
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
	by a3.inai.de (Postfix) with ESMTP id 6876E58B194F3
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 17:13:30 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH] man: proper roff encoding for ~ and ^
Date: Sat, 25 Nov 2023 17:12:50 +0100
Message-ID: <20231125161326.77308-1-jengelh@inai.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: v1.8.10-28-g4b0c168a
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
I thought I had read the groff_char manual, but perhaps too hastily.

 extensions/libxt_CONNMARK.man |  4 ++--
 extensions/libxt_NFLOG.man    |  2 +-
 iptables/ebtables-nft.8       |  2 +-
 iptables/xtables-nft.8        | 16 ++++++++--------
 iptables/xtables-translate.8  | 16 ++++++++--------
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/extensions/libxt_CONNMARK.man b/extensions/libxt_CONNMARK.man
index 742df11d..ccd7da61 100644
--- a/extensions/libxt_CONNMARK.man
+++ b/extensions/libxt_CONNMARK.man
@@ -8,7 +8,7 @@ Zero out the bits given by \fImask\fP and XOR \fIvalue\fP into the ctmark.
 Copy the packet mark (nfmark) to the connection mark (ctmark) using the given
 masks. The new nfmark value is determined as follows:
 .IP
-ctmark = (ctmark & \~ctmask) \^ (nfmark & nfmask)
+ctmark = (ctmark & \(tictmask) \(ha (nfmark & nfmask)
 .IP
 i.e. \fIctmask\fP defines what bits to clear and \fInfmask\fP what bits of the
 nfmark to XOR into the ctmark. \fIctmask\fP and \fInfmask\fP default to
@@ -18,7 +18,7 @@ nfmark to XOR into the ctmark. \fIctmask\fP and \fInfmask\fP default to
 Copy the connection mark (ctmark) to the packet mark (nfmark) using the given
 masks. The new ctmark value is determined as follows:
 .IP
-nfmark = (nfmark & \~\fInfmask\fP) \^ (ctmark & \fIctmask\fP);
+nfmark = (nfmark & \(ti\fInfmask\fP) \(ha (ctmark & \fIctmask\fP);
 .IP
 i.e. \fInfmask\fP defines what bits to clear and \fIctmask\fP what bits of the
 ctmark to XOR into the nfmark. \fIctmask\fP and \fInfmask\fP default to
diff --git a/extensions/libxt_NFLOG.man b/extensions/libxt_NFLOG.man
index 43629893..86ebb210 100644
--- a/extensions/libxt_NFLOG.man
+++ b/extensions/libxt_NFLOG.man
@@ -9,7 +9,7 @@ may subscribe to the group to receive the packets. Like LOG, this is a
 non-terminating target, i.e. rule traversal continues at the next rule.
 .TP
 \fB\-\-nflog\-group\fP \fInlgroup\fP
-The netlink group (0\(en2\^16\-1) to which packets are (only applicable for
+The netlink group (0\(en2\(ha16\-1) to which packets are (only applicable for
 nfnetlink_log). The default value is 0.
 .TP
 \fB\-\-nflog\-prefix\fP \fIprefix\fP
diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index 641008cf..60cf2d61 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -858,7 +858,7 @@ Log with the default logging options
 .TP
 .B --nflog-group "\fInlgroup\fP"
 .br
-The netlink group (1\(en2\^32\-1) to which packets are (only applicable for
+The netlink group (1\(en2\(ha32\-1) to which packets are (only applicable for
 nfnetlink_log). The default value is 1.
 .TP
 .B --nflog-prefix "\fIprefix\fP"
diff --git a/iptables/xtables-nft.8 b/iptables/xtables-nft.8
index 3ced29ca..ae54476c 100644
--- a/iptables/xtables-nft.8
+++ b/iptables/xtables-nft.8
@@ -105,15 +105,15 @@ One basic example is creating the skeleton ruleset in nf_tables from the
 xtables-nft tools, in a fresh machine:
 
 .nf
-	root@machine:\~# iptables\-nft \-L
+	root@machine:\(ti# iptables\-nft \-L
 	[...]
-	root@machine:\~# ip6tables\-nft \-L
+	root@machine:\(ti# ip6tables\-nft \-L
 	[...]
-	root@machine:\~# arptables\-nft \-L
+	root@machine:\(ti# arptables\-nft \-L
 	[...]
-	root@machine:\~# ebtables\-nft \-L
+	root@machine:\(ti# ebtables\-nft \-L
 	[...]
-	root@machine:\~# nft list ruleset
+	root@machine:\(ti# nft list ruleset
 	table ip filter {
 		chain INPUT {
 			type filter hook input priority 0; policy accept;
@@ -175,12 +175,12 @@ To migrate your complete filter ruleset, in the case of \fBiptables(8)\fP,
 you would use:
 
 .nf
-	root@machine:\~# iptables\-legacy\-save > myruleset # reads from x_tables
-	root@machine:\~# iptables\-nft\-restore myruleset   # writes to nf_tables
+	root@machine:\(ti# iptables\-legacy\-save > myruleset # reads from x_tables
+	root@machine:\(ti# iptables\-nft\-restore myruleset   # writes to nf_tables
 .fi
 or
 .nf
-	root@machine:\~# iptables\-legacy\-save | iptables\-translate\-restore | less
+	root@machine:\(ti# iptables\-legacy\-save | iptables\-translate\-restore | less
 .fi
 
 to see how rules would look like in the nft
diff --git a/iptables/xtables-translate.8 b/iptables/xtables-translate.8
index fe127887..6fbbd617 100644
--- a/iptables/xtables-translate.8
+++ b/iptables/xtables-translate.8
@@ -73,18 +73,18 @@ Basic operation examples.
 Single command translation:
 
 .nf
-root@machine:\~# iptables\-translate \-A INPUT \-p tcp \-\-dport 22 \-m conntrack \-\-ctstate NEW \-j ACCEPT
+root@machine:\(ti# iptables\-translate \-A INPUT \-p tcp \-\-dport 22 \-m conntrack \-\-ctstate NEW \-j ACCEPT
 nft add rule ip filter INPUT tcp dport 22 ct state new counter accept
 
-root@machine:\~# ip6tables\-translate \-A FORWARD \-i eth0 \-o eth3 \-p udp \-m multiport \-\-dports 111,222 \-j ACCEPT
+root@machine:\(ti# ip6tables\-translate \-A FORWARD \-i eth0 \-o eth3 \-p udp \-m multiport \-\-dports 111,222 \-j ACCEPT
 nft add rule ip6 filter FORWARD iifname eth0 oifname eth3 meta l4proto udp udp dport { 111,222} counter accept
 .fi
 
 Whole ruleset translation:
 
 .nf
-root@machine:\~# iptables\-save > save.txt
-root@machine:\~# cat save.txt
+root@machine:\(ti# iptables\-save > save.txt
+root@machine:\(ti# cat save.txt
 # Generated by iptables\-save v1.6.0 on Sat Dec 24 14:26:40 2016
 *filter
 :INPUT ACCEPT [5166:1752111]
@@ -94,7 +94,7 @@ root@machine:\~# cat save.txt
 COMMIT
 # Completed on Sat Dec 24 14:26:40 2016
 
-root@machine:\~# iptables\-restore\-translate \-f save.txt
+root@machine:\(ti# iptables\-restore\-translate \-f save.txt
 # Translated by iptables\-restore\-translate v1.6.0 on Sat Dec 24 14:26:59 2016
 add table ip filter
 add chain ip filter INPUT { type filter hook input priority 0; }
@@ -102,9 +102,9 @@ add chain ip filter FORWARD { type filter hook forward priority 0; }
 add chain ip filter OUTPUT { type filter hook output priority 0; }
 add rule ip filter FORWARD tcp dport 22 ct state new counter accept
 
-root@machine:\~# iptables\-restore\-translate \-f save.txt > ruleset.nft
-root@machine:\~# nft \-f ruleset.nft
-root@machine:\~# nft list ruleset
+root@machine:\(ti# iptables\-restore\-translate \-f save.txt > ruleset.nft
+root@machine:\(ti# nft \-f ruleset.nft
+root@machine:\(ti# nft list ruleset
 table ip filter {
 	chain INPUT {
 		type filter hook input priority 0; policy accept;
-- 
2.43.0

