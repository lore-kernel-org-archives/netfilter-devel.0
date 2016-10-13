From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,RFC 06/10] netfilter: nf_tables: use hook state from xt_action_param structure
Date: Thu, 13 Oct 2016 14:11:59 +0200
Message-ID: <1476360723-3291-7-git-send-email-pablo@netfilter.org>
References: <1476360723-3291-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44752 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756047AbcJMMMe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 08:12:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 03B503EBA88
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:12:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1E56BAAB5
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:12:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE20BBAC3C
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:12:26 +0200 (CEST)
In-Reply-To: <1476360723-3291-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't copy relevant fields from hook state structure, instead use the
one that is already available in struct xt_action_param.

This patch also adds a set of new wrapper functions to fetch relevant
hook state structure fields.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        | 35 +++++++++++++++++++++++---------
 net/bridge/netfilter/nft_meta_bridge.c   |  2 +-
 net/bridge/netfilter/nft_reject_bridge.c | 30 ++++++++++++++++-----------
 net/ipv4/netfilter/nft_dup_ipv4.c        |  2 +-
 net/ipv4/netfilter/nft_masq_ipv4.c       |  4 ++--
 net/ipv4/netfilter/nft_redir_ipv4.c      |  3 +--
 net/ipv4/netfilter/nft_reject_ipv4.c     |  4 ++--
 net/ipv6/netfilter/nft_dup_ipv6.c        |  2 +-
 net/ipv6/netfilter/nft_masq_ipv6.c       |  3 ++-
 net/ipv6/netfilter/nft_redir_ipv6.c      |  3 ++-
 net/ipv6/netfilter/nft_reject_ipv6.c     |  6 +++---
 net/netfilter/nf_dup_netdev.c            |  2 +-
 net/netfilter/nf_tables_core.c           | 10 ++++-----
 net/netfilter/nf_tables_trace.c          |  8 ++++----
 net/netfilter/nft_log.c                  |  5 +++--
 net/netfilter/nft_lookup.c               |  5 ++---
 net/netfilter/nft_meta.c                 |  6 +++---
 net/netfilter/nft_queue.c                |  2 +-
 net/netfilter/nft_reject_inet.c          | 18 ++++++++--------
 19 files changed, 86 insertions(+), 64 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 44060344f958..ba49f21d62ab 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -14,27 +14,42 @@
 
 struct nft_pktinfo {
 	struct sk_buff			*skb;
-	struct net			*net;
-	const struct net_device		*in;
-	const struct net_device		*out;
-	u8				pf;
-	u8				hook;
 	bool				tprot_set;
 	u8				tprot;
 	/* for x_tables compatibility */
 	struct xt_action_param		xt;
 };
 
+static inline struct net *pkt_net(const struct nft_pktinfo *pkt)
+{
+	return pkt->xt.state->net;
+}
+
+static inline unsigned int pkt_hook(const struct nft_pktinfo *pkt)
+{
+	return pkt->xt.state->hook;
+}
+
+static inline u8 pkt_pf(const struct nft_pktinfo *pkt)
+{
+	return pkt->xt.state->pf;
+}
+
+static inline const struct net_device *pkt_in(const struct nft_pktinfo *pkt)
+{
+	return pkt->xt.state->in;
+}
+
+static inline const struct net_device *pkt_out(const struct nft_pktinfo *pkt)
+{
+	return pkt->xt.state->out;
+}
+
 static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
 				   struct sk_buff *skb,
 				   const struct nf_hook_state *state)
 {
 	pkt->skb = skb;
-	pkt->net = state->net;
-	pkt->in = state->in;
-	pkt->out = state->out;
-	pkt->hook = state->hook;
-	pkt->pf = state->pf;
 	pkt->xt.state = state;
 }
 
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index ad47a921b701..ea72d56d44b9 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -23,7 +23,7 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 				     const struct nft_pktinfo *pkt)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
-	const struct net_device *in = pkt->in, *out = pkt->out;
+	const struct net_device *in = pkt_in(pkt), *out = pkt_out(pkt);
 	u32 *dest = &regs->data[priv->dreg];
 	const struct net_bridge_port *p;
 
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 4b3df6b0e3b9..e8918a8a1511 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -315,17 +315,20 @@ static void nft_reject_bridge_eval(const struct nft_expr *expr,
 	case htons(ETH_P_IP):
 		switch (priv->type) {
 		case NFT_REJECT_ICMP_UNREACH:
-			nft_reject_br_send_v4_unreach(pkt->net, pkt->skb,
-						      pkt->in, pkt->hook,
+			nft_reject_br_send_v4_unreach(pkt_net(pkt), pkt->skb,
+						      pkt_in(pkt),
+						      pkt_hook(pkt),
 						      priv->icmp_code);
 			break;
 		case NFT_REJECT_TCP_RST:
-			nft_reject_br_send_v4_tcp_reset(pkt->net, pkt->skb,
-							pkt->in, pkt->hook);
+			nft_reject_br_send_v4_tcp_reset(pkt_net(pkt), pkt->skb,
+							pkt_in(pkt),
+							pkt_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
-			nft_reject_br_send_v4_unreach(pkt->net, pkt->skb,
-						      pkt->in, pkt->hook,
+			nft_reject_br_send_v4_unreach(pkt_net(pkt), pkt->skb,
+						      pkt_in(pkt),
+						      pkt_hook(pkt),
 						      nft_reject_icmp_code(priv->icmp_code));
 			break;
 		}
@@ -333,17 +336,20 @@ static void nft_reject_bridge_eval(const struct nft_expr *expr,
 	case htons(ETH_P_IPV6):
 		switch (priv->type) {
 		case NFT_REJECT_ICMP_UNREACH:
-			nft_reject_br_send_v6_unreach(pkt->net, pkt->skb,
-						      pkt->in, pkt->hook,
+			nft_reject_br_send_v6_unreach(pkt_net(pkt), pkt->skb,
+						      pkt_in(pkt),
+						      pkt_hook(pkt),
 						      priv->icmp_code);
 			break;
 		case NFT_REJECT_TCP_RST:
-			nft_reject_br_send_v6_tcp_reset(pkt->net, pkt->skb,
-							pkt->in, pkt->hook);
+			nft_reject_br_send_v6_tcp_reset(pkt_net(pkt), pkt->skb,
+							pkt_in(pkt),
+							pkt_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
-			nft_reject_br_send_v6_unreach(pkt->net, pkt->skb,
-						      pkt->in, pkt->hook,
+			nft_reject_br_send_v6_unreach(pkt_net(pkt), pkt->skb,
+						      pkt_in(pkt),
+						      pkt_hook(pkt),
 						      nft_reject_icmpv6_code(priv->icmp_code));
 			break;
 		}
diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup_ipv4.c
index bf855e64fc45..b277070031cc 100644
--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -30,7 +30,7 @@ static void nft_dup_ipv4_eval(const struct nft_expr *expr,
 	};
 	int oif = regs->data[priv->sreg_dev];
 
-	nf_dup_ipv4(pkt->net, pkt->skb, pkt->hook, &gw, oif);
+	nf_dup_ipv4(pkt_net(pkt), pkt->skb, pkt_hook(pkt), &gw, oif);
 }
 
 static int nft_dup_ipv4_init(const struct nft_ctx *ctx,
diff --git a/net/ipv4/netfilter/nft_masq_ipv4.c b/net/ipv4/netfilter/nft_masq_ipv4.c
index 51ced81b616c..75cc43f9ef66 100644
--- a/net/ipv4/netfilter/nft_masq_ipv4.c
+++ b/net/ipv4/netfilter/nft_masq_ipv4.c
@@ -31,8 +31,8 @@ static void nft_masq_ipv4_eval(const struct nft_expr *expr,
 		range.max_proto.all =
 			*(__be16 *)&regs->data[priv->sreg_proto_max];
 	}
-	regs->verdict.code = nf_nat_masquerade_ipv4(pkt->skb, pkt->hook,
-						    &range, pkt->out);
+	regs->verdict.code = nf_nat_masquerade_ipv4(pkt->skb, pkt_hook(pkt),
+						    &range, pkt_out(pkt));
 }
 
 static struct nft_expr_type nft_masq_ipv4_type;
diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c b/net/ipv4/netfilter/nft_redir_ipv4.c
index c09d4381427e..de6b46013da4 100644
--- a/net/ipv4/netfilter/nft_redir_ipv4.c
+++ b/net/ipv4/netfilter/nft_redir_ipv4.c
@@ -35,8 +35,7 @@ static void nft_redir_ipv4_eval(const struct nft_expr *expr,
 
 	mr.range[0].flags |= priv->flags;
 
-	regs->verdict.code = nf_nat_redirect_ipv4(pkt->skb, &mr,
-						  pkt->hook);
+	regs->verdict.code = nf_nat_redirect_ipv4(pkt->skb, &mr, pkt_hook(pkt));
 }
 
 static struct nft_expr_type nft_redir_ipv4_type;
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index 2c2553b9026c..4b0d930c9fdb 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -27,10 +27,10 @@ static void nft_reject_ipv4_eval(const struct nft_expr *expr,
 
 	switch (priv->type) {
 	case NFT_REJECT_ICMP_UNREACH:
-		nf_send_unreach(pkt->skb, priv->icmp_code, pkt->hook);
+		nf_send_unreach(pkt->skb, priv->icmp_code, pkt_hook(pkt));
 		break;
 	case NFT_REJECT_TCP_RST:
-		nf_send_reset(pkt->net, pkt->skb, pkt->hook);
+		nf_send_reset(pkt_net(pkt), pkt->skb, pkt_hook(pkt));
 		break;
 	default:
 		break;
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
index 8bfd470cbe72..af50ce95cb39 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -28,7 +28,7 @@ static void nft_dup_ipv6_eval(const struct nft_expr *expr,
 	struct in6_addr *gw = (struct in6_addr *)&regs->data[priv->sreg_addr];
 	int oif = regs->data[priv->sreg_dev];
 
-	nf_dup_ipv6(pkt->net, pkt->skb, pkt->hook, gw, oif);
+	nf_dup_ipv6(pkt_net(pkt), pkt->skb, pkt_hook(pkt), gw, oif);
 }
 
 static int nft_dup_ipv6_init(const struct nft_ctx *ctx,
diff --git a/net/ipv6/netfilter/nft_masq_ipv6.c b/net/ipv6/netfilter/nft_masq_ipv6.c
index 9597ffb74077..f71b03a3172c 100644
--- a/net/ipv6/netfilter/nft_masq_ipv6.c
+++ b/net/ipv6/netfilter/nft_masq_ipv6.c
@@ -32,7 +32,8 @@ static void nft_masq_ipv6_eval(const struct nft_expr *expr,
 		range.max_proto.all =
 			*(__be16 *)&regs->data[priv->sreg_proto_max];
 	}
-	regs->verdict.code = nf_nat_masquerade_ipv6(pkt->skb, &range, pkt->out);
+	regs->verdict.code = nf_nat_masquerade_ipv6(pkt->skb, &range,
+						    pkt_out(pkt));
 }
 
 static struct nft_expr_type nft_masq_ipv6_type;
diff --git a/net/ipv6/netfilter/nft_redir_ipv6.c b/net/ipv6/netfilter/nft_redir_ipv6.c
index aca44e89a881..281f727a3d02 100644
--- a/net/ipv6/netfilter/nft_redir_ipv6.c
+++ b/net/ipv6/netfilter/nft_redir_ipv6.c
@@ -35,7 +35,8 @@ static void nft_redir_ipv6_eval(const struct nft_expr *expr,
 
 	range.flags |= priv->flags;
 
-	regs->verdict.code = nf_nat_redirect_ipv6(pkt->skb, &range, pkt->hook);
+	regs->verdict.code = nf_nat_redirect_ipv6(pkt->skb, &range,
+						  pkt_hook(pkt));
 }
 
 static struct nft_expr_type nft_redir_ipv6_type;
diff --git a/net/ipv6/netfilter/nft_reject_ipv6.c b/net/ipv6/netfilter/nft_reject_ipv6.c
index 92bda9908bb9..fa80c277e7ba 100644
--- a/net/ipv6/netfilter/nft_reject_ipv6.c
+++ b/net/ipv6/netfilter/nft_reject_ipv6.c
@@ -27,11 +27,11 @@ static void nft_reject_ipv6_eval(const struct nft_expr *expr,
 
 	switch (priv->type) {
 	case NFT_REJECT_ICMP_UNREACH:
-		nf_send_unreach6(pkt->net, pkt->skb, priv->icmp_code,
-				 pkt->hook);
+		nf_send_unreach6(pkt_net(pkt), pkt->skb, priv->icmp_code,
+				 pkt_hook(pkt));
 		break;
 	case NFT_REJECT_TCP_RST:
-		nf_send_reset6(pkt->net, pkt->skb, pkt->hook);
+		nf_send_reset6(pkt_net(pkt), pkt->skb, pkt_hook(pkt));
 		break;
 	default:
 		break;
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 7ec69723940f..e999fafaca8d 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -19,7 +19,7 @@ void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 	struct net_device *dev;
 	struct sk_buff *skb;
 
-	dev = dev_get_by_index_rcu(pkt->net, oif);
+	dev = dev_get_by_index_rcu(pkt_net(pkt), oif);
 	if (dev == NULL)
 		return;
 
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 0dd5c695482f..27fa3c2dea8a 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -53,10 +53,10 @@ static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 
 	nft_trace_notify(info);
 
-	nf_log_trace(pkt->net, pkt->pf, pkt->hook, pkt->skb, pkt->in,
-		     pkt->out, &trace_loginfo, "TRACE: %s:%s:%s:%u ",
-		     chain->table->name, chain->name, comments[type],
-		     rulenum);
+	nf_log_trace(pkt_net(pkt), pkt_pf(pkt), pkt_hook(pkt), pkt->skb,
+		     pkt_in(pkt), pkt_out(pkt), &trace_loginfo,
+		     "TRACE: %s:%s:%s:%u ",
+		     chain->table->name, chain->name, comments[type], rulenum);
 }
 
 static inline void nft_trace_packet(struct nft_traceinfo *info,
@@ -124,7 +124,7 @@ unsigned int
 nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 {
 	const struct nft_chain *chain = priv, *basechain = chain;
-	const struct net *net = pkt->net;
+	const struct net *net = pkt->xt.state->net;
 	const struct nft_rule *rule;
 	const struct nft_expr *expr, *last;
 	struct nft_regs regs;
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index ab695f8e2d29..5a09f78a6a4f 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -171,7 +171,7 @@ void nft_trace_notify(struct nft_traceinfo *info)
 	unsigned int size;
 	int event = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_TRACE;
 
-	if (!nfnetlink_has_listeners(pkt->net, NFNLGRP_NFTRACE))
+	if (!nfnetlink_has_listeners(pkt_net(pkt), NFNLGRP_NFTRACE))
 		return;
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg)) +
@@ -207,7 +207,7 @@ void nft_trace_notify(struct nft_traceinfo *info)
 	nfmsg->version		= NFNETLINK_V0;
 	nfmsg->res_id		= 0;
 
-	if (nla_put_be32(skb, NFTA_TRACE_NFPROTO, htonl(pkt->pf)))
+	if (nla_put_be32(skb, NFTA_TRACE_NFPROTO, htonl(pkt_pf(pkt))))
 		goto nla_put_failure;
 
 	if (nla_put_be32(skb, NFTA_TRACE_TYPE, htonl(info->type)))
@@ -249,7 +249,7 @@ void nft_trace_notify(struct nft_traceinfo *info)
 		goto nla_put_failure;
 
 	if (!info->packet_dumped) {
-		if (nf_trace_fill_dev_info(skb, pkt->in, pkt->out))
+		if (nf_trace_fill_dev_info(skb, pkt_in(pkt), pkt_out(pkt)))
 			goto nla_put_failure;
 
 		if (nf_trace_fill_pkt_info(skb, pkt))
@@ -258,7 +258,7 @@ void nft_trace_notify(struct nft_traceinfo *info)
 	}
 
 	nlmsg_end(skb, nlh);
-	nfnetlink_send(skb, pkt->net, 0, NFNLGRP_NFTRACE, 0, GFP_ATOMIC);
+	nfnetlink_send(skb, pkt_net(pkt), 0, NFNLGRP_NFTRACE, 0, GFP_ATOMIC);
 	return;
 
  nla_put_failure:
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 1b01404bb33f..3ffff350e6d6 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -32,8 +32,9 @@ static void nft_log_eval(const struct nft_expr *expr,
 {
 	const struct nft_log *priv = nft_expr_priv(expr);
 
-	nf_log_packet(pkt->net, pkt->pf, pkt->hook, pkt->skb, pkt->in,
-		      pkt->out, &priv->loginfo, "%s", priv->prefix);
+	nf_log_packet(pkt_net(pkt), pkt_pf(pkt), pkt_hook(pkt), pkt->skb,
+		      pkt_in(pkt), pkt_out(pkt), &priv->loginfo, "%s",
+		      priv->prefix);
 }
 
 static const struct nla_policy nft_log_policy[NFTA_LOG_MAX + 1] = {
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 8166b6994cc7..fb36f967609c 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -35,9 +35,8 @@ static void nft_lookup_eval(const struct nft_expr *expr,
 	const struct nft_set_ext *ext;
 	bool found;
 
-	found = set->ops->lookup(pkt->net, set, &regs->data[priv->sreg], &ext) ^
-		priv->invert;
-
+	found = set->ops->lookup(pkt_net(pkt), set, &regs->data[priv->sreg],
+				 &ext) ^ priv->invert;
 	if (!found) {
 		regs->verdict.code = NFT_BREAK;
 		return;
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 6c1e0246706e..8270e2cc1513 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -36,7 +36,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-	const struct net_device *in = pkt->in, *out = pkt->out;
+	const struct net_device *in = pkt_in(pkt), *out = pkt_out(pkt);
 	struct sock *sk;
 	u32 *dest = &regs->data[priv->dreg];
 
@@ -49,7 +49,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		*(__be16 *)dest = skb->protocol;
 		break;
 	case NFT_META_NFPROTO:
-		*dest = pkt->pf;
+		*dest = pkt_pf(pkt);
 		break;
 	case NFT_META_L4PROTO:
 		if (!pkt->tprot_set)
@@ -146,7 +146,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			break;
 		}
 
-		switch (pkt->pf) {
+		switch (pkt_pf(pkt)) {
 		case NFPROTO_IPV4:
 			if (ipv4_is_multicast(ip_hdr(skb)->daddr))
 				*dest = PACKET_MULTICAST;
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 393d359a1889..f596a1614daa 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -43,7 +43,7 @@ static void nft_queue_eval(const struct nft_expr *expr,
 			queue = priv->queuenum + cpu % priv->queues_total;
 		} else {
 			queue = nfqueue_hash(pkt->skb, queue,
-					     priv->queues_total, pkt->pf,
+					     priv->queues_total, pkt_pf(pkt),
 					     jhash_initval);
 		}
 	}
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index e79d9ca2ffee..7c1418755a21 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -23,36 +23,36 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 {
 	struct nft_reject *priv = nft_expr_priv(expr);
 
-	switch (pkt->pf) {
+	switch (pkt_pf(pkt)) {
 	case NFPROTO_IPV4:
 		switch (priv->type) {
 		case NFT_REJECT_ICMP_UNREACH:
 			nf_send_unreach(pkt->skb, priv->icmp_code,
-					pkt->hook);
+					pkt_hook(pkt));
 			break;
 		case NFT_REJECT_TCP_RST:
-			nf_send_reset(pkt->net, pkt->skb, pkt->hook);
+			nf_send_reset(pkt_net(pkt), pkt->skb, pkt_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
 			nf_send_unreach(pkt->skb,
 					nft_reject_icmp_code(priv->icmp_code),
-					pkt->hook);
+					pkt_hook(pkt));
 			break;
 		}
 		break;
 	case NFPROTO_IPV6:
 		switch (priv->type) {
 		case NFT_REJECT_ICMP_UNREACH:
-			nf_send_unreach6(pkt->net, pkt->skb, priv->icmp_code,
-					 pkt->hook);
+			nf_send_unreach6(pkt_net(pkt), pkt->skb,
+					 priv->icmp_code, pkt_hook(pkt));
 			break;
 		case NFT_REJECT_TCP_RST:
-			nf_send_reset6(pkt->net, pkt->skb, pkt->hook);
+			nf_send_reset6(pkt_net(pkt), pkt->skb, pkt_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
-			nf_send_unreach6(pkt->net, pkt->skb,
+			nf_send_unreach6(pkt_net(pkt), pkt->skb,
 					 nft_reject_icmpv6_code(priv->icmp_code),
-					 pkt->hook);
+					 pkt_hook(pkt));
 			break;
 		}
 		break;
-- 
2.1.4

