From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH v2 4/6] netfilter: tarpit: Make tarpit code generic
Date: Sun,  8 Jul 2012 11:11:23 -0700
Message-ID: <1341771085-5771-5-git-send-email-johunt@akamai.com>
References: <1341771085-5771-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: jengelh@inai.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:39591 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440Ab2GHSL0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jul 2012 14:11:26 -0400
In-Reply-To: <1341771085-5771-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Creates a generic function to perform the tcp header manipulation in. Done
in preparation for IPv6 support. This allows us to share code between v4 and
v6 processing.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 extensions/xt_TARPIT.c |   33 +++++++++++++++++++++++----------
 1 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/extensions/xt_TARPIT.c b/extensions/xt_TARPIT.c
index 5d8af70..528c012 100644
--- a/extensions/xt_TARPIT.c
+++ b/extensions/xt_TARPIT.c
@@ -146,6 +146,27 @@ static bool xttarpit_reset(struct tcphdr *oth, struct tcphdr *tcph)
 	return true;
 }
 
+static bool tarpit_generic(struct tcphdr *oth, struct tcphdr *tcph, uint16_t payload,
+	unsigned int mode)
+{
+	switch(mode) {
+	case XTTARPIT_TARPIT:
+		if (!xttarpit_tarpit(oth, tcph))
+			return false;
+		break;
+	case XTTARPIT_HONEYPOT:
+		if (!xttarpit_honeypot(oth, tcph, payload))
+			return false;
+		break;
+	case XTTARPIT_RESET:
+		if (!xttarpit_reset(oth, tcph))
+			return false;
+		break;
+	}
+
+	return true;
+}
+
 static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
     unsigned int mode)
 {
@@ -211,16 +232,8 @@ static void tarpit_tcp(struct sk_buff *oldskb, unsigned int hook,
 	/* Reset flags */
 	((u_int8_t *)tcph)[13] = 0;
 
-	if (mode == XTTARPIT_TARPIT) {
-		if (!xttarpit_tarpit(oth, tcph))
-			return;
-	} else if (mode == XTTARPIT_HONEYPOT) {
-		if (!xttarpit_honeypot(oth, tcph, payload))
-			return;
-	} else if (mode == XTTARPIT_RESET) {
-		if (!xttarpit_reset(oth, tcph))
-			return;
-	}
+	if (!tarpit_generic(oth, tcph, payload, mode))
+		return;
 
 	/* Adjust TCP checksum */
 	tcph->check = 0;
-- 
1.7.0.4

