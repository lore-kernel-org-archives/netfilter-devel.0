From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: bail out when exporting ruleset with unsupported output
Date: Thu, 15 Feb 2018 17:29:25 +0100
Message-ID: <20180215162925.27574-1-pablo@netfilter.org>
Cc: mayhs11saini@gmail.com, phil@nwl.cc, anthonyryan1@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57946 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425921AbeBOQ3e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Feb 2018 11:29:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 542792519AD
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 17:29:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44E78DA3B4
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 17:29:33 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Display error message and propagate error to shell when running command
with unsupported output:

 # nft export ruleset json
 Error: this output type is not supported
 export ruleset json
 ^^^^^^^^^^^^^^^^^^^^
 # echo $?
 1

 # nft export ruleset vm json
 ... low-level VM json output
 # echo $?
 0

Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1224
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables.h |  2 ++
 src/evaluate.c     | 13 ++++++++++++-
 src/parser_bison.y |  6 ++----
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 3bfa33e5cb33..5e637e10acd3 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -127,4 +127,6 @@ int nft_print(struct output_ctx *octx, const char *fmt, ...)
 int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
 	__attribute__((format(printf, 2, 0)));
 
+#define __NFT_OUTPUT_NOTSUPP	UINT_MAX
+
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index 8107df838a90..e5ad1044fbb7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3423,10 +3423,21 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 
 static int cmd_evaluate_export(struct eval_ctx *ctx, struct cmd *cmd)
 {
+	if (cmd->markup->format == __NFT_OUTPUT_NOTSUPP)
+		return cmd_error(ctx, "this output type is not supported");
+
 	return cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
 			    ctx->debug_mask & NFT_DEBUG_NETLINK, ctx->octx);
 }
 
+static int cmd_evaluate_import(struct eval_ctx *ctx, struct cmd *cmd)
+{
+	if (cmd->markup->format == __NFT_OUTPUT_NOTSUPP)
+		return cmd_error(ctx, "this output type not supported");
+
+	return 0;
+}
+
 static const char * const cmd_op_name[] = {
 	[CMD_INVALID]	= "invalid",
 	[CMD_ADD]	= "add",
@@ -3486,7 +3497,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_MONITOR:
 		return cmd_evaluate_monitor(ctx, cmd);
 	case CMD_IMPORT:
-		return 0;
+		return cmd_evaluate_import(ctx, cmd);
 	default:
 		BUG("invalid command operation %u\n", cmd->op);
 	};
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 578bfdc10429..563411155bf4 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1198,7 +1198,6 @@ import_cmd			:       RULESET         markup_format
 				struct markup *markup = markup_alloc($1);
 				$$ = cmd_alloc(CMD_IMPORT, CMD_OBJ_MARKUP, &h, &@$, markup);
 			}
-			|	JSON		{ $$ = NULL; }
 			;
 
 export_cmd		:	RULESET		markup_format
@@ -1213,7 +1212,6 @@ export_cmd		:	RULESET		markup_format
 				struct markup *markup = markup_alloc($1);
 				$$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_MARKUP, &h, &@$, markup);
 			}
-			|	JSON		{ $$ = NULL; }
 			;
 
 monitor_cmd		:	monitor_event	monitor_object	monitor_format
@@ -1241,10 +1239,10 @@ monitor_object		:	/* empty */	{ $$ = CMD_MONITOR_OBJ_ANY; }
 
 monitor_format		:	/* empty */	{ $$ = NFTNL_OUTPUT_DEFAULT; }
 			|	markup_format
-			|	JSON		{ $$ = NFTNL_OUTPUT_JSON; }
 			;
 
-markup_format		: 	XML 		{ $$ = NFTNL_OUTPUT_XML; }
+markup_format		: 	XML 		{ $$ = __NFT_OUTPUT_NOTSUPP; }
+			|	JSON		{ $$ = __NFT_OUTPUT_NOTSUPP; }
 			|	VM JSON		{ $$ = NFTNL_OUTPUT_JSON; }
 			;
 
-- 
2.11.0

