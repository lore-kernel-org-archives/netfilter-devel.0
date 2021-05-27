Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EB3C4707F
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 15:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D58AD61008
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 15:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbhE0PpO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 11:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbhE0PpL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 11:45:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE25C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2021 08:43:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lmIAa-0003O9-5x; Thu, 27 May 2021 17:43:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/6] src: allow to turn off dependency removal
Date:   Thu, 27 May 2021 17:43:19 +0200
Message-Id: <20210527154323.4003-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210527154323.4003-1-fw@strlen.de>
References: <20210527154323.4003-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to list a table without dependency removal:

nft -O no-remove-dependencies list ruleset
table inet filter {
        chain ssh {
                type filter hook input priority filter; policy accept;
                meta l4proto tcp tcp dport 22 accept
        }
}

The dependency "meta l4proto tcp" is retained.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/nftables.h        |  9 +++++
 include/proto.h           |  4 +++
 src/libnftables.c         |  1 +
 src/main.c                | 69 +++++++++++++++++++++++++++++++++++++++
 src/netlink_delinearize.c | 16 +++++++--
 5 files changed, 96 insertions(+), 3 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index f239fcf0e1f4..bbf287e68a4c 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -108,6 +108,7 @@ struct nft_ctx {
 	unsigned int		num_include_paths;
 	unsigned int		parser_max_errors;
 	unsigned int		debug_mask;
+	unsigned int		optimization_flags;
 	struct output_ctx	output;
 	bool			check;
 	struct nft_cache	cache;
@@ -213,4 +214,12 @@ int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
 
 #define __NFT_OUTPUT_NOTSUPP	UINT_MAX
 
+/* XXX: exposing this in libnftables limits public API
+ * to 32 optimization flags.
+ */
+enum nft_optimization_flags {
+	NFT_OPTIMIZATION_F_REMOVE_DEPS = 1 << 0,
+};
+#define DEFAULT_OPTIMIZATION_FLAGS NFT_OPTIMIZATION_F_REMOVE_DEPS
+
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/include/proto.h b/include/proto.h
index 001b6f9436f7..019e12e1899d 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -168,6 +168,10 @@ extern const struct proto_desc *proto_dev_desc(uint16_t type);
 
 #define PROTO_CTX_NUM_PROTOS	16
 
+enum proto_ctx_flags {
+	PROTO_F_REMOVE_DEPS = 1 << 0,
+};
+
 /**
  * struct proto_ctx - protocol context
  *
diff --git a/src/libnftables.c b/src/libnftables.c
index e080eb032770..a1f822cbe2e6 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -166,6 +166,7 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 
 	ctx->state = xzalloc(sizeof(struct parser_state));
 	nft_ctx_add_include_path(ctx, DEFAULT_INCLUDE_PATH);
+	ctx->optimization_flags = DEFAULT_OPTIMIZATION_FLAGS;
 	ctx->parser_max_errors	= 10;
 	cache_init(&ctx->cache.table_cache);
 	ctx->top_scope = scope_alloc();
diff --git a/src/main.c b/src/main.c
index 8c47064459ec..6e14a7f26b0f 100644
--- a/src/main.c
+++ b/src/main.c
@@ -19,6 +19,7 @@
 #include <sys/types.h>
 
 #include <nftables/libnftables.h>
+#include <nftables.h>
 #include <utils.h>
 #include <cli.h>
 
@@ -34,6 +35,7 @@ enum opt_indices {
 #define IDX_RULESET_INPUT_START	IDX_FILE
 	IDX_INTERACTIVE,
         IDX_INCLUDEPATH,
+	IDX_OPTIMIZE,
 	IDX_CHECK,
 #define IDX_RULESET_INPUT_END	IDX_CHECK
         /* Ruleset list formatting */
@@ -78,9 +80,15 @@ enum opt_vals {
 	OPT_NUMERIC_PROTO	= 'p',
 	OPT_NUMERIC_TIME	= 'T',
 	OPT_TERSE		= 't',
+	OPT_OPTIMIZE		= 'O',
 	OPT_INVALID		= '?',
 };
 
+enum optimization_feature {
+	OPTIMIZE_UNDEFINED,
+	OPTIMIZE_REMOVE_DEPENDENCIES,
+};
+
 struct nft_opt {
 	const char    *name;
 	enum opt_vals  val;
@@ -104,6 +112,8 @@ static const struct nft_opt nft_options[] = {
 				     "Read input from interactive CLI"),
 	[IDX_INCLUDEPATH]   = NFT_OPT("includepath",		OPT_INCLUDEPATH,	"<directory>",
 				     "Add <directory> to the paths searched for include files. Default is: " DEFAULT_INCLUDE_PATH),
+	[IDX_OPTIMIZE]	    = NFT_OPT("optimize",		OPT_OPTIMIZE,		"<name [,name..]>",
+				     "Specify optimization options"),
 	[IDX_CHECK]	    = NFT_OPT("check",			OPT_CHECK,		NULL,
 				     "Check commands validity without actually applying the changes."),
 	[IDX_HANDLE]	    = NFT_OPT("handle",			OPT_HANDLE_OUTPUT,	NULL,
@@ -303,6 +313,18 @@ static const struct {
 	},
 };
 
+static const struct {
+	const char		*name;
+	enum optimization_feature level;
+	enum nft_optimization_flags flag;
+} optimization_param[] = {
+	{
+		.name	= "remove-dependencies",
+		.level	= OPTIMIZE_REMOVE_DEPENDENCIES,
+		.flag	= NFT_OPTIMIZATION_F_REMOVE_DEPS,
+	},
+};
+
 static void nft_options_error(int argc, char * const argv[], int pos)
 {
 	int i;
@@ -331,9 +353,11 @@ static bool nft_options_check(int argc, char * const argv[])
 				return false;
 			} else if (argv[i][1] == 'd' ||
 				   argv[i][1] == 'I' ||
+				   argv[i][1] == 'O' ||
 				   argv[i][1] == 'f' ||
 				   !strcmp(argv[i], "--debug") ||
 				   !strcmp(argv[i], "--includepath") ||
+				   !strcmp(argv[i], "--optimize") ||
 				   !strcmp(argv[i], "--file")) {
 				skip = true;
 				continue;
@@ -346,6 +370,48 @@ static bool nft_options_check(int argc, char * const argv[])
 	return true;
 }
 
+static void optimize_settings_set_custom(struct nft_ctx *ctx, char *options)
+{
+	unsigned int i;
+	char *end;
+
+	do {
+		enum optimization_feature level = OPTIMIZE_UNDEFINED;
+		unsigned int flag = 0;
+		bool enable = true;
+
+		end = strchr(options, ',');
+		if (end)
+			*end = '\0';
+
+		if (strncmp(options, "no-", 3) == 0) {
+			options += 3;
+			enable = false;
+		}
+
+		for (i = 0; i < array_size(optimization_param); i++) {
+			if (strcmp(optimization_param[i].name, options))
+				continue;
+
+			level = optimization_param[i].level;
+			flag = optimization_param[i].flag;
+			break;
+		}
+
+		switch (level) {
+		case OPTIMIZE_UNDEFINED:
+			fprintf(stderr, "invalid optimization option `%s'\n", options);
+			exit(EXIT_FAILURE);
+		case OPTIMIZE_REMOVE_DEPENDENCIES:
+			break;
+		}
+		if (enable)
+			ctx->optimization_flags |= flag;
+		else
+			ctx->optimization_flags &= ~flag;
+	} while (end != NULL);
+}
+
 int main(int argc, char * const *argv)
 {
 	const struct option *options = get_options();
@@ -465,6 +531,9 @@ int main(int argc, char * const *argv)
 		case OPT_TERSE:
 			output_flags |= NFT_CTX_OUTPUT_TERSE;
 			break;
+		case OPT_OPTIMIZE:
+			optimize_settings_set_custom(nft, optarg);
+			break;
 		case OPT_INVALID:
 			exit(EXIT_FAILURE);
 		}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 6e907e95dbf1..9cd582211e78 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1847,6 +1847,9 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		assert(left->payload.base);
 		assert(base == left->payload.base);
 
+		if ((ctx->pctx.options & PROTO_F_REMOVE_DEPS) == 0)
+			continue;
+
 		stacked = payload_is_stacked(ctx->pctx.protocol[base].desc, nexpr);
 
 		/* Remember the first payload protocol expression to
@@ -1985,6 +1988,9 @@ static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
 
 		relational_expr_pctx_update(&ctx->pctx, expr);
 
+		if ((ctx->pctx.options & PROTO_F_REMOVE_DEPS) == 0)
+			break;
+
 		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
 		    left->flags & EXPR_F_PROTOCOL) {
 			payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
@@ -2814,13 +2820,14 @@ rule_maybe_reset_payload_deps(struct payload_dep_ctx *pdctx, enum stmt_types t)
 	payload_dependency_reset(pdctx);
 }
 
-static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *rule)
+static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *rule,
+				   unsigned int options)
 {
 	struct rule_pp_ctx rctx;
 	struct stmt *stmt, *next;
 
 	memset(&rctx, 0, sizeof(rctx));
-	proto_ctx_init(&rctx.pctx, rule->handle.family, ctx->debug_mask, 0);
+	proto_ctx_init(&rctx.pctx, rule->handle.family, ctx->debug_mask, options);
 
 	list_for_each_entry_safe(stmt, next, &rule->stmts, list) {
 		enum stmt_types type = stmt->ops->type;
@@ -2947,11 +2954,14 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 				      struct nftnl_rule *nlr)
 {
 	struct netlink_parse_ctx _ctx, *pctx = &_ctx;
+	unsigned int proto_options = 0;
 	struct handle h;
 
 	memset(&_ctx, 0, sizeof(_ctx));
 	_ctx.msgs = ctx->msgs;
 	_ctx.debug_mask = ctx->nft->debug_mask;
+	if (ctx->nft->optimization_flags & NFT_OPTIMIZATION_F_REMOVE_DEPS)
+		proto_options |= PROTO_F_REMOVE_DEPS;
 
 	memset(&h, 0, sizeof(h));
 	h.family = nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY);
@@ -2971,7 +2981,7 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 
 	nftnl_expr_foreach(nlr, netlink_parse_rule_expr, pctx);
 
-	rule_parse_postprocess(pctx, pctx->rule);
+	rule_parse_postprocess(pctx, pctx->rule, proto_options);
 	netlink_release_registers(pctx);
 	return pctx->rule;
 }
-- 
2.26.3

