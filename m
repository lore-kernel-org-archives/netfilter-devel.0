From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH v2 2/6] netfilter: tarpit: Move XTTARPIT_HONEYPOT mode into its own function
Date: Sun,  8 Jul 2012 11:11:21 -0700
Message-ID: <1341771085-5771-3-git-send-email-johunt@akamai.com>
References: <1341771085-5771-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: jengelh@inai.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:41155 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618Ab2GHSL0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jul 2012 14:11:26 -0400
In-Reply-To: <1341771085-5771-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Moves XTTARPIT_HONEYPOT into its own function.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 extensions/xt_TARPIT.c |  102 ++++++++++++++++++++++++++---------------------
 1 files changed, 56 insertions(+), 46 deletions(-)

diff --git a/extensions/xt_TARPIT.c b/extensions/xt_TARPIT.c
index 3cb61ac..6c75184 100644
--- a/extensions/xt_TARPIT.c
+++ b/extensions/xt_TARPIT.c
@@ -78,6 +78,61 @@ static bool xttarpit_tarpit(struct tcphdr *oth, struct tcphdr *tcph) {
 	return true;
 }
 
+static bool xttarpit_honeypot(struct tcphdr *oth, struct tcphdr *tcph,
+	uint16_t payload)
+{
+
+	/* Do not answer any resets regardless of combination */
+	if (oth->rst || oth->seq == 0xDEADBEEF)
+		return false;
+	/* Send a reset to scanners. They like that. */
+	if (oth->syn && oth->ack) {
+		tcph->window  = 0;
+		tcph->ack     = false;
+		tcph->psh     = true;
+		tcph->ack_seq = 0xdeadbeef; /* see if they ack it */
+		tcph->seq     = oth->ack_seq;
+		tcph->rst     = true;
+	}
+
+	/* SYN > SYN-ACK */
+	if (oth->syn && !oth->ack) {
+		tcph->syn     = true;
+		tcph->ack     = true;
+		tcph->window  = oth->window &
+			((net_random() & 0x1f) - 0xf);
+		tcph->seq     = htonl(net_random() & ~oth->seq);
+		tcph->ack_seq = htonl(ntohl(oth->seq) + oth->syn);
+	}
+
+	/* ACK > ACK */
+	if (oth->ack && (!(oth->fin || oth->syn))) {
+		tcph->syn     = false;
+		tcph->ack     = true;
+		tcph->window  = oth->window &
+			((net_random() & 0x1f) - 0xf);
+		tcph->ack_seq = payload > 100 ?
+			htonl(ntohl(oth->seq) + payload) :
+			oth->seq;
+		tcph->seq     = oth->ack_seq;
+	}
+
+	/*
+	* FIN > RST.
+	* We cannot terminate gracefully so just be abrupt.
+	*/
+	if (oth->fin) {
+		tcph->window  = 0;
+		tcph->seq     = oth->ack_seq;
+		tcph->ack_seq = oth->ack_seq;
+		tcph->fin     = false;
+		tcph->ack     = false;
+		tcph->rst     = true;
+	}
+
+	return true;
+}
+
 static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
     unsigned int mode)
 {
@@ -147,53 +202,8 @@ static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
 		if (!xttarpit_tarpit(oth, tcph))
 			return;
 	} else if (mode == XTTARPIT_HONEYPOT) {
-		/* Do not answer any resets regardless of combination */
-		if (oth->rst || oth->seq == 0xDEADBEEF)
+		if (!xttarpit_honeypot(oth, tcph, payload))
 			return;
-		/* Send a reset to scanners. They like that. */
-		if (oth->syn && oth->ack) {
-			tcph->window  = 0;
-			tcph->ack     = false;
-			tcph->psh     = true;
-			tcph->ack_seq = 0xdeadbeef; /* see if they ack it */
-			tcph->seq     = oth->ack_seq;
-			tcph->rst     = true;
-		}
-
-		/* SYN > SYN-ACK */
-		if (oth->syn && !oth->ack) {
-			tcph->syn     = true;
-			tcph->ack     = true;
-			tcph->window  = oth->window &
-			                ((net_random() & 0x1f) - 0xf);
-			tcph->seq     = htonl(net_random() & ~oth->seq);
-			tcph->ack_seq = htonl(ntohl(oth->seq) + oth->syn);
-		}
-
-		/* ACK > ACK */
-		if (oth->ack && (!(oth->fin || oth->syn))) {
-			tcph->syn     = false;
-			tcph->ack     = true;
-			tcph->window  = oth->window &
-			                ((net_random() & 0x1f) - 0xf);
-			tcph->ack_seq = payload > 100 ?
-			                htonl(ntohl(oth->seq) + payload) :
-			                oth->seq;
-			tcph->seq     = oth->ack_seq;
-		}
-
-		/*
-		 * FIN > RST.
-		 * We cannot terminate gracefully so just be abrupt.
-		 */
-		if (oth->fin) {
-			tcph->window  = 0;
-			tcph->seq     = oth->ack_seq;
-			tcph->ack_seq = oth->ack_seq;
-			tcph->fin     = false;
-			tcph->ack     = false;
-			tcph->rst     = true;
-		}
 	} else if (mode == XTTARPIT_RESET) {
 		tcph->window  = 0;
 		tcph->ack     = false;
-- 
1.7.0.4

