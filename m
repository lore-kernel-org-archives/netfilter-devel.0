Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBF1C77B7C
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbjEEPcM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbjEEPcJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:32:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC9324C28
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:51 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 10/12] netfilter: nf_tables: add track infrastructure to prepare for expression prefetch
Date:   Fri,  5 May 2023 17:31:28 +0200
Message-Id: <20230505153130.2385-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new operation to track register content at ruleset load time.
This comes in preparation of the new prefetch infrastructure.

A register can be in any of these three states:

- NFT_TRACK_UNSET: The register has not yet been used.
- NFT_TRACK_SET: The register has been used and it contains a selector
  that is candidate to be prefetched before ruleset evaluation.
- NFT_TRACK_SKIP: The register has been used to store different
  selectors, this is not a candidate to be prefetched, ie. this
  register is used a scratchpad area.

Initially, all registers are in NFT_TRACK_UNSET. If a register R1 is
used n-times to store the same selector, this register remains in
state NFT_TRACK_SET. If the register R1 is used by different selectors,
then it enters NFT_TRACK_SKIP from the NFT_TRACK_SET state.

This patch introduces the infrastructure, follow up patch that
introduces the expression prefetch support uses this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      | 28 +++++++++++++++++++++++++-
 include/net/netfilter/nft_fib.h        |  1 +
 include/net/netfilter/nft_meta.h       |  3 +++
 net/bridge/netfilter/nft_meta_bridge.c |  1 +
 net/ipv4/netfilter/nft_fib_ipv4.c      |  2 ++
 net/ipv6/netfilter/nft_fib_ipv6.c      |  2 ++
 net/netfilter/nf_tables_api.c          | 21 +++++++++++++++++++
 net/netfilter/nft_ct.c                 |  9 +++++++++
 net/netfilter/nft_exthdr.c             |  9 +++++++++
 net/netfilter/nft_fib.c                | 25 +++++++++++++++++++++++
 net/netfilter/nft_fib_inet.c           |  1 +
 net/netfilter/nft_fib_netdev.c         |  1 +
 net/netfilter/nft_hash.c               |  9 +++++++++
 net/netfilter/nft_meta.c               | 10 +++++++++
 net/netfilter/nft_osf.c                |  9 +++++++++
 net/netfilter/nft_payload.c            | 10 +++++++++
 net/netfilter/nft_socket.c             |  9 +++++++++
 net/netfilter/nft_tunnel.c             |  9 +++++++++
 net/netfilter/nft_xfrm.c               |  9 +++++++++
 19 files changed, 167 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f7132f136b47..744beb30f105 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1057,6 +1057,8 @@ struct nft_expr_ops {
 	int				(*validate)(const struct nft_ctx *ctx,
 						    const struct nft_expr *expr,
 						    const struct nft_data **data);
+	void				(*track)(struct nft_regs_track *track,
+						 const struct nft_expr *expr);
 	bool				(*reduce)(struct nft_regs_track *track,
 						  const struct nft_expr *expr);
 	bool				(*gc)(struct net *net,
@@ -1830,15 +1832,39 @@ static inline bool nft_reduce_is_readonly(const struct nft_expr *expr)
 	return expr->ops->reduce == NFT_REDUCE_READONLY;
 }
 
+void nft_reg_track(struct nft_regs_track *track,
+		   const struct nft_expr *expr, u8 dreg, u8 len,
+		   bool (*cmp)(const struct nft_reg_track *reg,
+			       const struct nft_expr *expr));
 void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, u8 len);
 void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg);
 
+#define __NFT_TRACK_SKIP_PTR	1UL
+#define NFT_TRACK_SKIP_PTR	(void *)__NFT_TRACK_SKIP_PTR
+
 static inline bool nft_reg_track_cmp(const struct nft_reg_track *reg,
 				     const struct nft_expr *expr)
 {
-	return reg->selector &&
+	return reg->selector && reg->selector != NFT_TRACK_SKIP_PTR &&
 	       reg->selector->ops == expr->ops &&
 	       reg->num_reg == 0;
 }
 
+enum nft_track_status {
+	NFT_TRACK_UNSET		= 0,
+	NFT_TRACK_SKIP,
+	NFT_TRACK_SET,
+};
+
+static inline enum nft_track_status
+nft_reg_track_status(const struct nft_reg_track *reg)
+{
+	if (reg->selector == NFT_TRACK_SKIP_PTR)
+		return NFT_TRACK_SKIP;
+	else if (reg->selector != NULL)
+		return NFT_TRACK_SET;
+
+	return NFT_TRACK_UNSET;
+}
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index d365eb765327..4a7b525f0b2a 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -38,6 +38,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 void nft_fib_store_result(struct nft_regs *regs, const struct nft_fib *priv,
 			  const struct net_device *dev);
 
+void nft_fib_track(struct nft_regs_track *track, const struct nft_expr *expr);
 bool nft_fib_reduce(struct nft_regs_track *track,
 		    const struct nft_expr *expr);
 #endif
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index ba1238f12a48..413ad538c1bf 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -44,6 +44,9 @@ int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr,
 			  const struct nft_data **data);
 
+void nft_meta_get_track(struct nft_regs_track *track,
+			const struct nft_expr *expr);
+
 bool nft_meta_get_reduce(struct nft_regs_track *track,
 			 const struct nft_expr *expr);
 
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 5e592b4df642..9df5294eb973 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -101,6 +101,7 @@ static const struct nft_expr_ops nft_meta_bridge_get_ops = {
 	.eval		= nft_meta_bridge_get_eval,
 	.init		= nft_meta_bridge_get_init,
 	.dump		= nft_meta_get_dump,
+	.track		= nft_meta_get_track,
 	.reduce		= nft_meta_get_reduce,
 };
 
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index cece7cc48104..a9da77bf84e3 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -158,6 +158,7 @@ static const struct nft_expr_ops nft_fib4_type_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
+	.track		= nft_fib_track,
 	.reduce		= nft_fib_reduce,
 };
 
@@ -168,6 +169,7 @@ static const struct nft_expr_ops nft_fib4_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
+	.track		= nft_fib_track,
 	.reduce		= nft_fib_reduce,
 };
 
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index e12251175434..b131b1deb61c 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -219,6 +219,7 @@ static const struct nft_expr_ops nft_fib6_type_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
+	.track		= nft_fib_track,
 	.reduce		= nft_fib_reduce,
 };
 
@@ -229,6 +230,7 @@ static const struct nft_expr_ops nft_fib6_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
+	.track		= nft_fib_track,
 	.reduce		= nft_fib_reduce,
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a0e3b73c72a3..3e43e5eab4be 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -679,6 +679,27 @@ void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg)
 }
 EXPORT_SYMBOL_GPL(__nft_reg_track_cancel);
 
+void nft_reg_track(struct nft_regs_track *track,
+		   const struct nft_expr *expr, u8 dreg, u8 len,
+		   bool (*cmp)(const struct nft_reg_track *reg, const struct nft_expr *expr))
+{
+	switch (nft_reg_track_status(&track->regs[dreg])) {
+	case NFT_TRACK_SKIP:
+		return;
+	case NFT_TRACK_UNSET:
+		nft_reg_track_update(track, expr, dreg, len);
+		return;
+	case NFT_TRACK_SET:
+		if (cmp(&track->regs[dreg], expr))
+			return;
+
+		nft_reg_track_cancel(track, dreg, len);
+		track->regs[dreg].selector = NFT_TRACK_SKIP_PTR;
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(nft_reg_track);
+
 /*
  * Tables
  */
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 746416d894e0..21828fb3100e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -715,6 +715,14 @@ static bool nft_ct_expr_cmp(const struct nft_reg_track *reg,
 	return true;
 }
 
+static void nft_ct_get_track(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_ct *priv = nft_expr_priv(expr);
+
+	nft_reg_track(track, expr, priv->dreg, priv->len, nft_ct_expr_cmp);
+}
+
 static bool nft_ct_get_reduce(struct nft_regs_track *track,
 			      const struct nft_expr *expr)
 {
@@ -762,6 +770,7 @@ static const struct nft_expr_ops nft_ct_get_ops = {
 	.init		= nft_ct_get_init,
 	.destroy	= nft_ct_get_destroy,
 	.dump		= nft_ct_get_dump,
+	.track		= nft_ct_get_track,
 	.reduce		= nft_ct_get_reduce,
 };
 
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 43d53e4342c5..cf5ee748f2c6 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -630,6 +630,14 @@ static bool nft_exthdr_cmp(const struct nft_reg_track *reg,
 	return true;
 }
 
+static void nft_exthdr_track(struct nft_regs_track *track,
+			     const struct nft_expr *expr)
+{
+       const struct nft_exthdr *priv = nft_expr_priv(expr);
+
+       nft_reg_track(track, expr, priv->dreg, priv->len, nft_exthdr_cmp);
+}
+
 static bool nft_exthdr_reduce(struct nft_regs_track *track,
 			       const struct nft_expr *expr)
 {
@@ -649,6 +657,7 @@ static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
 	.eval		= nft_exthdr_ipv6_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
+	.track		= nft_exthdr_track,
 	.reduce		= nft_exthdr_reduce,
 };
 
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 8a1aad66ce91..e493e4851d93 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -190,6 +190,31 @@ static bool nft_fib_cmp(const struct nft_reg_track *reg,
 	return true;
 }
 
+void nft_fib_track(struct nft_regs_track *track, const struct nft_expr *expr)
+{
+	const struct nft_fib *priv = nft_expr_priv(expr);
+	unsigned int len = NFT_REG32_SIZE;
+
+	switch (priv->result) {
+	case NFT_FIB_RESULT_OIF:
+		break;
+	case NFT_FIB_RESULT_OIFNAME:
+		if (priv->flags & NFTA_FIB_F_PRESENT)
+			len = NFT_REG32_SIZE;
+		else
+			len = IFNAMSIZ;
+		break;
+	case NFT_FIB_RESULT_ADDRTYPE:
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	nft_reg_track(track, expr, priv->dreg, len, nft_fib_cmp);
+}
+EXPORT_SYMBOL_GPL(nft_fib_track);
+
 bool nft_fib_reduce(struct nft_regs_track *track,
 		    const struct nft_expr *expr)
 {
diff --git a/net/netfilter/nft_fib_inet.c b/net/netfilter/nft_fib_inet.c
index 666a3741d20b..4e3c51c99130 100644
--- a/net/netfilter/nft_fib_inet.c
+++ b/net/netfilter/nft_fib_inet.c
@@ -49,6 +49,7 @@ static const struct nft_expr_ops nft_fib_inet_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
+	.track		= nft_fib_track,
 	.reduce		= nft_fib_reduce,
 };
 
diff --git a/net/netfilter/nft_fib_netdev.c b/net/netfilter/nft_fib_netdev.c
index 9121ec64e918..2f0b1251c281 100644
--- a/net/netfilter/nft_fib_netdev.c
+++ b/net/netfilter/nft_fib_netdev.c
@@ -58,6 +58,7 @@ static const struct nft_expr_ops nft_fib_netdev_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
+	.track		= nft_fib_track,
 	.reduce		= nft_fib_reduce,
 };
 
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 8d93d9d4ecd9..db2e1eb50aa2 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -220,6 +220,14 @@ static bool nft_symhash_cmp(const struct nft_reg_track *reg,
 	return true;
 }
 
+static void nft_symhash_track(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_symhash *priv = nft_expr_priv(expr);
+
+	nft_reg_track(track, expr, priv->dreg, sizeof(u32), nft_symhash_cmp);
+}
+
 static bool nft_symhash_reduce(struct nft_regs_track *track,
 			       const struct nft_expr *expr)
 {
@@ -249,6 +257,7 @@ static const struct nft_expr_ops nft_symhash_ops = {
 	.eval		= nft_symhash_eval,
 	.init		= nft_symhash_init,
 	.dump		= nft_symhash_dump,
+	.track		= nft_symhash_track,
 	.reduce		= nft_symhash_reduce,
 };
 
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index db13a4771261..7f160e4be1b7 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -790,6 +790,15 @@ static bool nft_meta_cmp(const struct nft_reg_track *reg,
 	return true;
 }
 
+void nft_meta_get_track(struct nft_regs_track *track,
+			const struct nft_expr *expr)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+
+	nft_reg_track(track, expr, priv->dreg, priv->len, nft_meta_cmp);
+}
+EXPORT_SYMBOL_GPL(nft_meta_get_track);
+
 bool nft_meta_get_reduce(struct nft_regs_track *track,
 			 const struct nft_expr *expr)
 {
@@ -811,6 +820,7 @@ static const struct nft_expr_ops nft_meta_get_ops = {
 	.init		= nft_meta_get_init,
 	.dump		= nft_meta_get_dump,
 	.reduce		= nft_meta_get_reduce,
+	.track		= nft_meta_get_track,
 	.validate	= nft_meta_get_validate,
 	.offload	= nft_meta_get_offload,
 };
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index ce01e3970579..117a8f8c9efd 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -151,6 +151,14 @@ static bool nft_osf_cmp(const struct nft_reg_track *reg,
 	return true;
 }
 
+static void nft_osf_track(struct nft_regs_track *track,
+			  const struct nft_expr *expr)
+{
+	const struct nft_osf *priv = nft_expr_priv(expr);
+
+	nft_reg_track(track, expr, priv->dreg, NFT_OSF_MAXGENRELEN, nft_osf_cmp);
+}
+
 static bool nft_osf_reduce(struct nft_regs_track *track,
 			   const struct nft_expr *expr)
 {
@@ -172,6 +180,7 @@ static const struct nft_expr_ops nft_osf_op = {
 	.dump		= nft_osf_dump,
 	.type		= &nft_osf_type,
 	.validate	= nft_osf_validate,
+	.track		= nft_osf_track,
 	.reduce		= nft_osf_reduce,
 };
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 056a8adf8726..a4b111e1eb96 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -270,6 +270,14 @@ static bool nft_payload_cmp(const struct nft_reg_track *reg,
 	return true;
 }
 
+static void nft_payload_track(struct nft_regs_track *track,
+			       const struct nft_expr *expr)
+{
+	const struct nft_payload *priv = nft_expr_priv(expr);
+
+	nft_reg_track(track, expr, priv->dreg, priv->len, nft_payload_cmp);
+}
+
 static bool nft_payload_reduce(struct nft_regs_track *track,
 			       const struct nft_expr *expr)
 {
@@ -586,6 +594,7 @@ static const struct nft_expr_ops nft_payload_ops = {
 	.eval		= nft_payload_eval,
 	.init		= nft_payload_init,
 	.dump		= nft_payload_dump,
+	.track		= nft_payload_track,
 	.reduce		= nft_payload_reduce,
 	.offload	= nft_payload_offload,
 };
@@ -596,6 +605,7 @@ const struct nft_expr_ops nft_payload_fast_ops = {
 	.eval		= nft_payload_eval,
 	.init		= nft_payload_init,
 	.dump		= nft_payload_dump,
+	.track		= nft_payload_track,
 	.reduce		= nft_payload_reduce,
 	.offload	= nft_payload_offload,
 };
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 8bc1df325ab9..6fde13c939c0 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -235,6 +235,14 @@ static bool nft_socket_cmp(const struct nft_reg_track *reg,
 	return true;
 }
 
+static void nft_socket_track(struct nft_regs_track *track,
+			     const struct nft_expr *expr)
+{
+	const struct nft_socket *priv = nft_expr_priv(expr);
+
+	nft_reg_track(track, expr, priv->dreg, priv->len, nft_socket_cmp);
+}
+
 static bool nft_socket_reduce(struct nft_regs_track *track,
 			      const struct nft_expr *expr)
 {
@@ -266,6 +274,7 @@ static const struct nft_expr_ops nft_socket_ops = {
 	.init		= nft_socket_init,
 	.dump		= nft_socket_dump,
 	.validate	= nft_socket_validate,
+	.track		= nft_socket_track,
 	.reduce		= nft_socket_reduce,
 };
 
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 2a831a40d7c2..bb4ff36d2047 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -142,6 +142,14 @@ static bool nft_tunnel_cmp(const struct nft_reg_track *reg,
 	return true;
 }
 
+static void nft_tunnel_get_track(struct nft_regs_track *track,
+				 const struct nft_expr *expr)
+{
+	const struct nft_tunnel *priv = nft_expr_priv(expr);
+
+	nft_reg_track(track, expr, priv->dreg, priv->len, nft_tunnel_cmp);
+}
+
 static bool nft_tunnel_get_reduce(struct nft_regs_track *track,
 				  const struct nft_expr *expr)
 {
@@ -162,6 +170,7 @@ static const struct nft_expr_ops nft_tunnel_get_ops = {
 	.eval		= nft_tunnel_get_eval,
 	.init		= nft_tunnel_get_init,
 	.dump		= nft_tunnel_get_dump,
+	.track		= nft_tunnel_get_track,
 	.reduce		= nft_tunnel_get_reduce,
 };
 
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 7f65f5b3bbbf..f4610b795ede 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -276,6 +276,14 @@ static bool nft_xfrm_cmp(const struct nft_reg_track *reg,
 	return true;
 }
 
+static void nft_xfrm_track(struct nft_regs_track *track,
+			   const struct nft_expr *expr)
+{
+	const struct nft_xfrm *priv = nft_expr_priv(expr);
+
+	nft_reg_track(track, expr, priv->dreg, priv->len, nft_xfrm_cmp);
+}
+
 static bool nft_xfrm_reduce(struct nft_regs_track *track,
 			    const struct nft_expr *expr)
 {
@@ -297,6 +305,7 @@ static const struct nft_expr_ops nft_xfrm_get_ops = {
 	.init		= nft_xfrm_get_init,
 	.dump		= nft_xfrm_get_dump,
 	.validate	= nft_xfrm_validate,
+	.track		= nft_xfrm_track,
 	.reduce		= nft_xfrm_reduce,
 };
 
-- 
2.30.2

