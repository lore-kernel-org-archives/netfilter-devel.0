Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005B1C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jan 2022 00:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347259AbiALAeQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 19:34:16 -0500
Received: from mail.netfilter.org ([217.70.188.207]:47920 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347263AbiALAeP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 19:34:15 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0829564690
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jan 2022 01:31:22 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/4] src: 'nft list chain' prints anonymous chains correctly
Date:   Wed, 12 Jan 2022 01:34:01 +0100
Message-Id: <20220112003401.332999-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220112003401.332999-1-pablo@netfilter.org>
References: <20220112003401.332999-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the user is requesting a chain listing, e.g. nft list chain x y
and a rule refers to an anonymous chain that cannot be found in the cache,
then fetch such anonymous chain and its ruleset.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1577
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h                               |  3 ++
 include/netlink.h                             |  1 +
 src/cache.c                                   | 37 +++++++++++++++++++
 src/netlink_delinearize.c                     |  8 ++++
 .../testcases/cache/0010_implicit_chain_0     | 19 ++++++++++
 5 files changed, 68 insertions(+)
 create mode 100755 tests/shell/testcases/cache/0010_implicit_chain_0

diff --git a/include/cache.h b/include/cache.h
index d185f3cfeda0..b6c7d48bfba6 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -134,4 +134,7 @@ struct nft_cache {
 	uint32_t		flags;
 };
 
+void nft_chain_cache_update(struct netlink_ctx *ctx, struct table *table,
+			    const char *chain);
+
 #endif /* _NFT_CACHE_H_ */
diff --git a/include/netlink.h b/include/netlink.h
index 0e439061e380..e8e0f68ae1a4 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -39,6 +39,7 @@ struct netlink_parse_ctx {
 	struct stmt		*stmt;
 	struct expr		*registers[MAX_REGS + 1];
 	unsigned int		debug_mask;
+	struct netlink_ctx	*nlctx;
 };
 
 struct rule_pp_ctx {
diff --git a/src/cache.c b/src/cache.c
index 14957f2de3a9..630d6ae1307c 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -423,6 +423,21 @@ chain_cache_dump(struct netlink_ctx *ctx,
 	return chain_list;
 }
 
+void nft_chain_cache_update(struct netlink_ctx *ctx, struct table *table,
+			    const char *chain)
+{
+	struct nftnl_chain_list *chain_list;
+
+	chain_list = mnl_nft_chain_dump(ctx, table->handle.family,
+					table->handle.table.name, chain);
+	if (!chain_list)
+		return;
+
+	chain_cache_init(ctx, table, chain_list);
+
+	nftnl_chain_list_free(chain_list);
+}
+
 void chain_cache_add(struct chain *chain, struct table *table)
 {
 	uint32_t hash;
@@ -834,6 +849,22 @@ static int rule_init_cache(struct netlink_ctx *ctx, struct table *table,
 	return ret;
 }
 
+static int implicit_chain_cache(struct netlink_ctx *ctx, struct table *table,
+				const char *chain_name)
+{
+	struct nft_cache_filter filter;
+	struct chain *chain;
+	int ret = 0;
+
+	list_for_each_entry(chain, &table->chain_bindings, cache.list) {
+		filter.list.table = table->handle.table.name;
+		filter.list.chain = chain->handle.chain.name;
+		ret = rule_init_cache(ctx, table, &filter);
+	}
+
+	return ret;
+}
+
 static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 			      const struct nft_cache_filter *filter)
 {
@@ -926,6 +957,12 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 			ret = rule_init_cache(ctx, table, filter);
 			if (ret < 0)
 				goto cache_fails;
+
+			if (filter && filter->list.table && filter->list.chain) {
+				ret = implicit_chain_cache(ctx, table, filter->list.chain);
+				if (ret < 0)
+					goto cache_fails;
+			}
 		}
 	}
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 323e9150cdf6..0ea89135cc9a 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -218,6 +218,13 @@ static void netlink_parse_chain_verdict(struct netlink_parse_ctx *ctx,
 
 	expr_chain_export(expr->chain, chain_name);
 	chain = chain_binding_lookup(ctx->table, chain_name);
+
+	/* Special case: 'nft list chain x y' needs to pull in implicit chains */
+	if (!chain && !strncmp(chain_name, "__chain", strlen("__chain"))) {
+		nft_chain_cache_update(ctx->nlctx, ctx->table, chain_name);
+		chain = chain_binding_lookup(ctx->table, chain_name);
+	}
+
 	if (chain) {
 		ctx->stmt = chain_stmt_alloc(loc, chain, verdict);
 		expr_free(expr);
@@ -3141,6 +3148,7 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	memset(&_ctx, 0, sizeof(_ctx));
 	_ctx.msgs = ctx->msgs;
 	_ctx.debug_mask = ctx->nft->debug_mask;
+	_ctx.nlctx = ctx;
 
 	memset(&h, 0, sizeof(h));
 	h.family = nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY);
diff --git a/tests/shell/testcases/cache/0010_implicit_chain_0 b/tests/shell/testcases/cache/0010_implicit_chain_0
new file mode 100755
index 000000000000..0ab0db957cf2
--- /dev/null
+++ b/tests/shell/testcases/cache/0010_implicit_chain_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="table ip f {
+	chain c {
+		jump {
+			accept
+		}
+	}
+}"
+
+$NFT 'table ip f { chain c { jump { accept; }; }; }'
+GET="$($NFT list chain ip f c)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
-- 
2.30.2

