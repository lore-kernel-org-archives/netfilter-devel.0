From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/52] netfilter: mark expected switch fall-throughs
Date: Mon,  8 Jan 2018 21:19:12 +0100
Message-ID: <20180108202000.12989-5-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42462 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754002AbeAHUUP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 15:20:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D4DFEE7B8F
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 21:20:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF74BA6A3
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 21:20:13 +0100 (CET)
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c      | 2 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c   | 1 +
 net/netfilter/ipvs/ip_vs_proto_udp.c   | 1 +
 net/netfilter/nf_conntrack_h323_asn1.c | 3 +++
 net/netfilter/nft_cmp.c                | 2 ++
 net/netfilter/x_tables.c               | 2 +-
 6 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index cf84f7b37cd9..d5a43cad90f0 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1386,7 +1386,7 @@ ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
 				goto next_set;
 			if (set->variant->uref)
 				set->variant->uref(set, cb, true);
-			/* Fall through and add elements */
+			/* fall through */
 		default:
 			rcu_read_lock_bh();
 			ret = set->variant->list(set, skb, cb);
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 121a321b91be..bcd9b7bde4ee 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -315,6 +315,7 @@ tcp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp)
 	switch (skb->ip_summed) {
 	case CHECKSUM_NONE:
 		skb->csum = skb_checksum(skb, tcphoff, skb->len - tcphoff, 0);
+		/* fall through */
 	case CHECKSUM_COMPLETE:
 #ifdef CONFIG_IP_VS_IPV6
 		if (af == AF_INET6) {
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index 30e11cd6aa8a..c15ef7c2a1fa 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -319,6 +319,7 @@ udp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp)
 		case CHECKSUM_NONE:
 			skb->csum = skb_checksum(skb, udphoff,
 						 skb->len - udphoff, 0);
+			/* fall through */
 		case CHECKSUM_COMPLETE:
 #ifdef CONFIG_IP_VS_IPV6
 			if (af == AF_INET6) {
diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index dc6347342e34..38cf5e4f30bd 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -262,12 +262,15 @@ static unsigned int get_uint(struct bitstr *bs, int b)
 	case 4:
 		v |= *bs->cur++;
 		v <<= 8;
+		/* fall through */
 	case 3:
 		v |= *bs->cur++;
 		v <<= 8;
+		/* fall through */
 	case 2:
 		v |= *bs->cur++;
 		v <<= 8;
+		/* fall through */
 	case 1:
 		v |= *bs->cur++;
 		break;
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index c2945eb3397c..fa90a8402845 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -44,6 +44,7 @@ static void nft_cmp_eval(const struct nft_expr *expr,
 	case NFT_CMP_LT:
 		if (d == 0)
 			goto mismatch;
+		/* fall through */
 	case NFT_CMP_LTE:
 		if (d > 0)
 			goto mismatch;
@@ -51,6 +52,7 @@ static void nft_cmp_eval(const struct nft_expr *expr,
 	case NFT_CMP_GT:
 		if (d == 0)
 			goto mismatch;
+		/* fall through */
 	case NFT_CMP_GTE:
 		if (d < 0)
 			goto mismatch;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 55802e97f906..0d9efc3cb451 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1397,7 +1397,7 @@ static void *xt_mttg_seq_next(struct seq_file *seq, void *v, loff_t *ppos,
 		trav->curr = trav->curr->next;
 		if (trav->curr != trav->head)
 			break;
-		/* fallthru, _stop will unlock */
+		/* fall through */
 	default:
 		return NULL;
 	}
-- 
2.11.0

