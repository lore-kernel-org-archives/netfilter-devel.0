From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/2] netfilter: nf_tables: add chain to pktinfo structure
Date: Mon, 28 Nov 2016 01:00:43 +0100
Message-ID: <1480291244-3666-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40050 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753066AbcK1ABH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2016 19:01:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AA666DA722
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97AB9524C0
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89F16524C3
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:00:56 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the chain object to the pktinfo structure. This
potentially allow us to know what basechain this packet is walking over
from the expression evaluation path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h         | 17 +++++++++++++----
 include/net/netfilter/nf_tables_ipv4.h    | 10 ++++++----
 include/net/netfilter/nf_tables_ipv6.h    | 10 ++++++----
 net/bridge/netfilter/nf_tables_bridge.c   |  8 ++++----
 net/ipv4/netfilter/nf_tables_arp.c        |  4 ++--
 net/ipv4/netfilter/nf_tables_ipv4.c       |  4 ++--
 net/ipv4/netfilter/nft_chain_nat_ipv4.c   |  4 ++--
 net/ipv4/netfilter/nft_chain_route_ipv4.c |  4 ++--
 net/ipv6/netfilter/nf_tables_ipv6.c       |  4 ++--
 net/ipv6/netfilter/nft_chain_nat_ipv6.c   |  4 ++--
 net/ipv6/netfilter/nft_chain_route_ipv6.c |  4 ++--
 net/netfilter/nf_tables_core.c            |  5 ++---
 net/netfilter/nf_tables_netdev.c          |  8 ++++----
 13 files changed, 49 insertions(+), 37 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3295fb85bff6..7205c94fa0c8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -14,6 +14,7 @@
 
 struct nft_pktinfo {
 	struct sk_buff			*skb;
+	const struct nft_chain		*chain;
 	bool				tprot_set;
 	u8				tprot;
 	/* for x_tables compatibility */
@@ -45,11 +46,18 @@ static inline const struct net_device *nft_out(const struct nft_pktinfo *pkt)
 	return pkt->xt.state->out;
 }
 
+static inline const struct nft_chain *nft_chain(const struct nft_pktinfo *pkt)
+{
+	return pkt->chain;
+}
+
 static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
 				   struct sk_buff *skb,
-				   const struct nf_hook_state *state)
+				   const struct nf_hook_state *state,
+				   const struct nft_chain *chain)
 {
 	pkt->skb = skb;
+	pkt->chain = chain;
 	pkt->xt.state = state;
 }
 
@@ -64,9 +72,10 @@ static inline void nft_set_pktinfo_proto_unspec(struct nft_pktinfo *pkt,
 
 static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt,
 					  struct sk_buff *skb,
-					  const struct nf_hook_state *state)
+					  const struct nf_hook_state *state,
+					  const struct nft_chain *chain)
 {
-	nft_set_pktinfo(pkt, skb, state);
+	nft_set_pktinfo(pkt, skb, state, chain);
 	nft_set_pktinfo_proto_unspec(pkt, skb);
 }
 
@@ -865,7 +874,7 @@ static inline struct nft_base_chain *nft_base_chain(const struct nft_chain *chai
 
 int __nft_release_basechain(struct nft_ctx *ctx);
 
-unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
+unsigned int nft_do_chain(struct nft_pktinfo *pkt);
 
 /**
  *	struct nft_table - nf_tables table
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index 25e33aee91e7..62839b5ce3f3 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -7,11 +7,12 @@
 static inline void
 nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt,
 		     struct sk_buff *skb,
-		     const struct nf_hook_state *state)
+		     const struct nf_hook_state *state,
+		     const struct nft_chain *chain)
 {
 	struct iphdr *ip;
 
-	nft_set_pktinfo(pkt, skb, state);
+	nft_set_pktinfo(pkt, skb, state, chain);
 
 	ip = ip_hdr(pkt->skb);
 	pkt->tprot_set = true;
@@ -54,9 +55,10 @@ __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
 static inline void
 nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
 			      struct sk_buff *skb,
-			      const struct nf_hook_state *state)
+			      const struct nf_hook_state *state,
+			      const struct nft_chain *chain)
 {
-	nft_set_pktinfo(pkt, skb, state);
+	nft_set_pktinfo(pkt, skb, state, chain);
 	if (__nft_set_pktinfo_ipv4_validate(pkt, skb, state) < 0)
 		nft_set_pktinfo_proto_unspec(pkt, skb);
 }
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index d150b5066201..7bb936dcf4e7 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -7,12 +7,13 @@
 static inline void
 nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt,
 		     struct sk_buff *skb,
-		     const struct nf_hook_state *state)
+		     const struct nf_hook_state *state,
+		     const struct nft_chain *chain)
 {
 	int protohdr, thoff = 0;
 	unsigned short frag_off;
 
-	nft_set_pktinfo(pkt, skb, state);
+	nft_set_pktinfo(pkt, skb, state, chain);
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, NULL);
 	if (protohdr < 0) {
@@ -68,9 +69,10 @@ __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
 static inline void
 nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
 			      struct sk_buff *skb,
-			      const struct nf_hook_state *state)
+			      const struct nf_hook_state *state,
+			      const struct nft_chain *chain)
 {
-	nft_set_pktinfo(pkt, skb, state);
+	nft_set_pktinfo(pkt, skb, state, chain);
 	if (__nft_set_pktinfo_ipv6_validate(pkt, skb, state) < 0)
 		nft_set_pktinfo_proto_unspec(pkt, skb);
 }
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index 97afdc0744e6..0e20ac3c8a5b 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -27,17 +27,17 @@ nft_do_chain_bridge(void *priv,
 
 	switch (eth_hdr(skb)->h_proto) {
 	case htons(ETH_P_IP):
-		nft_set_pktinfo_ipv4_validate(&pkt, skb, state);
+		nft_set_pktinfo_ipv4_validate(&pkt, skb, state, priv);
 		break;
 	case htons(ETH_P_IPV6):
-		nft_set_pktinfo_ipv6_validate(&pkt, skb, state);
+		nft_set_pktinfo_ipv6_validate(&pkt, skb, state, priv);
 		break;
 	default:
-		nft_set_pktinfo_unspec(&pkt, skb, state);
+		nft_set_pktinfo_unspec(&pkt, skb, state, priv);
 		break;
 	}
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt);
 }
 
 static struct nft_af_info nft_af_bridge __read_mostly = {
diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index 805c8ddfe860..4b51ac10eba1 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -21,9 +21,9 @@ nft_do_chain_arp(void *priv,
 {
 	struct nft_pktinfo pkt;
 
-	nft_set_pktinfo_unspec(&pkt, skb, state);
+	nft_set_pktinfo_unspec(&pkt, skb, state, priv);
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt);
 }
 
 static struct nft_af_info nft_af_arp __read_mostly = {
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index 2840a29b2e04..19fafadc1789 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -24,9 +24,9 @@ static unsigned int nft_do_chain_ipv4(void *priv,
 {
 	struct nft_pktinfo pkt;
 
-	nft_set_pktinfo_ipv4(&pkt, skb, state);
+	nft_set_pktinfo_ipv4(&pkt, skb, state, priv);
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt);
 }
 
 static unsigned int nft_ipv4_output(void *priv,
diff --git a/net/ipv4/netfilter/nft_chain_nat_ipv4.c b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
index f5c66a7a4bf2..49467d8d673c 100644
--- a/net/ipv4/netfilter/nft_chain_nat_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
@@ -33,9 +33,9 @@ static unsigned int nft_nat_do_chain(void *priv,
 {
 	struct nft_pktinfo pkt;
 
-	nft_set_pktinfo_ipv4(&pkt, skb, state);
+	nft_set_pktinfo_ipv4(&pkt, skb, state, priv);
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt);
 }
 
 static unsigned int nft_nat_ipv4_fn(void *priv,
diff --git a/net/ipv4/netfilter/nft_chain_route_ipv4.c b/net/ipv4/netfilter/nft_chain_route_ipv4.c
index 30493beb611a..3f59252f55c5 100644
--- a/net/ipv4/netfilter/nft_chain_route_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_route_ipv4.c
@@ -38,7 +38,7 @@ static unsigned int nf_route_table_hook(void *priv,
 	    ip_hdrlen(skb) < sizeof(struct iphdr))
 		return NF_ACCEPT;
 
-	nft_set_pktinfo_ipv4(&pkt, skb, state);
+	nft_set_pktinfo_ipv4(&pkt, skb, state, priv);
 
 	mark = skb->mark;
 	iph = ip_hdr(skb);
@@ -46,7 +46,7 @@ static unsigned int nf_route_table_hook(void *priv,
 	daddr = iph->daddr;
 	tos = iph->tos;
 
-	ret = nft_do_chain(&pkt, priv);
+	ret = nft_do_chain(&pkt);
 	if (ret != NF_DROP && ret != NF_STOLEN) {
 		iph = ip_hdr(skb);
 
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index d6e4ba5de916..238afed83132 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -22,9 +22,9 @@ static unsigned int nft_do_chain_ipv6(void *priv,
 {
 	struct nft_pktinfo pkt;
 
-	nft_set_pktinfo_ipv6(&pkt, skb, state);
+	nft_set_pktinfo_ipv6(&pkt, skb, state, priv);
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt);
 }
 
 static unsigned int nft_ipv6_output(void *priv,
diff --git a/net/ipv6/netfilter/nft_chain_nat_ipv6.c b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
index 443cd306c0b0..7f9b69f2c010 100644
--- a/net/ipv6/netfilter/nft_chain_nat_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
@@ -31,9 +31,9 @@ static unsigned int nft_nat_do_chain(void *priv,
 {
 	struct nft_pktinfo pkt;
 
-	nft_set_pktinfo_ipv6(&pkt, skb, state);
+	nft_set_pktinfo_ipv6(&pkt, skb, state, priv);
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt);
 }
 
 static unsigned int nft_nat_ipv6_fn(void *priv,
diff --git a/net/ipv6/netfilter/nft_chain_route_ipv6.c b/net/ipv6/netfilter/nft_chain_route_ipv6.c
index f2727475895e..f3687c45e251 100644
--- a/net/ipv6/netfilter/nft_chain_route_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_route_ipv6.c
@@ -33,7 +33,7 @@ static unsigned int nf_route_table_hook(void *priv,
 	u32 mark, flowlabel;
 	int err;
 
-	nft_set_pktinfo_ipv6(&pkt, skb, state);
+	nft_set_pktinfo_ipv6(&pkt, skb, state, priv);
 
 	/* save source/dest address, mark, hoplimit, flowlabel, priority */
 	memcpy(&saddr, &ipv6_hdr(skb)->saddr, sizeof(saddr));
@@ -44,7 +44,7 @@ static unsigned int nf_route_table_hook(void *priv,
 	/* flowlabel and prio (includes version, which shouldn't change either */
 	flowlabel = *((u32 *)ipv6_hdr(skb));
 
-	ret = nft_do_chain(&pkt, priv);
+	ret = nft_do_chain(&pkt);
 	if (ret != NF_DROP && ret != NF_STOLEN &&
 	    (memcmp(&ipv6_hdr(skb)->saddr, &saddr, sizeof(saddr)) ||
 	     memcmp(&ipv6_hdr(skb)->daddr, &daddr, sizeof(daddr)) ||
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 65dbeadcb118..70cba7019d18 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -120,10 +120,9 @@ struct nft_jumpstack {
 	int			rulenum;
 };
 
-unsigned int
-nft_do_chain(struct nft_pktinfo *pkt, void *priv)
+unsigned int nft_do_chain(struct nft_pktinfo *pkt)
 {
-	const struct nft_chain *chain = priv, *basechain = chain;
+	const struct nft_chain *chain = pkt->chain, *basechain = chain;
 	const struct net *net = nft_net(pkt);
 	const struct nft_rule *rule;
 	const struct nft_expr *expr, *last;
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 9e2ae424b640..49166eedaf35 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -23,17 +23,17 @@ nft_do_chain_netdev(void *priv, struct sk_buff *skb,
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		nft_set_pktinfo_ipv4_validate(&pkt, skb, state);
+		nft_set_pktinfo_ipv4_validate(&pkt, skb, state, priv);
 		break;
 	case htons(ETH_P_IPV6):
-		nft_set_pktinfo_ipv6_validate(&pkt, skb, state);
+		nft_set_pktinfo_ipv6_validate(&pkt, skb, state, priv);
 		break;
 	default:
-		nft_set_pktinfo_unspec(&pkt, skb, state);
+		nft_set_pktinfo_unspec(&pkt, skb, state, priv);
 		break;
 	}
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt);
 }
 
 static struct nft_af_info nft_af_netdev __read_mostly = {
-- 
2.1.4

