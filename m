Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22C3C77B73
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 16:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238015AbjFFQft (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 12:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238043AbjFFQfq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 12:35:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FA33126
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 09:35:41 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf-next,v2 1/7] netfilter: nf_tables: remove expression reduce infrastructure
Date:   Tue,  6 Jun 2023 18:35:27 +0200
Message-Id: <20230606163533.1533-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230606163533.1533-1-pablo@netfilter.org>
References: <20230606163533.1533-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This infrastructure is disabled since 9e539c5b6d9c ("netfilter: nf_tables:
disable expression reduction infra") and the combo match infrastructure
provides an alternative to this approach, remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/net/netfilter/nf_tables.h        |  36 --------
 include/net/netfilter/nft_fib.h          |   2 -
 include/net/netfilter/nft_meta.h         |   3 -
 net/bridge/netfilter/nft_meta_bridge.c   |  20 -----
 net/bridge/netfilter/nft_reject_bridge.c |   1 -
 net/ipv4/netfilter/nft_dup_ipv4.c        |   1 -
 net/ipv4/netfilter/nft_fib_ipv4.c        |   2 -
 net/ipv4/netfilter/nft_reject_ipv4.c     |   1 -
 net/ipv6/netfilter/nft_dup_ipv6.c        |   1 -
 net/ipv6/netfilter/nft_fib_ipv6.c        |   2 -
 net/ipv6/netfilter/nft_reject_ipv6.c     |   1 -
 net/netfilter/nf_tables_api.c            |  66 ---------------
 net/netfilter/nft_bitwise.c              | 103 -----------------------
 net/netfilter/nft_byteorder.c            |  11 ---
 net/netfilter/nft_cmp.c                  |   3 -
 net/netfilter/nft_compat.c               |  10 ---
 net/netfilter/nft_connlimit.c            |   1 -
 net/netfilter/nft_counter.c              |   1 -
 net/netfilter/nft_ct.c                   |  46 ----------
 net/netfilter/nft_dup_netdev.c           |   1 -
 net/netfilter/nft_dynset.c               |   1 -
 net/netfilter/nft_exthdr.c               |  34 --------
 net/netfilter/nft_fib.c                  |  42 ---------
 net/netfilter/nft_fib_inet.c             |   1 -
 net/netfilter/nft_fib_netdev.c           |   1 -
 net/netfilter/nft_flow_offload.c         |   1 -
 net/netfilter/nft_fwd_netdev.c           |   2 -
 net/netfilter/nft_hash.c                 |  36 --------
 net/netfilter/nft_immediate.c            |  12 ---
 net/netfilter/nft_last.c                 |   1 -
 net/netfilter/nft_limit.c                |   2 -
 net/netfilter/nft_log.c                  |   1 -
 net/netfilter/nft_lookup.c               |  12 ---
 net/netfilter/nft_masq.c                 |   3 -
 net/netfilter/nft_meta.c                 |  45 ----------
 net/netfilter/nft_nat.c                  |   2 -
 net/netfilter/nft_numgen.c               |  22 -----
 net/netfilter/nft_objref.c               |   2 -
 net/netfilter/nft_osf.c                  |  25 ------
 net/netfilter/nft_payload.c              |  47 -----------
 net/netfilter/nft_queue.c                |   2 -
 net/netfilter/nft_quota.c                |   1 -
 net/netfilter/nft_range.c                |   1 -
 net/netfilter/nft_redir.c                |   3 -
 net/netfilter/nft_reject_inet.c          |   1 -
 net/netfilter/nft_reject_netdev.c        |   1 -
 net/netfilter/nft_rt.c                   |   1 -
 net/netfilter/nft_socket.c               |  26 ------
 net/netfilter/nft_synproxy.c             |   1 -
 net/netfilter/nft_tproxy.c               |   1 -
 net/netfilter/nft_tunnel.c               |  26 ------
 net/netfilter/nft_xfrm.c                 |  27 ------
 52 files changed, 695 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2e24ea1d744c..588b1904e411 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -123,17 +123,6 @@ struct nft_regs {
 	};
 };
 
-struct nft_regs_track {
-	struct {
-		const struct nft_expr		*selector;
-		const struct nft_expr		*bitwise;
-		u8				num_reg;
-	} regs[NFT_REG32_NUM];
-
-	const struct nft_expr			*cur;
-	const struct nft_expr			*last;
-};
-
 /* Store/load an u8, u16 or u64 integer to/from the u32 data register.
  *
  * Note, when using concatenations, register allocation happens at 32-bit
@@ -396,8 +385,6 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr, bool reset);
-bool nft_expr_reduce_bitwise(struct nft_regs_track *track,
-			     const struct nft_expr *expr);
 
 struct nft_set_ext;
 
@@ -947,8 +934,6 @@ struct nft_expr_ops {
 	int				(*validate)(const struct nft_ctx *ctx,
 						    const struct nft_expr *expr,
 						    const struct nft_data **data);
-	bool				(*reduce)(struct nft_regs_track *track,
-						  const struct nft_expr *expr);
 	bool				(*gc)(struct net *net,
 					      const struct nft_expr *expr);
 	int				(*offload)(struct nft_offload_ctx *ctx,
@@ -1712,25 +1697,4 @@ static inline struct nftables_pernet *nft_pernet(const struct net *net)
 	return net_generic(net, nf_tables_net_id);
 }
 
-#define __NFT_REDUCE_READONLY	1UL
-#define NFT_REDUCE_READONLY	(void *)__NFT_REDUCE_READONLY
-
-static inline bool nft_reduce_is_readonly(const struct nft_expr *expr)
-{
-	return expr->ops->reduce == NFT_REDUCE_READONLY;
-}
-
-void nft_reg_track_update(struct nft_regs_track *track,
-			  const struct nft_expr *expr, u8 dreg, u8 len);
-void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, u8 len);
-void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg);
-
-static inline bool nft_reg_track_cmp(struct nft_regs_track *track,
-				     const struct nft_expr *expr, u8 dreg)
-{
-	return track->regs[dreg].selector &&
-	       track->regs[dreg].selector->ops == expr->ops &&
-	       track->regs[dreg].num_reg == 0;
-}
-
 #endif /* _NET_NF_TABLES_H */
diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index 167640b843ef..2e434ba41b97 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -38,6 +38,4 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 			  const struct net_device *dev);
 
-bool nft_fib_reduce(struct nft_regs_track *track,
-		    const struct nft_expr *expr);
 #endif
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index ba1238f12a48..690f6245026c 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -44,9 +44,6 @@ int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr,
 			  const struct nft_data **data);
 
-bool nft_meta_get_reduce(struct nft_regs_track *track,
-			 const struct nft_expr *expr);
-
 struct nft_inner_tun_ctx;
 void nft_meta_inner_eval(const struct nft_expr *expr,
 			 struct nft_regs *regs, const struct nft_pktinfo *pkt,
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index bd4d1b4d745f..93e8a8dadd80 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -102,7 +102,6 @@ static const struct nft_expr_ops nft_meta_bridge_get_ops = {
 	.eval		= nft_meta_bridge_get_eval,
 	.init		= nft_meta_bridge_get_init,
 	.dump		= nft_meta_get_dump,
-	.reduce		= nft_meta_get_reduce,
 };
 
 static void nft_meta_bridge_set_eval(const struct nft_expr *expr,
@@ -149,24 +148,6 @@ static int nft_meta_bridge_set_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
-				       const struct nft_expr *expr)
-{
-	int i;
-
-	for (i = 0; i < NFT_REG32_NUM; i++) {
-		if (!track->regs[i].selector)
-			continue;
-
-		if (track->regs[i].selector->ops != &nft_meta_bridge_get_ops)
-			continue;
-
-		__nft_reg_track_cancel(track, i);
-	}
-
-	return false;
-}
-
 static int nft_meta_bridge_set_validate(const struct nft_ctx *ctx,
 					const struct nft_expr *expr,
 					const struct nft_data **data)
@@ -192,7 +173,6 @@ static const struct nft_expr_ops nft_meta_bridge_set_ops = {
 	.init		= nft_meta_bridge_set_init,
 	.destroy	= nft_meta_set_destroy,
 	.dump		= nft_meta_set_dump,
-	.reduce		= nft_meta_bridge_set_reduce,
 	.validate	= nft_meta_bridge_set_validate,
 };
 
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 71b54fed7263..fbf858ddec35 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -185,7 +185,6 @@ static const struct nft_expr_ops nft_reject_bridge_ops = {
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
 	.validate	= nft_reject_bridge_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_reject_bridge_type __read_mostly = {
diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup_ipv4.c
index a522c3a3be52..cae5b38335b3 100644
--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -76,7 +76,6 @@ static const struct nft_expr_ops nft_dup_ipv4_ops = {
 	.eval		= nft_dup_ipv4_eval,
 	.init		= nft_dup_ipv4_init,
 	.dump		= nft_dup_ipv4_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nla_policy nft_dup_ipv4_policy[NFTA_DUP_MAX + 1] = {
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 9eee535c64dd..55c4b73265ed 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -159,7 +159,6 @@ static const struct nft_expr_ops nft_fib4_type_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
-	.reduce		= nft_fib_reduce,
 };
 
 static const struct nft_expr_ops nft_fib4_ops = {
@@ -169,7 +168,6 @@ static const struct nft_expr_ops nft_fib4_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
-	.reduce		= nft_fib_reduce,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index 6cb213bb7256..55fc23a8f7a7 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -45,7 +45,6 @@ static const struct nft_expr_ops nft_reject_ipv4_ops = {
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
 	.validate	= nft_reject_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_reject_ipv4_type __read_mostly = {
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
index c82f3fdd4a65..e859beb29bb1 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -74,7 +74,6 @@ static const struct nft_expr_ops nft_dup_ipv6_ops = {
 	.eval		= nft_dup_ipv6_eval,
 	.init		= nft_dup_ipv6_init,
 	.dump		= nft_dup_ipv6_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nla_policy nft_dup_ipv6_policy[NFTA_DUP_MAX + 1] = {
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 36dc14b34388..6ae17f530994 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -220,7 +220,6 @@ static const struct nft_expr_ops nft_fib6_type_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
-	.reduce		= nft_fib_reduce,
 };
 
 static const struct nft_expr_ops nft_fib6_ops = {
@@ -230,7 +229,6 @@ static const struct nft_expr_ops nft_fib6_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
-	.reduce		= nft_fib_reduce,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/ipv6/netfilter/nft_reject_ipv6.c b/net/ipv6/netfilter/nft_reject_ipv6.c
index 5c61294f410e..ed69c768797e 100644
--- a/net/ipv6/netfilter/nft_reject_ipv6.c
+++ b/net/ipv6/netfilter/nft_reject_ipv6.c
@@ -46,7 +46,6 @@ static const struct nft_expr_ops nft_reject_ipv6_ops = {
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
 	.validate	= nft_reject_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_reject_ipv6_type __read_mostly = {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0396fd8f4e71..80932407b9a6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -576,58 +576,6 @@ static int nft_delflowtable(struct nft_ctx *ctx,
 	return err;
 }
 
-static void __nft_reg_track_clobber(struct nft_regs_track *track, u8 dreg)
-{
-	int i;
-
-	for (i = track->regs[dreg].num_reg; i > 0; i--)
-		__nft_reg_track_cancel(track, dreg - i);
-}
-
-static void __nft_reg_track_update(struct nft_regs_track *track,
-				   const struct nft_expr *expr,
-				   u8 dreg, u8 num_reg)
-{
-	track->regs[dreg].selector = expr;
-	track->regs[dreg].bitwise = NULL;
-	track->regs[dreg].num_reg = num_reg;
-}
-
-void nft_reg_track_update(struct nft_regs_track *track,
-			  const struct nft_expr *expr, u8 dreg, u8 len)
-{
-	unsigned int regcount;
-	int i;
-
-	__nft_reg_track_clobber(track, dreg);
-
-	regcount = DIV_ROUND_UP(len, NFT_REG32_SIZE);
-	for (i = 0; i < regcount; i++, dreg++)
-		__nft_reg_track_update(track, expr, dreg, i);
-}
-EXPORT_SYMBOL_GPL(nft_reg_track_update);
-
-void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, u8 len)
-{
-	unsigned int regcount;
-	int i;
-
-	__nft_reg_track_clobber(track, dreg);
-
-	regcount = DIV_ROUND_UP(len, NFT_REG32_SIZE);
-	for (i = 0; i < regcount; i++, dreg++)
-		__nft_reg_track_cancel(track, dreg);
-}
-EXPORT_SYMBOL_GPL(nft_reg_track_cancel);
-
-void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg)
-{
-	track->regs[dreg].selector = NULL;
-	track->regs[dreg].bitwise = NULL;
-	track->regs[dreg].num_reg = 0;
-}
-EXPORT_SYMBOL_GPL(__nft_reg_track_cancel);
-
 /*
  * Tables
  */
@@ -8953,16 +8901,9 @@ void nf_tables_trans_destroy_flush_work(void)
 }
 EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
 
-static bool nft_expr_reduce(struct nft_regs_track *track,
-			    const struct nft_expr *expr)
-{
-	return false;
-}
-
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
 {
 	const struct nft_expr *expr, *last;
-	struct nft_regs_track track = {};
 	unsigned int size, data_size;
 	void *data, *data_boundary;
 	struct nft_rule_dp *prule;
@@ -8999,14 +8940,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 			return -ENOMEM;
 
 		size = 0;
-		track.last = nft_expr_last(rule);
 		nft_rule_for_each_expr(expr, last, rule) {
-			track.cur = expr;
-
-			if (nft_expr_reduce(&track, expr)) {
-				expr = track.cur;
-				continue;
-			}
 
 			if (WARN_ON_ONCE(data + expr->ops->size > data_boundary))
 				return -ENOMEM;
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 84eae7cabc67..8d2b9249078a 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -281,60 +281,12 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
-static bool nft_bitwise_reduce(struct nft_regs_track *track,
-			       const struct nft_expr *expr)
-{
-	const struct nft_bitwise *priv = nft_expr_priv(expr);
-	const struct nft_bitwise *bitwise;
-	unsigned int regcount;
-	u8 dreg;
-	int i;
-
-	if (!track->regs[priv->sreg].selector)
-		return false;
-
-	bitwise = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
-	    track->regs[priv->sreg].num_reg == 0 &&
-	    track->regs[priv->dreg].bitwise &&
-	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
-	    priv->sreg == bitwise->sreg &&
-	    priv->dreg == bitwise->dreg &&
-	    priv->op == bitwise->op &&
-	    priv->len == bitwise->len &&
-	    !memcmp(&priv->mask, &bitwise->mask, sizeof(priv->mask)) &&
-	    !memcmp(&priv->xor, &bitwise->xor, sizeof(priv->xor)) &&
-	    !memcmp(&priv->data, &bitwise->data, sizeof(priv->data))) {
-		track->cur = expr;
-		return true;
-	}
-
-	if (track->regs[priv->sreg].bitwise ||
-	    track->regs[priv->sreg].num_reg != 0) {
-		nft_reg_track_cancel(track, priv->dreg, priv->len);
-		return false;
-	}
-
-	if (priv->sreg != priv->dreg) {
-		nft_reg_track_update(track, track->regs[priv->sreg].selector,
-				     priv->dreg, priv->len);
-	}
-
-	dreg = priv->dreg;
-	regcount = DIV_ROUND_UP(priv->len, NFT_REG32_SIZE);
-	for (i = 0; i < regcount; i++, dreg++)
-		track->regs[priv->dreg].bitwise = expr;
-
-	return false;
-}
-
 static const struct nft_expr_ops nft_bitwise_ops = {
 	.type		= &nft_bitwise_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_bitwise)),
 	.eval		= nft_bitwise_eval,
 	.init		= nft_bitwise_init,
 	.dump		= nft_bitwise_dump,
-	.reduce		= nft_bitwise_reduce,
 	.offload	= nft_bitwise_offload,
 };
 
@@ -436,48 +388,12 @@ static int nft_bitwise_fast_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
-static bool nft_bitwise_fast_reduce(struct nft_regs_track *track,
-				    const struct nft_expr *expr)
-{
-	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
-	const struct nft_bitwise_fast_expr *bitwise;
-
-	if (!track->regs[priv->sreg].selector)
-		return false;
-
-	bitwise = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
-	    track->regs[priv->dreg].bitwise &&
-	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
-	    priv->sreg == bitwise->sreg &&
-	    priv->dreg == bitwise->dreg &&
-	    priv->mask == bitwise->mask &&
-	    priv->xor == bitwise->xor) {
-		track->cur = expr;
-		return true;
-	}
-
-	if (track->regs[priv->sreg].bitwise) {
-		nft_reg_track_cancel(track, priv->dreg, NFT_REG32_SIZE);
-		return false;
-	}
-
-	if (priv->sreg != priv->dreg) {
-		track->regs[priv->dreg].selector =
-			track->regs[priv->sreg].selector;
-	}
-	track->regs[priv->dreg].bitwise = expr;
-
-	return false;
-}
-
 const struct nft_expr_ops nft_bitwise_fast_ops = {
 	.type		= &nft_bitwise_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_bitwise_fast_expr)),
 	.eval		= NULL, /* inlined */
 	.init		= nft_bitwise_fast_init,
 	.dump		= nft_bitwise_fast_dump,
-	.reduce		= nft_bitwise_fast_reduce,
 	.offload	= nft_bitwise_fast_offload,
 };
 
@@ -514,22 +430,3 @@ struct nft_expr_type nft_bitwise_type __read_mostly = {
 	.maxattr	= NFTA_BITWISE_MAX,
 	.owner		= THIS_MODULE,
 };
-
-bool nft_expr_reduce_bitwise(struct nft_regs_track *track,
-			     const struct nft_expr *expr)
-{
-	const struct nft_expr *last = track->last;
-	const struct nft_expr *next;
-
-	if (expr == last)
-		return false;
-
-	next = nft_expr_next(expr);
-	if (next->ops == &nft_bitwise_ops)
-		return nft_bitwise_reduce(track, next);
-	else if (next->ops == &nft_bitwise_fast_ops)
-		return nft_bitwise_fast_reduce(track, next);
-
-	return false;
-}
-EXPORT_SYMBOL_GPL(nft_expr_reduce_bitwise);
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index b66647a5a171..a42d03741bb3 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -169,23 +169,12 @@ static int nft_byteorder_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static bool nft_byteorder_reduce(struct nft_regs_track *track,
-				 const struct nft_expr *expr)
-{
-	struct nft_byteorder *priv = nft_expr_priv(expr);
-
-	nft_reg_track_cancel(track, priv->dreg, priv->len);
-
-	return false;
-}
-
 static const struct nft_expr_ops nft_byteorder_ops = {
 	.type		= &nft_byteorder_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_byteorder)),
 	.eval		= nft_byteorder_eval,
 	.init		= nft_byteorder_init,
 	.dump		= nft_byteorder_dump,
-	.reduce		= nft_byteorder_reduce,
 };
 
 struct nft_expr_type nft_byteorder_type __read_mostly = {
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 6eb21a4f5698..75a7b24eeefc 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -190,7 +190,6 @@ static const struct nft_expr_ops nft_cmp_ops = {
 	.eval		= nft_cmp_eval,
 	.init		= nft_cmp_init,
 	.dump		= nft_cmp_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_cmp_offload,
 };
 
@@ -282,7 +281,6 @@ const struct nft_expr_ops nft_cmp_fast_ops = {
 	.eval		= NULL,	/* inlined */
 	.init		= nft_cmp_fast_init,
 	.dump		= nft_cmp_fast_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_cmp_fast_offload,
 };
 
@@ -376,7 +374,6 @@ const struct nft_expr_ops nft_cmp16_fast_ops = {
 	.eval		= NULL,	/* inlined */
 	.init		= nft_cmp16_fast_init,
 	.dump		= nft_cmp16_fast_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_cmp16_fast_offload,
 };
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 5284cd2ad532..e178b479dfaf 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -734,14 +734,6 @@ static const struct nfnetlink_subsystem nfnl_compat_subsys = {
 
 static struct nft_expr_type nft_match_type;
 
-static bool nft_match_reduce(struct nft_regs_track *track,
-			     const struct nft_expr *expr)
-{
-	const struct xt_match *match = expr->ops->data;
-
-	return strcmp(match->name, "comment") == 0;
-}
-
 static const struct nft_expr_ops *
 nft_match_select_ops(const struct nft_ctx *ctx,
 		     const struct nlattr * const tb[])
@@ -784,7 +776,6 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	ops->dump = nft_match_dump;
 	ops->validate = nft_match_validate;
 	ops->data = match;
-	ops->reduce = nft_match_reduce;
 
 	matchsize = NFT_EXPR_SIZE(XT_ALIGN(match->matchsize));
 	if (matchsize > NFT_MATCH_LARGE_THRESH) {
@@ -874,7 +865,6 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	ops->dump = nft_target_dump;
 	ops->validate = nft_target_validate;
 	ops->data = target;
-	ops->reduce = NFT_REDUCE_READONLY;
 
 	if (family == NFPROTO_BRIDGE)
 		ops->eval = nft_target_eval_bridge;
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index de9d1980df69..53ef6854f8e6 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -258,7 +258,6 @@ static const struct nft_expr_ops nft_connlimit_ops = {
 	.destroy_clone	= nft_connlimit_destroy_clone,
 	.dump		= nft_connlimit_dump,
 	.gc		= nft_connlimit_gc,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_connlimit_type __read_mostly = {
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index dccc68a5135a..446406631c9a 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -294,7 +294,6 @@ static const struct nft_expr_ops nft_counter_ops = {
 	.destroy_clone	= nft_counter_destroy,
 	.dump		= nft_counter_dump,
 	.clone		= nft_counter_clone,
-	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_counter_offload,
 	.offload_stats	= nft_counter_offload_stats,
 };
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index b9c84499438b..fe25ce6fa0bd 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -671,29 +671,6 @@ static int nft_ct_get_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static bool nft_ct_get_reduce(struct nft_regs_track *track,
-			      const struct nft_expr *expr)
-{
-	const struct nft_ct *priv = nft_expr_priv(expr);
-	const struct nft_ct *ct;
-
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	ct = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (priv->key != ct->key) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return nft_expr_reduce_bitwise(track, expr);
-}
-
 static int nft_ct_set_dump(struct sk_buff *skb,
 			   const struct nft_expr *expr, bool reset)
 {
@@ -728,27 +705,8 @@ static const struct nft_expr_ops nft_ct_get_ops = {
 	.init		= nft_ct_get_init,
 	.destroy	= nft_ct_get_destroy,
 	.dump		= nft_ct_get_dump,
-	.reduce		= nft_ct_get_reduce,
 };
 
-static bool nft_ct_set_reduce(struct nft_regs_track *track,
-			      const struct nft_expr *expr)
-{
-	int i;
-
-	for (i = 0; i < NFT_REG32_NUM; i++) {
-		if (!track->regs[i].selector)
-			continue;
-
-		if (track->regs[i].selector->ops != &nft_ct_get_ops)
-			continue;
-
-		__nft_reg_track_cancel(track, i);
-	}
-
-	return false;
-}
-
 #ifdef CONFIG_RETPOLINE
 static const struct nft_expr_ops nft_ct_get_fast_ops = {
 	.type		= &nft_ct_type,
@@ -757,7 +715,6 @@ static const struct nft_expr_ops nft_ct_get_fast_ops = {
 	.init		= nft_ct_get_init,
 	.destroy	= nft_ct_get_destroy,
 	.dump		= nft_ct_get_dump,
-	.reduce		= nft_ct_set_reduce,
 };
 #endif
 
@@ -768,7 +725,6 @@ static const struct nft_expr_ops nft_ct_set_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
-	.reduce		= nft_ct_set_reduce,
 };
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
@@ -779,7 +735,6 @@ static const struct nft_expr_ops nft_ct_set_zone_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
-	.reduce		= nft_ct_set_reduce,
 };
 #endif
 
@@ -849,7 +804,6 @@ static const struct nft_expr_ops nft_notrack_ops = {
 	.type		= &nft_notrack_type,
 	.size		= NFT_EXPR_SIZE(0),
 	.eval		= nft_notrack_eval,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_notrack_type __read_mostly = {
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index e5739a59ebf1..2007700bef8e 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -80,7 +80,6 @@ static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.eval		= nft_dup_netdev_eval,
 	.init		= nft_dup_netdev_init,
 	.dump		= nft_dup_netdev_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_dup_netdev_offload,
 	.offload_action	= nft_dup_netdev_offload_action,
 };
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index bd19c7aec92e..c3bd57be2ee8 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -414,7 +414,6 @@ static const struct nft_expr_ops nft_dynset_ops = {
 	.activate	= nft_dynset_activate,
 	.deactivate	= nft_dynset_deactivate,
 	.dump		= nft_dynset_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 struct nft_expr_type nft_dynset_type __read_mostly = {
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 671474e59817..41e8ae77b823 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -698,40 +698,12 @@ static int nft_exthdr_dump_strip(struct sk_buff *skb,
 	return nft_exthdr_dump_common(skb, priv);
 }
 
-static bool nft_exthdr_reduce(struct nft_regs_track *track,
-			       const struct nft_expr *expr)
-{
-	const struct nft_exthdr *priv = nft_expr_priv(expr);
-	const struct nft_exthdr *exthdr;
-
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	exthdr = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (priv->type != exthdr->type ||
-	    priv->op != exthdr->op ||
-	    priv->flags != exthdr->flags ||
-	    priv->offset != exthdr->offset ||
-	    priv->len != exthdr->len) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return nft_expr_reduce_bitwise(track, expr);
-}
-
 static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
 	.type		= &nft_exthdr_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
 	.eval		= nft_exthdr_ipv6_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
-	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops nft_exthdr_ipv4_ops = {
@@ -740,7 +712,6 @@ static const struct nft_expr_ops nft_exthdr_ipv4_ops = {
 	.eval		= nft_exthdr_ipv4_eval,
 	.init		= nft_exthdr_ipv4_init,
 	.dump		= nft_exthdr_dump,
-	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops nft_exthdr_tcp_ops = {
@@ -749,7 +720,6 @@ static const struct nft_expr_ops nft_exthdr_tcp_ops = {
 	.eval		= nft_exthdr_tcp_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
-	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops nft_exthdr_tcp_set_ops = {
@@ -758,7 +728,6 @@ static const struct nft_expr_ops nft_exthdr_tcp_set_ops = {
 	.eval		= nft_exthdr_tcp_set_eval,
 	.init		= nft_exthdr_tcp_set_init,
 	.dump		= nft_exthdr_dump_set,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops nft_exthdr_tcp_strip_ops = {
@@ -767,7 +736,6 @@ static const struct nft_expr_ops nft_exthdr_tcp_strip_ops = {
 	.eval		= nft_exthdr_tcp_strip_eval,
 	.init		= nft_exthdr_tcp_strip_init,
 	.dump		= nft_exthdr_dump_strip,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops nft_exthdr_sctp_ops = {
@@ -776,7 +744,6 @@ static const struct nft_expr_ops nft_exthdr_sctp_ops = {
 	.eval		= nft_exthdr_sctp_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
-	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops nft_exthdr_dccp_ops = {
@@ -785,7 +752,6 @@ static const struct nft_expr_ops nft_exthdr_dccp_ops = {
 	.eval		= nft_exthdr_dccp_eval,
 	.init		= nft_exthdr_dccp_init,
 	.dump		= nft_exthdr_dump,
-	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 6e049fd48760..e7cb42c9c175 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -160,47 +160,5 @@ void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 }
 EXPORT_SYMBOL_GPL(nft_fib_store_result);
 
-bool nft_fib_reduce(struct nft_regs_track *track,
-		    const struct nft_expr *expr)
-{
-	const struct nft_fib *priv = nft_expr_priv(expr);
-	unsigned int len = NFT_REG32_SIZE;
-	const struct nft_fib *fib;
-
-	switch (priv->result) {
-	case NFT_FIB_RESULT_OIF:
-		break;
-	case NFT_FIB_RESULT_OIFNAME:
-		if (priv->flags & NFTA_FIB_F_PRESENT)
-			len = NFT_REG32_SIZE;
-		else
-			len = IFNAMSIZ;
-		break;
-	case NFT_FIB_RESULT_ADDRTYPE:
-	     break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
-
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
-		nft_reg_track_update(track, expr, priv->dreg, len);
-		return false;
-	}
-
-	fib = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (priv->result != fib->result ||
-	    priv->flags != fib->flags) {
-		nft_reg_track_update(track, expr, priv->dreg, len);
-		return false;
-	}
-
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return false;
-}
-EXPORT_SYMBOL_GPL(nft_fib_reduce);
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
diff --git a/net/netfilter/nft_fib_inet.c b/net/netfilter/nft_fib_inet.c
index 666a3741d20b..a88d44e163d1 100644
--- a/net/netfilter/nft_fib_inet.c
+++ b/net/netfilter/nft_fib_inet.c
@@ -49,7 +49,6 @@ static const struct nft_expr_ops nft_fib_inet_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
-	.reduce		= nft_fib_reduce,
 };
 
 static struct nft_expr_type nft_fib_inet_type __read_mostly = {
diff --git a/net/netfilter/nft_fib_netdev.c b/net/netfilter/nft_fib_netdev.c
index 9121ec64e918..3f3478abd845 100644
--- a/net/netfilter/nft_fib_netdev.c
+++ b/net/netfilter/nft_fib_netdev.c
@@ -58,7 +58,6 @@ static const struct nft_expr_ops nft_fib_netdev_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
-	.reduce		= nft_fib_reduce,
 };
 
 static struct nft_expr_type nft_fib_netdev_type __read_mostly = {
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 5ef9146e74ad..59c468261134 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -462,7 +462,6 @@ static const struct nft_expr_ops nft_flow_offload_ops = {
 	.destroy	= nft_flow_offload_destroy,
 	.validate	= nft_flow_offload_validate,
 	.dump		= nft_flow_offload_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_flow_offload_type __read_mostly = {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 7b9d4d1bd17c..a534d060ce1b 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -219,7 +219,6 @@ static const struct nft_expr_ops nft_fwd_neigh_netdev_ops = {
 	.init		= nft_fwd_neigh_init,
 	.dump		= nft_fwd_neigh_dump,
 	.validate	= nft_fwd_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops nft_fwd_netdev_ops = {
@@ -229,7 +228,6 @@ static const struct nft_expr_ops nft_fwd_netdev_ops = {
 	.init		= nft_fwd_netdev_init,
 	.dump		= nft_fwd_netdev_dump,
 	.validate	= nft_fwd_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_fwd_netdev_offload,
 	.offload_action	= nft_fwd_netdev_offload_action,
 };
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index ee8d487b69c0..4fc99c80b28e 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -165,16 +165,6 @@ static int nft_jhash_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static bool nft_jhash_reduce(struct nft_regs_track *track,
-			     const struct nft_expr *expr)
-{
-	const struct nft_jhash *priv = nft_expr_priv(expr);
-
-	nft_reg_track_cancel(track, priv->dreg, sizeof(u32));
-
-	return false;
-}
-
 static int nft_symhash_dump(struct sk_buff *skb,
 			    const struct nft_expr *expr, bool reset)
 {
@@ -195,30 +185,6 @@ static int nft_symhash_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static bool nft_symhash_reduce(struct nft_regs_track *track,
-			       const struct nft_expr *expr)
-{
-	struct nft_symhash *priv = nft_expr_priv(expr);
-	struct nft_symhash *symhash;
-
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
-		nft_reg_track_update(track, expr, priv->dreg, sizeof(u32));
-		return false;
-	}
-
-	symhash = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (priv->offset != symhash->offset ||
-	    priv->modulus != symhash->modulus) {
-		nft_reg_track_update(track, expr, priv->dreg, sizeof(u32));
-		return false;
-	}
-
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return false;
-}
-
 static struct nft_expr_type nft_hash_type;
 static const struct nft_expr_ops nft_jhash_ops = {
 	.type		= &nft_hash_type,
@@ -226,7 +192,6 @@ static const struct nft_expr_ops nft_jhash_ops = {
 	.eval		= nft_jhash_eval,
 	.init		= nft_jhash_init,
 	.dump		= nft_jhash_dump,
-	.reduce		= nft_jhash_reduce,
 };
 
 static const struct nft_expr_ops nft_symhash_ops = {
@@ -235,7 +200,6 @@ static const struct nft_expr_ops nft_symhash_ops = {
 	.eval		= nft_symhash_eval,
 	.init		= nft_symhash_init,
 	.dump		= nft_symhash_dump,
-	.reduce		= nft_symhash_reduce,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index c9d2f7c29f53..0d744c3f73b3 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -240,17 +240,6 @@ static bool nft_immediate_offload_action(const struct nft_expr *expr)
 	return false;
 }
 
-static bool nft_immediate_reduce(struct nft_regs_track *track,
-				 const struct nft_expr *expr)
-{
-	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
-
-	if (priv->dreg != NFT_REG_VERDICT)
-		nft_reg_track_cancel(track, priv->dreg, priv->dlen);
-
-	return false;
-}
-
 static const struct nft_expr_ops nft_imm_ops = {
 	.type		= &nft_imm_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
@@ -261,7 +250,6 @@ static const struct nft_expr_ops nft_imm_ops = {
 	.destroy	= nft_immediate_destroy,
 	.dump		= nft_immediate_dump,
 	.validate	= nft_immediate_validate,
-	.reduce		= nft_immediate_reduce,
 	.offload	= nft_immediate_offload,
 	.offload_action	= nft_immediate_offload_action,
 };
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 8e6d7eaf9dc8..5d44d45ca4ef 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -125,7 +125,6 @@ static const struct nft_expr_ops nft_last_ops = {
 	.destroy	= nft_last_destroy,
 	.clone		= nft_last_clone,
 	.dump		= nft_last_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 struct nft_expr_type nft_last_type __read_mostly = {
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 145dc62c6247..10752da5bd16 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -228,7 +228,6 @@ static const struct nft_expr_ops nft_limit_pkts_ops = {
 	.destroy	= nft_limit_pkts_destroy,
 	.clone		= nft_limit_pkts_clone,
 	.dump		= nft_limit_pkts_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static void nft_limit_bytes_eval(const struct nft_expr *expr,
@@ -283,7 +282,6 @@ static const struct nft_expr_ops nft_limit_bytes_ops = {
 	.dump		= nft_limit_bytes_dump,
 	.clone		= nft_limit_bytes_clone,
 	.destroy	= nft_limit_bytes_destroy,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 5defe6e4fd98..84e374411877 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -291,7 +291,6 @@ static const struct nft_expr_ops nft_log_ops = {
 	.init		= nft_log_init,
 	.destroy	= nft_log_destroy,
 	.dump		= nft_log_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_log_type __read_mostly = {
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 29ac48cdd6db..5ba799a7722d 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -233,17 +233,6 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static bool nft_lookup_reduce(struct nft_regs_track *track,
-			      const struct nft_expr *expr)
-{
-	const struct nft_lookup *priv = nft_expr_priv(expr);
-
-	if (priv->set->flags & NFT_SET_MAP)
-		nft_reg_track_cancel(track, priv->dreg, priv->set->dlen);
-
-	return false;
-}
-
 static const struct nft_expr_ops nft_lookup_ops = {
 	.type		= &nft_lookup_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_lookup)),
@@ -254,7 +243,6 @@ static const struct nft_expr_ops nft_lookup_ops = {
 	.destroy	= nft_lookup_destroy,
 	.dump		= nft_lookup_dump,
 	.validate	= nft_lookup_validate,
-	.reduce		= nft_lookup_reduce,
 };
 
 struct nft_expr_type nft_lookup_type __read_mostly = {
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index b115d77fbbc7..b6cd11fd596b 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -146,7 +146,6 @@ static const struct nft_expr_ops nft_masq_ipv4_ops = {
 	.destroy	= nft_masq_ipv4_destroy,
 	.dump		= nft_masq_dump,
 	.validate	= nft_masq_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_masq_ipv4_type __read_mostly = {
@@ -174,7 +173,6 @@ static const struct nft_expr_ops nft_masq_ipv6_ops = {
 	.destroy	= nft_masq_ipv6_destroy,
 	.dump		= nft_masq_dump,
 	.validate	= nft_masq_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_masq_ipv6_type __read_mostly = {
@@ -216,7 +214,6 @@ static const struct nft_expr_ops nft_masq_inet_ops = {
 	.destroy	= nft_masq_inet_destroy,
 	.dump		= nft_masq_dump,
 	.validate	= nft_masq_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_masq_inet_type __read_mostly = {
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index e384e0de7a54..73128d73fc99 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -744,60 +744,16 @@ static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
-bool nft_meta_get_reduce(struct nft_regs_track *track,
-			 const struct nft_expr *expr)
-{
-	const struct nft_meta *priv = nft_expr_priv(expr);
-	const struct nft_meta *meta;
-
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	meta = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (priv->key != meta->key ||
-	    priv->dreg != meta->dreg) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return nft_expr_reduce_bitwise(track, expr);
-}
-EXPORT_SYMBOL_GPL(nft_meta_get_reduce);
-
 static const struct nft_expr_ops nft_meta_get_ops = {
 	.type		= &nft_meta_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
 	.eval		= nft_meta_get_eval,
 	.init		= nft_meta_get_init,
 	.dump		= nft_meta_get_dump,
-	.reduce		= nft_meta_get_reduce,
 	.validate	= nft_meta_get_validate,
 	.offload	= nft_meta_get_offload,
 };
 
-static bool nft_meta_set_reduce(struct nft_regs_track *track,
-				const struct nft_expr *expr)
-{
-	int i;
-
-	for (i = 0; i < NFT_REG32_NUM; i++) {
-		if (!track->regs[i].selector)
-			continue;
-
-		if (track->regs[i].selector->ops != &nft_meta_get_ops)
-			continue;
-
-		__nft_reg_track_cancel(track, i);
-	}
-
-	return false;
-}
-
 static const struct nft_expr_ops nft_meta_set_ops = {
 	.type		= &nft_meta_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
@@ -805,7 +761,6 @@ static const struct nft_expr_ops nft_meta_set_ops = {
 	.init		= nft_meta_set_init,
 	.destroy	= nft_meta_set_destroy,
 	.dump		= nft_meta_set_dump,
-	.reduce		= nft_meta_set_reduce,
 	.validate	= nft_meta_set_validate,
 };
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 5c29915ab028..296667e25420 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -318,7 +318,6 @@ static const struct nft_expr_ops nft_nat_ops = {
 	.destroy        = nft_nat_destroy,
 	.dump           = nft_nat_dump,
 	.validate	= nft_nat_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_nat_type __read_mostly = {
@@ -349,7 +348,6 @@ static const struct nft_expr_ops nft_nat_inet_ops = {
 	.destroy        = nft_nat_destroy,
 	.dump           = nft_nat_dump,
 	.validate	= nft_nat_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_inet_nat_type __read_mostly = {
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 7d29db7c2ac0..c46534347405 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -84,16 +84,6 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 	return err;
 }
 
-static bool nft_ng_inc_reduce(struct nft_regs_track *track,
-				 const struct nft_expr *expr)
-{
-	const struct nft_ng_inc *priv = nft_expr_priv(expr);
-
-	nft_reg_track_cancel(track, priv->dreg, NFT_REG32_SIZE);
-
-	return false;
-}
-
 static int nft_ng_dump(struct sk_buff *skb, enum nft_registers dreg,
 		       u32 modulus, enum nft_ng_types type, u32 offset)
 {
@@ -178,16 +168,6 @@ static int nft_ng_random_dump(struct sk_buff *skb,
 			   priv->offset);
 }
 
-static bool nft_ng_random_reduce(struct nft_regs_track *track,
-				 const struct nft_expr *expr)
-{
-	const struct nft_ng_random *priv = nft_expr_priv(expr);
-
-	nft_reg_track_cancel(track, priv->dreg, NFT_REG32_SIZE);
-
-	return false;
-}
-
 static struct nft_expr_type nft_ng_type;
 static const struct nft_expr_ops nft_ng_inc_ops = {
 	.type		= &nft_ng_type,
@@ -196,7 +176,6 @@ static const struct nft_expr_ops nft_ng_inc_ops = {
 	.init		= nft_ng_inc_init,
 	.destroy	= nft_ng_inc_destroy,
 	.dump		= nft_ng_inc_dump,
-	.reduce		= nft_ng_inc_reduce,
 };
 
 static const struct nft_expr_ops nft_ng_random_ops = {
@@ -205,7 +184,6 @@ static const struct nft_expr_ops nft_ng_random_ops = {
 	.eval		= nft_ng_random_eval,
 	.init		= nft_ng_random_init,
 	.dump		= nft_ng_random_dump,
-	.reduce		= nft_ng_random_reduce,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index a48dd5b5d45b..0db12fe25d16 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -91,7 +91,6 @@ static const struct nft_expr_ops nft_objref_ops = {
 	.activate	= nft_objref_activate,
 	.deactivate	= nft_objref_deactivate,
 	.dump		= nft_objref_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 struct nft_objref_map {
@@ -205,7 +204,6 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 70820c66b591..093ec7f96a77 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -133,30 +133,6 @@ static int nft_osf_validate(const struct nft_ctx *ctx,
 	return nft_chain_validate_hooks(ctx->chain, hooks);
 }
 
-static bool nft_osf_reduce(struct nft_regs_track *track,
-			   const struct nft_expr *expr)
-{
-	struct nft_osf *priv = nft_expr_priv(expr);
-	struct nft_osf *osf;
-
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
-		nft_reg_track_update(track, expr, priv->dreg, NFT_OSF_MAXGENRELEN);
-		return false;
-	}
-
-	osf = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (priv->flags != osf->flags ||
-	    priv->ttl != osf->ttl) {
-		nft_reg_track_update(track, expr, priv->dreg, NFT_OSF_MAXGENRELEN);
-		return false;
-	}
-
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return false;
-}
-
 static struct nft_expr_type nft_osf_type;
 static const struct nft_expr_ops nft_osf_op = {
 	.eval		= nft_osf_eval,
@@ -165,7 +141,6 @@ static const struct nft_expr_ops nft_osf_op = {
 	.dump		= nft_osf_dump,
 	.type		= &nft_osf_type,
 	.validate	= nft_osf_validate,
-	.reduce		= nft_osf_reduce,
 };
 
 static struct nft_expr_type nft_osf_type __read_mostly = {
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 3a3c7746e88f..2c06aca301cb 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -247,31 +247,6 @@ static int nft_payload_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static bool nft_payload_reduce(struct nft_regs_track *track,
-			       const struct nft_expr *expr)
-{
-	const struct nft_payload *priv = nft_expr_priv(expr);
-	const struct nft_payload *payload;
-
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	payload = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (priv->base != payload->base ||
-	    priv->offset != payload->offset ||
-	    priv->len != payload->len) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return nft_expr_reduce_bitwise(track, expr);
-}
-
 static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
 				     u32 priv_len, u32 field_len)
 {
@@ -575,7 +550,6 @@ static const struct nft_expr_ops nft_payload_ops = {
 	.eval		= nft_payload_eval,
 	.init		= nft_payload_init,
 	.dump		= nft_payload_dump,
-	.reduce		= nft_payload_reduce,
 	.offload	= nft_payload_offload,
 };
 
@@ -585,7 +559,6 @@ const struct nft_expr_ops nft_payload_fast_ops = {
 	.eval		= nft_payload_eval,
 	.init		= nft_payload_init,
 	.dump		= nft_payload_dump,
-	.reduce		= nft_payload_reduce,
 	.offload	= nft_payload_offload,
 };
 
@@ -940,32 +913,12 @@ static int nft_payload_set_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static bool nft_payload_set_reduce(struct nft_regs_track *track,
-				   const struct nft_expr *expr)
-{
-	int i;
-
-	for (i = 0; i < NFT_REG32_NUM; i++) {
-		if (!track->regs[i].selector)
-			continue;
-
-		if (track->regs[i].selector->ops != &nft_payload_ops &&
-		    track->regs[i].selector->ops != &nft_payload_fast_ops)
-			continue;
-
-		__nft_reg_track_cancel(track, i);
-	}
-
-	return false;
-}
-
 static const struct nft_expr_ops nft_payload_set_ops = {
 	.type		= &nft_payload_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload_set)),
 	.eval		= nft_payload_set_eval,
 	.init		= nft_payload_set_init,
 	.dump		= nft_payload_set_dump,
-	.reduce		= nft_payload_set_reduce,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index b2b8127c8d43..160541791939 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -192,7 +192,6 @@ static const struct nft_expr_ops nft_queue_ops = {
 	.init		= nft_queue_init,
 	.dump		= nft_queue_dump,
 	.validate	= nft_queue_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops nft_queue_sreg_ops = {
@@ -202,7 +201,6 @@ static const struct nft_expr_ops nft_queue_sreg_ops = {
 	.init		= nft_queue_sreg_init,
 	.dump		= nft_queue_sreg_dump,
 	.validate	= nft_queue_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 3ba12a7471b0..5453056f07df 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -259,7 +259,6 @@ static const struct nft_expr_ops nft_quota_ops = {
 	.destroy	= nft_quota_destroy,
 	.clone		= nft_quota_clone,
 	.dump		= nft_quota_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_quota_type __read_mostly = {
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index 0566d6aaf1e5..f8258d520229 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -138,7 +138,6 @@ static const struct nft_expr_ops nft_range_ops = {
 	.eval		= nft_range_eval,
 	.init		= nft_range_init,
 	.dump		= nft_range_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 struct nft_expr_type nft_range_type __read_mostly = {
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index a70196ffcb1e..ab8dfaa34230 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -149,7 +149,6 @@ static const struct nft_expr_ops nft_redir_ipv4_ops = {
 	.destroy	= nft_redir_ipv4_destroy,
 	.dump		= nft_redir_dump,
 	.validate	= nft_redir_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_redir_ipv4_type __read_mostly = {
@@ -177,7 +176,6 @@ static const struct nft_expr_ops nft_redir_ipv6_ops = {
 	.destroy	= nft_redir_ipv6_destroy,
 	.dump		= nft_redir_dump,
 	.validate	= nft_redir_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_redir_ipv6_type __read_mostly = {
@@ -206,7 +204,6 @@ static const struct nft_expr_ops nft_redir_inet_ops = {
 	.destroy	= nft_redir_inet_destroy,
 	.dump		= nft_redir_dump,
 	.validate	= nft_redir_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_redir_inet_type __read_mostly = {
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 973fa31a9dd6..554caf967baa 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -80,7 +80,6 @@ static const struct nft_expr_ops nft_reject_inet_ops = {
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
 	.validate	= nft_reject_inet_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_reject_inet_type __read_mostly = {
diff --git a/net/netfilter/nft_reject_netdev.c b/net/netfilter/nft_reject_netdev.c
index 7865cd8b11bb..61cd8c4ac385 100644
--- a/net/netfilter/nft_reject_netdev.c
+++ b/net/netfilter/nft_reject_netdev.c
@@ -159,7 +159,6 @@ static const struct nft_expr_ops nft_reject_netdev_ops = {
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
 	.validate	= nft_reject_netdev_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_reject_netdev_type __read_mostly = {
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index 5990fdd7b3cc..63a6069aa02b 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -191,7 +191,6 @@ static const struct nft_expr_ops nft_rt_get_ops = {
 	.init		= nft_rt_get_init,
 	.dump		= nft_rt_get_dump,
 	.validate	= nft_rt_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 struct nft_expr_type nft_rt_type __read_mostly = {
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 85f8df87efda..3bfcfe3ee5aa 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -213,31 +213,6 @@ static int nft_socket_dump(struct sk_buff *skb,
 	return 0;
 }
 
-static bool nft_socket_reduce(struct nft_regs_track *track,
-			      const struct nft_expr *expr)
-{
-	const struct nft_socket *priv = nft_expr_priv(expr);
-	const struct nft_socket *socket;
-
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	socket = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (priv->key != socket->key ||
-	    priv->dreg != socket->dreg ||
-	    priv->level != socket->level) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return nft_expr_reduce_bitwise(track, expr);
-}
-
 static int nft_socket_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr,
 			       const struct nft_data **data)
@@ -256,7 +231,6 @@ static const struct nft_expr_ops nft_socket_ops = {
 	.init		= nft_socket_init,
 	.dump		= nft_socket_dump,
 	.validate	= nft_socket_validate,
-	.reduce		= nft_socket_reduce,
 };
 
 static struct nft_expr_type nft_socket_type __read_mostly = {
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 13da882669a4..bf7268908154 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -289,7 +289,6 @@ static const struct nft_expr_ops nft_synproxy_ops = {
 	.dump		= nft_synproxy_dump,
 	.type		= &nft_synproxy_type,
 	.validate	= nft_synproxy_validate,
-	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_synproxy_type __read_mostly = {
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index ea83f661417e..089d608f6b32 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -327,7 +327,6 @@ static const struct nft_expr_ops nft_tproxy_ops = {
 	.init		= nft_tproxy_init,
 	.destroy	= nft_tproxy_destroy,
 	.dump		= nft_tproxy_dump,
-	.reduce		= NFT_REDUCE_READONLY,
 	.validate	= nft_tproxy_validate,
 };
 
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index b059aa541798..ddd698332730 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -124,31 +124,6 @@ static int nft_tunnel_get_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static bool nft_tunnel_get_reduce(struct nft_regs_track *track,
-				  const struct nft_expr *expr)
-{
-	const struct nft_tunnel *priv = nft_expr_priv(expr);
-	const struct nft_tunnel *tunnel;
-
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	tunnel = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (priv->key != tunnel->key ||
-	    priv->dreg != tunnel->dreg ||
-	    priv->mode != tunnel->mode) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return false;
-}
-
 static struct nft_expr_type nft_tunnel_type;
 static const struct nft_expr_ops nft_tunnel_get_ops = {
 	.type		= &nft_tunnel_type,
@@ -156,7 +131,6 @@ static const struct nft_expr_ops nft_tunnel_get_ops = {
 	.eval		= nft_tunnel_get_eval,
 	.init		= nft_tunnel_get_init,
 	.dump		= nft_tunnel_get_dump,
-	.reduce		= nft_tunnel_get_reduce,
 };
 
 static struct nft_expr_type nft_tunnel_type __read_mostly = {
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index c88fd078a9ae..6252e1d9def8 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -254,32 +254,6 @@ static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *e
 	return nft_chain_validate_hooks(ctx->chain, hooks);
 }
 
-static bool nft_xfrm_reduce(struct nft_regs_track *track,
-			    const struct nft_expr *expr)
-{
-	const struct nft_xfrm *priv = nft_expr_priv(expr);
-	const struct nft_xfrm *xfrm;
-
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	xfrm = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (priv->key != xfrm->key ||
-	    priv->dreg != xfrm->dreg ||
-	    priv->dir != xfrm->dir ||
-	    priv->spnum != xfrm->spnum) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
-		return false;
-	}
-
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return nft_expr_reduce_bitwise(track, expr);
-}
-
 static struct nft_expr_type nft_xfrm_type;
 static const struct nft_expr_ops nft_xfrm_get_ops = {
 	.type		= &nft_xfrm_type,
@@ -288,7 +262,6 @@ static const struct nft_expr_ops nft_xfrm_get_ops = {
 	.init		= nft_xfrm_get_init,
 	.dump		= nft_xfrm_get_dump,
 	.validate	= nft_xfrm_validate,
-	.reduce		= nft_xfrm_reduce,
 };
 
 static struct nft_expr_type nft_xfrm_type __read_mostly = {
-- 
2.30.2

