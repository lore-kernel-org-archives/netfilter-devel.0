From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 1/2] netfilter: pkttype: unnecessary to check ipv6 multicast address
Date: Sat,  7 Jan 2017 21:33:54 +0800
Message-ID: <1483796035-54792-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:51297 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932596AbdAGNem (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Jan 2017 08:34:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Since there's no broadcast address in IPV6, so in ipv6 family, the
PACKET_LOOPBACK must be multicast packets, there's no need to check
it again.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nft_meta.c   | 5 +----
 net/netfilter/xt_pkttype.c | 3 +--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 66c7f4b..9a22b24 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -154,10 +154,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 				*dest = PACKET_BROADCAST;
 			break;
 		case NFPROTO_IPV6:
-			if (ipv6_hdr(skb)->daddr.s6_addr[0] == 0xFF)
-				*dest = PACKET_MULTICAST;
-			else
-				*dest = PACKET_BROADCAST;
+			*dest = PACKET_MULTICAST;
 			break;
 		default:
 			WARN_ON(1);
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 57efb70..1ef9915 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -33,8 +33,7 @@ pkttype_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	else if (xt_family(par) == NFPROTO_IPV4 &&
 	    ipv4_is_multicast(ip_hdr(skb)->daddr))
 		type = PACKET_MULTICAST;
-	else if (xt_family(par) == NFPROTO_IPV6 &&
-	    ipv6_hdr(skb)->daddr.s6_addr[0] == 0xFF)
+	else if (xt_family(par) == NFPROTO_IPV6)
 		type = PACKET_MULTICAST;
 	else
 		type = PACKET_BROADCAST;
-- 
2.5.5


