From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/4] expr: ct: Use nft_rule_expr_set_* in the xml parsing code
Date: Tue, 24 Jun 2014 08:46:37 +0200
Message-ID: <1403592401-5057-2-git-send-email-anarey@gmail.com>
References: <1403592401-5057-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:56546 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaFXGrE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:47:04 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so8167670wes.29
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 23:47:03 -0700 (PDT)
In-Reply-To: <1403592401-5057-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/ct.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index 38f5169..0f1c050 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -286,23 +286,18 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 				      struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_ct *ct = nft_expr_data(e);
 	const char *key_str, *dir_str;
 	int key;
 	uint8_t dir;
-	uint32_t reg;
+	uint32_t dreg, sreg;
 
-	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
-			       NFT_XML_OPT, err) >= 0) {
-		ct->dreg = reg;
-		e->flags |= (1 << NFT_EXPR_CT_DREG);
-	}
+	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
+			       NFT_XML_OPT, err) >= 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_CT_DREG, dreg);
 
-	if (nft_mxml_reg_parse(tree, "sreg", &reg, MXML_DESCEND_FIRST,
-			       NFT_XML_OPT, err) >= 0) {
-		ct->sreg = reg;
-		e->flags |= (1 << NFT_EXPR_CT_SREG);
-	}
+	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
+			       NFT_XML_OPT, err) >= 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_CT_SREG, sreg);
 
 	key_str = nft_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST,
 				     NFT_XML_MAND, err);
@@ -313,8 +308,7 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 	if (key < 0)
 		goto err;
 
-	ct->key = key;
-	e->flags |= (1 << NFT_EXPR_CT_KEY);
+	nft_rule_expr_set_u32(e, NFT_EXPR_CT_KEY, key);
 
 	dir_str = nft_mxml_str_parse(tree, "dir", MXML_DESCEND_FIRST,
 				     NFT_XML_OPT, err);
-- 
2.0.0

