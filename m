From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/3] expr: lookup: Do not print unset values in xml file
Date: Tue, 24 Jun 2014 19:14:16 +0200
Message-ID: <1403630057-12996-3-git-send-email-anarey@gmail.com>
References: <1403630057-12996-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37396 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbaFXROe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:14:34 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so6255514wib.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 10:14:29 -0700 (PDT)
In-Reply-To: <1403630057-12996-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/lookup.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 68b7345..d0d81cb 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -199,17 +199,15 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 
 	set_name = nft_mxml_str_parse(tree, "set", MXML_DESCEND_FIRST,
 				      NFT_XML_MAND, err);
-	if (set_name == NULL)
-		return -1;
-	nft_rule_expr_set_str(e, NFT_EXPR_LOOKUP_SET, set_name);
+	if (set_name != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_LOOKUP_SET, set_name);
 
-	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND,
-			       NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_SREG, sreg);
+	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND, NFT_XML_MAND,
+			       err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_SREG, sreg);
 
-	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND,
-			       NFT_XML_OPT, err) == 0)
+	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND, NFT_XML_OPT,
+			       err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_DREG, dreg);
 
 	return 0;
@@ -246,12 +244,16 @@ nft_rule_expr_lookup_snprintf_xml(char *buf, size_t size,
 	int len = size, offset = 0, ret;
 	struct nft_expr_lookup *l = nft_expr_data(e);
 
-	ret = snprintf(buf, len, "<set>%s</set><sreg>%u</sreg>",
-		       l->set_name, l->sreg);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_SET)) {
+		ret = snprintf(buf, len, "<set>%s</set>", l->set_name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_SREG)) {
+		ret = snprintf(buf + offset, len, "<sreg>%u</sreg>", l->sreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 	if (e->flags & (1 << NFT_EXPR_LOOKUP_DREG)) {
-		ret = snprintf(buf+offset, len, "<dreg>%u</dreg>", l->dreg);
+		ret = snprintf(buf + offset, len, "<dreg>%u</dreg>", l->dreg);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-- 
2.0.0

