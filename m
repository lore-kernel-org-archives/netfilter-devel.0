From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH v2 1/6] netfilter: tarpit: Move XTTARPIT_TARPIT mode processing to its own function
Date: Sun,  8 Jul 2012 11:11:20 -0700
Message-ID: <1341771085-5771-2-git-send-email-johunt@akamai.com>
References: <1341771085-5771-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: jengelh@inai.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:41152 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148Ab2GHSL0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jul 2012 14:11:26 -0400
In-Reply-To: <1341771085-5771-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Moves the XTTARPIT_TARPIT mode processing to its own function.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 extensions/xt_TARPIT.c |   48 ++++++++++++++++++++++++++++--------------------
 1 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/extensions/xt_TARPIT.c b/extensions/xt_TARPIT.c
index db24f90..3cb61ac 100644
--- a/extensions/xt_TARPIT.c
+++ b/extensions/xt_TARPIT.c
@@ -51,6 +51,33 @@
 #include "compat_xtables.h"
 #include "xt_TARPIT.h"
 
+static bool xttarpit_tarpit(struct tcphdr *oth, struct tcphdr *tcph) {
+
+	/* No replies for RST, FIN or !SYN,!ACK */
+	if (oth->rst || oth->fin || (!oth->syn && !oth->ack))
+		return false;
+	tcph->seq = oth->ack ? oth->ack_seq : 0;
+
+	/* Our SYN-ACKs must have a >0 window */
+	tcph->window  = (oth->syn && !oth->ack) ? htons(5) : 0;
+	if (oth->syn && oth->ack) {
+		tcph->rst     = true;
+		tcph->ack_seq = false;
+	} else {
+		tcph->syn     = oth->syn;
+		tcph->ack     = true;
+		tcph->ack_seq = htonl(ntohl(oth->seq) + oth->syn);
+	}
+#if 0
+	/* Rate-limit replies to !SYN,ACKs */
+	if (!oth->syn && oth->ack)
+		if (!xrlim_allow(rt_dst(ort), HZ))
+			return;
+#endif
+
+	return true;
+}
+
 static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
     unsigned int mode)
 {
@@ -117,27 +144,8 @@ static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
 	((u_int8_t *)tcph)[13] = 0;
 
 	if (mode == XTTARPIT_TARPIT) {
-		/* No replies for RST, FIN or !SYN,!ACK */
-		if (oth->rst || oth->fin || (!oth->syn && !oth->ack))
+		if (!xttarpit_tarpit(oth, tcph))
 			return;
-		tcph->seq = oth->ack ? oth->ack_seq : 0;
-
-		/* Our SYN-ACKs must have a >0 window */
-		tcph->window  = (oth->syn && !oth->ack) ? htons(5) : 0;
-		if (oth->syn && oth->ack) {
-			tcph->rst     = true;
-			tcph->ack_seq = false;
-		} else {
-			tcph->syn     = oth->syn;
-			tcph->ack     = true;
-			tcph->ack_seq = htonl(ntohl(oth->seq) + oth->syn);
-		}
-#if 0
-		/* Rate-limit replies to !SYN,ACKs */
-		if (!oth->syn && oth->ack)
-			if (!xrlim_allow(rt_dst(ort), HZ))
-				return;
-#endif
 	} else if (mode == XTTARPIT_HONEYPOT) {
 		/* Do not answer any resets regardless of combination */
 		if (oth->rst || oth->seq == 0xDEADBEEF)
-- 
1.7.0.4

