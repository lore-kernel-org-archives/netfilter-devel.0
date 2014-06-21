From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/3] expr: immediate: Do not print unset values in json file
Date: Sat, 21 Jun 2014 17:53:42 +0200
Message-ID: <1403366023-6385-3-git-send-email-anarey@gmail.com>
References: <1403366023-6385-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:47788 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaFUPyJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2014 11:54:09 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so4857265wes.8
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2014 08:54:06 -0700 (PDT)
In-Reply-To: <1403366023-6385-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/immediate.c | 49 +++++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index eab1497..b52bd23 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -186,30 +186,26 @@ nft_rule_expr_immediate_json_parse(struct nft_rule_expr *e, json_t *root,
 	int datareg_type;
 	uint32_t reg;
 
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_IMM_DREG, reg);
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_IMM_DREG, reg);
 
 	datareg_type = nft_jansson_data_reg_parse(root, "immediatedata",
 						  &imm->data, err);
-	if (datareg_type < 0)
-		return -1;
-
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
-
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -261,22 +257,23 @@ nft_rule_expr_immediate_snprintf_json(char *buf, size_t len,
 	int size = len, offset = 0, ret;
 	struct nft_expr_immediate *imm = nft_expr_data(e);
 
-	ret = snprintf(buf, len, "\"dreg\":%u,", imm->dreg);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
+	if (e->flags & (1 << NFT_EXPR_IMM_DREG)) {
+		ret = snprintf(buf, len, "\"dreg\":%u,", imm->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	if (e->flags & (1 << NFT_EXPR_IMM_DATA)) {
-		ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
+		ret = nft_data_reg_snprintf(buf + offset, len, &imm->data,
 					    NFT_OUTPUT_JSON, flags, DATA_VALUE);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	} else if (e->flags & (1 << NFT_EXPR_IMM_VERDICT)) {
-		ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
+		ret = nft_data_reg_snprintf(buf + offset, len, &imm->data,
 					  NFT_OUTPUT_JSON, flags, DATA_VERDICT);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	} else if (e->flags & (1 << NFT_EXPR_IMM_CHAIN)) {
-		ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
+		ret = nft_data_reg_snprintf(buf + offset, len, &imm->data,
 					    NFT_OUTPUT_JSON, flags, DATA_CHAIN);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
-- 
2.0.0

