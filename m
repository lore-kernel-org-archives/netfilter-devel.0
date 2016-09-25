From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 19/53] netfilter: nf_tables: don't drop IPv6 packets that cannot parse transport
Date: Mon, 26 Sep 2016 01:06:29 +0200
Message-ID: <1474844823-2026-20-git-send-email-pablo@netfilter.org>
References: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54576 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034648AbcIYXHk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 19:07:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B0487C0B39
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9431FDA846
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89D14DA84B
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:36 +0200 (CEST)
In-Reply-To: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is overly conservative and not flexible at all, so better let them
go through and let the filtering policy decide what to do with them. We
use skb_header_pointer() all over the place so we would just fail to
match when trying to access fields from malformed traffic.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_ipv6.h    | 6 ++----
 net/ipv6/netfilter/nf_tables_ipv6.c       | 4 +---
 net/ipv6/netfilter/nft_chain_route_ipv6.c | 4 +---
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index 39b7b717b540..d150b5066201 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -4,7 +4,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <net/ipv6.h>
 
-static inline int
+static inline void
 nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt,
 		     struct sk_buff *skb,
 		     const struct nf_hook_state *state)
@@ -17,15 +17,13 @@ nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt,
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, NULL);
 	if (protohdr < 0) {
 		nft_set_pktinfo_proto_unspec(pkt, skb);
-		return -1;
+		return;
 	}
 
 	pkt->tprot_set = true;
 	pkt->tprot = protohdr;
 	pkt->xt.thoff = thoff;
 	pkt->xt.fragoff = frag_off;
-
-	return 0;
 }
 
 static inline int
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index 30b22f4dff55..05d05926962a 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -22,9 +22,7 @@ static unsigned int nft_do_chain_ipv6(void *priv,
 {
 	struct nft_pktinfo pkt;
 
-	/* malformed packet, drop it */
-	if (nft_set_pktinfo_ipv6(&pkt, skb, state) < 0)
-		return NF_DROP;
+	nft_set_pktinfo_ipv6(&pkt, skb, state);
 
 	return nft_do_chain(&pkt, priv);
 }
diff --git a/net/ipv6/netfilter/nft_chain_route_ipv6.c b/net/ipv6/netfilter/nft_chain_route_ipv6.c
index 71d995ff3108..01eb0f658366 100644
--- a/net/ipv6/netfilter/nft_chain_route_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_route_ipv6.c
@@ -32,9 +32,7 @@ static unsigned int nf_route_table_hook(void *priv,
 	u_int8_t hop_limit;
 	u32 mark, flowlabel;
 
-	/* malformed packet, drop it */
-	if (nft_set_pktinfo_ipv6(&pkt, skb, state) < 0)
-		return NF_DROP;
+	nft_set_pktinfo_ipv6(&pkt, skb, state);
 
 	/* save source/dest address, mark, hoplimit, flowlabel, priority */
 	memcpy(&saddr, &ipv6_hdr(skb)->saddr, sizeof(saddr));
-- 
2.1.4

