From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/4] expr: payload: Use nft_rule_expr_set_* in the xml parsing code
Date: Sun, 22 Jun 2014 20:32:18 +0200
Message-ID: <1403461941-21605-2-git-send-email-anarey@gmail.com>
References: <1403461941-21605-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:52531 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaFVSce (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:32:34 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so5755569wgg.29
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2014 11:32:33 -0700 (PDT)
In-Reply-To: <1403461941-21605-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/payload.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/src/expr/payload.c b/src/expr/payload.c
index ad82015..90322c1 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -240,17 +240,15 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 				struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_payload *payload = nft_expr_data(e);
 	const char *base_str;
 	int32_t base;
-	uint32_t reg;
+	uint32_t dreg, offset, len;
 
-	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
+	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
 			       NFT_XML_MAND, err) != 0)
 		return -1;
 
-	payload->dreg = reg;
-	e->flags |= (1 << NFT_EXPR_PAYLOAD_DREG);
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, dreg);
 
 	base_str = nft_mxml_str_parse(tree, "base", MXML_DESCEND_FIRST,
 				      NFT_XML_MAND, err);
@@ -261,22 +259,19 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	if (base < 0)
 		return -1;
 
-	payload->base = base;
-	e->flags |= (1 << NFT_EXPR_PAYLOAD_BASE);
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_BASE, base);
 
 	if (nft_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
-			       &payload->offset, NFT_TYPE_U8,
-			       NFT_XML_MAND, err) != 0)
+			       &offset, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
 		return -1;
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET, offset);
 
-	e->flags |= (1 << NFT_EXPR_PAYLOAD_OFFSET);
 
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &payload->len, NFT_TYPE_U8,
-			       NFT_XML_MAND, err) != 0)
+			       &len, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
 		return -1;
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, len);
 
-	e->flags |= (1 << NFT_EXPR_PAYLOAD_LEN);
 	return 0;
 #else
 	errno = EOPNOTSUPP;
-- 
2.0.0

