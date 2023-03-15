Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6CFC6FD1D
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 12:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbjCOM5u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 08:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbjCOM5u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 08:57:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC4998E90
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 05:57:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pcQhM-0005nR-31; Wed, 15 Mar 2023 13:57:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] meta: don't crash if meta key isn't known
Date:   Wed, 15 Mar 2023 13:57:38 +0100
Message-Id: <20230315125738.28817-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If older nft version is used for dumping, 'key' might be
outside of the range of known templates.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/meta.c                | 31 +++++++++++++++++++++----------
 src/netlink_delinearize.c |  4 +++-
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 013e8cbaf38a..dcf971a5dd62 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -717,12 +717,16 @@ static bool meta_key_is_unqualified(enum nft_meta_keys key)
 
 static void meta_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	if (meta_key_is_unqualified(expr->meta.key))
-		nft_print(octx, "%s",
-			  meta_templates[expr->meta.key].token);
+	const char *token = "unknown";
+	uint32_t key = expr->meta.key;
+
+	if (key < array_size(meta_templates))
+		token = meta_templates[key].token;
+
+	if (meta_key_is_unqualified(key))
+		nft_print(octx, "%s", token);
 	else
-		nft_print(octx, "meta %s",
-			  meta_templates[expr->meta.key].token);
+		nft_print(octx, "meta %s", token);
 }
 
 static bool meta_expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -918,12 +922,16 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 
 static void meta_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
+	const char *token = "unknown";
+	uint32_t key = stmt->meta.key;
+
+	if (key < array_size(meta_templates))
+		token = meta_templates[key].token;
+
 	if (meta_key_is_unqualified(stmt->meta.key))
-		nft_print(octx, "%s set ",
-			  meta_templates[stmt->meta.key].token);
+		nft_print(octx, "%s set ", token);
 	else
-		nft_print(octx, "meta %s set ",
-			  meta_templates[stmt->meta.key].token);
+		nft_print(octx, "meta %s set ", token);
 
 	expr_print(stmt->meta.expr, octx);
 }
@@ -948,8 +956,11 @@ struct stmt *meta_stmt_alloc(const struct location *loc, enum nft_meta_keys key,
 
 	stmt = stmt_alloc(loc, &meta_stmt_ops);
 	stmt->meta.key	= key;
-	stmt->meta.tmpl	= &meta_templates[key];
 	stmt->meta.expr	= expr;
+
+        if (key < array_size(meta_templates))
+                stmt->meta.tmpl = &meta_templates[key];
+
 	return stmt;
 }
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 60350cd6cd96..d28b545e69d2 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -920,7 +920,9 @@ static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
 
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_META_KEY);
 	stmt = meta_stmt_alloc(loc, key, expr);
-	expr_set_type(expr, stmt->meta.tmpl->dtype, stmt->meta.tmpl->byteorder);
+
+	if (stmt->meta.tmpl)
+		expr_set_type(expr, stmt->meta.tmpl->dtype, stmt->meta.tmpl->byteorder);
 
 	ctx->stmt = stmt;
 }
-- 
2.39.2

