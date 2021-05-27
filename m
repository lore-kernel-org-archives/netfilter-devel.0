Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8092EC47089
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 15:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63215613BF
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 15:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbhE0Pp3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 11:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbhE0PpT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 11:45:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15434C061760
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2021 08:43:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lmIAi-0003Oi-Gb; Thu, 27 May 2021 17:43:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/6] evaluate: optionally kill anon sets with one element
Date:   Thu, 27 May 2021 17:43:21 +0200
Message-Id: <20210527154323.4003-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210527154323.4003-1-fw@strlen.de>
References: <20210527154323.4003-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new optimization option, disabled by default, that auto-replaces
lookups in single-element anon sets with a standard compare.

'add rule foo bar meta iif { "lo" }' gets replaced with
'add rule foo bar meta iif "lo"'.

The former is a set lookup, the latter is a comparision.
Comparisions is slightly faster in this special case.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/nftables.h |  3 +++
 include/rule.h     |  6 ++++++
 src/evaluate.c     | 22 ++++++++++++++++++++--
 src/libnftables.c  |  9 +++++++++
 src/main.c         |  8 ++++++++
 5 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index bbf287e68a4c..23b7fea53f42 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -216,9 +216,12 @@ int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
 
 /* XXX: exposing this in libnftables limits public API
  * to 32 optimization flags.
+ *
+ * For now this is internal to nft.
  */
 enum nft_optimization_flags {
 	NFT_OPTIMIZATION_F_REMOVE_DEPS = 1 << 0,
+	NFT_OPTIMIZATION_F_REPLACE_SINGLE_ELEM_ANON_SETS = 1 << 1,
 };
 #define DEFAULT_OPTIMIZATION_FLAGS NFT_OPTIMIZATION_F_REMOVE_DEPS
 
diff --git a/include/rule.h b/include/rule.h
index f469db55bf60..ae23467187ff 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -735,6 +735,10 @@ void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc);
 #include <payload.h>
 #include <expression.h>
 
+enum eval_ctx_flags {
+	EVAL_F_REPLACE_SINGLE_ELEM_ANON_SETS = 1 << 0,
+};
+
 /**
  * struct eval_ctx - evaluation context
  *
@@ -749,6 +753,7 @@ void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc);
  * @debug_mask: debugging bitmask
  * @ectx:	expression context
  * @pctx:	payload context
+ * @eval_flags: enum eval_ctx_flags
  */
 struct eval_ctx {
 	struct nft_ctx		*nft;
@@ -760,6 +765,7 @@ struct eval_ctx {
 	struct stmt		*stmt;
 	struct expr_ctx		ectx;
 	struct proto_ctx	pctx;
+	unsigned int		eval_flags;
 };
 
 extern int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd);
diff --git a/src/evaluate.c b/src/evaluate.c
index 6bfc464e677a..088742bfe6b4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1455,8 +1455,26 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 		}
 	}
 
-	if (ctx->set && (ctx->set->flags & NFT_SET_CONCAT))
-		set->set_flags |= NFT_SET_CONCAT;
+	if (ctx->set) {
+		if (ctx->set->flags & NFT_SET_CONCAT)
+			set->set_flags |= NFT_SET_CONCAT;
+	} else if ((ctx->eval_flags & EVAL_F_REPLACE_SINGLE_ELEM_ANON_SETS) &&
+		   set->size == 1) {
+		i = list_first_entry(&set->expressions, struct expr, list);
+		if (i->etype == EXPR_SET_ELEM) {
+			switch (i->key->etype) {
+			case EXPR_PREFIX:
+			case EXPR_RANGE:
+			case EXPR_VALUE:
+				*expr = i->key;
+				i->key = NULL;
+				expr_free(set);
+				return 0;
+			default:
+				break;
+			}
+		}
+	}
 
 	set->set_flags |= NFT_SET_CONSTANT;
 
diff --git a/src/libnftables.c b/src/libnftables.c
index a1f822cbe2e6..0c17007bac4e 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -412,6 +412,12 @@ static int nft_parse_bison_filename(struct nft_ctx *nft, const char *filename,
 	return 0;
 }
 
+static void eval_ctx_set_flags(struct eval_ctx *ectx, const struct nft_ctx *nft)
+{
+	if (nft->optimization_flags & NFT_OPTIMIZATION_F_REPLACE_SINGLE_ELEM_ANON_SETS)
+		ectx->eval_flags |= EVAL_F_REPLACE_SINGLE_ELEM_ANON_SETS;
+}
+
 static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 			struct list_head *cmds)
 {
@@ -427,6 +433,9 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 			.nft	= nft,
 			.msgs	= msgs,
 		};
+
+		eval_ctx_set_flags(&ectx, nft);
+
 		if (cmd_evaluate(&ectx, cmd) < 0 &&
 		    ++nft->state->nerrs == nft->parser_max_errors)
 			return -1;
diff --git a/src/main.c b/src/main.c
index cf00f27f06de..858218c79989 100644
--- a/src/main.c
+++ b/src/main.c
@@ -88,6 +88,7 @@ enum optimization_feature {
 	OPTIMIZE_UNDEFINED,
 	OPTIMIZE_HELP,
 	OPTIMIZE_REMOVE_DEPENDENCIES,
+	OPTIMIZE_REMOVE_SINGLE_ELEM_ANON_SET,
 };
 
 struct nft_opt {
@@ -331,6 +332,12 @@ static const struct {
 		.level	= OPTIMIZE_REMOVE_DEPENDENCIES,
 		.flag	= NFT_OPTIMIZATION_F_REMOVE_DEPS,
 	},
+	{
+		.name	= "replace-single-anon-sets",
+		.help	= "replace anonymous sets with one element with single compare",
+		.level	= OPTIMIZE_REMOVE_SINGLE_ELEM_ANON_SET,
+		.flag	= NFT_OPTIMIZATION_F_REPLACE_SINGLE_ELEM_ANON_SETS,
+	},
 };
 
 static void nft_options_error(int argc, char * const argv[], int pos)
@@ -426,6 +433,7 @@ static void optimize_settings_set_custom(struct nft_ctx *ctx, char *options)
 			printf("\nPrepend \"no-\" to disable options that are enabled by default.\n");
 			exit(EXIT_SUCCESS);
 		case OPTIMIZE_REMOVE_DEPENDENCIES:
+		case OPTIMIZE_REMOVE_SINGLE_ELEM_ANON_SET:
 			break;
 		}
 		if (enable)
-- 
2.26.3

