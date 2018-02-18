From: Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] extenstions: ecn: add tcp ecn/cwr translation
Date: Sun, 18 Feb 2018 10:24:47 +0100
Message-ID: <20180218092447.17730-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56766 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751238AbeBRJZx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Feb 2018 04:25:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft can match tcp flags, so add ece/cwr translation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_ecn.c      | 50 +++++++++++++++++++++++++++++----------------
 extensions/libxt_ecn.txlate |  6 ++++++
 2 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/extensions/libxt_ecn.c b/extensions/libxt_ecn.c
index aeba01b348a1..a6378b0e4586 100644
--- a/extensions/libxt_ecn.c
+++ b/extensions/libxt_ecn.c
@@ -124,27 +124,41 @@ static int ecn_xlate(struct xt_xlate *xl,
 	const struct xt_ecn_info *einfo =
 		(const struct xt_ecn_info *)params->match->data;
 
-	if (!(einfo->operation & XT_ECN_OP_MATCH_IP))
-		return 0;
+	if (einfo->operation & XT_ECN_OP_MATCH_ECE) {
+		xt_xlate_add(xl, "tcp flags ");
+		if (einfo->invert)
+			xt_xlate_add(xl,"!= ");
+		xt_xlate_add(xl, "ecn");
+	}
 
-	xt_xlate_add(xl, "ip ecn ");
-	if (einfo->invert)
-		xt_xlate_add(xl,"!= ");
+	if (einfo->operation & XT_ECN_OP_MATCH_CWR) {
+		xt_xlate_add(xl, "tcp flags ");
+		if (einfo->invert)
+			xt_xlate_add(xl,"!= ");
+		xt_xlate_add(xl, "cwr");
+	}
 
-	switch (einfo->ip_ect) {
-	case 0:
-		xt_xlate_add(xl, "not-ect");
-		break;
-	case 1:
-		xt_xlate_add(xl, "ect1");
-		break;
-	case 2:
-		xt_xlate_add(xl, "ect0");
-		break;
-	case 3:
-		xt_xlate_add(xl, "ce");
-		break;
+	if (einfo->operation & XT_ECN_OP_MATCH_IP) {
+		xt_xlate_add(xl, "ip ecn ");
+		if (einfo->invert)
+			xt_xlate_add(xl,"!= ");
+
+		switch (einfo->ip_ect) {
+		case 0:
+			xt_xlate_add(xl, "not-ect");
+			break;
+		case 1:
+			xt_xlate_add(xl, "ect1");
+			break;
+		case 2:
+			xt_xlate_add(xl, "ect0");
+			break;
+		case 3:
+			xt_xlate_add(xl, "ce");
+			break;
+		}
 	}
+
 	return 1;
 }
 
diff --git a/extensions/libxt_ecn.txlate b/extensions/libxt_ecn.txlate
index 9e3bd3109093..f012f1282a21 100644
--- a/extensions/libxt_ecn.txlate
+++ b/extensions/libxt_ecn.txlate
@@ -21,3 +21,9 @@ nft add rule ip filter INPUT ip ecn != ect0 counter
 
 iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 3
 nft add rule ip filter INPUT ip ecn != ce counter
+
+iptables-translate -A INPUT -m ecn ! --ecn-tcp-ece
+nft add rule ip filter INPUT tcp flags != ecn counter
+
+iptables-translate -A INPUT -m ecn --ecn-tcp-cwr
+nft add rule ip filter INPUT tcp flags cwr counter
-- 
2.16.1

