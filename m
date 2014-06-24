From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/4] expr: exthdr: Do not print unset values in json
Date: Tue, 24 Jun 2014 14:33:47 +0200
Message-ID: <1403613227-14134-5-git-send-email-anarey@gmail.com>
References: <1403613227-14134-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47273 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaFXMeI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:34:08 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so274645wgg.13
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 05:34:04 -0700 (PDT)
In-Reply-To: <1403613227-14134-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/exthdr.c | 64 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 25 deletions(-)

diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 6fb83b2..e237c73 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -201,30 +201,24 @@ nft_rule_expr_exthdr_json_parse(struct nft_rule_expr *e, json_t *root,
 	uint32_t uval32;
 	int type;
 
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &uval32, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_DREG, uval32);
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &uval32,
+				  err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_DREG, uval32);
 
 	exthdr_type = nft_jansson_parse_str(root, "exthdr_type", err);
-	if (exthdr_type == NULL)
-		return -1;
-
-	type = str2exthdr_type(exthdr_type);
-	if (type < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_TYPE, type);
-
-	if (nft_jansson_parse_val(root, "offset", NFT_TYPE_U32, &uval32, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_OFFSET, uval32);
+	if (exthdr_type != NULL) {
+		type = str2exthdr_type(exthdr_type);
+		if (type < 0)
+			return -1;
+		nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_TYPE, type);
+	}
 
-	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &uval32, err) < 0)
-		return -1;
+	if (nft_jansson_parse_val(root, "offset", NFT_TYPE_U32, &uval32,
+				  err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_OFFSET, uval32);
 
-	 nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_LEN, uval32);
+	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &uval32, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_LEN, uval32);
 
 	return 0;
 #else
@@ -276,12 +270,32 @@ static int nft_rule_expr_exthdr_snprintf_json(char *buf, size_t len,
 					      struct nft_rule_expr *e)
 {
 	struct nft_expr_exthdr *exthdr = nft_expr_data(e);
+	int ret, size = len, offset = 0;
 
-	return snprintf(buf, len, "\"dreg\":%u,"
-				  "\"exthdr_type\":\"%s\",\"offset\":%u,"
-				  "\"len\":%u",
-			exthdr->dreg, exthdr_type2str(exthdr->type),
-			exthdr->offset, exthdr->len);
+	if (e->flags & (1 << NFT_EXPR_EXTHDR_DREG)) {
+		ret = snprintf(buf, len, "\"dreg\":%u,", exthdr->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_EXTHDR_TYPE)) {
+		ret = snprintf(buf + offset, len, "\"exthdr_type\":\"%s\",",
+			       exthdr_type2str(exthdr->type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_EXTHDR_OFFSET)) {
+		ret = snprintf(buf + offset, len, "\"offset\":%u,",
+			       exthdr->offset);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_EXTHDR_LEN)) {
+		ret = snprintf(buf + offset, len, "\"len\":%u,",
+			       exthdr->len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	/* Remove the last comma characther */
+	if (offset > 0)
+		offset--;
+
+	return offset;
 }
 
 static int nft_rule_expr_exthdr_snprintf_xml(char *buf, size_t len,
-- 
2.0.0

