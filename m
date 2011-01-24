From: Thomas Jacob <jacob@internet24.de>
Subject: [PATCH] Incorrect xt_iprange boundary check for IPv6
Date: Mon, 24 Jan 2011 13:13:47 +0100
Message-ID: <1295871227-2545-2-git-send-email-jacob@internet24.de>
References: <1295871227-2545-1-git-send-email-jacob@internet24.de>
Cc: Thomas Jacob <jacob@internet24.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:59238 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1AXMNv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:13:51 -0500
Received: from [192.168.1.111] (helo=mailin02.ims-firmen.de)
	by mailout02.ims-firmen.de with esmtp (Exim 4.72)
	(envelope-from <jacob@internet24.de>)
	id 1PhLIr-0003p9-3B
	for netfilter-devel@vger.kernel.org; Mon, 24 Jan 2011 13:13:49 +0100
In-Reply-To: <1295871227-2545-1-git-send-email-jacob@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iprange_ipv6_sub was substracting 2 unsigned ints and then casting
the result to int to find out whether they are lt, eq or gt each
other, this doesn't work if the full 32 bits of each part
can be used in IPv6 addresses. Patch should remedy that without
significant performance penalties. Also number of ntohl
calls can be reduced this way (Jozsef Kadlecsik).

Signed-off-by: Thomas Jacob <jacob@internet24.de>
---
 net/netfilter/xt_iprange.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 4b5741b..140e906 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -96,15 +96,13 @@ iprange_mt4(const struct sk_buff *skb, const struct net_device *in,
 }
 
 static inline int
-iprange_ipv6_sub(const struct in6_addr *a, const struct in6_addr *b)
+iprange_ipv6_lt(const struct in6_addr *a, const struct in6_addr *b)
 {
 	unsigned int i;
-	int r;
 
 	for (i = 0; i < 4; ++i) {
-		r = ntohl(a->s6_addr32[i]) - ntohl(b->s6_addr32[i]);
-		if (r != 0)
-			return r;
+		if(a->s6_addr32[i] != b->s6_addr32[i])
+			return ntohl(a->s6_addr32[i]) < ntohl(b->s6_addr32[i]);
 	}
 
 	return 0;
@@ -121,15 +119,15 @@ iprange_mt6(const struct sk_buff *skb, const struct net_device *in,
 	bool m;
 
 	if (info->flags & IPRANGE_SRC) {
-		m  = iprange_ipv6_sub(&iph->saddr, &info->src_min.in6) < 0;
-		m |= iprange_ipv6_sub(&iph->saddr, &info->src_max.in6) > 0;
+		m  = iprange_ipv6_lt(&iph->saddr, &info->src_min.in6);
+		m |= iprange_ipv6_lt(&info->src_max.in6, &iph->saddr);
 		m ^= !!(info->flags & IPRANGE_SRC_INV);
 		if (m)
 			return false;
 	}
 	if (info->flags & IPRANGE_DST) {
-		m  = iprange_ipv6_sub(&iph->daddr, &info->dst_min.in6) < 0;
-		m |= iprange_ipv6_sub(&iph->daddr, &info->dst_max.in6) > 0;
+		m  = iprange_ipv6_lt(&iph->daddr, &info->dst_min.in6);
+		m |= iprange_ipv6_lt(&info->dst_max.in6, &iph->daddr);
 		m ^= !!(info->flags & IPRANGE_DST_INV);
 		if (m)
 			return false;
-- 
1.5.6.5

