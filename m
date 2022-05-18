Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAFDC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 12:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbiERMUB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 08:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbiERMUA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 08:20:00 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B3E814CDD4
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 05:19:58 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] nft: support for dynamic register allocation
Date:   Wed, 18 May 2022 14:19:54 +0200
Message-Id: <20220518121954.190221-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Starting Linux kernel 5.18-rc, operations on registers that already
contain the expected data are turned into noop.

Use libnftnl dynamic register allocation infrastructure to select
the registers to be used for payload and meta expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Patch for tests/py still missing, it will be large, coming after this.

 include/netlink.h       |   5 +-
 src/libnftables.c       |  15 ++
 src/mnl.c               |   4 +-
 src/netlink_linearize.c | 327 ++++++++++++++++++----------------------
 4 files changed, 171 insertions(+), 180 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index e8e0f68ae1a4..c88f34944a1c 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -69,6 +69,7 @@ struct netlink_ctx {
 	const void		*data;
 	uint32_t		seqnum;
 	struct nftnl_batch	*batch;
+	struct nftnl_regs	*regs;
 };
 
 extern struct nftnl_expr *alloc_nft_expr(const char *name);
@@ -218,12 +219,14 @@ int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
 enum nft_data_types dtype_map_to_kernel(const struct datatype *dtype);
 
 void netlink_linearize_init(struct netlink_linearize_ctx *lctx,
+			    struct nftnl_regs *regs,
 			    struct nftnl_rule *nlr);
 void netlink_linearize_fini(struct netlink_linearize_ctx *lctx);
 
 struct netlink_linearize_ctx {
 	struct nftnl_rule	*nlr;
-	unsigned int		reg_low;
+	struct nftnl_regs	*regs;
+	bool			concat;
 	struct list_head	*expr_loc_htable;
 };
 
diff --git a/src/libnftables.c b/src/libnftables.c
index 6a22ea093952..17636dbe4f68 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -16,6 +16,18 @@
 #include <errno.h>
 #include <stdlib.h>
 #include <string.h>
+#include <libnftnl/regs.h>
+
+static struct nftnl_regs *nft_regs_alloc(void)
+{
+	struct nftnl_regs *regs;
+
+	regs = nftnl_regs_alloc(16);
+	if (!regs)
+		memory_allocation_error();
+
+	return regs;
+}
 
 static int nft_netlink(struct nft_ctx *nft,
 		       struct list_head *cmds, struct list_head *msgs,
@@ -27,6 +39,7 @@ static int nft_netlink(struct nft_ctx *nft,
 		.msgs = msgs,
 		.list = LIST_HEAD_INIT(ctx.list),
 		.batch = mnl_batch_init(),
+		.regs = nft_regs_alloc(),
 	};
 	struct cmd *cmd;
 	struct mnl_err *err, *tmp;
@@ -97,6 +110,8 @@ static int nft_netlink(struct nft_ctx *nft,
 		mnl_err_list_free(err);
 out:
 	mnl_batch_reset(ctx.batch);
+	nftnl_regs_free(ctx.regs);
+
 	return ret;
 }
 
diff --git a/src/mnl.c b/src/mnl.c
index 7dd77be1bec0..c6799e535b8b 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -510,7 +510,7 @@ int mnl_nft_rule_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	if (h->position_id)
 		nftnl_rule_set_u32(nlr, NFTNL_RULE_POSITION_ID, h->position_id);
 
-	netlink_linearize_init(&lctx, nlr);
+	netlink_linearize_init(&lctx, ctx->regs, nlr);
 	netlink_linearize_rule(ctx, rule, &lctx);
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_NEWRULE,
@@ -561,7 +561,7 @@ int mnl_nft_rule_replace(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	nftnl_rule_set_u32(nlr, NFTNL_RULE_FAMILY, h->family);
 
-	netlink_linearize_init(&lctx, nlr);
+	netlink_linearize_init(&lctx, ctx->regs, nlr);
 	netlink_linearize_rule(ctx, rule, &lctx);
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_NEWRULE,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index bc487bb60ae8..4478c74bf097 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -22,8 +22,55 @@
 #include <netinet/in.h>
 
 #include <linux/netfilter.h>
+#include <libnftnl/regs.h>
 #include <libnftnl/udata.h>
 
+static enum nft_registers nft_reg_compat(enum nft_registers reg)
+{
+	if (reg == NFT_REG_VERDICT)
+		return reg;
+
+	if (reg >= NFT_REG32_00 && reg % 4 == 0) {
+		reg -= NFT_REG32_00;
+		reg /= 4;
+		reg++;
+	}
+
+	return reg;
+}
+
+static void netlink_put_register(struct nftnl_expr *nle,
+				 uint32_t attr, uint32_t reg)
+{
+	reg = nft_reg_compat(reg);
+	nftnl_expr_set_u32(nle, attr, reg);
+}
+
+static void nft_expr_set_reg(struct netlink_linearize_ctx *ctx, struct nftnl_expr *nle,
+			     uint32_t len, uint32_t attr, enum nft_registers *dreg)
+{
+	if (!ctx->concat)
+		*dreg = nftnl_reg_get(ctx->regs, nle);
+
+	nftnl_expr_set_u32(nle, attr, nft_reg_compat(*dreg));
+
+	if (ctx->concat)
+		*dreg += netlink_register_space(len);
+}
+
+static void nft_expr_set_reg_scratch(struct netlink_linearize_ctx *ctx,
+				     struct nftnl_expr *nle, uint32_t len,
+				     uint32_t attr, enum nft_registers *dreg)
+{
+	if (!ctx->concat)
+		*dreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(len, BITS_PER_BYTE));
+
+	netlink_put_register(nle, attr, *dreg);
+
+	if (ctx->concat)
+		*dreg += netlink_register_space(len);
+}
+
 struct nft_expr_loc *nft_expr_loc_find(const struct nftnl_expr *nle,
 				       struct netlink_linearize_ctx *ctx)
 {
@@ -53,65 +100,6 @@ static void nft_expr_loc_add(const struct nftnl_expr *nle,
 	list_add_tail(&eloc->hlist, &ctx->expr_loc_htable[hash]);
 }
 
-static void netlink_put_register(struct nftnl_expr *nle,
-				 uint32_t attr, uint32_t reg)
-{
-	/* Convert to 128 bit register numbers if possible for compatibility */
-	if (reg != NFT_REG_VERDICT) {
-		reg -= NFT_REG_1;
-		if (reg % (NFT_REG_SIZE / NFT_REG32_SIZE) == 0)
-			reg = NFT_REG_1 + reg / (NFT_REG_SIZE / NFT_REG32_SIZE);
-		else
-			reg += NFT_REG32_00;
-	}
-
-	nftnl_expr_set_u32(nle, attr, reg);
-}
-
-static enum nft_registers __get_register(struct netlink_linearize_ctx *ctx,
-					 unsigned int size)
-{
-	unsigned int reg, n;
-
-	n = netlink_register_space(size);
-	if (ctx->reg_low + n > NFT_REG_1 + NFT_REG32_15 - NFT_REG32_00 + 1)
-		BUG("register reg_low %u invalid\n", ctx->reg_low);
-
-	reg = ctx->reg_low;
-	ctx->reg_low += n;
-	return reg;
-}
-
-static void __release_register(struct netlink_linearize_ctx *ctx,
-			       unsigned int size)
-{
-	unsigned int n;
-
-	n = netlink_register_space(size);
-	if (ctx->reg_low < NFT_REG_1 + n)
-		BUG("register reg_low %u invalid\n", ctx->reg_low);
-
-	ctx->reg_low -= n;
-}
-
-static enum nft_registers get_register(struct netlink_linearize_ctx *ctx,
-				       const struct expr *expr)
-{
-	if (expr && expr->etype == EXPR_CONCAT)
-		return __get_register(ctx, expr->len);
-	else
-		return __get_register(ctx, NFT_REG_SIZE * BITS_PER_BYTE);
-}
-
-static void release_register(struct netlink_linearize_ctx *ctx,
-			     const struct expr *expr)
-{
-	if (expr && expr->etype == EXPR_CONCAT)
-		__release_register(ctx, expr->len);
-	else
-		__release_register(ctx, NFT_REG_SIZE * BITS_PER_BYTE);
-}
-
 static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 			     const struct expr *expr,
 			     enum nft_registers *dreg);
@@ -120,12 +108,20 @@ static void netlink_gen_concat(struct netlink_linearize_ctx *ctx,
 			       const struct expr *expr,
 			       enum nft_registers *dreg)
 {
+	enum nft_registers reg;
 	const struct expr *i;
 
-	list_for_each_entry(i, &expr->expressions, list) {
+	/* pre-allocate registers for this concatenation */
+	reg = nftnl_reg_get_scratch(ctx->regs, div_round_up(expr->len, BITS_PER_BYTE));
+	*dreg = reg;
+
+	ctx->concat = true;
+	list_for_each_entry(i, &expr->expressions, list)
 		netlink_gen_expr(ctx, i, dreg);
-		*dreg += netlink_register_space(i->len);
-	}
+
+	ctx->concat = false;
+
+	*dreg = reg;
 }
 
 static void nft_rule_add_expr(struct netlink_linearize_ctx *ctx,
@@ -143,9 +139,9 @@ static void netlink_gen_fib(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("fib");
-	netlink_put_register(nle, NFTNL_EXPR_FIB_DREG, *dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_FIB_RESULT, expr->fib.result);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_FIB_FLAGS, expr->fib.flags);
+	nft_expr_set_reg(ctx, nle, expr->len, NFTNL_EXPR_FIB_DREG, dreg);
 
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
@@ -160,16 +156,15 @@ static void netlink_gen_hash(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("hash");
 
 	if (expr->hash.expr) {
-		sreg = get_register(ctx, expr->hash.expr);
+		sreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(expr->hash.expr->len, BITS_PER_BYTE));
 		netlink_gen_expr(ctx, expr->hash.expr, &sreg);
-		release_register(ctx, expr->hash.expr);
 		netlink_put_register(nle, NFTNL_EXPR_HASH_SREG, sreg);
 
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_LEN,
 				   div_round_up(expr->hash.expr->len,
 						BITS_PER_BYTE));
 	}
-	netlink_put_register(nle, NFTNL_EXPR_HASH_DREG, *dreg);
+	nft_expr_set_reg_scratch(ctx, nle, expr->len, NFTNL_EXPR_HASH_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_MODULUS, expr->hash.mod);
 	if (expr->hash.seed_set)
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
@@ -185,14 +180,13 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("payload");
-	netlink_put_register(nle, NFTNL_EXPR_PAYLOAD_DREG, *dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_BASE,
 			   expr->payload.base - 1);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_OFFSET,
 			   expr->payload.offset / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
-
+	nft_expr_set_reg(ctx, nle, expr->len, NFTNL_EXPR_PAYLOAD_DREG, dreg);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
@@ -204,7 +198,6 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("exthdr");
-	netlink_put_register(nle, NFTNL_EXPR_EXTHDR_DREG, *dreg);
 	nftnl_expr_set_u8(nle, NFTNL_EXPR_EXTHDR_TYPE,
 			  expr->exthdr.raw_type);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET, offset / BITS_PER_BYTE);
@@ -212,6 +205,7 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 			   div_round_up(expr->len, BITS_PER_BYTE));
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OP, expr->exthdr.op);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_FLAGS, expr->exthdr.flags);
+	nft_expr_set_reg(ctx, nle, expr->len, NFTNL_EXPR_EXTHDR_DREG, dreg);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
@@ -222,8 +216,8 @@ static void netlink_gen_meta(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("meta");
-	netlink_put_register(nle, NFTNL_EXPR_META_DREG, *dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_META_KEY, expr->meta.key);
+	nft_expr_set_reg(ctx, nle, expr->len, NFTNL_EXPR_META_DREG, dreg);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
@@ -234,8 +228,8 @@ static void netlink_gen_rt(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("rt");
-	netlink_put_register(nle, NFTNL_EXPR_RT_DREG, *dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_RT_KEY, expr->rt.key);
+	nft_expr_set_reg(ctx, nle, expr->len, NFTNL_EXPR_RT_DREG, dreg);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
@@ -246,9 +240,9 @@ static void netlink_gen_socket(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("socket");
-	netlink_put_register(nle, NFTNL_EXPR_SOCKET_DREG, *dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_SOCKET_KEY, expr->socket.key);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_SOCKET_LEVEL, expr->socket.level);
+	nft_expr_set_reg(ctx, nle, expr->len, NFTNL_EXPR_SOCKET_DREG, dreg);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
@@ -259,9 +253,9 @@ static void netlink_gen_osf(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("osf");
-	netlink_put_register(nle, NFTNL_EXPR_OSF_DREG, *dreg);
 	nftnl_expr_set_u8(nle, NFTNL_EXPR_OSF_TTL, expr->osf.ttl);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_OSF_FLAGS, expr->osf.flags);
+	nft_expr_set_reg(ctx, nle, expr->len, NFTNL_EXPR_OSF_DREG, dreg);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
@@ -272,10 +266,10 @@ static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("numgen");
-	netlink_put_register(nle, NFTNL_EXPR_NG_DREG, *dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_TYPE, expr->numgen.type);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_MODULUS, expr->numgen.mod);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_OFFSET, expr->numgen.offset);
+	nft_expr_set_reg_scratch(ctx, nle, expr->len, NFTNL_EXPR_NG_DREG, dreg);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
@@ -286,11 +280,12 @@ static void netlink_gen_ct(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("ct");
-	netlink_put_register(nle, NFTNL_EXPR_CT_DREG, *dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_CT_KEY, expr->ct.key);
-	if (expr->ct.direction >= 0)
+	if (expr->ct.direction >= 0) {
 		nftnl_expr_set_u8(nle, NFTNL_EXPR_CT_DIR,
 				  expr->ct.direction);
+	}
+	nft_expr_set_reg(ctx, nle, expr->len, NFTNL_EXPR_CT_DREG, dreg);
 
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
@@ -301,23 +296,16 @@ static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 {
 	struct nftnl_expr *nle;
 	enum nft_registers sreg;
-	int regspace = 0;
 
 	assert(expr->mappings->etype == EXPR_SET_REF);
 
-	if (*dreg == NFT_REG_VERDICT)
-		sreg = get_register(ctx, expr->map);
-	else
-		sreg = *dreg;
-
-	/* suppress assert in netlink_gen_expr */
-	if (expr->map->etype == EXPR_CONCAT) {
-		regspace = netlink_register_space(expr->map->len);
-		ctx->reg_low += regspace;
-	}
+	netlink_gen_expr(ctx, expr->map, dreg);
+	sreg = *dreg;
 
-	netlink_gen_expr(ctx, expr->map, &sreg);
-	ctx->reg_low -= regspace;
+	if (expr->mappings->set->data->dtype->type == TYPE_VERDICT)
+		*dreg = NFT_REG_VERDICT;
+	else
+		*dreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(expr->mappings->set->data->len, BITS_PER_BYTE));
 
 	nle = alloc_nft_expr("lookup");
 	netlink_put_register(nle, NFTNL_EXPR_LOOKUP_SREG, sreg);
@@ -327,9 +315,6 @@ static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_LOOKUP_SET_ID,
 			   expr->mappings->set->handle.set_id);
 
-	if (*dreg == NFT_REG_VERDICT)
-		release_register(ctx, expr->map);
-
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
@@ -343,7 +328,7 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 	assert(expr->right->etype == EXPR_SET_REF);
 	assert(*dreg == NFT_REG_VERDICT);
 
-	sreg = get_register(ctx, expr->left);
+	sreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(expr->left->len, BITS_PER_BYTE));
 	netlink_gen_expr(ctx, expr->left, &sreg);
 
 	nle = alloc_nft_expr("lookup");
@@ -355,7 +340,6 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 	if (expr->op == OP_NEQ)
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_LOOKUP_FLAGS, NFT_LOOKUP_F_INV);
 
-	release_register(ctx, expr->left);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
@@ -398,7 +382,7 @@ static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("bitwise");
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, *sreg);
-	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, *sreg);
+	nft_expr_set_reg_scratch(ctx, nle, expr->right->len, NFTNL_EXPR_BITWISE_DREG, sreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, nld.len);
 	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, &nld.value, nld.len);
 	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, &zero.value, zero.len);
@@ -418,7 +402,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 
 	assert(*dreg == NFT_REG_VERDICT);
 
-	sreg = get_register(ctx, expr->left);
+	sreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(expr->left->len, BITS_PER_BYTE));
 	netlink_gen_expr(ctx, expr->left, &sreg);
 
 	switch (expr->op) {
@@ -456,8 +440,6 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 		BUG("invalid range operation %u\n", expr->op);
 
 	}
-
-	release_register(ctx, expr->left);
 }
 
 static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
@@ -472,7 +454,7 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 
 	assert(*dreg == NFT_REG_VERDICT);
 
-	sreg = get_register(ctx, expr->left);
+	sreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(expr->left->len, BITS_PER_BYTE));
 	netlink_gen_expr(ctx, expr->left, &sreg);
 	len = div_round_up(expr->left->len, BITS_PER_BYTE);
 
@@ -490,7 +472,8 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 	} else {
 		nle = alloc_nft_expr("bitwise");
 		netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, sreg);
-		netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, sreg);
+		nft_expr_set_reg_scratch(ctx, nle, expr->right->len, NFTNL_EXPR_BITWISE_DREG, &sreg);
+		*dreg = sreg;
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
 		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, &nld2.value, nld2.len);
 		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, &nld.value, nld.len);
@@ -508,7 +491,6 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 	}
 
 	mpz_clear(zero);
-	release_register(ctx, expr->left);
 }
 
 static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
@@ -546,7 +528,7 @@ static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
 	case EXPR_LIST:
 		return netlink_gen_flagcmp(ctx, expr, dreg);
 	case EXPR_PREFIX:
-		sreg = get_register(ctx, expr->left);
+		sreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(expr->left->len, BITS_PER_BYTE));
 		if (expr_basetype(expr->left)->type != TYPE_STRING &&
 		    (expr->right->byteorder != BYTEORDER_BIG_ENDIAN ||
 		     !expr->right->prefix_len ||
@@ -567,7 +549,7 @@ static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
 		    expr->right->dtype->basetype->type == TYPE_BITMASK)
 			return netlink_gen_flagcmp(ctx, expr, dreg);
 
-		sreg = get_register(ctx, expr->left);
+		sreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(expr->left->len, BITS_PER_BYTE));
 		len = div_round_up(expr->right->len, BITS_PER_BYTE);
 		right = expr->right;
 		netlink_gen_expr(ctx, expr->left, &sreg);
@@ -580,7 +562,6 @@ static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
 			   netlink_gen_cmp_op(expr->op));
 	netlink_gen_data(right, &nld);
 	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, len);
-	release_register(ctx, expr->left);
 
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
@@ -608,7 +589,7 @@ static void netlink_gen_shift(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("bitwise");
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, *dreg);
-	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, *dreg);
+	nft_expr_set_reg_scratch(ctx, nle, expr->len, NFTNL_EXPR_BITWISE_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, op);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
 
@@ -674,7 +655,7 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("bitwise");
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, *dreg);
-	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, *dreg);
+	nft_expr_set_reg_scratch(ctx, nle, expr->len, NFTNL_EXPR_BITWISE_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_BOOL);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
 
@@ -736,7 +717,7 @@ static void netlink_gen_unary(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("byteorder");
 	netlink_put_register(nle, NFTNL_EXPR_BYTEORDER_SREG, *dreg);
-	netlink_put_register(nle, NFTNL_EXPR_BYTEORDER_DREG, *dreg);
+	nft_expr_set_reg_scratch(ctx, nle, expr->len, NFTNL_EXPR_BYTEORDER_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BYTEORDER_LEN,
 			   expr->len / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BYTEORDER_SIZE,
@@ -785,10 +766,10 @@ static void netlink_gen_xfrm(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("xfrm");
-	netlink_put_register(nle, NFTNL_EXPR_XFRM_DREG, *dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_XFRM_KEY, expr->xfrm.key);
 	nftnl_expr_set_u8(nle, NFTNL_EXPR_XFRM_DIR, expr->xfrm.direction);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_XFRM_SPNUM, expr->xfrm.spnum);
+	nft_expr_set_reg(ctx, nle, expr->len, NFTNL_EXPR_XFRM_DREG, dreg);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
@@ -796,8 +777,6 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 			     const struct expr *expr,
 			     enum nft_registers *dreg)
 {
-	assert(*dreg < ctx->reg_low);
-
 	switch (expr->etype) {
 	case EXPR_VERDICT:
 	case EXPR_VALUE:
@@ -852,9 +831,8 @@ static void netlink_gen_objref_stmt(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("objref");
 	switch (expr->etype) {
 	case EXPR_MAP:
-		sreg_key = get_register(ctx, expr->map);
+		sreg_key = nftnl_reg_get_scratch(ctx->regs, div_round_up(expr->map->len, BITS_PER_BYTE));
 		netlink_gen_expr(ctx, expr->map, &sreg_key);
-		release_register(ctx, expr->map);
 
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_OBJREF_SET_SREG, sreg_key);
 		nftnl_expr_set_str(nle, NFTNL_EXPR_OBJREF_SET_NAME,
@@ -977,9 +955,8 @@ static void netlink_gen_exthdr_stmt(struct netlink_linearize_ctx *ctx,
 	enum nft_registers sreg;
 	unsigned int offset;
 
-	sreg = get_register(ctx, stmt->exthdr.val);
+	sreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->exthdr.val->len, BITS_PER_BYTE));
 	netlink_gen_expr(ctx, stmt->exthdr.val, &sreg);
-	release_register(ctx, stmt->exthdr.val);
 
 	expr = stmt->exthdr.expr;
 
@@ -1005,9 +982,8 @@ static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
 	enum nft_registers sreg;
 	unsigned int csum_off;
 
-	sreg = get_register(ctx, stmt->payload.val);
+	sreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->payload.val->len, BITS_PER_BYTE));
 	netlink_gen_expr(ctx, stmt->payload.val, &sreg);
-	release_register(ctx, stmt->payload.val);
 
 	expr = stmt->payload.expr;
 
@@ -1045,9 +1021,8 @@ static void netlink_gen_meta_stmt(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 	enum nft_registers sreg;
 
-	sreg = get_register(ctx, stmt->meta.expr);
+	sreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->meta.expr->len, BITS_PER_BYTE));
 	netlink_gen_expr(ctx, stmt->meta.expr, &sreg);
-	release_register(ctx, stmt->meta.expr);
 
 	nle = alloc_nft_expr("meta");
 	netlink_put_register(nle, NFTNL_EXPR_META_SREG, sreg);
@@ -1114,13 +1089,13 @@ static unsigned int nat_addrlen(uint8_t family)
 static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
-	struct nftnl_expr *nle;
 	enum nft_registers amin_reg, amax_reg;
 	enum nft_registers pmin_reg, pmax_reg;
-	uint8_t family = 0;
-	int registers = 0;
-	int nftnl_flag_attr;
 	int nftnl_reg_pmin, nftnl_reg_pmax;
+	struct nftnl_expr *nle;
+	uint32_t reg_len = 0;
+	int nftnl_flag_attr;
+	uint8_t family = 0;
 
 	switch (stmt->nat.type) {
 	case NFT_NAT_SNAT:
@@ -1158,19 +1133,34 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u32(nle, nftnl_flag_attr, stmt->nat.flags);
 
 	if (stmt->nat.addr) {
-		amin_reg = get_register(ctx, NULL);
-		registers++;
+		if (stmt->nat.addr->etype == EXPR_RANGE)
+			reg_len += stmt->nat.addr->right->len;
+		else
+			reg_len = stmt->nat.addr->len;
+	}
+	if (stmt->nat.proto) {
+		if (stmt->nat.proto->etype == EXPR_RANGE)
+			reg_len += stmt->nat.proto->right->len;
+		else
+			reg_len += stmt->nat.proto->len;
+	}
+	reg_len = div_round_up(reg_len, BITS_PER_BYTE);
 
-		if (stmt->nat.addr->etype == EXPR_RANGE) {
-			amax_reg = get_register(ctx, NULL);
-			registers++;
+	amin_reg = nftnl_reg_get_scratch(ctx->regs, reg_len);
 
+	if (stmt->nat.addr) {
+		if (stmt->nat.addr->etype == EXPR_RANGE) {
 			netlink_gen_expr(ctx, stmt->nat.addr->left, &amin_reg);
+			amax_reg = amin_reg;
+			amax_reg += netlink_register_space(div_round_up(stmt->nat.addr->right->len,
+							   BITS_PER_BYTE));
 			netlink_gen_expr(ctx, stmt->nat.addr->right, &amax_reg);
 			netlink_put_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MIN,
 					     amin_reg);
 			netlink_put_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MAX,
 					     amax_reg);
+			amin_reg = amax_reg;
+			amin_reg += netlink_register_space(div_round_up(stmt->nat.addr->right->len, BITS_PER_BYTE));
 		} else {
 			netlink_gen_expr(ctx, stmt->nat.addr, &amin_reg);
 			netlink_put_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MIN,
@@ -1186,6 +1176,7 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 							     amin_reg);
 				}
 			}
+			amin_reg += netlink_register_space(nat_addrlen(family));
 		}
 
 		if (stmt->nat.type_flags & STMT_NAT_F_CONCAT) {
@@ -1197,9 +1188,9 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 			pmin_reg = amin_reg;
 
 			if (stmt->nat.type_flags & STMT_NAT_F_INTERVAL) {
-				pmin_reg += netlink_register_space(nat_addrlen(family));
 				netlink_put_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MAX,
 						     pmin_reg);
+				pmin_reg += netlink_register_space(nat_addrlen(family));
 			}
 
 			/* if STMT_NAT_F_CONCAT is set, the mapped type is a
@@ -1209,7 +1200,6 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 			 * the address and use the register that
 			 * will hold the inet_service part.
 			 */
-			pmin_reg += netlink_register_space(nat_addrlen(family));
 			if (stmt->nat.type_flags & STMT_NAT_F_INTERVAL)
 				netlink_put_register(nle, nftnl_reg_pmax, pmin_reg);
 			else
@@ -1217,15 +1207,12 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		}
 	}
 
+	pmin_reg = amin_reg;
 	if (stmt->nat.proto) {
-		pmin_reg = get_register(ctx, NULL);
-		registers++;
-
 		if (stmt->nat.proto->etype == EXPR_RANGE) {
-			pmax_reg = get_register(ctx, NULL);
-			registers++;
-
-			netlink_gen_expr(ctx, stmt->nat.proto->left, &pmin_reg);
+			netlink_gen_expr(ctx, stmt->nat.proto->right, &pmin_reg);
+			pmax_reg = pmin_reg;
+			pmax_reg += netlink_register_space(div_round_up(stmt->nat.proto->right->len, BITS_PER_BYTE));
 			netlink_gen_expr(ctx, stmt->nat.proto->right, &pmax_reg);
 			netlink_put_register(nle, nftnl_reg_pmin, pmin_reg);
 			netlink_put_register(nle, nftnl_reg_pmax, pmax_reg);
@@ -1235,22 +1222,17 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		}
 	}
 
-	while (registers > 0) {
-		release_register(ctx, NULL);
-		registers--;
-	}
-
 	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_tproxy_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
-	struct nftnl_expr *nle;
+	const int family = stmt->tproxy.family;
 	enum nft_registers addr_reg;
 	enum nft_registers port_reg;
-	int registers = 0;
-	const int family = stmt->tproxy.family;
+	struct nftnl_expr *nle;
+	uint32_t reg_len = 0;
 	int nftnl_reg_port;
 
 	nle = alloc_nft_expr("tproxy");
@@ -1259,26 +1241,28 @@ static void netlink_gen_tproxy_stmt(struct netlink_linearize_ctx *ctx,
 
 	nftnl_reg_port = NFTNL_EXPR_TPROXY_REG_PORT;
 
+	if (stmt->tproxy.addr)
+		reg_len = stmt->tproxy.addr->len;
+	if (stmt->nat.proto)
+		reg_len += stmt->tproxy.port->len;
+
+	reg_len = div_round_up(reg_len, BITS_PER_BYTE);
+
+	addr_reg = nftnl_reg_get_scratch(ctx->regs, reg_len);
+
 	if (stmt->tproxy.addr) {
-		addr_reg = get_register(ctx, NULL);
-		registers++;
 		netlink_gen_expr(ctx, stmt->tproxy.addr, &addr_reg);
 		netlink_put_register(nle, NFTNL_EXPR_TPROXY_REG_ADDR,
 				     addr_reg);
 	}
 
 	if (stmt->tproxy.port) {
-		port_reg = get_register(ctx, NULL);
-		registers++;
+		port_reg = addr_reg;
+		port_reg += netlink_register_space(stmt->tproxy.port->len);
 		netlink_gen_expr(ctx, stmt->tproxy.port, &port_reg);
 		netlink_put_register(nle, nftnl_reg_port, port_reg);
 	}
 
-	while (registers > 0) {
-		release_register(ctx, NULL);
-		registers--;
-	}
-
 	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
@@ -1307,23 +1291,20 @@ static void netlink_gen_dup_stmt(struct netlink_linearize_ctx *ctx,
 
 	if (stmt->dup.to != NULL) {
 		if (stmt->dup.to->dtype == &ifindex_type) {
-			sreg1 = get_register(ctx, stmt->dup.to);
+			sreg1 = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->dup.to->len, BITS_PER_BYTE));
 			netlink_gen_expr(ctx, stmt->dup.to, &sreg1);
 			netlink_put_register(nle, NFTNL_EXPR_DUP_SREG_DEV, sreg1);
 		} else {
-			sreg1 = get_register(ctx, stmt->dup.to);
+			sreg1 = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->dup.to->len, BITS_PER_BYTE));
 			netlink_gen_expr(ctx, stmt->dup.to, &sreg1);
 			netlink_put_register(nle, NFTNL_EXPR_DUP_SREG_ADDR, sreg1);
 		}
 	}
 	if (stmt->dup.dev != NULL) {
-		sreg2 = get_register(ctx, stmt->dup.dev);
+		sreg2 = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->dup.dev->len, BITS_PER_BYTE));
 		netlink_gen_expr(ctx, stmt->dup.dev, &sreg2);
 		netlink_put_register(nle, NFTNL_EXPR_DUP_SREG_DEV, sreg2);
-		release_register(ctx, stmt->dup.dev);
 	}
-	if (stmt->dup.to != NULL)
-		release_register(ctx, stmt->dup.to);
 
 	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
@@ -1336,17 +1317,15 @@ static void netlink_gen_fwd_stmt(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("fwd");
 
-	sreg1 = get_register(ctx, stmt->fwd.dev);
+	sreg1 = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->fwd.dev->len, BITS_PER_BYTE));
 	netlink_gen_expr(ctx, stmt->fwd.dev, &sreg1);
 	netlink_put_register(nle, NFTNL_EXPR_FWD_SREG_DEV, sreg1);
 
 	if (stmt->fwd.addr != NULL) {
-		sreg2 = get_register(ctx, stmt->fwd.addr);
+		sreg2 = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->fwd.addr->len, BITS_PER_BYTE));
 		netlink_gen_expr(ctx, stmt->fwd.addr, &sreg2);
 		netlink_put_register(nle, NFTNL_EXPR_FWD_SREG_ADDR, sreg2);
-		release_register(ctx, stmt->fwd.addr);
 	}
-	release_register(ctx, stmt->fwd.dev);
 
 	if (stmt->fwd.family)
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_FWD_NFPROTO,
@@ -1386,9 +1365,8 @@ static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 			range_expr_value_low(low, stmt->queue.queue);
 			range_expr_value_high(high, stmt->queue.queue);
 		} else {
-			sreg = get_register(ctx, expr);
+			sreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(expr->len, BITS_PER_BYTE));
 			netlink_gen_expr(ctx, expr, &sreg);
-			release_register(ctx, expr);
 		}
 	}
 
@@ -1419,9 +1397,8 @@ static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 	enum nft_registers sreg;
 
-	sreg = get_register(ctx, stmt->ct.expr);
+	sreg = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->ct.expr->len, BITS_PER_BYTE));
 	netlink_gen_expr(ctx, stmt->ct.expr, &sreg);
-	release_register(ctx, stmt->ct.expr);
 
 	nle = alloc_nft_expr("ct");
 	netlink_put_register(nle, NFTNL_EXPR_CT_SREG, sreg);
@@ -1462,9 +1439,8 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 	int num_stmts = 0;
 	struct stmt *this;
 
-	sreg_key = get_register(ctx, stmt->set.key->key);
+	sreg_key = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->set.key->key->len, BITS_PER_BYTE));
 	netlink_gen_expr(ctx, stmt->set.key->key, &sreg_key);
-	release_register(ctx, stmt->set.key->key);
 
 	nle = alloc_nft_expr("dynset");
 	netlink_put_register(nle, NFTNL_EXPR_DYNSET_SREG_KEY, sreg_key);
@@ -1504,15 +1480,12 @@ static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
 	int num_stmts = 0;
 	struct stmt *this;
 
-	sreg_key = get_register(ctx, stmt->map.key);
+	sreg_key = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->map.key->len, BITS_PER_BYTE));
 	netlink_gen_expr(ctx, stmt->map.key, &sreg_key);
 
-	sreg_data = get_register(ctx, stmt->map.data);
+	sreg_data = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->map.data->len, BITS_PER_BYTE));
 	netlink_gen_expr(ctx, stmt->map.data, &sreg_data);
 
-	release_register(ctx, stmt->map.key);
-	release_register(ctx, stmt->map.data);
-
 	nle = alloc_nft_expr("dynset");
 	netlink_put_register(nle, NFTNL_EXPR_DYNSET_SREG_KEY, sreg_key);
 	netlink_put_register(nle, NFTNL_EXPR_DYNSET_SREG_DATA, sreg_data);
@@ -1546,9 +1519,8 @@ static void netlink_gen_meter_stmt(struct netlink_linearize_ctx *ctx,
 	enum nft_dynset_ops op;
 	struct set *set;
 
-	sreg_key = get_register(ctx, stmt->meter.key->key);
+	sreg_key = nftnl_reg_get_scratch(ctx->regs, div_round_up(stmt->meter.key->key->len, BITS_PER_BYTE));
 	netlink_gen_expr(ctx, stmt->meter.key->key, &sreg_key);
-	release_register(ctx, stmt->meter.key->key);
 
 	set = stmt->meter.set->set;
 	if (stmt->meter.key->timeout)
@@ -1641,12 +1613,13 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 }
 
 void netlink_linearize_init(struct netlink_linearize_ctx *lctx,
+			    struct nftnl_regs *regs,
 			    struct nftnl_rule *nlr)
 {
 	int i;
 
 	memset(lctx, 0, sizeof(*lctx));
-	lctx->reg_low = NFT_REG_1;
+	lctx->regs = regs;
 	lctx->nlr = nlr;
 	lctx->expr_loc_htable =
 		xmalloc(sizeof(struct list_head) * NFT_EXPR_LOC_HSIZE);
-- 
2.30.2

