From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 016/103] netfilter: iptables: remove unused datalen variable
Date: Tue,  4 Aug 2009 09:25:00 +0200
Message-ID: <1249370787-17583-17-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50622 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539AbZHDH0v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:51 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ip_tables.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index fdefae6..3856aa3 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -315,7 +315,6 @@ ipt_do_table(struct sk_buff *skb,
 
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	const struct iphdr *ip;
-	u_int16_t datalen;
 	bool hotdrop = false;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
 	unsigned int verdict = NF_DROP;
@@ -328,7 +327,6 @@ ipt_do_table(struct sk_buff *skb,
 
 	/* Initialization */
 	ip = ip_hdr(skb);
-	datalen = skb->len - ip->ihl * 4;
 	indev = in ? in->name : nulldevname;
 	outdev = out ? out->name : nulldevname;
 	/* We handle fragments by dealing with the first fragment as
@@ -427,8 +425,6 @@ ipt_do_table(struct sk_buff *skb,
 #endif
 		/* Target might have changed stuff. */
 		ip = ip_hdr(skb);
-		datalen = skb->len - ip->ihl * 4;
-
 		if (verdict == IPT_CONTINUE)
 			e = ipt_next_entry(e);
 		else
-- 
1.6.3.3

