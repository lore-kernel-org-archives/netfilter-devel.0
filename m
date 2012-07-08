From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH v2 3/6] netfilter: tarpit: Move XTTARPIT_RESET to its own function
Date: Sun,  8 Jul 2012 11:11:22 -0700
Message-ID: <1341771085-5771-4-git-send-email-johunt@akamai.com>
References: <1341771085-5771-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: jengelh@inai.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:41154 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629Ab2GHSL0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jul 2012 14:11:26 -0400
In-Reply-To: <1341771085-5771-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Moves XTTARPIT_RESET into its own function.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 extensions/xt_TARPIT.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/extensions/xt_TARPIT.c b/extensions/xt_TARPIT.c
index 6c75184..5d8af70 100644
--- a/extensions/xt_TARPIT.c
+++ b/extensions/xt_TARPIT.c
@@ -133,6 +133,19 @@ static bool xttarpit_honeypot(struct tcphdr *oth, struct tcphdr *tcph,
 	return true;
 }
 
+static bool xttarpit_reset(struct tcphdr *oth, struct tcphdr *tcph)
+{
+
+	tcph->window  = 0;
+	tcph->ack     = false;
+	tcph->syn     = false;
+	tcph->rst     = true;
+	tcph->seq     = oth->ack_seq;
+	tcph->ack_seq = oth->seq;
+
+	return true;
+}
+
 static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
     unsigned int mode)
 {
@@ -205,12 +218,8 @@ static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
 		if (!xttarpit_honeypot(oth, tcph, payload))
 			return;
 	} else if (mode == XTTARPIT_RESET) {
-		tcph->window  = 0;
-		tcph->ack     = false;
-		tcph->syn     = false;
-		tcph->rst     = true;
-		tcph->seq     = oth->ack_seq;
-		tcph->ack_seq = oth->seq;
+		if (!xttarpit_reset(oth, tcph))
+			return;
 	}
 
 	/* Adjust TCP checksum */
-- 
1.7.0.4

