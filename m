From: Ulrich Weber <uweber@astaro.com>
Subject: [PATCH] ipv6: netfilter: move xfrm_lookup at end of
 ip6_route_me_harder
Date: Thu, 15 Apr 2010 11:42:08 +0200
Message-ID: <20100415094208.GA7770@babylon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-87.dex002.intermedia.net ([64.78.20.224]:28878 "EHLO
	dhost002-87.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161Ab0DOJ50 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 05:57:26 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xfrm_lookup should be called after ip6_route_output skb_dst_set,
otherwise skb_dst_set of xfrm_lookup is pointless

Signed-off-by: Ulrich Weber <uweber@astaro.com>
---
 net/ipv6/netfilter.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index d5ed92b..a74951c 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -25,20 +25,6 @@ int ip6_route_me_harder(struct sk_buff *skb)
 	};
 
 	dst = ip6_route_output(net, skb->sk, &fl);
-
-#ifdef CONFIG_XFRM
-	if (!(IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED) &&
-	    xfrm_decode_session(skb, &fl, AF_INET6) == 0) {
-		struct dst_entry *dst2 = skb_dst(skb);
-
-		if (xfrm_lookup(net, &dst2, &fl, skb->sk, 0)) {
-			skb_dst_set(skb, NULL);
-			return -1;
-		}
-		skb_dst_set(skb, dst2);
-	}
-#endif
-
 	if (dst->error) {
 		IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
 		LIMIT_NETDEBUG(KERN_DEBUG "ip6_route_me_harder: No more route.\n");
@@ -50,6 +36,17 @@ int ip6_route_me_harder(struct sk_buff *skb)
 	skb_dst_drop(skb);
 
 	skb_dst_set(skb, dst);
+
+#ifdef CONFIG_XFRM
+	if (!(IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED) &&
+	    xfrm_decode_session(skb, &fl, AF_INET6) == 0) {
+		skb_dst_set(skb, NULL);
+		if (xfrm_lookup(net, &dst, &fl, skb->sk, 0))
+			return -1;
+		skb_dst_set(skb, dst);
+	}
+#endif
+
 	return 0;
 }
 EXPORT_SYMBOL(ip6_route_me_harder);
-- 
1.6.3.3

