Return-Path: <SRS0=2TpG=4X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2C9C10DCE
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 15:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 369832073B
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 15:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCFPWU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 10:22:20 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:35700 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgCFPWU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 10:22:20 -0500
Received: from localhost ([::1]:48790 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jAEnq-0001N2-TB; Fri, 06 Mar 2020 16:22:18 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Eric Garver <e@erig.me>, netfilter-devel@vger.kernel.org
Subject: [nft PATCH] parser_json: Support ranges in concat expressions
Date:   Fri,  6 Mar 2020 16:22:10 +0100
Message-Id: <20200306152210.14971-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duplicate commit 8ac2f3b2fca38's changes to bison parser into JSON
parser by introducing a new context flag signalling we're parsing
concatenated expressions.

Fixes: 8ac2f3b2fca38 ("src: Add support for concatenated set ranges")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 85082ccee7ef6..67d59458b95fe 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -40,6 +40,7 @@
 #define CTX_F_MANGLE	(1 << 5)
 #define CTX_F_SES	(1 << 6)	/* set_elem_expr_stmt */
 #define CTX_F_MAP	(1 << 7)	/* LHS of map_expr */
+#define CTX_F_CONCAT	(1 << 8)	/* inside concat_expr */
 
 struct json_ctx {
 	struct input_descriptor indesc;
@@ -99,6 +100,7 @@ static struct expr *json_parse_primary_expr(struct json_ctx *ctx, json_t *root);
 static struct expr *json_parse_set_rhs_expr(struct json_ctx *ctx, json_t *root);
 static struct expr *json_parse_set_elem_expr_stmt(struct json_ctx *ctx, json_t *root);
 static struct expr *json_parse_map_lhs_expr(struct json_ctx *ctx, json_t *root);
+static struct expr *json_parse_concat_elem_expr(struct json_ctx *ctx, json_t *root);
 static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root);
 
 /* parsing helpers */
@@ -1058,7 +1060,7 @@ static struct expr *json_parse_concat_expr(struct json_ctx *ctx,
 	}
 
 	json_array_foreach(root, index, value) {
-		tmp = json_parse_primary_expr(ctx, value);
+		tmp = json_parse_concat_elem_expr(ctx, value);
 		if (!tmp) {
 			json_error(ctx, "Parsing expr at index %zd failed.", index);
 			expr_free(expr);
@@ -1354,8 +1356,8 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		{ "set", json_parse_set_expr, CTX_F_RHS | CTX_F_STMT }, /* allow this as stmt expr because that allows set references */
 		{ "map", json_parse_map_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS },
 		/* below three are multiton_rhs_expr */
-		{ "prefix", json_parse_prefix_expr, CTX_F_RHS | CTX_F_STMT },
-		{ "range", json_parse_range_expr, CTX_F_RHS | CTX_F_STMT },
+		{ "prefix", json_parse_prefix_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_CONCAT },
+		{ "range", json_parse_range_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_CONCAT },
 		{ "payload", json_parse_payload_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP },
 		{ "exthdr", json_parse_exthdr_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
 		{ "tcp option", json_parse_tcp_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES },
@@ -1371,11 +1373,11 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		{ "jhash", json_parse_hash_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
 		{ "symhash", json_parse_hash_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
 		{ "fib", json_parse_fib_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
-		{ "|", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
-		{ "^", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
-		{ "&", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
-		{ ">>", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
-		{ "<<", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
+		{ "|", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
+		{ "^", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
+		{ "&", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
+		{ ">>", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
+		{ "<<", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "accept", json_parse_verdict_expr, CTX_F_RHS | CTX_F_SET_RHS },
 		{ "drop", json_parse_verdict_expr, CTX_F_RHS | CTX_F_SET_RHS },
 		{ "continue", json_parse_verdict_expr, CTX_F_RHS | CTX_F_SET_RHS },
@@ -1500,6 +1502,11 @@ static struct expr *json_parse_map_lhs_expr(struct json_ctx *ctx, json_t *root)
 	return json_parse_flagged_expr(ctx, CTX_F_MAP, root);
 }
 
+static struct expr *json_parse_concat_elem_expr(struct json_ctx *ctx, json_t *root)
+{
+	return json_parse_flagged_expr(ctx, CTX_F_CONCAT, root);
+}
+
 static struct expr *json_parse_dtype_expr(struct json_ctx *ctx, json_t *root)
 {
 	if (json_is_string(root)) {
-- 
2.25.1

