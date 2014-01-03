From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/6] netfilter: nf_tables: add hook ops to struct nft_pktinfo
Date: Fri,  3 Jan 2014 12:16:14 +0000
Message-ID: <1388751378-23272-3-git-send-email-kaber@trash.net>
References: <1388751378-23272-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56523 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaACMQ0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 07:16:26 -0500
In-Reply-To: <1388751378-23272-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Multi-family tables need the AF from the hook ops. Add a pointer to the
hook ops and replace usage of the hooknum member in struct nft_pktinfo.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h | 5 +++--
 net/netfilter/nf_tables_core.c    | 2 +-
 net/netfilter/nft_log.c           | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5a91abf..c9e6316 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -13,7 +13,7 @@ struct nft_pktinfo {
 	struct sk_buff			*skb;
 	const struct net_device		*in;
 	const struct net_device		*out;
-	u8				hooknum;
+	const struct nf_hook_ops	*ops;
 	u8				nhoff;
 	u8				thoff;
 	/* for x_tables compatibility */
@@ -29,7 +29,8 @@ static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
 	pkt->skb = skb;
 	pkt->in = pkt->xt.in = in;
 	pkt->out = pkt->xt.out = out;
-	pkt->hooknum = pkt->xt.hooknum = ops->hooknum;
+	pkt->ops = ops;
+	pkt->xt.hooknum = ops->hooknum;
 	pkt->xt.family = ops->pf;
 }
 
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index cb9e685..eb6a157 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -109,7 +109,7 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
 {
 	struct net *net = dev_net(pkt->in ? pkt->in : pkt->out);
 
-	nf_log_packet(net, pkt->xt.family, pkt->hooknum, pkt->skb, pkt->in,
+	nf_log_packet(net, pkt->xt.family, pkt->ops->hooknum, pkt->skb, pkt->in,
 		      pkt->out, &trace_loginfo, "TRACE: %s:%s:%s:%u ",
 		      chain->table->name, chain->name, comments[type],
 		      rulenum);
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 57cad07..5af7901 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -33,7 +33,7 @@ static void nft_log_eval(const struct nft_expr *expr,
 	const struct nft_log *priv = nft_expr_priv(expr);
 	struct net *net = dev_net(pkt->in ? pkt->in : pkt->out);
 
-	nf_log_packet(net, priv->family, pkt->hooknum, pkt->skb, pkt->in,
+	nf_log_packet(net, priv->family, pkt->ops->hooknum, pkt->skb, pkt->in,
 		      pkt->out, &priv->loginfo, "%s", priv->prefix);
 }
 
-- 
1.8.4.2

