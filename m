From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/3] expr: lookup: Use nft_rule_expr_set_* in the xml parsing code
Date: Tue, 24 Jun 2014 19:14:15 +0200
Message-ID: <1403630057-12996-2-git-send-email-anarey@gmail.com>
References: <1403630057-12996-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:59464 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaFXROe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:14:34 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so696492wes.15
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 10:14:29 -0700 (PDT)
In-Reply-To: <1403630057-12996-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/lookup.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 1df65db..68b7345 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -194,31 +194,23 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 			       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_lookup *lookup = nft_expr_data(e);
 	const char *set_name;
-	uint32_t reg;
+	uint32_t sreg, dreg;
 
 	set_name = nft_mxml_str_parse(tree, "set", MXML_DESCEND_FIRST,
 				      NFT_XML_MAND, err);
 	if (set_name == NULL)
 		return -1;
+	nft_rule_expr_set_str(e, NFT_EXPR_LOOKUP_SET, set_name);
 
-	strncpy(lookup->set_name, set_name, IFNAMSIZ);
-	lookup->set_name[IFNAMSIZ-1] = '\0';
-	e->flags |= (1 << NFT_EXPR_LOOKUP_SET);
-
-	if (nft_mxml_reg_parse(tree, "sreg", &reg, MXML_DESCEND,
+	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND,
 			       NFT_XML_MAND, err) != 0)
 		return -1;
+	nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_SREG, sreg);
 
-	lookup->sreg = reg;
-	e->flags |= (1 << NFT_EXPR_LOOKUP_SREG);
-
-	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND,
-			       NFT_XML_OPT, err) == 0) {
-		lookup->dreg = reg;
-		e->flags |= (1 << NFT_EXPR_LOOKUP_DREG);
-	}
+	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND,
+			       NFT_XML_OPT, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_DREG, dreg);
 
 	return 0;
 #else
-- 
2.0.0

