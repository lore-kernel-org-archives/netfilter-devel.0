From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/3] expr: bitwise: Do not print unset values in json
Date: Thu, 19 Jun 2014 12:05:39 +0200
Message-ID: <1403172339-29786-4-git-send-email-anarey@gmail.com>
References: <1403172339-29786-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36678 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaFSKFy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:05:54 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so2015584wgh.11
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 03:05:53 -0700 (PDT)
In-Reply-To: <1403172339-29786-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/bitwise.c | 90 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 51 insertions(+), 39 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 36a3111..529594b 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -188,32 +188,22 @@ nft_rule_expr_bitwise_json_parse(struct nft_rule_expr *e, json_t *root,
 	struct nft_expr_bitwise *bitwise = nft_expr_data(e);
 	uint32_t reg, len;
 
-	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &reg, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_SREG, reg);
-
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_DREG, reg);
-
-	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &len, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_LEN, len);
+	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &reg, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_SREG, reg);
 
-	if (nft_jansson_data_reg_parse(root, "mask",
-				       &bitwise->mask, err) != DATA_VALUE)
-		return -1;
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_DREG, reg);
 
-	e->flags |= (1 << NFT_EXPR_BITWISE_MASK);
+	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &len, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_LEN, len);
 
-	if (nft_jansson_data_reg_parse(root, "xor",
-				       &bitwise->xor, err) != DATA_VALUE)
-		return -1;
+	if (nft_jansson_data_reg_parse(root, "mask", &bitwise->mask,
+				       err) == DATA_VALUE)
+		e->flags |= (1 << NFT_EXPR_BITWISE_MASK);
 
-	e->flags |= (1 << NFT_EXPR_BITWISE_XOR);
+	if (nft_jansson_data_reg_parse(root, "xor", &bitwise->xor,
+				       err) == DATA_VALUE)
+		e->flags |= (1 << NFT_EXPR_BITWISE_XOR);
 
 	if (bitwise->mask.len != bitwise->xor.len)
 		return -1;
@@ -272,28 +262,50 @@ static int nft_rule_expr_bitwise_snprintf_json(char *buf, size_t size,
 	int len = size, offset = 0, ret;
 	struct nft_expr_bitwise *bitwise = nft_expr_data(e);
 
-	ret = snprintf(buf, len, "\"sreg\":%u,"
-				 "\"dreg\":%u,"
-				 "\"len\":%u,",
-		       bitwise->sreg, bitwise->dreg, bitwise->len);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_BITWISE_SREG)) {
+		ret = snprintf(buf + offset, len, "\"sreg\":%u,",
+			       bitwise->sreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
-	ret = snprintf(buf+offset, len, "\"mask\":{");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_BITWISE_DREG)) {
+		ret = snprintf(buf + offset, len, "\"dreg\":%u,",
+			       bitwise->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_BITWISE_LEN)) {
+		ret = snprintf(buf + offset, len, "\"len\":%u,",
+			       bitwise->len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
-	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
-				    NFT_OUTPUT_JSON, 0, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_BITWISE_MASK)) {
+		ret = snprintf(buf + offset, len, "\"mask\":{");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "},\"xor\":{");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
+					    NFT_OUTPUT_JSON, 0, DATA_VALUE);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
-				    NFT_OUTPUT_JSON, 0, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, len, "},");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "}");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_BITWISE_XOR)) {
+		ret = snprintf(buf+offset, len, "\"xor\":{");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
+					    NFT_OUTPUT_JSON, 0, DATA_VALUE);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = snprintf(buf+offset, len, "},");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (offset > 0)
+		offset--;
 
 	return offset;
 }
-- 
2.0.0

