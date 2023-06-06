Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B597FC7EE37
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 16:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbjFFQfs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 12:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238015AbjFFQfq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 12:35:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70A2CE5E
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 09:35:41 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf-next,v2 3/7] netfilter: nf_tables: track register store and load operations
Date:   Tue,  6 Jun 2023 18:35:29 +0200
Message-Id: <20230606163533.1533-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230606163533.1533-1-pablo@netfilter.org>
References: <20230606163533.1533-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add basic register tracking for the combo infrastructure.

Track registers to detect an expression that recycles data from an
expression that has been merged into a combo expression. Skip track
and merge into combo logic in such case. Otherwise userspace might
trigger a combo expression then try to access a register that is
uninitialized.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series.

 include/net/netfilter/nf_tables.h        | 35 +++++++++++++++++++++++
 include/net/netfilter/nft_fib.h          |  4 +++
 include/net/netfilter/nft_meta.h         |  8 ++++++
 net/bridge/netfilter/nft_meta_bridge.c   |  2 ++
 net/bridge/netfilter/nft_reject_bridge.c |  1 +
 net/ipv4/netfilter/nft_dup_ipv4.c        | 14 +++++++++
 net/ipv4/netfilter/nft_fib_ipv4.c        |  2 ++
 net/ipv4/netfilter/nft_reject_ipv4.c     |  1 +
 net/ipv6/netfilter/nft_dup_ipv6.c        | 14 +++++++++
 net/ipv6/netfilter/nft_fib_ipv6.c        |  2 ++
 net/ipv6/netfilter/nft_reject_ipv6.c     |  1 +
 net/netfilter/nft_bitwise.c              | 13 +++++++++
 net/netfilter/nft_byteorder.c            | 13 +++++++++
 net/netfilter/nft_cmp.c                  | 24 ++++++++++++++++
 net/netfilter/nft_compat.c               |  1 +
 net/netfilter/nft_connlimit.c            |  1 +
 net/netfilter/nft_counter.c              |  1 +
 net/netfilter/nft_ct.c                   | 27 ++++++++++++++++++
 net/netfilter/nft_dup_netdev.c           | 12 ++++++++
 net/netfilter/nft_dynset.c               | 14 +++++++++
 net/netfilter/nft_exthdr.c               | 29 +++++++++++++++++++
 net/netfilter/nft_fib.c                  | 12 ++++++++
 net/netfilter/nft_fib_inet.c             |  1 +
 net/netfilter/nft_fib_netdev.c           |  1 +
 net/netfilter/nft_flow_offload.c         |  1 +
 net/netfilter/nft_fwd_netdev.c           | 36 ++++++++++++++++++++++++
 net/netfilter/nft_hash.c                 | 25 ++++++++++++++++
 net/netfilter/nft_immediate.c            | 12 ++++++++
 net/netfilter/nft_inner.c                | 10 +++++++
 net/netfilter/nft_last.c                 |  1 +
 net/netfilter/nft_limit.c                |  2 ++
 net/netfilter/nft_log.c                  |  1 +
 net/netfilter/nft_lookup.c               | 14 +++++++++
 net/netfilter/nft_masq.c                 | 17 +++++++++++
 net/netfilter/nft_meta.c                 | 26 +++++++++++++++++
 net/netfilter/nft_nat.c                  | 32 +++++++++++++++++++++
 net/netfilter/nft_numgen.c               | 24 ++++++++++++++++
 net/netfilter/nft_objref.c               | 13 +++++++++
 net/netfilter/nft_osf.c                  | 12 ++++++++
 net/netfilter/nft_payload.c              | 26 +++++++++++++++++
 net/netfilter/nft_queue.c                | 14 +++++++++
 net/netfilter/nft_quota.c                |  1 +
 net/netfilter/nft_range.c                | 12 ++++++++
 net/netfilter/nft_redir.c                | 17 +++++++++++
 net/netfilter/nft_reject_inet.c          |  1 +
 net/netfilter/nft_reject_netdev.c        |  1 +
 net/netfilter/nft_rt.c                   | 14 +++++++++
 net/netfilter/nft_socket.c               | 12 ++++++++
 net/netfilter/nft_synproxy.c             |  1 +
 net/netfilter/nft_tproxy.c               | 27 ++++++++++++++++++
 net/netfilter/nft_tunnel.c               | 12 ++++++++
 net/netfilter/nft_xfrm.c                 | 12 ++++++++
 52 files changed, 609 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 588b1904e411..81adf294da25 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -123,6 +123,38 @@ struct nft_regs {
 	};
 };
 
+struct nft_expr_track_ctx {
+	u32	reg_bitmap;
+	bool	cancel;
+};
+
+static inline u32 nft_expr_track_bitmask(u8 reg, u8 len)
+{
+	return ((1 << DIV_ROUND_UP(len, 4)) - 1) << reg;
+}
+
+static inline void nft_expr_track_dreg(struct nft_expr_track_ctx *ctx, u8 dreg, u8 len)
+{
+	ctx->reg_bitmap |= nft_expr_track_bitmask(dreg, len);
+}
+
+static inline void nft_expr_track_sreg(struct nft_expr_track_ctx *ctx, u8 sreg, u8 len)
+{
+	if (!(ctx->reg_bitmap & nft_expr_track_bitmask(sreg, len)))
+		ctx->cancel = true;
+}
+
+static inline void nft_expr_track_reset_dreg(struct nft_expr_track_ctx *ctx, u8 dreg, u8 len)
+{
+	ctx->reg_bitmap &= ~nft_expr_track_bitmask(dreg, len);
+}
+
+#define __NFT_TRACK_GENERIC	1UL
+#define NFT_TRACK_GENERIC	(void *)__NFT_TRACK_GENERIC
+
+struct nft_expr_track {
+};
+
 /* Store/load an u8, u16 or u64 integer to/from the u32 data register.
  *
  * Note, when using concatenations, register allocation happens at 32-bit
@@ -934,6 +966,9 @@ struct nft_expr_ops {
 	int				(*validate)(const struct nft_ctx *ctx,
 						    const struct nft_expr *expr,
 						    const struct nft_data **data);
+	int				(*track)(struct nft_expr_track_ctx *ctx,
+						 struct nft_expr_track *track,
+						 const struct nft_expr *expr);
 	bool				(*gc)(struct net *net,
 					      const struct nft_expr *expr);
 	int				(*offload)(struct nft_offload_ctx *ctx,
diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index 2e434ba41b97..7045e7106611 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -7,6 +7,7 @@
 struct nft_fib {
 	u8			dreg;
 	u8			result;
+	u8			len;
 	u32			flags;
 };
 
@@ -38,4 +39,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 			  const struct net_device *dev);
 
+int nft_fib_track(struct nft_expr_track_ctx *ctx, struct nft_expr_track *track,
+		  const struct nft_expr *expr);
+
 #endif
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index 690f6245026c..e03e008cbd51 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -44,6 +44,14 @@ int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr,
 			  const struct nft_data **data);
 
+int nft_meta_get_track(struct nft_expr_track_ctx *ctx,
+		       struct nft_expr_track *track,
+		       const struct nft_expr *expr);
+
+int nft_meta_set_track(struct nft_expr_track_ctx *ctx,
+		       struct nft_expr_track *track,
+		       const struct nft_expr *expr);
+
 struct nft_inner_tun_ctx;
 void nft_meta_inner_eval(const struct nft_expr *expr,
 			 struct nft_regs *regs, const struct nft_pktinfo *pkt,
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 93e8a8dadd80..3964f0a0f328 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -102,6 +102,7 @@ static const struct nft_expr_ops nft_meta_bridge_get_ops = {
 	.eval		= nft_meta_bridge_get_eval,
 	.init		= nft_meta_bridge_get_init,
 	.dump		= nft_meta_get_dump,
+	.track		= nft_meta_get_track,
 };
 
 static void nft_meta_bridge_set_eval(const struct nft_expr *expr,
@@ -173,6 +174,7 @@ static const struct nft_expr_ops nft_meta_bridge_set_ops = {
 	.init		= nft_meta_bridge_set_init,
 	.destroy	= nft_meta_set_destroy,
 	.dump		= nft_meta_set_dump,
+	.track		= nft_meta_set_track,
 	.validate	= nft_meta_bridge_set_validate,
 };
 
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index fbf858ddec35..eb94369d24bf 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -184,6 +184,7 @@ static const struct nft_expr_ops nft_reject_bridge_ops = {
 	.eval		= nft_reject_bridge_eval,
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
+	.track		= NFT_TRACK_GENERIC,
 	.validate	= nft_reject_bridge_validate,
 };
 
diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup_ipv4.c
index cae5b38335b3..b7b0cbe3115b 100644
--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -69,6 +69,19 @@ static int nft_dup_ipv4_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_dup_ipv4_track(struct nft_expr_track_ctx *ctx,
+			      struct nft_expr_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_dup_ipv4 *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg_addr, sizeof(struct in_addr));
+	if (priv->sreg_dev)
+		nft_expr_track_dreg(ctx, priv->sreg_dev, sizeof(int));
+
+       return 1;
+}
+
 static struct nft_expr_type nft_dup_ipv4_type;
 static const struct nft_expr_ops nft_dup_ipv4_ops = {
 	.type		= &nft_dup_ipv4_type,
@@ -76,6 +89,7 @@ static const struct nft_expr_ops nft_dup_ipv4_ops = {
 	.eval		= nft_dup_ipv4_eval,
 	.init		= nft_dup_ipv4_init,
 	.dump		= nft_dup_ipv4_dump,
+	.track		= nft_dup_ipv4_track,
 };
 
 static const struct nla_policy nft_dup_ipv4_policy[NFTA_DUP_MAX + 1] = {
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 55c4b73265ed..258a3ffd3294 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -158,6 +158,7 @@ static const struct nft_expr_ops nft_fib4_type_ops = {
 	.eval		= nft_fib4_eval_type,
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
+	.track		= nft_fib_track,
 	.validate	= nft_fib_validate,
 };
 
@@ -167,6 +168,7 @@ static const struct nft_expr_ops nft_fib4_ops = {
 	.eval		= nft_fib4_eval,
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
+	.track		= nft_fib_track,
 	.validate	= nft_fib_validate,
 };
 
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index 55fc23a8f7a7..56e18609df8c 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -44,6 +44,7 @@ static const struct nft_expr_ops nft_reject_ipv4_ops = {
 	.eval		= nft_reject_ipv4_eval,
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
+	.track		= NFT_TRACK_GENERIC,
 	.validate	= nft_reject_validate,
 };
 
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
index e859beb29bb1..0527a6f064b7 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -67,6 +67,19 @@ static int nft_dup_ipv6_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_dup_ipv6_track(struct nft_expr_track_ctx *ctx,
+			      struct nft_expr_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_dup_ipv6 *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg_addr, sizeof(struct in6_addr));
+	if (priv->sreg_dev)
+		nft_expr_track_dreg(ctx, priv->sreg_dev, sizeof(int));
+
+	return 1;
+}
+
 static struct nft_expr_type nft_dup_ipv6_type;
 static const struct nft_expr_ops nft_dup_ipv6_ops = {
 	.type		= &nft_dup_ipv6_type,
@@ -74,6 +87,7 @@ static const struct nft_expr_ops nft_dup_ipv6_ops = {
 	.eval		= nft_dup_ipv6_eval,
 	.init		= nft_dup_ipv6_init,
 	.dump		= nft_dup_ipv6_dump,
+	.track		= nft_dup_ipv6_track,
 };
 
 static const struct nla_policy nft_dup_ipv6_policy[NFTA_DUP_MAX + 1] = {
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 6ae17f530994..bf46d169cd15 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -219,6 +219,7 @@ static const struct nft_expr_ops nft_fib6_type_ops = {
 	.eval		= nft_fib6_eval_type,
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
+	.track		= nft_fib_track,
 	.validate	= nft_fib_validate,
 };
 
@@ -228,6 +229,7 @@ static const struct nft_expr_ops nft_fib6_ops = {
 	.eval		= nft_fib6_eval,
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
+	.track		= nft_fib_track,
 	.validate	= nft_fib_validate,
 };
 
diff --git a/net/ipv6/netfilter/nft_reject_ipv6.c b/net/ipv6/netfilter/nft_reject_ipv6.c
index ed69c768797e..0cb315f57c74 100644
--- a/net/ipv6/netfilter/nft_reject_ipv6.c
+++ b/net/ipv6/netfilter/nft_reject_ipv6.c
@@ -45,6 +45,7 @@ static const struct nft_expr_ops nft_reject_ipv6_ops = {
 	.eval		= nft_reject_ipv6_eval,
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
+	.track		= NFT_TRACK_GENERIC,
 	.validate	= nft_reject_validate,
 };
 
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index b358c03bdb04..0ab2d281f245 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -262,6 +262,18 @@ static int nft_bitwise_dump(struct sk_buff *skb,
 
 static struct nft_data zero;
 
+static int nft_bitwise_track(struct nft_expr_track_ctx *ctx,
+			     struct nft_expr_track *track,
+			     const struct nft_expr *expr)
+{
+	const struct nft_bitwise *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg, priv->len);
+	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
+
+	return 1;
+}
+
 static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
 			       struct nft_flow_rule *flow,
 			       const struct nft_expr *expr)
@@ -287,6 +299,7 @@ static const struct nft_expr_ops nft_bitwise_ops = {
 	.eval		= nft_bitwise_eval,
 	.init		= nft_bitwise_init,
 	.dump		= nft_bitwise_dump,
+	.track		= nft_bitwise_track,
 	.offload	= nft_bitwise_offload,
 };
 
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index a42d03741bb3..3d7ed9c8b611 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -169,12 +169,25 @@ static int nft_byteorder_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_byteorder_track(struct nft_expr_track_ctx *ctx,
+			       struct nft_expr_track *track,
+			       const struct nft_expr *expr)
+{
+	const struct nft_byteorder *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg, priv->len);
+	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
+
+	return 1;
+}
+
 static const struct nft_expr_ops nft_byteorder_ops = {
 	.type		= &nft_byteorder_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_byteorder)),
 	.eval		= nft_byteorder_eval,
 	.init		= nft_byteorder_init,
 	.dump		= nft_byteorder_dump,
+	.track		= nft_byteorder_track,
 };
 
 struct nft_expr_type nft_byteorder_type __read_mostly = {
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 7f3f87446683..dc026cd4458d 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -184,12 +184,24 @@ static int nft_cmp_offload(struct nft_offload_ctx *ctx,
 	return __nft_cmp_offload(ctx, flow, priv);
 }
 
+static int nft_cmp_track(struct nft_expr_track_ctx *ctx,
+			 struct nft_expr_track *track,
+			 const struct nft_expr *expr)
+{
+	const struct nft_cmp_expr *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg, priv->len);
+
+	return 1;
+}
+
 static const struct nft_expr_ops nft_cmp_ops = {
 	.type		= &nft_cmp_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp_expr)),
 	.eval		= nft_cmp_eval,
 	.init		= nft_cmp_init,
 	.dump		= nft_cmp_dump,
+	.track		= nft_cmp_track,
 	.offload	= nft_cmp_offload,
 };
 
@@ -275,12 +287,24 @@ static int nft_cmp_fast_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_cmp_fast_track(struct nft_expr_track_ctx *ctx,
+			      struct nft_expr_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg, sizeof(u32));
+
+	return 1;
+}
+
 const struct nft_expr_ops nft_cmp_fast_ops = {
 	.type		= &nft_cmp_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp_fast_expr)),
 	.eval		= NULL,	/* inlined */
 	.init		= nft_cmp_fast_init,
 	.dump		= nft_cmp_fast_dump,
+	.track		= nft_cmp_fast_track,
 	.offload	= nft_cmp_fast_offload,
 };
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index e178b479dfaf..af88078caf99 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -864,6 +864,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	ops->destroy = nft_target_destroy;
 	ops->dump = nft_target_dump;
 	ops->validate = nft_target_validate;
+	ops->track = NFT_TRACK_GENERIC;
 	ops->data = target;
 
 	if (family == NFPROTO_BRIDGE)
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 53ef6854f8e6..029414111cdb 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -257,6 +257,7 @@ static const struct nft_expr_ops nft_connlimit_ops = {
 	.clone		= nft_connlimit_clone,
 	.destroy_clone	= nft_connlimit_destroy_clone,
 	.dump		= nft_connlimit_dump,
+	.track		= NFT_TRACK_GENERIC,
 	.gc		= nft_connlimit_gc,
 };
 
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 446406631c9a..04fdc9378087 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -293,6 +293,7 @@ static const struct nft_expr_ops nft_counter_ops = {
 	.destroy	= nft_counter_destroy,
 	.destroy_clone	= nft_counter_destroy,
 	.dump		= nft_counter_dump,
+	.track		= NFT_TRACK_GENERIC,
 	.clone		= nft_counter_clone,
 	.offload	= nft_counter_offload,
 	.offload_stats	= nft_counter_offload_stats,
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index fe25ce6fa0bd..0cd628cc2282 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -697,6 +697,28 @@ static int nft_ct_set_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_ct_get_track(struct nft_expr_track_ctx *ctx,
+			    struct nft_expr_track *track,
+			    const struct nft_expr *expr)
+{
+	const struct nft_ct *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
+
+	return 1;
+}
+
+static int nft_ct_set_track(struct nft_expr_track_ctx *ctx,
+			    struct nft_expr_track *track,
+			    const struct nft_expr *expr)
+{
+	const struct nft_ct *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg, priv->len);
+
+	return 1;
+}
+
 static struct nft_expr_type nft_ct_type;
 static const struct nft_expr_ops nft_ct_get_ops = {
 	.type		= &nft_ct_type,
@@ -705,6 +727,7 @@ static const struct nft_expr_ops nft_ct_get_ops = {
 	.init		= nft_ct_get_init,
 	.destroy	= nft_ct_get_destroy,
 	.dump		= nft_ct_get_dump,
+	.track		= nft_ct_get_track,
 };
 
 #ifdef CONFIG_RETPOLINE
@@ -715,6 +738,7 @@ static const struct nft_expr_ops nft_ct_get_fast_ops = {
 	.init		= nft_ct_get_init,
 	.destroy	= nft_ct_get_destroy,
 	.dump		= nft_ct_get_dump,
+	.track		= nft_ct_get_track,
 };
 #endif
 
@@ -725,6 +749,7 @@ static const struct nft_expr_ops nft_ct_set_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
+	.track		= nft_ct_set_track,
 };
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
@@ -735,6 +760,7 @@ static const struct nft_expr_ops nft_ct_set_zone_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
+	.track		= nft_ct_set_track,
 };
 #endif
 
@@ -804,6 +830,7 @@ static const struct nft_expr_ops nft_notrack_ops = {
 	.type		= &nft_notrack_type,
 	.size		= NFT_EXPR_SIZE(0),
 	.eval		= nft_notrack_eval,
+	.track		= NFT_TRACK_GENERIC,
 };
 
 static struct nft_expr_type nft_notrack_type __read_mostly = {
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index 2007700bef8e..e2f1ac2a3bb7 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -58,6 +58,17 @@ static int nft_dup_netdev_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_dup_netdev_track(struct nft_expr_track_ctx *ctx,
+				struct nft_expr_track *track,
+				const struct nft_expr *expr)
+{
+	const struct nft_dup_netdev *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg_dev, IFNAMSIZ);
+
+	return 1;
+}
+
 static int nft_dup_netdev_offload(struct nft_offload_ctx *ctx,
 				  struct nft_flow_rule *flow,
 				  const struct nft_expr *expr)
@@ -80,6 +91,7 @@ static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.eval		= nft_dup_netdev_eval,
 	.init		= nft_dup_netdev_init,
 	.dump		= nft_dup_netdev_dump,
+	.track		= nft_dup_netdev_track,
 	.offload	= nft_dup_netdev_offload,
 	.offload_action	= nft_dup_netdev_offload_action,
 };
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index c3bd57be2ee8..4b2ff0b25dfe 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -405,6 +405,19 @@ static int nft_dynset_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_dynset_track(struct nft_expr_track_ctx *ctx,
+			    struct nft_expr_track *track,
+			    const struct nft_expr *expr)
+{
+	const struct nft_dynset *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg_key, priv->set->klen);
+	if (priv->set->flags & NFT_SET_MAP)
+		nft_expr_track_sreg(ctx, priv->sreg_data, priv->set->dlen);
+
+	return 1;
+}
+
 static const struct nft_expr_ops nft_dynset_ops = {
 	.type		= &nft_dynset_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_dynset)),
@@ -414,6 +427,7 @@ static const struct nft_expr_ops nft_dynset_ops = {
 	.activate	= nft_dynset_activate,
 	.deactivate	= nft_dynset_deactivate,
 	.dump		= nft_dynset_dump,
+	.track		= nft_dynset_track,
 };
 
 struct nft_expr_type nft_dynset_type __read_mostly = {
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 41e8ae77b823..83f783e8b7b7 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -698,12 +698,35 @@ static int nft_exthdr_dump_strip(struct sk_buff *skb,
 	return nft_exthdr_dump_common(skb, priv);
 }
 
+static int nft_exthdr_track(struct nft_expr_track_ctx *ctx,
+			    struct nft_expr_track *track,
+			    const struct nft_expr *expr)
+{
+	const struct nft_exthdr *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
+
+	return 1;
+}
+
+static int nft_exthdr_set_track(struct nft_expr_track_ctx *ctx,
+				struct nft_expr_track *track,
+				const struct nft_expr *expr)
+{
+	const struct nft_exthdr *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg, priv->len);
+
+	return 1;
+}
+
 static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
 	.type		= &nft_exthdr_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
 	.eval		= nft_exthdr_ipv6_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
+	.track		= nft_exthdr_track,
 };
 
 static const struct nft_expr_ops nft_exthdr_ipv4_ops = {
@@ -712,6 +735,7 @@ static const struct nft_expr_ops nft_exthdr_ipv4_ops = {
 	.eval		= nft_exthdr_ipv4_eval,
 	.init		= nft_exthdr_ipv4_init,
 	.dump		= nft_exthdr_dump,
+	.track		= nft_exthdr_track,
 };
 
 static const struct nft_expr_ops nft_exthdr_tcp_ops = {
@@ -720,6 +744,7 @@ static const struct nft_expr_ops nft_exthdr_tcp_ops = {
 	.eval		= nft_exthdr_tcp_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
+	.track		= nft_exthdr_track,
 };
 
 static const struct nft_expr_ops nft_exthdr_tcp_set_ops = {
@@ -728,6 +753,7 @@ static const struct nft_expr_ops nft_exthdr_tcp_set_ops = {
 	.eval		= nft_exthdr_tcp_set_eval,
 	.init		= nft_exthdr_tcp_set_init,
 	.dump		= nft_exthdr_dump_set,
+	.track		= nft_exthdr_set_track,
 };
 
 static const struct nft_expr_ops nft_exthdr_tcp_strip_ops = {
@@ -736,6 +762,7 @@ static const struct nft_expr_ops nft_exthdr_tcp_strip_ops = {
 	.eval		= nft_exthdr_tcp_strip_eval,
 	.init		= nft_exthdr_tcp_strip_init,
 	.dump		= nft_exthdr_dump_strip,
+	.track		= NFT_TRACK_GENERIC,
 };
 
 static const struct nft_expr_ops nft_exthdr_sctp_ops = {
@@ -744,6 +771,7 @@ static const struct nft_expr_ops nft_exthdr_sctp_ops = {
 	.eval		= nft_exthdr_sctp_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
+	.track		= nft_exthdr_track,
 };
 
 static const struct nft_expr_ops nft_exthdr_dccp_ops = {
@@ -752,6 +780,7 @@ static const struct nft_expr_ops nft_exthdr_dccp_ops = {
 	.eval		= nft_exthdr_dccp_eval,
 	.init		= nft_exthdr_dccp_init,
 	.dump		= nft_exthdr_dump,
+	.track		= nft_exthdr_track,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index e7cb42c9c175..12eff4ba05bd 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -108,6 +108,7 @@ int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	default:
 		return -EINVAL;
 	}
+	priv->len = len;
 
 	err = nft_parse_register_store(ctx, tb[NFTA_FIB_DREG], &priv->dreg,
 				       NULL, NFT_DATA_VALUE, len);
@@ -135,6 +136,17 @@ int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr, bool reset)
 }
 EXPORT_SYMBOL_GPL(nft_fib_dump);
 
+int nft_fib_track(struct nft_expr_track_ctx *ctx, struct nft_expr_track *track,
+		  const struct nft_expr *expr)
+{
+	const struct nft_fib *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(nft_fib_track);
+
 void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 			  const struct net_device *dev)
 {
diff --git a/net/netfilter/nft_fib_inet.c b/net/netfilter/nft_fib_inet.c
index a88d44e163d1..9dc81538815f 100644
--- a/net/netfilter/nft_fib_inet.c
+++ b/net/netfilter/nft_fib_inet.c
@@ -48,6 +48,7 @@ static const struct nft_expr_ops nft_fib_inet_ops = {
 	.eval		= nft_fib_inet_eval,
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
+	.track		= nft_fib_track,
 	.validate	= nft_fib_validate,
 };
 
diff --git a/net/netfilter/nft_fib_netdev.c b/net/netfilter/nft_fib_netdev.c
index 3f3478abd845..69448f630fdb 100644
--- a/net/netfilter/nft_fib_netdev.c
+++ b/net/netfilter/nft_fib_netdev.c
@@ -57,6 +57,7 @@ static const struct nft_expr_ops nft_fib_netdev_ops = {
 	.eval		= nft_fib_netdev_eval,
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
+	.track		= nft_fib_track,
 	.validate	= nft_fib_validate,
 };
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 59c468261134..84fbe808644a 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -462,6 +462,7 @@ static const struct nft_expr_ops nft_flow_offload_ops = {
 	.destroy	= nft_flow_offload_destroy,
 	.validate	= nft_flow_offload_validate,
 	.dump		= nft_flow_offload_dump,
+	.track		= NFT_TRACK_GENERIC,
 };
 
 static struct nft_expr_type nft_flow_offload_type __read_mostly = {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index a534d060ce1b..e535b27d05ae 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -70,6 +70,17 @@ static int nft_fwd_netdev_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_fwd_netdev_track(struct nft_expr_track_ctx *ctx,
+				struct nft_expr_track *track,
+				const struct nft_expr *expr)
+{
+	const struct nft_fwd_netdev *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg_dev, IFNAMSIZ);
+
+	return 1;
+}
+
 static int nft_fwd_netdev_offload(struct nft_offload_ctx *ctx,
 				  struct nft_flow_rule *flow,
 				  const struct nft_expr *expr)
@@ -203,6 +214,29 @@ static int nft_fwd_neigh_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_fwd_neigh_track(struct nft_expr_track_ctx *ctx,
+			       struct nft_expr_track *track,
+			       const struct nft_expr *expr)
+{
+	const struct nft_fwd_neigh *priv = nft_expr_priv(expr);
+	u8 addr_len;
+
+	switch (priv->nfproto) {
+	case NFPROTO_IPV4:
+		addr_len = sizeof(struct in_addr);
+		break;
+	case NFPROTO_IPV6:
+		addr_len = sizeof(struct in6_addr);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	nft_expr_track_sreg(ctx, priv->sreg_dev, IFNAMSIZ);
+	nft_expr_track_sreg(ctx, priv->sreg_addr, addr_len);
+
+	return 1;
+}
+
 static int nft_fwd_validate(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nft_data **data)
@@ -219,6 +253,7 @@ static const struct nft_expr_ops nft_fwd_neigh_netdev_ops = {
 	.init		= nft_fwd_neigh_init,
 	.dump		= nft_fwd_neigh_dump,
 	.validate	= nft_fwd_validate,
+	.track		= nft_fwd_neigh_track,
 };
 
 static const struct nft_expr_ops nft_fwd_netdev_ops = {
@@ -228,6 +263,7 @@ static const struct nft_expr_ops nft_fwd_netdev_ops = {
 	.init		= nft_fwd_netdev_init,
 	.dump		= nft_fwd_netdev_dump,
 	.validate	= nft_fwd_validate,
+	.track		= nft_fwd_netdev_track,
 	.offload	= nft_fwd_netdev_offload,
 	.offload_action	= nft_fwd_netdev_offload_action,
 };
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 4fc99c80b28e..f64394e0327e 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -165,6 +165,18 @@ static int nft_jhash_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_jhash_track(struct nft_expr_track_ctx *ctx,
+			   struct nft_expr_track *track,
+			   const struct nft_expr *expr)
+{
+	const struct nft_jhash *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg, priv->len);
+	nft_expr_track_dreg(ctx, priv->dreg, sizeof(u32));
+
+	return 1;
+}
+
 static int nft_symhash_dump(struct sk_buff *skb,
 			    const struct nft_expr *expr, bool reset)
 {
@@ -185,6 +197,17 @@ static int nft_symhash_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_symhash_track(struct nft_expr_track_ctx *ctx,
+			     struct nft_expr_track *track,
+			     const struct nft_expr *expr)
+{
+	const struct nft_symhash *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, sizeof(u32));
+
+	return 1;
+}
+
 static struct nft_expr_type nft_hash_type;
 static const struct nft_expr_ops nft_jhash_ops = {
 	.type		= &nft_hash_type,
@@ -192,6 +215,7 @@ static const struct nft_expr_ops nft_jhash_ops = {
 	.eval		= nft_jhash_eval,
 	.init		= nft_jhash_init,
 	.dump		= nft_jhash_dump,
+	.track		= nft_jhash_track,
 };
 
 static const struct nft_expr_ops nft_symhash_ops = {
@@ -200,6 +224,7 @@ static const struct nft_expr_ops nft_symhash_ops = {
 	.eval		= nft_symhash_eval,
 	.init		= nft_symhash_init,
 	.dump		= nft_symhash_dump,
+	.track		= nft_symhash_track,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 0d744c3f73b3..4b977538ecdd 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -162,6 +162,17 @@ static int nft_immediate_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_immediate_track(struct nft_expr_track_ctx *ctx,
+			       struct nft_expr_track *track,
+			       const struct nft_expr *expr)
+{
+	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, priv->dlen);
+
+	return 1;
+}
+
 static int nft_immediate_validate(const struct nft_ctx *ctx,
 				  const struct nft_expr *expr,
 				  const struct nft_data **d)
@@ -249,6 +260,7 @@ static const struct nft_expr_ops nft_imm_ops = {
 	.deactivate	= nft_immediate_deactivate,
 	.destroy	= nft_immediate_destroy,
 	.dump		= nft_immediate_dump,
+	.track		= nft_immediate_track,
 	.validate	= nft_immediate_validate,
 	.offload	= nft_immediate_offload,
 	.offload_action	= nft_immediate_offload_action,
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 28e2873ba24e..470ddf59b1ea 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -368,12 +368,22 @@ static int nft_inner_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_inner_track(struct nft_expr_track_ctx *ctx,
+			   struct nft_expr_track *track,
+			   const struct nft_expr *expr)
+{
+	struct nft_inner *priv = nft_expr_priv(expr);
+
+	return priv->expr.ops->track(ctx, track, (struct nft_expr *)&priv->expr);
+}
+
 static const struct nft_expr_ops nft_inner_ops = {
 	.type		= &nft_inner_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_inner)),
 	.eval		= nft_inner_eval,
 	.init		= nft_inner_init,
 	.dump		= nft_inner_dump,
+	.track		= nft_inner_track,
 };
 
 struct nft_expr_type nft_inner_type __read_mostly = {
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 5d44d45ca4ef..ac6facafff94 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -125,6 +125,7 @@ static const struct nft_expr_ops nft_last_ops = {
 	.destroy	= nft_last_destroy,
 	.clone		= nft_last_clone,
 	.dump		= nft_last_dump,
+	.track		= NFT_TRACK_GENERIC,
 };
 
 struct nft_expr_type nft_last_type __read_mostly = {
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 10752da5bd16..074de96c4d13 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -228,6 +228,7 @@ static const struct nft_expr_ops nft_limit_pkts_ops = {
 	.destroy	= nft_limit_pkts_destroy,
 	.clone		= nft_limit_pkts_clone,
 	.dump		= nft_limit_pkts_dump,
+	.track		= NFT_TRACK_GENERIC,
 };
 
 static void nft_limit_bytes_eval(const struct nft_expr *expr,
@@ -280,6 +281,7 @@ static const struct nft_expr_ops nft_limit_bytes_ops = {
 	.eval		= nft_limit_bytes_eval,
 	.init		= nft_limit_bytes_init,
 	.dump		= nft_limit_bytes_dump,
+	.track		= NFT_TRACK_GENERIC,
 	.clone		= nft_limit_bytes_clone,
 	.destroy	= nft_limit_bytes_destroy,
 };
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 84e374411877..c72ce995cb55 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -291,6 +291,7 @@ static const struct nft_expr_ops nft_log_ops = {
 	.init		= nft_log_init,
 	.destroy	= nft_log_destroy,
 	.dump		= nft_log_dump,
+	.track		= NFT_TRACK_GENERIC,
 };
 
 static struct nft_expr_type nft_log_type __read_mostly = {
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 5ba799a7722d..efb45b2ed405 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -206,6 +206,19 @@ static int nft_lookup_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_lookup_track(struct nft_expr_track_ctx *ctx,
+			    struct nft_expr_track *track,
+			    const struct nft_expr *expr)
+{
+	const struct nft_lookup *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg, priv->set->klen);
+	if (priv->dreg_set)
+		nft_expr_track_dreg(ctx, priv->dreg, priv->set->dlen);
+
+	return 1;
+}
+
 static int nft_lookup_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr,
 			       const struct nft_data **d)
@@ -243,6 +256,7 @@ static const struct nft_expr_ops nft_lookup_ops = {
 	.destroy	= nft_lookup_destroy,
 	.dump		= nft_lookup_dump,
 	.validate	= nft_lookup_validate,
+	.track		= nft_lookup_track,
 };
 
 struct nft_expr_type nft_lookup_type __read_mostly = {
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index b6cd11fd596b..b21e8634d1e0 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -96,6 +96,20 @@ static int nft_masq_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_masq_track(struct nft_expr_track_ctx *ctx,
+			  struct nft_expr_track *track,
+			  const struct nft_expr *expr)
+{
+	const struct nft_masq *priv = nft_expr_priv(expr);
+
+	if (priv->sreg_proto_min) {
+		nft_expr_track_sreg(ctx, priv->sreg_proto_min, sizeof(u16));
+		nft_expr_track_sreg(ctx, priv->sreg_proto_max, sizeof(u16));
+	}
+
+	return 1;
+}
+
 static void nft_masq_eval(const struct nft_expr *expr,
 			  struct nft_regs *regs,
 			  const struct nft_pktinfo *pkt)
@@ -145,6 +159,7 @@ static const struct nft_expr_ops nft_masq_ipv4_ops = {
 	.init		= nft_masq_init,
 	.destroy	= nft_masq_ipv4_destroy,
 	.dump		= nft_masq_dump,
+	.track		= nft_masq_track,
 	.validate	= nft_masq_validate,
 };
 
@@ -172,6 +187,7 @@ static const struct nft_expr_ops nft_masq_ipv6_ops = {
 	.init		= nft_masq_init,
 	.destroy	= nft_masq_ipv6_destroy,
 	.dump		= nft_masq_dump,
+	.track		= nft_masq_track,
 	.validate	= nft_masq_validate,
 };
 
@@ -213,6 +229,7 @@ static const struct nft_expr_ops nft_masq_inet_ops = {
 	.init		= nft_masq_init,
 	.destroy	= nft_masq_inet_destroy,
 	.dump		= nft_masq_dump,
+	.track		= nft_masq_track,
 	.validate	= nft_masq_validate,
 };
 
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 73128d73fc99..db445f8c9f9f 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -744,6 +744,30 @@ static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
+int nft_meta_get_track(struct nft_expr_track_ctx *ctx,
+		       struct nft_expr_track *track,
+		       const struct nft_expr *expr)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(nft_meta_get_track);
+
+int nft_meta_set_track(struct nft_expr_track_ctx *ctx,
+		       struct nft_expr_track *track,
+		       const struct nft_expr *expr)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg, priv->len);
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(nft_meta_set_track);
+
 static const struct nft_expr_ops nft_meta_get_ops = {
 	.type		= &nft_meta_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
@@ -761,6 +785,7 @@ static const struct nft_expr_ops nft_meta_set_ops = {
 	.init		= nft_meta_set_init,
 	.destroy	= nft_meta_set_destroy,
 	.dump		= nft_meta_set_dump,
+	.track		= nft_meta_set_track,
 	.validate	= nft_meta_set_validate,
 };
 
@@ -845,6 +870,7 @@ static const struct nft_expr_ops nft_meta_inner_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
 	.init		= nft_meta_inner_init,
 	.dump		= nft_meta_get_dump,
+	.track		= nft_meta_get_track,
 	/* direct call to nft_meta_inner_eval(). */
 };
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 296667e25420..e12f4e75f247 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -301,6 +301,36 @@ static int nft_nat_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_nat_track(struct nft_expr_track_ctx *ctx,
+			 struct nft_expr_track *track,
+			 const struct nft_expr *expr)
+{
+	const struct nft_nat *priv = nft_expr_priv(expr);
+	u8 alen;
+
+	if (priv->sreg_addr_min) {
+		switch (priv->family) {
+		case NFPROTO_IPV4:
+			alen = sizeof_field(struct nf_nat_range, min_addr.ip);
+			break;
+		case NFPROTO_IPV6:
+			alen = sizeof_field(struct nf_nat_range, min_addr.ip6);
+			break;
+		default:
+			break;
+		}
+
+		nft_expr_track_sreg(ctx, priv->sreg_addr_min, alen);
+		nft_expr_track_sreg(ctx, priv->sreg_addr_max, alen);
+	}
+	if (priv->sreg_proto_min) {
+		nft_expr_track_sreg(ctx, priv->sreg_proto_min, sizeof(u16));
+		nft_expr_track_sreg(ctx, priv->sreg_proto_max, sizeof(u16));
+	}
+
+	return 1;
+}
+
 static void
 nft_nat_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
@@ -317,6 +347,7 @@ static const struct nft_expr_ops nft_nat_ops = {
 	.init           = nft_nat_init,
 	.destroy        = nft_nat_destroy,
 	.dump           = nft_nat_dump,
+	.track		= nft_nat_track,
 	.validate	= nft_nat_validate,
 };
 
@@ -347,6 +378,7 @@ static const struct nft_expr_ops nft_nat_inet_ops = {
 	.init           = nft_nat_init,
 	.destroy        = nft_nat_destroy,
 	.dump           = nft_nat_dump,
+	.track		= nft_nat_track,
 	.validate	= nft_nat_validate,
 };
 
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index c46534347405..0cd44b561492 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -111,6 +111,17 @@ static int nft_ng_inc_dump(struct sk_buff *skb,
 			   priv->offset);
 }
 
+static int nft_ng_inc_track(struct nft_expr_track_ctx *ctx,
+			    struct nft_expr_track *track,
+			    const struct nft_expr *expr)
+{
+	struct nft_ng_inc *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, sizeof(u32));
+
+	return 1;
+}
+
 static void nft_ng_inc_destroy(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
@@ -168,6 +179,17 @@ static int nft_ng_random_dump(struct sk_buff *skb,
 			   priv->offset);
 }
 
+static int nft_ng_random_track(struct nft_expr_track_ctx *ctx,
+			       struct nft_expr_track *track,
+			       const struct nft_expr *expr)
+{
+	struct nft_ng_random *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, sizeof(u32));
+
+	return 1;
+}
+
 static struct nft_expr_type nft_ng_type;
 static const struct nft_expr_ops nft_ng_inc_ops = {
 	.type		= &nft_ng_type,
@@ -176,6 +198,7 @@ static const struct nft_expr_ops nft_ng_inc_ops = {
 	.init		= nft_ng_inc_init,
 	.destroy	= nft_ng_inc_destroy,
 	.dump		= nft_ng_inc_dump,
+	.track		= nft_ng_inc_track,
 };
 
 static const struct nft_expr_ops nft_ng_random_ops = {
@@ -184,6 +207,7 @@ static const struct nft_expr_ops nft_ng_random_ops = {
 	.eval		= nft_ng_random_eval,
 	.init		= nft_ng_random_init,
 	.dump		= nft_ng_random_dump,
+	.track		= nft_ng_random_track,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 0db12fe25d16..e3c3154cbf6f 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -91,6 +91,7 @@ static const struct nft_expr_ops nft_objref_ops = {
 	.activate	= nft_objref_activate,
 	.deactivate	= nft_objref_deactivate,
 	.dump		= nft_objref_dump,
+	.track		= NFT_TRACK_GENERIC,
 };
 
 struct nft_objref_map {
@@ -170,6 +171,17 @@ static int nft_objref_map_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_objref_map_track(struct nft_expr_track_ctx *ctx,
+				struct nft_expr_track *track,
+				const struct nft_expr *expr)
+{
+	const struct nft_objref_map *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg, priv->set->klen);
+
+	return 1;
+}
+
 static void nft_objref_map_deactivate(const struct nft_ctx *ctx,
 				      const struct nft_expr *expr,
 				      enum nft_trans_phase phase)
@@ -204,6 +216,7 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
+	.track		= nft_objref_map_track,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 093ec7f96a77..3717b041ed37 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -112,6 +112,17 @@ static int nft_osf_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_osf_track(struct nft_expr_track_ctx *ctx,
+			 struct nft_expr_track *track,
+			 const struct nft_expr *expr)
+{
+	const struct nft_osf *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, NFT_OSF_MAXGENRELEN);
+
+	return 1;
+}
+
 static int nft_osf_validate(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nft_data **data)
@@ -139,6 +150,7 @@ static const struct nft_expr_ops nft_osf_op = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_osf)),
 	.init		= nft_osf_init,
 	.dump		= nft_osf_dump,
+	.track		= nft_osf_track,
 	.type		= &nft_osf_type,
 	.validate	= nft_osf_validate,
 };
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 2c06aca301cb..e5929aea685f 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -247,6 +247,17 @@ static int nft_payload_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_payload_track(struct nft_expr_track_ctx *ctx,
+			     struct nft_expr_track *track,
+			     const struct nft_expr *expr)
+{
+	const struct nft_payload *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
+
+	return 1;
+}
+
 static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
 				     u32 priv_len, u32 field_len)
 {
@@ -550,6 +561,7 @@ static const struct nft_expr_ops nft_payload_ops = {
 	.eval		= nft_payload_eval,
 	.init		= nft_payload_init,
 	.dump		= nft_payload_dump,
+	.track		= nft_payload_track,
 	.offload	= nft_payload_offload,
 };
 
@@ -559,6 +571,7 @@ const struct nft_expr_ops nft_payload_fast_ops = {
 	.eval		= nft_payload_eval,
 	.init		= nft_payload_init,
 	.dump		= nft_payload_dump,
+	.track		= nft_payload_track,
 	.offload	= nft_payload_offload,
 };
 
@@ -645,6 +658,7 @@ static const struct nft_expr_ops nft_payload_inner_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload)),
 	.init		= nft_payload_inner_init,
 	.dump		= nft_payload_dump,
+	.track		= nft_payload_track,
 	/* direct call to nft_payload_inner_eval(). */
 };
 
@@ -913,12 +927,24 @@ static int nft_payload_set_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_payload_set_track(struct nft_expr_track_ctx *ctx,
+				 struct nft_expr_track *track,
+				 const struct nft_expr *expr)
+{
+	const struct nft_payload_set *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg, priv->len);
+
+	return 1;
+}
+
 static const struct nft_expr_ops nft_payload_set_ops = {
 	.type		= &nft_payload_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload_set)),
 	.eval		= nft_payload_set_eval,
 	.init		= nft_payload_set_init,
 	.dump		= nft_payload_set_dump,
+	.track		= nft_payload_set_track,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 160541791939..62fe8cfa322d 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -184,6 +184,18 @@ nft_queue_sreg_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_queue_track(struct nft_expr_track_ctx *ctx,
+			   struct nft_expr_track *track,
+			   const struct nft_expr *expr)
+{
+	const struct nft_queue *priv = nft_expr_priv(expr);
+
+	if (priv->sreg_qnum)
+		nft_expr_track_sreg(ctx, priv->sreg_qnum, sizeof(u32));
+
+	return 1;
+}
+
 static struct nft_expr_type nft_queue_type;
 static const struct nft_expr_ops nft_queue_ops = {
 	.type		= &nft_queue_type,
@@ -191,6 +203,7 @@ static const struct nft_expr_ops nft_queue_ops = {
 	.eval		= nft_queue_eval,
 	.init		= nft_queue_init,
 	.dump		= nft_queue_dump,
+	.track		= nft_queue_track,
 	.validate	= nft_queue_validate,
 };
 
@@ -200,6 +213,7 @@ static const struct nft_expr_ops nft_queue_sreg_ops = {
 	.eval		= nft_queue_sreg_eval,
 	.init		= nft_queue_sreg_init,
 	.dump		= nft_queue_sreg_dump,
+	.track		= nft_queue_track,
 	.validate	= nft_queue_validate,
 };
 
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 5453056f07df..eb2ae8a7a6a5 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -259,6 +259,7 @@ static const struct nft_expr_ops nft_quota_ops = {
 	.destroy	= nft_quota_destroy,
 	.clone		= nft_quota_clone,
 	.dump		= nft_quota_dump,
+	.track		= NFT_TRACK_GENERIC,
 };
 
 static struct nft_expr_type nft_quota_type __read_mostly = {
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index f8258d520229..c75acc1995fc 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -132,12 +132,24 @@ static int nft_range_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_range_track(struct nft_expr_track_ctx *ctx,
+			   struct nft_expr_track *track,
+			   const struct nft_expr *expr)
+{
+	const struct nft_range_expr *priv = nft_expr_priv(expr);
+
+	nft_expr_track_sreg(ctx, priv->sreg, priv->len);
+
+	return 1;
+}
+
 static const struct nft_expr_ops nft_range_ops = {
 	.type		= &nft_range_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_range_expr)),
 	.eval		= nft_range_eval,
 	.init		= nft_range_init,
 	.dump		= nft_range_dump,
+	.track		= nft_range_track,
 };
 
 struct nft_expr_type nft_range_type __read_mostly = {
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index ab8dfaa34230..824aaf1abdf3 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -101,6 +101,20 @@ static int nft_redir_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_redir_track(struct nft_expr_track_ctx *ctx,
+			   struct nft_expr_track *track,
+			   const struct nft_expr *expr)
+{
+	const struct nft_redir *priv = nft_expr_priv(expr);
+
+	if (priv->sreg_proto_min) {
+		nft_expr_track_sreg(ctx, priv->sreg_proto_min, sizeof(u16));
+		nft_expr_track_sreg(ctx, priv->sreg_proto_max, sizeof(u16));
+	}
+
+	return 1;
+}
+
 static void nft_redir_eval(const struct nft_expr *expr,
 			   struct nft_regs *regs,
 			   const struct nft_pktinfo *pkt)
@@ -148,6 +162,7 @@ static const struct nft_expr_ops nft_redir_ipv4_ops = {
 	.init		= nft_redir_init,
 	.destroy	= nft_redir_ipv4_destroy,
 	.dump		= nft_redir_dump,
+	.track		= nft_redir_track,
 	.validate	= nft_redir_validate,
 };
 
@@ -175,6 +190,7 @@ static const struct nft_expr_ops nft_redir_ipv6_ops = {
 	.init		= nft_redir_init,
 	.destroy	= nft_redir_ipv6_destroy,
 	.dump		= nft_redir_dump,
+	.track		= nft_redir_track,
 	.validate	= nft_redir_validate,
 };
 
@@ -203,6 +219,7 @@ static const struct nft_expr_ops nft_redir_inet_ops = {
 	.init		= nft_redir_init,
 	.destroy	= nft_redir_inet_destroy,
 	.dump		= nft_redir_dump,
+	.track		= nft_redir_track,
 	.validate	= nft_redir_validate,
 };
 
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 554caf967baa..8be0bda077f9 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -79,6 +79,7 @@ static const struct nft_expr_ops nft_reject_inet_ops = {
 	.eval		= nft_reject_inet_eval,
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
+	.track		= NFT_TRACK_GENERIC,
 	.validate	= nft_reject_inet_validate,
 };
 
diff --git a/net/netfilter/nft_reject_netdev.c b/net/netfilter/nft_reject_netdev.c
index 61cd8c4ac385..d4f6cfa5c34a 100644
--- a/net/netfilter/nft_reject_netdev.c
+++ b/net/netfilter/nft_reject_netdev.c
@@ -158,6 +158,7 @@ static const struct nft_expr_ops nft_reject_netdev_ops = {
 	.eval		= nft_reject_netdev_eval,
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
+	.track		= NFT_TRACK_GENERIC,
 	.validate	= nft_reject_netdev_validate,
 };
 
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index 63a6069aa02b..478276db8868 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -16,6 +16,7 @@
 struct nft_rt {
 	enum nft_rt_keys	key:8;
 	u8			dreg;
+	u8			len;
 };
 
 static u16 get_tcpmss(const struct nft_pktinfo *pkt, const struct dst_entry *skbdst)
@@ -140,6 +141,7 @@ static int nft_rt_get_init(const struct nft_ctx *ctx,
 	default:
 		return -EOPNOTSUPP;
 	}
+	priv->len = len;
 
 	return nft_parse_register_store(ctx, tb[NFTA_RT_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, len);
@@ -160,6 +162,17 @@ static int nft_rt_get_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_rt_get_track(struct nft_expr_track_ctx *ctx,
+			    struct nft_expr_track *track,
+			    const struct nft_expr *expr)
+{
+	const struct nft_rt *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
+
+	return 1;
+}
+
 static int nft_rt_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			   const struct nft_data **data)
 {
@@ -190,6 +203,7 @@ static const struct nft_expr_ops nft_rt_get_ops = {
 	.eval		= nft_rt_get_eval,
 	.init		= nft_rt_get_init,
 	.dump		= nft_rt_get_dump,
+	.track		= nft_rt_get_track,
 	.validate	= nft_rt_validate,
 };
 
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 3bfcfe3ee5aa..bb714dc19247 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -213,6 +213,17 @@ static int nft_socket_dump(struct sk_buff *skb,
 	return 0;
 }
 
+static int nft_socket_track(struct nft_expr_track_ctx *ctx,
+			    struct nft_expr_track *track,
+			    const struct nft_expr *expr)
+{
+	const struct nft_socket *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
+
+	return 1;
+}
+
 static int nft_socket_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr,
 			       const struct nft_data **data)
@@ -230,6 +241,7 @@ static const struct nft_expr_ops nft_socket_ops = {
 	.eval		= nft_socket_eval,
 	.init		= nft_socket_init,
 	.dump		= nft_socket_dump,
+	.track		= nft_socket_track,
 	.validate	= nft_socket_validate,
 };
 
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index bf7268908154..81707c8844d4 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -287,6 +287,7 @@ static const struct nft_expr_ops nft_synproxy_ops = {
 	.init		= nft_synproxy_init,
 	.destroy	= nft_synproxy_destroy,
 	.dump		= nft_synproxy_dump,
+	.track		= NFT_TRACK_GENERIC,
 	.type		= &nft_synproxy_type,
 	.validate	= nft_synproxy_validate,
 };
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 089d608f6b32..d7b4ed7f5009 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -312,6 +312,32 @@ static int nft_tproxy_dump(struct sk_buff *skb,
 	return 0;
 }
 
+static int nft_tproxy_track(struct nft_expr_track_ctx *ctx,
+			    struct nft_expr_track *track,
+			    const struct nft_expr *expr)
+{
+	const struct nft_tproxy *priv = nft_expr_priv(expr);
+	u8 alen = 0;
+
+	switch (priv->family) {
+	case NFPROTO_IPV4:
+		alen = sizeof_field(union nf_inet_addr, in);
+		break;
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+	case NFPROTO_IPV6:
+		alen = sizeof_field(union nf_inet_addr, in6);
+		break;
+#endif
+	}
+
+	if (priv->sreg_addr)
+		nft_expr_track_sreg(ctx, priv->sreg_addr, alen);
+	if (priv->sreg_port)
+		nft_expr_track_sreg(ctx, priv->sreg_port, sizeof(u16));
+
+	return 1;
+}
+
 static int nft_tproxy_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr,
 			       const struct nft_data **data)
@@ -327,6 +353,7 @@ static const struct nft_expr_ops nft_tproxy_ops = {
 	.init		= nft_tproxy_init,
 	.destroy	= nft_tproxy_destroy,
 	.dump		= nft_tproxy_dump,
+	.track		= nft_tproxy_track,
 	.validate	= nft_tproxy_validate,
 };
 
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index ddd698332730..9ed4e65899f3 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -124,6 +124,17 @@ static int nft_tunnel_get_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_tunnel_get_track(struct nft_expr_track_ctx *ctx,
+				struct nft_expr_track *track,
+				const struct nft_expr *expr)
+{
+	const struct nft_tunnel *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
+
+	return 1;
+}
+
 static struct nft_expr_type nft_tunnel_type;
 static const struct nft_expr_ops nft_tunnel_get_ops = {
 	.type		= &nft_tunnel_type,
@@ -131,6 +142,7 @@ static const struct nft_expr_ops nft_tunnel_get_ops = {
 	.eval		= nft_tunnel_get_eval,
 	.init		= nft_tunnel_get_init,
 	.dump		= nft_tunnel_get_dump,
+	.track		= nft_tunnel_get_track,
 };
 
 static struct nft_expr_type nft_tunnel_type __read_mostly = {
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 6252e1d9def8..f75fb1a2be80 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -229,6 +229,17 @@ static int nft_xfrm_get_dump(struct sk_buff *skb,
 	return 0;
 }
 
+static int nft_xfrm_get_track(struct nft_expr_track_ctx *ctx,
+			      struct nft_expr_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_xfrm *priv = nft_expr_priv(expr);
+
+	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
+
+	return 1;
+}
+
 static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			     const struct nft_data **data)
 {
@@ -261,6 +272,7 @@ static const struct nft_expr_ops nft_xfrm_get_ops = {
 	.eval		= nft_xfrm_get_eval,
 	.init		= nft_xfrm_get_init,
 	.dump		= nft_xfrm_get_dump,
+	.track		= nft_xfrm_get_track,
 	.validate	= nft_xfrm_validate,
 };
 
-- 
2.30.2

