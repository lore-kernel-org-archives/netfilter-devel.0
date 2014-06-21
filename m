From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/4] expr: meta: Do not print unset values in json file
Date: Sat, 21 Jun 2014 18:30:00 +0200
Message-ID: <1403368200-8860-5-git-send-email-anarey@gmail.com>
References: <1403368200-8860-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40144 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaFUQaS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2014 12:30:18 -0400
Received: by mail-wi0-f171.google.com with SMTP id n15so2160371wiw.10
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2014 09:30:17 -0700 (PDT)
In-Reply-To: <1403368200-8860-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.
Moreover, It adds some whitespaces arount '+' caracter, as the CodingStyle
recommends.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/meta.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/src/expr/meta.c b/src/expr/meta.c
index 95d538c..248686b 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -188,29 +188,22 @@ static int nft_rule_expr_meta_json_parse(struct nft_rule_expr *e, json_t *root,
 	int key;
 
 	key_str = nft_jansson_parse_str(root, "key", err);
-	if (key_str == NULL)
-		return -1;
-
-	key = str2meta_key(key_str);
-	if (key < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_META_KEY, key);
+	if (key_str != NULL) {
+		key = str2meta_key(key_str);
+		if (key >= 0)
+			nft_rule_expr_set_u32(e, NFT_EXPR_META_KEY, key);
+	}
 
 	if (nft_jansson_node_exist(root, "dreg")) {
 		if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg,
-					  err) < 0)
-			return -1;
-
-		nft_rule_expr_set_u32(e, NFT_EXPR_META_DREG, reg);
+					  err) == 0)
+			nft_rule_expr_set_u32(e, NFT_EXPR_META_DREG, reg);
 	}
 
 	if (nft_jansson_node_exist(root, "sreg")) {
 		if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &reg,
-					  err) < 0)
-			return -1;
-
-		nft_rule_expr_set_u32(e, NFT_EXPR_META_SREG, reg);
+					  err) == 0)
+			nft_rule_expr_set_u32(e, NFT_EXPR_META_SREG, reg);
 	}
 
 	return 0;
@@ -304,19 +297,19 @@ nft_rule_expr_meta_snprintf_json(char *buf, size_t size,
 	struct nft_expr_meta *meta = nft_expr_data(e);
 
 	if (e->flags & (1 << NFT_EXPR_META_DREG)) {
-		ret = snprintf(buf+offset, len, "\"dreg\":%u,",
+		ret = snprintf(buf + offset, len, "\"dreg\":%u,",
 			       meta->dreg);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (e->flags & (1 << NFT_EXPR_META_KEY)) {
-		ret = snprintf(buf+offset, len, "\"key\":\"%s\",",
-						meta_key2str(meta->key));
+		ret = snprintf(buf + offset, len, "\"key\":\"%s\",",
+			       meta_key2str(meta->key));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (e->flags & (1 << NFT_EXPR_META_SREG)) {
-		ret = snprintf(buf+offset, len, "\"sreg\":%u,",
+		ret = snprintf(buf + offset, len, "\"sreg\":%u,",
 			       meta->sreg);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
-- 
2.0.0

