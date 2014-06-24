From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/4] expr: exthdr: Do not print unset values in xml
Date: Tue, 24 Jun 2014 14:33:46 +0200
Message-ID: <1403613227-14134-4-git-send-email-anarey@gmail.com>
References: <1403613227-14134-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43022 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaFXMeJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:34:09 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so524286wib.13
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 05:34:05 -0700 (PDT)
In-Reply-To: <1403613227-14134-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/exthdr.c | 57 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index e624990..6fb83b2 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -243,32 +243,27 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	uint32_t dreg, len, offset;
 
 	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
-			       NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_DREG, dreg);
+			       NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_DREG, dreg);
 
 	exthdr_type = nft_mxml_str_parse(tree, "exthdr_type",
 					 MXML_DESCEND_FIRST, NFT_XML_MAND, err);
-	if (exthdr_type == NULL)
-		return -1;
-
-	type = str2exthdr_type(exthdr_type);
-	if (type < 0)
-		return -1;
-	nft_rule_expr_set_u8(e, NFT_EXPR_EXTHDR_TYPE, type);
+	if (exthdr_type != NULL) {
+		type = str2exthdr_type(exthdr_type);
+		if (type < 0)
+			return -1;
+		nft_rule_expr_set_u8(e, NFT_EXPR_EXTHDR_TYPE, type);
+	}
 
 	/* Get and set <offset> */
 	if (nft_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
-			       &offset, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_OFFSET, offset);
+			       &offset, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_OFFSET, offset);
 
 	/* Get and set <len> */
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &len, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_LEN, len);
+			       &len, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_LEN, len);
 
 	return 0;
 #else
@@ -293,13 +288,29 @@ static int nft_rule_expr_exthdr_snprintf_xml(char *buf, size_t len,
 					     struct nft_rule_expr *e)
 {
 	struct nft_expr_exthdr *exthdr = nft_expr_data(e);
+	int ret, size = len, offset = 0;
 
-	return snprintf(buf, len, "<dreg>%u</dreg>"
-				  "<exthdr_type>%s</exthdr_type>"
-				  "<offset>%u</offset>"
-				  "<len>%u</len>",
-			exthdr->dreg, exthdr_type2str(exthdr->type),
-			exthdr->offset, exthdr->len);
+	if (e->flags & (1 << NFT_EXPR_EXTHDR_DREG)) {
+		ret = snprintf(buf, len, "<dreg>%u</dreg>", exthdr->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_EXTHDR_TYPE)) {
+		ret = snprintf(buf + offset, len,
+			       "<exthdr_type>%s</exthdr_type>",
+			       exthdr_type2str(exthdr->type));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_EXTHDR_OFFSET)) {
+		ret = snprintf(buf + offset, len, "<offset>%u</offset>",
+			       exthdr->offset);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_EXTHDR_LEN)) {
+		ret = snprintf(buf + offset, len, "<len>%u</len>", exthdr->len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 
 static int nft_rule_expr_exthdr_snprintf_default(char *buf, size_t len,
-- 
2.0.0

