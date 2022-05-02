Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DCAC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 May 2022 14:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238193AbiEBOqK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 May 2022 10:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbiEBOqK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 May 2022 10:46:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D625ADCA
        for <netfilter-devel@vger.kernel.org>; Mon,  2 May 2022 07:42:39 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl,v2] src: add dynamic register allocation infrastructure
Date:   Mon,  2 May 2022 16:42:16 +0200
Message-Id: <20220502144216.137780-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Starting Linux kernel 5.18-rc, operations on registers that already
contain the expected data are turned into noop.

Track operation on registers to use the same register through
nftnl_reg_get(). This patch introduces an LRU eviction strategy when all
the registers are in used.

nftnl_reg_get_scratch() is used to allocate a register as scratchpad
area: no tracking is performed in this case, although register eviction
might occur.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix buggy register cancel logic.

 include/expr_ops.h           |   6 +
 include/internal.h           |   1 +
 include/libnftnl/Makefile.am |   1 +
 include/regs.h               |  32 +++++
 src/Makefile.am              |   1 +
 src/expr/meta.c              |  44 +++++++
 src/expr/payload.c           |  31 +++++
 src/libnftnl.map             |   7 ++
 src/regs.c                   | 226 +++++++++++++++++++++++++++++++++++
 9 files changed, 349 insertions(+)
 create mode 100644 include/regs.h
 create mode 100644 src/regs.c

diff --git a/include/expr_ops.h b/include/expr_ops.h
index 7a6aa23f9bd1..01f6fefd6f3a 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -7,6 +7,7 @@
 struct nlattr;
 struct nlmsghdr;
 struct nftnl_expr;
+struct nftnl_reg;
 
 struct expr_ops {
 	const char *name;
@@ -19,6 +20,11 @@ struct expr_ops {
 	int 	(*parse)(struct nftnl_expr *e, struct nlattr *attr);
 	void	(*build)(struct nlmsghdr *nlh, const struct nftnl_expr *e);
 	int	(*snprintf)(char *buf, size_t len, uint32_t flags, const struct nftnl_expr *e);
+	struct {
+		int	(*len)(const struct nftnl_expr *e);
+		bool	(*cmp)(const struct nftnl_reg *reg, const struct nftnl_expr *e);
+		void	(*update)(struct nftnl_reg *reg, const struct nftnl_expr *e);
+	} reg;
 };
 
 struct expr_ops *nftnl_expr_ops_lookup(const char *name);
diff --git a/include/internal.h b/include/internal.h
index 1f96731589c0..9f88828f9039 100644
--- a/include/internal.h
+++ b/include/internal.h
@@ -12,5 +12,6 @@
 #include "expr.h"
 #include "expr_ops.h"
 #include "rule.h"
+#include "regs.h"
 
 #endif /* _LIBNFTNL_INTERNAL_H_ */
diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile.am
index d846a574f438..186f758ab97e 100644
--- a/include/libnftnl/Makefile.am
+++ b/include/libnftnl/Makefile.am
@@ -3,6 +3,7 @@ pkginclude_HEADERS = batch.h		\
 		     trace.h		\
 		     chain.h		\
 		     object.h		\
+		     regs.h		\
 		     rule.h		\
 		     expr.h		\
 		     set.h		\
diff --git a/include/regs.h b/include/regs.h
new file mode 100644
index 000000000000..5312f607f692
--- /dev/null
+++ b/include/regs.h
@@ -0,0 +1,32 @@
+#ifndef _LIBNFTNL_REGS_INTERNAL_H_
+#define _LIBNFTNL_REGS_INTERNAL_H_
+
+enum nftnl_expr_type {
+	NFT_EXPR_UNSPEC	= 0,
+	NFT_EXPR_PAYLOAD,
+	NFT_EXPR_META,
+};
+
+struct nftnl_reg {
+	enum nftnl_expr_type				type;
+	uint32_t					len;
+	uint64_t					genid;
+	uint8_t						word;
+	union {
+		struct {
+			enum nft_meta_keys		key;
+		} meta;
+		struct {
+			enum nft_payload_bases		base;
+			uint32_t			offset;
+		} payload;
+	};
+};
+
+struct nftnl_regs {
+	uint32_t		num_regs;
+	struct nftnl_reg	*reg;
+	uint64_t		genid;
+};
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index c3b0ab974bd2..2a26d24ce3e3 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -14,6 +14,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      trace.c		\
 		      chain.c		\
 		      object.c		\
+		      regs.c		\
 		      rule.c		\
 		      set.c		\
 		      set_elem.c	\
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 34fbb9bb63c0..601248f3a710 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -14,6 +14,7 @@
 #include <string.h>
 #include <arpa/inet.h>
 #include <errno.h>
+#include <net/if.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include "internal.h"
@@ -132,6 +133,44 @@ nftnl_expr_meta_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
+static int nftnl_meta_reg_len(const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_meta *meta = nftnl_expr_data(e);
+
+	switch (meta->key) {
+	case NFT_META_IIFNAME:
+	case NFT_META_OIFNAME:
+	case NFT_META_IIFKIND:
+	case NFT_META_OIFKIND:
+	case NFT_META_SDIFNAME:
+	case NFT_META_BRI_IIFNAME:
+	case NFT_META_BRI_OIFNAME:
+		return IFNAMSIZ;
+	case NFT_META_TIME_NS:
+		return sizeof(uint64_t);
+	default:
+		break;
+	}
+
+	return sizeof(uint32_t);
+}
+
+static bool nftnl_meta_reg_cmp(const struct nftnl_reg *reg,
+			       const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_meta *meta = nftnl_expr_data(e);
+
+	return reg->meta.key == meta->key;
+}
+
+static void nftnl_meta_reg_update(struct nftnl_reg *reg,
+				  const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_meta *meta = nftnl_expr_data(e);
+
+	reg->meta.key = meta->key;
+}
+
 static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_LEN]		= "len",
 	[NFT_META_PROTOCOL]	= "protocol",
@@ -217,4 +256,9 @@ struct expr_ops expr_ops_meta = {
 	.parse		= nftnl_expr_meta_parse,
 	.build		= nftnl_expr_meta_build,
 	.snprintf	= nftnl_expr_meta_snprintf,
+	.reg		= {
+		.len	= nftnl_meta_reg_len,
+		.cmp	= nftnl_meta_reg_cmp,
+		.update	= nftnl_meta_reg_update,
+	},
 };
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 82747ec8994f..8b41a9d06a26 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -203,6 +203,32 @@ nftnl_expr_payload_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
+static int nftnl_payload_reg_len(const struct nftnl_expr *expr)
+{
+	const struct nftnl_expr_payload *payload = nftnl_expr_data(expr);
+
+	return payload->len;
+}
+
+static bool nftnl_payload_reg_cmp(const struct nftnl_reg *reg,
+				  const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_payload *payload = nftnl_expr_data(e);
+
+	return reg->payload.base == payload->base &&
+	       reg->payload.offset == payload->offset &&
+	       reg->len >= payload->len;
+}
+
+static void nftnl_payload_reg_update(struct nftnl_reg *reg,
+				     const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_payload *payload = nftnl_expr_data(e);
+
+	reg->payload.base = payload->base;
+	reg->payload.offset = payload->offset;
+}
+
 static const char *base2str_array[NFT_PAYLOAD_INNER_HEADER + 1] = {
 	[NFT_PAYLOAD_LL_HEADER]		= "link",
 	[NFT_PAYLOAD_NETWORK_HEADER] 	= "network",
@@ -260,4 +286,9 @@ struct expr_ops expr_ops_payload = {
 	.parse		= nftnl_expr_payload_parse,
 	.build		= nftnl_expr_payload_build,
 	.snprintf	= nftnl_expr_payload_snprintf,
+	.reg		= {
+		.len	= nftnl_payload_reg_len,
+		.cmp	= nftnl_payload_reg_cmp,
+		.update	= nftnl_payload_reg_update,
+	},
 };
diff --git a/src/libnftnl.map b/src/libnftnl.map
index ad8f2af060ae..3a85325216aa 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -387,3 +387,10 @@ LIBNFTNL_16 {
 LIBNFTNL_17 {
   nftnl_set_elem_nlmsg_build;
 } LIBNFTNL_16;
+
+LIBNFTNL_18 {
+  nftnl_regs_alloc;
+  nftnl_regs_free;
+  nftnl_reg_get;
+  nftnl_reg_get_scratch;
+} LIBNFTNL_17;
diff --git a/src/regs.c b/src/regs.c
new file mode 100644
index 000000000000..544ff816c4c0
--- /dev/null
+++ b/src/regs.c
@@ -0,0 +1,226 @@
+/*
+ * (C) 2012-2022 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Funded through the NGI0 PET Fund established by NLnet (https://nlnet.nl)
+ * with support from the European Commission's Next Generation Internet
+ * programme.
+ */
+
+#include <string.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <assert.h>
+
+#include <libnftnl/regs.h>
+
+#include "internal.h"
+
+EXPORT_SYMBOL(nftnl_regs_alloc);
+struct nftnl_regs *nftnl_regs_alloc(uint32_t num_regs)
+{
+	struct nftnl_regs *regs;
+
+	if (num_regs < 16)
+		num_regs = 16;
+
+	regs = calloc(1, sizeof(struct nftnl_regs));
+	if (!regs)
+		return NULL;
+
+	regs->reg = calloc(num_regs, sizeof(struct nftnl_reg));
+	if (!regs->reg) {
+		free(regs->reg);
+		return NULL;
+	}
+
+	regs->num_regs = num_regs;
+
+	return regs;
+}
+
+EXPORT_SYMBOL(nftnl_regs_free);
+void nftnl_regs_free(const struct nftnl_regs *regs)
+{
+	xfree(regs->reg);
+	xfree(regs);
+}
+
+static enum nftnl_expr_type nftnl_expr_type(const struct nftnl_expr *expr)
+{
+	if (!strcmp(expr->ops->name, "meta"))
+		return NFT_EXPR_META;
+	else if (!strcmp(expr->ops->name, "payload"))
+		return NFT_EXPR_PAYLOAD;
+
+	assert(0);
+	return NFT_EXPR_UNSPEC;
+}
+
+static int nftnl_expr_reg_len(const struct nftnl_expr *expr)
+{
+	return expr->ops->reg.len(expr);
+}
+
+static bool nftnl_expr_reg_cmp(const struct nftnl_regs *regs,
+			       const struct nftnl_expr *expr, int i)
+{
+	if (regs->reg[i].type != nftnl_expr_type(expr))
+		return false;
+
+	return expr->ops->reg.cmp(&regs->reg[i], expr);
+}
+
+static void nft_expr_reg_update(struct nftnl_regs *regs,
+				const struct nftnl_expr *expr, int i)
+{
+	return expr->ops->reg.update(&regs->reg[i], expr);
+}
+
+
+static int reg_space(int i)
+{
+	return sizeof(uint32_t) * 16 - sizeof(uint32_t) * i;
+}
+
+struct nftnl_reg_ctx {
+	uint64_t	genid;
+	int		reg;
+	int		evict;
+};
+
+static void register_track(struct nftnl_reg_ctx *ctx,
+			   const struct nftnl_regs *regs, int i, int len)
+{
+	if (ctx->reg >= 0 || regs->reg[i].word || reg_space(i) < len)
+		return;
+
+	if (regs->reg[i].type == NFT_EXPR_UNSPEC) {
+		ctx->genid = regs->genid;
+		ctx->reg = i;
+	} else if (regs->reg[i].genid < ctx->genid) {
+		ctx->genid = regs->reg[i].genid;
+		ctx->evict = i;
+	}
+}
+
+static void register_evict(struct nftnl_reg_ctx *ctx)
+{
+	if (ctx->reg < 0) {
+		assert(ctx->evict >= 0);
+		ctx->reg = ctx->evict;
+	}
+}
+
+static void __register_update(struct nftnl_regs *regs, uint8_t reg,
+			      int type, uint32_t len, uint8_t word,
+			      uint64_t genid, const struct nftnl_expr *expr)
+{
+	regs->reg[reg].type = type;
+	regs->reg[reg].genid = genid;
+	regs->reg[reg].len = len;
+	regs->reg[reg].word = word;
+	nft_expr_reg_update(regs, expr, reg);
+}
+
+static void __register_cancel(struct nftnl_regs *regs, int i)
+{
+	regs->reg[i].type = NFT_EXPR_UNSPEC;
+	regs->reg[i].word = 0;
+	regs->reg[i].len = 0;
+	regs->reg[i].genid = 0;
+}
+
+static void register_cancel(struct nftnl_reg_ctx *ctx, struct nftnl_regs *regs,
+			    int len)
+{
+	int i;
+
+	for (i = ctx->reg; len > 0; i++, len -= sizeof(uint32_t)) {
+		if (regs->reg[i].type == NFT_EXPR_UNSPEC)
+			continue;
+
+		__register_cancel(regs, i);
+	}
+
+	while (regs->reg[i].word != 0) {
+		__register_cancel(regs, i);
+		i++;
+	}
+}
+
+static void register_update(struct nftnl_reg_ctx *ctx, struct nftnl_regs *regs,
+			    int type, uint32_t len, uint64_t genid,
+			    const struct nftnl_expr *expr)
+{
+	register_cancel(ctx, regs, len);
+	__register_update(regs, ctx->reg, type, len, 0, genid, expr);
+}
+
+static uint64_t reg_genid(struct nftnl_regs *regs)
+{
+	return ++regs->genid;
+}
+
+EXPORT_SYMBOL(nftnl_reg_get);
+uint32_t nftnl_reg_get(struct nftnl_regs *regs, const struct nftnl_expr *expr)
+{
+	struct nftnl_reg_ctx ctx = {
+		.reg	= -1,
+		.evict	= -1,
+		.genid	= UINT64_MAX,
+	};
+	enum nftnl_expr_type type;
+	uint64_t genid;
+	int i, j, len;
+
+	type = nftnl_expr_type(expr);
+	len = nftnl_expr_reg_len(expr);
+
+	for (i = 0; i < 16; i++) {
+		register_track(&ctx, regs, i, len);
+
+		if (!nftnl_expr_reg_cmp(regs, expr, i))
+			continue;
+
+		regs->reg[i].genid = reg_genid(regs);
+		return i + NFT_REG32_00;
+	}
+
+	register_evict(&ctx);
+	genid = reg_genid(regs);
+	register_update(&ctx, regs, type, len, genid, expr);
+
+	len -= sizeof(uint32_t);
+	j = 1;
+	for (i = ctx.reg + 1; len > 0; i++, len -= sizeof(uint32_t))
+		__register_update(regs, i, type, len, j++, genid, expr);
+
+	return ctx.reg + NFT_REG32_00;
+}
+
+EXPORT_SYMBOL(nftnl_reg_get_scratch);
+uint32_t nftnl_reg_get_scratch(struct nftnl_regs *regs, uint32_t len)
+{
+	struct nftnl_reg_ctx ctx = {
+		.reg	= -1,
+		.evict	= -1,
+		.genid	= UINT64_MAX,
+	};
+	int i;
+
+	for (i = 0; i < 16; i++)
+		register_track(&ctx, regs, i, len);
+
+	register_evict(&ctx);
+	register_cancel(&ctx, regs, len);
+
+	return ctx.reg + NFT_REG32_00;
+}
-- 
2.30.2

