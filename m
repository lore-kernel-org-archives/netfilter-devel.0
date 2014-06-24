From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/4] expr: exthdr: Use nft_rule_expr_set_* in the xml parsing code
Date: Tue, 24 Jun 2014 14:33:45 +0200
Message-ID: <1403613227-14134-3-git-send-email-anarey@gmail.com>
References: <1403613227-14134-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:42728 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaFXMeF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:34:05 -0400
Received: by mail-we0-f171.google.com with SMTP id q58so269144wes.2
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 05:34:01 -0700 (PDT)
In-Reply-To: <1403613227-14134-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/exthdr.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index ad80826..e624990 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -238,17 +238,14 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 			       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_exthdr *exthdr = nft_expr_data(e);
 	const char *exthdr_type;
 	int type;
-	uint32_t reg;
+	uint32_t dreg, len, offset;
 
-	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
+	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
 			       NFT_XML_MAND, err) != 0)
 		return -1;
-
-	exthdr->dreg = reg;
-	e->flags |= (1 << NFT_EXPR_EXTHDR_DREG);
+	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_DREG, dreg);
 
 	exthdr_type = nft_mxml_str_parse(tree, "exthdr_type",
 					 MXML_DESCEND_FIRST, NFT_XML_MAND, err);
@@ -258,25 +255,20 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	type = str2exthdr_type(exthdr_type);
 	if (type < 0)
 		return -1;
-
-	exthdr->type = type;
-	e->flags |= (1 << NFT_EXPR_EXTHDR_TYPE);
+	nft_rule_expr_set_u8(e, NFT_EXPR_EXTHDR_TYPE, type);
 
 	/* Get and set <offset> */
 	if (nft_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
-			       &exthdr->offset, NFT_TYPE_U32,
-			       NFT_XML_MAND, err) != 0)
+			       &offset, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_EXTHDR_OFFSET);
+	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_OFFSET, offset);
 
 	/* Get and set <len> */
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &exthdr->len, NFT_TYPE_U32, NFT_XML_MAND,
-			       err) != 0)
+			       &len, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
 		return -1;
 
-	e->flags |= (1 << NFT_EXPR_EXTHDR_LEN);
+	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_LEN, len);
 
 	return 0;
 #else
-- 
2.0.0

