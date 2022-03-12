Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A446C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 00:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiCLAXC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 19:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiCLAXB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 19:23:01 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0FA028E2F
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Mar 2022 16:21:56 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 40E0060240
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 01:19:50 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2] netfilter: nf_tables: cancel register tracking if .reduce is not defined
Date:   Sat, 12 Mar 2022 01:21:52 +0100
Message-Id: <20220312002152.30187-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cancel all register tracking if the reduce function is not defined. Add
missing reduce function to cmp, immediate, counter and compat since
these are read-only register.

This patch unbreaks selftests/netfilter/nft_nat_zones.sh.

Fixes: 12e4ecfa244b ("netfilter: nf_tables: add register tracking infrastructure")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: remove redefinition of nft_match_reduce()

 net/netfilter/nf_tables_api.c |  2 ++
 net/netfilter/nft_cmp.c       |  8 ++++++++
 net/netfilter/nft_compat.c    |  7 +++++++
 net/netfilter/nft_counter.c   |  7 +++++++
 net/netfilter/nft_immediate.c | 14 ++++++++++++++
 5 files changed, 38 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3168ad8cffd1..71caa7d18681 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8338,6 +8338,8 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 			    expr->ops->reduce(&track, expr)) {
 				expr = track.cur;
 				continue;
+			} else if (expr->ops->reduce == NULL) {
+				memset(track.regs, 0, sizeof(track.regs));
 			}
 
 			if (WARN_ON_ONCE(data + expr->ops->size > data_boundary))
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 917072af09df..9ec5cb0e6331 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -187,12 +187,19 @@ static int nft_cmp_offload(struct nft_offload_ctx *ctx,
 	return __nft_cmp_offload(ctx, flow, priv);
 }
 
+static bool nft_cmp_reduce(struct nft_regs_track *track,
+			   const struct nft_expr *expr)
+{
+	return false;
+}
+
 static const struct nft_expr_ops nft_cmp_ops = {
 	.type		= &nft_cmp_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp_expr)),
 	.eval		= nft_cmp_eval,
 	.init		= nft_cmp_init,
 	.dump		= nft_cmp_dump,
+	.reduce		= nft_cmp_reduce,
 	.offload	= nft_cmp_offload,
 };
 
@@ -269,6 +276,7 @@ const struct nft_expr_ops nft_cmp_fast_ops = {
 	.eval		= NULL,	/* inlined */
 	.init		= nft_cmp_fast_init,
 	.dump		= nft_cmp_fast_dump,
+	.reduce		= nft_cmp_reduce,
 	.offload	= nft_cmp_fast_offload,
 };
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 5a46d8289d1d..6ec4e5b97050 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -820,6 +820,12 @@ static struct nft_expr_type nft_match_type __read_mostly = {
 
 static struct nft_expr_type nft_target_type;
 
+static bool nft_target_reduce(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	return false;
+}
+
 static const struct nft_expr_ops *
 nft_target_select_ops(const struct nft_ctx *ctx,
 		      const struct nlattr * const tb[])
@@ -871,6 +877,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	ops->dump = nft_target_dump;
 	ops->validate = nft_target_validate;
 	ops->data = target;
+	ops->reduce = nft_target_reduce;
 
 	if (family == NFPROTO_BRIDGE)
 		ops->eval = nft_target_eval_bridge;
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index f179e8c3b0ca..cd923c030353 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -283,6 +283,12 @@ void nft_counter_init_seqcount(void)
 		seqcount_init(per_cpu_ptr(&nft_counter_seq, cpu));
 }
 
+static bool nft_counter_reduce(struct nft_regs_track *track,
+			       const struct nft_expr *expr)
+{
+	return false;
+}
+
 struct nft_expr_type nft_counter_type;
 static const struct nft_expr_ops nft_counter_ops = {
 	.type		= &nft_counter_type,
@@ -293,6 +299,7 @@ static const struct nft_expr_ops nft_counter_ops = {
 	.destroy_clone	= nft_counter_destroy,
 	.dump		= nft_counter_dump,
 	.clone		= nft_counter_clone,
+	.reduce		= nft_counter_reduce,
 	.offload	= nft_counter_offload,
 	.offload_stats	= nft_counter_offload_stats,
 };
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index d0f67d325bdf..45b14af3c523 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -223,6 +223,19 @@ static bool nft_immediate_offload_action(const struct nft_expr *expr)
 	return false;
 }
 
+static bool nft_immediate_reduce(struct nft_regs_track *track,
+				 const struct nft_expr *expr)
+{
+	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+
+	if (priv->dreg != NFT_REG_VERDICT) {
+		track->regs[priv->dreg].selector = NULL;
+		track->regs[priv->dreg].bitwise = NULL;
+	}
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_imm_ops = {
 	.type		= &nft_imm_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
@@ -233,6 +246,7 @@ static const struct nft_expr_ops nft_imm_ops = {
 	.destroy	= nft_immediate_destroy,
 	.dump		= nft_immediate_dump,
 	.validate	= nft_immediate_validate,
+	.reduce		= nft_immediate_reduce,
 	.offload	= nft_immediate_offload,
 	.offload_action	= nft_immediate_offload_action,
 };
-- 
2.30.2

