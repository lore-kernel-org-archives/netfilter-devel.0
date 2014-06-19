From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/3] expr: bitwise: Do not print unset values in xml
Date: Thu, 19 Jun 2014 12:05:38 +0200
Message-ID: <1403172339-29786-3-git-send-email-anarey@gmail.com>
References: <1403172339-29786-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40416 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbaFSKFx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:05:53 -0400
Received: by mail-wg0-f47.google.com with SMTP id k14so2020175wgh.18
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 03:05:51 -0700 (PDT)
In-Reply-To: <1403172339-29786-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

Now, This part of a xml file is gotten without unset elements.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/bitwise.c | 95 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 49 insertions(+), 46 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 148ee08..36a3111 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -231,40 +231,27 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 {
 #ifdef XML_PARSING
 	struct nft_expr_bitwise *bitwise = nft_expr_data(e);
-	uint32_t reg;
+	uint32_t sreg, dreg, len;
 
-	if (nft_mxml_reg_parse(tree, "sreg", &reg, MXML_DESCEND_FIRST,
-			       NFT_XML_MAND, err) != 0)
-		return -1;
-
-	bitwise->sreg = reg;
-	e->flags |= (1 << NFT_EXPR_BITWISE_SREG);
-
-	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
-			       NFT_XML_MAND, err) != 0)
-		return -1;
-
-	bitwise->dreg = reg;
-	e->flags |= (1 << NFT_EXPR_BITWISE_DREG);
-
-	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST,
-			       BASE_DEC, &bitwise->len, NFT_TYPE_U8,
-			       NFT_XML_MAND, err) != 0)
-		return -1;
+	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
+			       NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_SREG, sreg);
 
-	e->flags |= (1 << NFT_EXPR_BITWISE_LEN);
+	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
+			       NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_DREG, dreg);
 
-	if (nft_mxml_data_reg_parse(tree, "mask", &bitwise->mask,
-				    NFT_XML_MAND, err) != DATA_VALUE)
-		return -1;
+	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
+			       &len, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_LEN, len);
 
-	e->flags |= (1 << NFT_EXPR_BITWISE_MASK);
+	if (nft_mxml_data_reg_parse(tree, "mask", &bitwise->mask, NFT_XML_MAND,
+				    err) == DATA_VALUE)
+		e->flags |= (1 << NFT_EXPR_BITWISE_MASK);
 
-	if (nft_mxml_data_reg_parse(tree, "xor", &bitwise->xor,
-				    NFT_XML_MAND, err) != DATA_VALUE)
-		return -1;
-
-	e->flags |= (1 << NFT_EXPR_BITWISE_XOR);
+	if (nft_mxml_data_reg_parse(tree, "xor", &bitwise->xor, NFT_XML_MAND,
+				    err) == DATA_VALUE)
+		e->flags |= (1 << NFT_EXPR_BITWISE_XOR);
 
 	/* Additional validation: mask and xor must use the same number of
 	 * data registers.
@@ -317,28 +304,44 @@ static int nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
 	struct nft_expr_bitwise *bitwise = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "<sreg>%u</sreg>"
-				 "<dreg>%u</dreg>"
-				 "<len>%u</len>",
-		       bitwise->sreg, bitwise->dreg, bitwise->len);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_BITWISE_SREG)) {
+		ret = snprintf(buf + offset, len, "<sreg>%u</sreg>",
+			       bitwise->sreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_BITWISE_DREG)) {
+		ret = snprintf(buf + offset, len, "<dreg>%u</dreg>",
+			       bitwise->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_BITWISE_LEN)) {
+		ret = snprintf(buf + offset, len, "<len>%u</len>",
+			       bitwise->len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_BITWISE_MASK)) {
+		ret = snprintf(buf + offset, len, "<mask>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "<mask>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = nft_data_reg_snprintf(buf + offset, len, &bitwise->mask,
+					    NFT_OUTPUT_XML, 0, DATA_VALUE);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
-				    NFT_OUTPUT_XML, 0, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, len, "</mask>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
-	ret = snprintf(buf+offset, len, "</mask><xor>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_BITWISE_XOR)) {
+		ret = snprintf(buf + offset, len, "<xor>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
-				    NFT_OUTPUT_XML, 0, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = nft_data_reg_snprintf(buf + offset, len, &bitwise->xor,
+					    NFT_OUTPUT_XML, 0, DATA_VALUE);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "</xor>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, len, "</xor>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	return offset;
 }
-- 
2.0.0

