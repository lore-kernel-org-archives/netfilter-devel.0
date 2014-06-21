From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/4] expr: meta: Use nft_rule_expr_set_* in the xml parsing code
Date: Sat, 21 Jun 2014 18:29:57 +0200
Message-ID: <1403368200-8860-2-git-send-email-anarey@gmail.com>
References: <1403368200-8860-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36509 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaFUQaQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2014 12:30:16 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so2142123wib.0
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2014 09:30:12 -0700 (PDT)
In-Reply-To: <1403368200-8860-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/meta.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/src/expr/meta.c b/src/expr/meta.c
index 24057f2..c325742 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -225,10 +225,9 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_node_t *tr
 					struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_meta *meta = nft_expr_data(e);
 	const char *key_str;
 	int key;
-	uint32_t reg;
+	uint32_t dreg, sreg;
 
 	key_str = nft_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST,
 				     NFT_XML_MAND, err);
@@ -238,21 +237,15 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_node_t *tr
 	key = str2meta_key(key_str);
 	if (key < 0)
 		return -1;
+	nft_rule_expr_set_u32(e, NFT_EXPR_META_KEY, key);
 
-	meta->key = key;
-	e->flags |= (1 << NFT_EXPR_META_KEY);
-
-	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
-			       NFT_XML_OPT, err) >= 0) {
-		meta->dreg = reg;
-		e->flags |= (1 << NFT_EXPR_META_DREG);
-	}
+	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
+			       NFT_XML_OPT, err) >= 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_META_DREG, dreg);
 
-	if (nft_mxml_reg_parse(tree, "sreg", &reg, MXML_DESCEND_FIRST,
-			       NFT_XML_OPT, err) >= 0) {
-		meta->sreg = reg;
-		e->flags |= (1 << NFT_EXPR_META_SREG);
-	}
+	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
+			       NFT_XML_OPT, err) >= 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_META_SREG, sreg);
 
 	return 0;
 #else
-- 
2.0.0

