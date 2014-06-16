From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/4] expr: limit: Do not print unset values in json
Date: Mon, 16 Jun 2014 11:10:16 +0200
Message-ID: <1402909817-25325-4-git-send-email-anarey@gmail.com>
References: <1402909817-25325-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50723 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaFPJKd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:10:33 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so5271477wgg.29
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2014 02:10:32 -0700 (PDT)
In-Reply-To: <1402909817-25325-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

Now, This part of a json file is gotten without unset elements.

{"expr":[{"type":"limit","rate":400,"unit":60}]}

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/limit.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/src/expr/limit.c b/src/expr/limit.c
index 6e0a732..6732318 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -124,15 +124,11 @@ static int nft_rule_expr_limit_json_parse(struct nft_rule_expr *e, json_t *root,
 #ifdef JSON_PARSING
 	uint64_t uval64;
 
-	if (nft_jansson_parse_val(root, "rate", NFT_TYPE_U64, &uval64, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_RATE, uval64);
+	if (nft_jansson_parse_val(root, "rate", NFT_TYPE_U64, &uval64, err) == 0)
+		nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_RATE, uval64);
 
-	if (nft_jansson_parse_val(root, "unit", NFT_TYPE_U64, &uval64, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_UNIT, uval64);
+	if (nft_jansson_parse_val(root, "unit", NFT_TYPE_U64, &uval64, err) == 0)
+		nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_UNIT, uval64);
 
 	return 0;
 #else
@@ -191,10 +187,24 @@ static int nft_rule_expr_limit_snprintf_xml(char *buf, size_t len,
 static int nft_rule_expr_limit_snprintf_json(char *buf, size_t len,
 					    struct nft_rule_expr *e) {
 	struct nft_expr_limit *limit = nft_expr_data(e);
+	int ret, size = len, offset = 0;
 
-	return snprintf(buf, len, "\"rate\":%"PRIu64","
-				  "\"unit\":%"PRIu64"",
-			limit->rate, limit->unit);
+	if (e->flags & (1 << NFT_EXPR_LIMIT_RATE)) {
+		ret = snprintf(buf + offset, len, "\"rate\":%"PRIu64",",
+			       limit->rate);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_LIMIT_UNIT)) {
+		ret = snprintf(buf + offset, len, "\"unit\":%"PRIu64",",
+			       limit->unit);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	/* Remove the last comma characther */
+	if (offset > 0)
+		offset--;
+
+	return offset;
 }
 
 static int nft_rule_expr_limit_snprintf_default(char *buf, size_t len,
-- 
2.0.0

