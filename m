From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/4] expr: cmp: Do not print unset values in xml file
Date: Thu, 19 Jun 2014 19:34:23 +0200
Message-ID: <1403199264-14271-4-git-send-email-anarey@gmail.com>
References: <1403199264-14271-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64483 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040AbaFSRen (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:34:43 -0400
Received: by mail-wg0-f43.google.com with SMTP id b13so2636562wgh.14
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 10:34:42 -0700 (PDT)
In-Reply-To: <1403199264-14271-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/cmp.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index cc01573..5fd02e4 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -221,26 +221,21 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	uint32_t sreg;
 
 	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
-			       NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_SREG, sreg);
+			       NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_CMP_SREG, sreg);
 
 	op = nft_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST, NFT_XML_MAND,
 				err);
-	if (op == NULL)
-		return -1;
-
-	op_value = nft_str2cmp(op);
-	if (op_value < 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_OP, op_value);
+	if (op != NULL) {
+		op_value = nft_str2cmp(op);
+		if (op_value >= 0)
+			nft_rule_expr_set_u32(e, NFT_EXPR_CMP_OP, op_value);
+	}
 
 	if (nft_mxml_data_reg_parse(tree, "cmpdata",
 				    &cmp->data, NFT_XML_MAND,
-				    err) != DATA_VALUE)
-		return -1;
-
-	e->flags |= (1 << NFT_EXPR_CMP_DATA);
+				    err) == DATA_VALUE)
+		e->flags |= (1 << NFT_EXPR_CMP_DATA);
 
 	return 0;
 #else
@@ -272,11 +267,19 @@ static int nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size,
 	struct nft_expr_cmp *cmp = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "<sreg>%u</sreg><op>%s</op>",
-		       cmp->sreg, expr_cmp_str[cmp->op]);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_CMP_SREG)) {
+		ret = snprintf(buf, len, "<sreg>%u</sreg>",
+			       cmp->sreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
-	ret = nft_data_reg_snprintf(buf+offset, len, &cmp->data,
+	if (e->flags & (1 << NFT_EXPR_CMP_SREG)) {
+		ret = snprintf(buf + offset, len, "<op>%s</op>",
+			       expr_cmp_str[cmp->op]);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret = nft_data_reg_snprintf(buf + offset, len, &cmp->data,
 				    NFT_OUTPUT_XML, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-- 
2.0.0

