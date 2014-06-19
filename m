From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/4] expr: cmp: Use nft_rule_expr_set_* in the xml parsing code
Date: Thu, 19 Jun 2014 19:34:22 +0200
Message-ID: <1403199264-14271-3-git-send-email-anarey@gmail.com>
References: <1403199264-14271-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:47270 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040AbaFSRel (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:34:41 -0400
Received: by mail-wg0-f41.google.com with SMTP id a1so2573624wgh.0
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 10:34:40 -0700 (PDT)
In-Reply-To: <1403199264-14271-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_cmp_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/cmp.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index b21fa9d..cc01573 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -218,14 +218,12 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	struct nft_expr_cmp *cmp = nft_expr_data(e);
 	const char *op;
 	int32_t op_value;
-	uint32_t reg;
+	uint32_t sreg;
 
-	if (nft_mxml_reg_parse(tree, "sreg", &reg, MXML_DESCEND_FIRST,
+	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
 			       NFT_XML_MAND, err) != 0)
 		return -1;
-
-	cmp->sreg = reg;
-	e->flags |= (1 << NFT_EXPR_CMP_SREG);
+	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_SREG, sreg);
 
 	op = nft_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST, NFT_XML_MAND,
 				err);
@@ -235,9 +233,7 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	op_value = nft_str2cmp(op);
 	if (op_value < 0)
 		return -1;
-
-	cmp->op = op_value;
-	e->flags |= (1 << NFT_EXPR_CMP_OP);
+	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_OP, op_value);
 
 	if (nft_mxml_data_reg_parse(tree, "cmpdata",
 				    &cmp->data, NFT_XML_MAND,
-- 
2.0.0

