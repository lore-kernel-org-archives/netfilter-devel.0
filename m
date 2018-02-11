From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: xt_cluster: get rid of xt_cluster_ipv6_is_multicast
Date: Sun, 11 Feb 2018 22:57:29 +0900
Message-ID: <20180211135729.23385-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:40698 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753243AbeBKN5h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Feb 2018 08:57:37 -0500
Received: by mail-pg0-f65.google.com with SMTP id g2so5878651pgn.7
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Feb 2018 05:57:37 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If use the ipv6_addr_is_multicast instead of xt_cluster_ipv6_is_multicast,
then we can reduce code size.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/xt_cluster.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index 57ef175..246d2cc 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -60,13 +60,6 @@ xt_cluster_hash(const struct nf_conn *ct,
 }
 
 static inline bool
-xt_cluster_ipv6_is_multicast(const struct in6_addr *addr)
-{
-	__be32 st = addr->s6_addr32[0];
-	return ((st & htonl(0xFF000000)) == htonl(0xFF000000));
-}
-
-static inline bool
 xt_cluster_is_multicast_addr(const struct sk_buff *skb, u_int8_t family)
 {
 	bool is_multicast = false;
@@ -76,8 +69,7 @@ xt_cluster_is_multicast_addr(const struct sk_buff *skb, u_int8_t family)
 		is_multicast = ipv4_is_multicast(ip_hdr(skb)->daddr);
 		break;
 	case NFPROTO_IPV6:
-		is_multicast =
-			xt_cluster_ipv6_is_multicast(&ipv6_hdr(skb)->daddr);
+		is_multicast = ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);
 		break;
 	default:
 		WARN_ON(1);
-- 
2.9.3

