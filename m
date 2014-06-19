From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 5/5] expr: byteorder: Do not print unset values in json
Date: Thu, 19 Jun 2014 17:07:10 +0200
Message-ID: <1403190430-22173-6-git-send-email-anarey@gmail.com>
References: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:40339 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127AbaFSPH3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:07:29 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so2441091wgh.35
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 08:07:28 -0700 (PDT)
In-Reply-To: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

Now, This part of a json file is gotten without unset elements.

[FILE EXAMPLE]

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/byteorder.c | 77 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index e56af3f..20a89d3 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -202,35 +202,24 @@ nft_rule_expr_byteorder_json_parse(struct nft_rule_expr *e, json_t *root,
 	uint32_t sreg, dreg, len, size;
 	int ntoh;
 
-	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &sreg, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SREG, sreg);
-
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &dreg, err) < 0)
-		return -1;
+	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &sreg, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SREG, sreg);
 
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_DREG, dreg);
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &dreg, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_DREG, dreg);
 
 	op = nft_jansson_parse_str(root, "op", err);
-	if (op == NULL)
-		return -1;
-
-	ntoh = nft_str2ntoh(op);
-	if (ntoh < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_OP, ntoh);
-
-	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &len, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_LEN, len);
+	if (op != NULL) {
+		ntoh = nft_str2ntoh(op);
+		if (ntoh >= 0)
+			nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_OP, ntoh);
+	}
 
-	if (nft_jansson_parse_val(root, "size", NFT_TYPE_U32, &size, err) < 0)
-		return -1;
+	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &len, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_LEN, len);
 
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SIZE, size);
+	if (nft_jansson_parse_val(root, "size", NFT_TYPE_U32, &size, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SIZE, size);
 
 	return 0;
 #else
@@ -285,15 +274,37 @@ static int nft_rule_expr_byteorder_snprintf_json(char *buf, size_t size,
 	struct nft_expr_byteorder *byteorder = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "\"sreg\":%u,"
-				 "\"dreg\":%u,"
-				 "\"op\":\"%s\","
-				 "\"len\":%u,"
-				 "\"size\":%u",
-		       byteorder->sreg, byteorder->dreg,
-		       expr_byteorder_str[byteorder->op],
-		       byteorder->len, byteorder->size);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_SREG)) {
+		ret = snprintf(buf + offset, len, "\"sreg\":%u,",
+			       byteorder->sreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_DREG)) {
+		ret = snprintf(buf + offset, len, "\"dreg\":%u,",
+			       byteorder->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_OP)) {
+		ret = snprintf(buf + offset, len, "\"op\":\"%s\",",
+			       expr_byteorder_str[byteorder->op]);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_LEN)) {
+		ret = snprintf(buf + offset, len, "\"len\":%u,",
+			       byteorder->len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_SIZE)) {
+		ret = snprintf(buf + offset, len, "\"size\":%u,",
+			       byteorder->size);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (offset > 0)
+		offset--;
 
 	return offset;
 }
-- 
2.0.0

