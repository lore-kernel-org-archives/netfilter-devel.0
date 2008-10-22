From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/03: xt_iprange: fix range inversion match
Date: Wed, 22 Oct 2008 19:41:28 +0200 (MEST)
Message-ID: <20081022174128.21341.79877.sendpatchset@x2.localnet>
References: <20081022174126.21341.38231.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58286 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980AbYJVRl3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:41:29 -0400
In-Reply-To: <20081022174126.21341.38231.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 3e533fa616520e6b068bc0b284fe801f05719e07
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Oct 22 19:34:06 2008 +0200

    netfilter: xt_iprange: fix range inversion match
    
    Upstream commit 6def1eb48:
    
    Inverted IPv4 v1 and IPv6 v0 matches don't match anything since 2.6.25-rc1!
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Acked-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index c63e933..4b5741b 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -67,7 +67,7 @@ iprange_mt4(const struct sk_buff *skb, const struct net_device *in,
 	if (info->flags & IPRANGE_SRC) {
 		m  = ntohl(iph->saddr) < ntohl(info->src_min.ip);
 		m |= ntohl(iph->saddr) > ntohl(info->src_max.ip);
-		m ^= info->flags & IPRANGE_SRC_INV;
+		m ^= !!(info->flags & IPRANGE_SRC_INV);
 		if (m) {
 			pr_debug("src IP " NIPQUAD_FMT " NOT in range %s"
 			         NIPQUAD_FMT "-" NIPQUAD_FMT "\n",
@@ -81,7 +81,7 @@ iprange_mt4(const struct sk_buff *skb, const struct net_device *in,
 	if (info->flags & IPRANGE_DST) {
 		m  = ntohl(iph->daddr) < ntohl(info->dst_min.ip);
 		m |= ntohl(iph->daddr) > ntohl(info->dst_max.ip);
-		m ^= info->flags & IPRANGE_DST_INV;
+		m ^= !!(info->flags & IPRANGE_DST_INV);
 		if (m) {
 			pr_debug("dst IP " NIPQUAD_FMT " NOT in range %s"
 			         NIPQUAD_FMT "-" NIPQUAD_FMT "\n",
@@ -123,14 +123,14 @@ iprange_mt6(const struct sk_buff *skb, const struct net_device *in,
 	if (info->flags & IPRANGE_SRC) {
 		m  = iprange_ipv6_sub(&iph->saddr, &info->src_min.in6) < 0;
 		m |= iprange_ipv6_sub(&iph->saddr, &info->src_max.in6) > 0;
-		m ^= info->flags & IPRANGE_SRC_INV;
+		m ^= !!(info->flags & IPRANGE_SRC_INV);
 		if (m)
 			return false;
 	}
 	if (info->flags & IPRANGE_DST) {
 		m  = iprange_ipv6_sub(&iph->daddr, &info->dst_min.in6) < 0;
 		m |= iprange_ipv6_sub(&iph->daddr, &info->dst_max.in6) > 0;
-		m ^= info->flags & IPRANGE_DST_INV;
+		m ^= !!(info->flags & IPRANGE_DST_INV);
 		if (m)
 			return false;
 	}
