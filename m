From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/5] expr: byteorder: Use nft_rule_expr_set_* in the xml parsing code
Date: Thu, 19 Jun 2014 17:07:07 +0200
Message-ID: <1403190430-22173-3-git-send-email-anarey@gmail.com>
References: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52590 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbaFSPHZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:07:25 -0400
Received: by mail-wg0-f43.google.com with SMTP id b13so2450666wgh.14
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 08:07:24 -0700 (PDT)
In-Reply-To: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/byteorder.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index e42d7b6..0b87eca 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -244,24 +244,19 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 				  struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_byteorder *byteorder = nft_expr_data(e);
 	const char *op;
 	int32_t ntoh;
-	uint32_t reg;
+	uint32_t sreg, dreg, len, size;
 
-	if (nft_mxml_reg_parse(tree, "sreg", &reg, MXML_DESCEND_FIRST,
-			       NFT_XML_MAND, err) != 0)
+	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
+			       NFT_XML_MAND, err) < 0)
 		return -1;
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SREG, sreg);
 
-	byteorder->sreg = reg;
-	e->flags |= (1 << NFT_EXPR_BYTEORDER_SREG);
-
-	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND, NFT_XML_MAND,
-			       err) != 0)
+	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND, NFT_XML_MAND,
+			       err) < 0)
 		return -1;
-
-	byteorder->dreg = reg;
-	e->flags |= (1 << NFT_EXPR_BYTEORDER_DREG);
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_DREG, dreg);
 
 	op = nft_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST, NFT_XML_MAND,
 				err);
@@ -271,23 +266,19 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	ntoh = nft_str2ntoh(op);
 	if (ntoh < 0)
 		return -1;
-
-	byteorder->op = ntoh;
-	e->flags |= (1 << NFT_EXPR_BYTEORDER_OP);
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_OP, ntoh);
 
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &byteorder->len, NFT_TYPE_U8,
-			       NFT_XML_MAND, err) != 0)
+			       &len, NFT_TYPE_U32, NFT_XML_MAND,
+			       err) < 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_BYTEORDER_LEN);
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_LEN, len);
 
 	if (nft_mxml_num_parse(tree, "size", MXML_DESCEND_FIRST, BASE_DEC,
-			       &byteorder->size, NFT_TYPE_U8,
-			       NFT_XML_MAND, err) != 0)
+			       &size, NFT_TYPE_U32, NFT_XML_MAND,
+			       err) != 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_BYTEORDER_SIZE);
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SIZE, size);
 
 	return 0;
 #else
-- 
2.0.0

