From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH] nftables: fib: Support existence check
Date: Fri, 10 Mar 2017 18:08:02 +0100
Message-ID: <20170310170802.27802-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53317 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755172AbdCJRIP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 12:08:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of the actual interface index or name, set destination register
to just 1 or 0 depending on whether the lookup succeeded or not if
NFTA_FIB_F_PRESENT was set in userspace.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nft_fib.h          |  2 +-
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/ipv4/netfilter/nft_fib_ipv4.c        |  4 ++--
 net/ipv6/netfilter/nft_fib_ipv6.c        |  2 +-
 net/netfilter/nft_fib.c                  | 14 +++++++++-----
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index 5ceb2205e4e3e..381af9469e6ad 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -32,6 +32,6 @@ void nft_fib6_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		   const struct nft_pktinfo *pkt);
 
-void nft_fib_store_result(void *reg, enum nft_fib_result r,
+void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 			  const struct nft_pktinfo *pkt, int index);
 #endif
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 4f7d75682c591..a9280a6541ac6 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1257,6 +1257,7 @@ enum nft_fib_flags {
 	NFTA_FIB_F_MARK		= 1 << 2,	/* use skb->mark */
 	NFTA_FIB_F_IIF		= 1 << 3,	/* restrict to iif */
 	NFTA_FIB_F_OIF		= 1 << 4,	/* restrict to oif */
+	NFTA_FIB_F_PRESENT	= 1 << 5,	/* check existence only */
 };
 
 #define NFT_OBJECT_UNSPEC	0
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 2981291910dd2..f4e4462cb5bb1 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -90,7 +90,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv->result, pkt,
+		nft_fib_store_result(dest, priv, pkt,
 				     nft_in(pkt)->ifindex);
 		return;
 	}
@@ -99,7 +99,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (ipv4_is_zeronet(iph->saddr)) {
 		if (ipv4_is_lbcast(iph->daddr) ||
 		    ipv4_is_local_multicast(iph->daddr)) {
-			nft_fib_store_result(dest, priv->result, pkt,
+			nft_fib_store_result(dest, priv, pkt,
 					     get_ifindex(pkt->skb->dev));
 			return;
 		}
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 765facf03d45c..e8d88d82636b7 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -159,7 +159,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv->result, pkt,
+		nft_fib_store_result(dest, priv, pkt,
 				     nft_in(pkt)->ifindex);
 		return;
 	}
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index fd0b19303b0db..21df8cccea658 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -24,7 +24,8 @@ const struct nla_policy nft_fib_policy[NFTA_FIB_MAX + 1] = {
 EXPORT_SYMBOL(nft_fib_policy);
 
 #define NFTA_FIB_F_ALL (NFTA_FIB_F_SADDR | NFTA_FIB_F_DADDR | \
-			NFTA_FIB_F_MARK | NFTA_FIB_F_IIF | NFTA_FIB_F_OIF)
+			NFTA_FIB_F_MARK | NFTA_FIB_F_IIF | NFTA_FIB_F_OIF | \
+			NFTA_FIB_F_PRESENT)
 
 int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		     const struct nft_data **data)
@@ -133,19 +134,22 @@ int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr)
 }
 EXPORT_SYMBOL_GPL(nft_fib_dump);
 
-void nft_fib_store_result(void *reg, enum nft_fib_result r,
+void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 			  const struct nft_pktinfo *pkt, int index)
 {
 	struct net_device *dev;
 	u32 *dreg = reg;
 
-	switch (r) {
+	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
-		*dreg = index;
+		*dreg = (priv->flags & NFTA_FIB_F_PRESENT) ? !!index : index;
 		break;
 	case NFT_FIB_RESULT_OIFNAME:
 		dev = dev_get_by_index_rcu(nft_net(pkt), index);
-		strncpy(reg, dev ? dev->name : "", IFNAMSIZ);
+		if (priv->flags & NFTA_FIB_F_PRESENT)
+			*dreg = !!dev;
+		else
+			strncpy(reg, dev ? dev->name : "", IFNAMSIZ);
 		break;
 	default:
 		WARN_ON_ONCE(1);
-- 
2.11.0

