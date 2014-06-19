From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/5] expr: byteorder: Do not print unset values in xml file
Date: Thu, 19 Jun 2014 17:07:08 +0200
Message-ID: <1403190430-22173-4-git-send-email-anarey@gmail.com>
References: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36127 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbaFSPH0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:07:26 -0400
Received: by mail-wg0-f44.google.com with SMTP id x13so2398418wgg.3
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 08:07:25 -0700 (PDT)
In-Reply-To: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/byteorder.c | 71 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 30 deletions(-)

diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 0b87eca..ad7721f 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -249,36 +249,28 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	uint32_t sreg, dreg, len, size;
 
 	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
-			       NFT_XML_MAND, err) < 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SREG, sreg);
+			       NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SREG, sreg);
 
 	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND, NFT_XML_MAND,
-			       err) < 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_DREG, dreg);
+			       err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_DREG, dreg);
 
 	op = nft_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST, NFT_XML_MAND,
 				err);
-	if (op == NULL)
-		return -1;
-
-	ntoh = nft_str2ntoh(op);
-	if (ntoh < 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_OP, ntoh);
+	if (op != NULL) {
+		ntoh = nft_str2ntoh(op);
+		if (ntoh >= 0)
+			nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_OP, ntoh);
+	}
 
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &len, NFT_TYPE_U32, NFT_XML_MAND,
-			       err) < 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_LEN, len);
+			       &len, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_LEN, len);
 
 	if (nft_mxml_num_parse(tree, "size", MXML_DESCEND_FIRST, BASE_DEC,
-			       &size, NFT_TYPE_U32, NFT_XML_MAND,
-			       err) != 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SIZE, size);
+			       &size, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SIZE, size);
 
 	return 0;
 #else
@@ -312,15 +304,34 @@ static int nft_rule_expr_byteorder_snprintf_xml(char *buf, size_t size,
 	struct nft_expr_byteorder *byteorder = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "<sreg>%u</sreg>"
-				 "<dreg>%u</dreg>"
-				 "<op>%s</op>"
-				 "<len>%u</len>"
-				 "<size>%u</size>",
-		       byteorder->sreg, byteorder->dreg,
-		       expr_byteorder_str[byteorder->op],
-		       byteorder->len, byteorder->size);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_SREG)) {
+		ret = snprintf(buf + offset, len, "<sreg>%u</sreg>",
+			       byteorder->sreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_DREG)) {
+		ret = snprintf(buf + offset, len, "<dreg>%u</dreg>",
+			       byteorder->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_OP)) {
+		ret = snprintf(buf + offset, len, "<op>%s</op>",
+			       expr_byteorder_str[byteorder->op]);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_LEN)) {
+		ret = snprintf(buf + offset, len, "<len>%u</len>",
+			       byteorder->len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_BYTEORDER_SIZE)) {
+		ret = snprintf(buf + offset, len, "<size>%u</size>",
+			       byteorder->size);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	return offset;
 }
-- 
2.0.0

