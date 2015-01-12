From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] meta: don't print meta keyword for unqualified meta stmts
Date: Mon, 12 Jan 2015 13:19:09 +0000
Message-ID: <1421068749-9365-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35261 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbbALNTS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:19:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/meta.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 6ff5fc8..6689ead 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -415,22 +415,28 @@ static const struct meta_template meta_templates[] = {
 						BYTEORDER_HOST_ENDIAN),
 };
 
-static void meta_expr_print(const struct expr *expr)
+static bool meta_key_is_qualified(enum nft_meta_keys key)
 {
-	switch (expr->meta.key) {
+	switch (key) {
 	case NFT_META_LEN:
 	case NFT_META_NFPROTO:
 	case NFT_META_L4PROTO:
 	case NFT_META_PROTOCOL:
 	case NFT_META_PRIORITY:
-		printf("meta %s", meta_templates[expr->meta.key].token);
-		break;
+		return true;
 	default:
-		printf("%s", meta_templates[expr->meta.key].token);
-		break;
+		return false;
 	}
 }
 
+static void meta_expr_print(const struct expr *expr)
+{
+	if (meta_key_is_qualified(expr->meta.key))
+		printf("meta %s", meta_templates[expr->meta.key].token);
+	else
+		printf("%s", meta_templates[expr->meta.key].token);
+}
+
 static bool meta_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
 	return e1->meta.key == e2->meta.key;
@@ -529,7 +535,11 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 
 static void meta_stmt_print(const struct stmt *stmt)
 {
-	printf("meta %s set ", meta_templates[stmt->meta.key].token);
+	if (meta_key_is_qualified(stmt->meta.key))
+		printf("meta %s set ", meta_templates[stmt->meta.key].token);
+	else
+		printf("%s set ", meta_templates[stmt->meta.key].token);
+
 	expr_print(stmt->meta.expr);
 }
 
-- 
2.1.0

