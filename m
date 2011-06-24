From: John Haxby <john.haxby@oracle.com>
Subject: [PATCH 1/2] Use %pI4/%pI6c instead of NIPQUAD_FMT/NIP6_FMT and make IPv6 work
Date: Fri, 24 Jun 2011 14:14:13 +0100
Message-ID: <ecfd8eafa3450afcd9f0fec1413b9dd725e757e2.1308920081.git.john.haxby@oracle.com>
References: <cover.1308920081.git.john.haxby@oracle.com>
Cc: prarit@redhat.com, John Haxby <john.haxby@oracle.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:45895 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab1FXNRn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:17:43 -0400
In-Reply-To: <cover.1308920081.git.john.haxby@oracle.com>
In-Reply-To: <cover.1308920081.git.john.haxby@oracle.com>
References: <cover.1308920081.git.john.haxby@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IPv6 sysrq never worked because of bad pointer arithmetic.  The
debug output now uses %pI4 nd %pI6c and also records the destination
address as well as the source.
---
 extensions/xt_SYSRQ.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/extensions/xt_SYSRQ.c b/extensions/xt_SYSRQ.c
index d8c0100..723e813 100644
--- a/extensions/xt_SYSRQ.c
+++ b/extensions/xt_SYSRQ.c
@@ -220,9 +220,9 @@ sysrq_tg4(struct sk_buff **pskb, const struct xt_action_param *par)
 
 	if (sysrq_debug)
 		printk(KERN_INFO KBUILD_MODNAME
-		       ": " NIPQUAD_FMT ":%u -> :%u len=%u\n",
-		       NIPQUAD(iph->saddr), htons(udph->source),
-		       htons(udph->dest), len);
+		       ": %pI4:%u -> %pI4:%u len=%u\n",
+		       &iph->saddr, htons(udph->source),
+		       &iph->daddr, htons(udph->dest), len);
 	return sysrq_tg((void *)udph + sizeof(struct udphdr), len);
 }
 
@@ -250,10 +250,10 @@ sysrq_tg6(struct sk_buff **pskb, const struct xt_action_param *par)
 
 	if (sysrq_debug)
 		printk(KERN_INFO KBUILD_MODNAME
-		       ": " NIP6_FMT ":%hu -> :%hu len=%u\n",
-		       NIP6(iph->saddr), ntohs(udph->source),
-		       ntohs(udph->dest), len);
-	return sysrq_tg(udph + sizeof(struct udphdr), len);
+		       ": [%pI6c]:%hu -> [%pI6c]:%hu len=%u\n",
+		       &iph->saddr, ntohs(udph->source),
+		       &iph->daddr, ntohs(udph->dest), len);
+	return sysrq_tg((void *)udph + sizeof(struct udphdr), len);
 }
 #endif
 
-- 
1.7.5.4

