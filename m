From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/3] expr: immediate: Do not print unset values in xml file
Date: Sat, 21 Jun 2014 17:53:43 +0200
Message-ID: <1403366023-6385-4-git-send-email-anarey@gmail.com>
References: <1403366023-6385-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52612 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaFUPyJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2014 11:54:09 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so2293081wib.0
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2014 08:54:07 -0700 (PDT)
In-Reply-To: <1403366023-6385-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/immediate.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index b52bd23..af3324b 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -223,24 +223,25 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	uint32_t reg;
 
 	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
-			       NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_IMM_DREG, reg);
+			       NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_IMM_DREG, reg);
 
 	datareg_type = nft_mxml_data_reg_parse(tree, "immediatedata",
 					       &imm->data, NFT_XML_MAND, err);
-	switch (datareg_type) {
-	case DATA_VALUE:
-		e->flags |= (1 << NFT_EXPR_IMM_DATA);
-		break;
-	case DATA_VERDICT:
-		e->flags |= (1 << NFT_EXPR_IMM_VERDICT);
-		break;
-	case DATA_CHAIN:
-		e->flags |= (1 << NFT_EXPR_IMM_CHAIN);
-		break;
-	default:
-		return -1;
+	if (datareg_type >= 0) {
+		switch (datareg_type) {
+		case DATA_VALUE:
+			e->flags |= (1 << NFT_EXPR_IMM_DATA);
+			break;
+		case DATA_VERDICT:
+			e->flags |= (1 << NFT_EXPR_IMM_VERDICT);
+			break;
+		case DATA_CHAIN:
+			e->flags |= (1 << NFT_EXPR_IMM_CHAIN);
+			break;
+		default:
+			return -1;
+		}
 	}
 
 	return 0;
@@ -288,22 +289,23 @@ nft_rule_expr_immediate_snprintf_xml(char *buf, size_t len,
 	int size = len, offset = 0, ret;
 	struct nft_expr_immediate *imm = nft_expr_data(e);
 
-	ret = snprintf(buf, len, "<dreg>%u</dreg>", imm->dreg);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
+	if (e->flags & (1 << NFT_EXPR_IMM_DREG)) {
+		ret = snprintf(buf, len, "<dreg>%u</dreg>", imm->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	if (e->flags & (1 << NFT_EXPR_IMM_DATA)) {
-		ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
+		ret = nft_data_reg_snprintf(buf + offset, len, &imm->data,
 					    NFT_OUTPUT_XML, flags, DATA_VALUE);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	} else if (e->flags & (1 << NFT_EXPR_IMM_VERDICT)) {
-		ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
+		ret = nft_data_reg_snprintf(buf + offset, len, &imm->data,
 					  NFT_OUTPUT_XML, flags, DATA_VERDICT);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	} else if (e->flags & (1 << NFT_EXPR_IMM_CHAIN)) {
-		ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
+		ret = nft_data_reg_snprintf(buf + offset, len, &imm->data,
 					    NFT_OUTPUT_XML, flags, DATA_CHAIN);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
-- 
2.0.0

