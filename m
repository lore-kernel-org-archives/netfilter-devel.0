From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/4] expr: cmp: Do not print unset values in json file
Date: Thu, 19 Jun 2014 19:34:24 +0200
Message-ID: <1403199264-14271-5-git-send-email-anarey@gmail.com>
References: <1403199264-14271-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63179 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040AbaFSReo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:34:44 -0400
Received: by mail-wi0-f174.google.com with SMTP id bs8so9769114wib.7
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 10:34:43 -0700 (PDT)
In-Reply-To: <1403199264-14271-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/cmp.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 5fd02e4..633e114 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -183,26 +183,20 @@ static int nft_rule_expr_cmp_json_parse(struct nft_rule_expr *e, json_t *root,
 	uint32_t uval32;
 	int base;
 
-	if (nft_jansson_parse_val(root, "sreg", NFT_TYPE_U32, &uval32, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_SREG, uval32);
+	if (nft_jansson_parse_val(root, "sreg", NFT_TYPE_U32, &uval32,
+				  err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_CMP_SREG, uval32);
 
 	op = nft_jansson_parse_str(root, "op", err);
-	if (op == NULL)
-		return -1;
-
-	base = nft_str2cmp(op);
-	if (base < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_OP, base);
+	if (op != NULL) {
+		base = nft_str2cmp(op);
+		if (base >= 0)
+			nft_rule_expr_set_u32(e, NFT_EXPR_CMP_OP, base);
+	}
 
 	if (nft_jansson_data_reg_parse(root, "cmpdata",
-				       &cmp->data, err) != DATA_VALUE)
-		return -1;
-
-	e->flags |= (1 << NFT_EXPR_CMP_DATA);
+				       &cmp->data, err) == DATA_VALUE)
+		e->flags |= (1 << NFT_EXPR_CMP_DATA);
 
 	return 0;
 #else
@@ -250,11 +244,16 @@ static int nft_rule_expr_cmp_snprintf_json(char *buf, size_t size,
 	struct nft_expr_cmp *cmp = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "\"sreg\":%u,\"op\":\"%s\",",
-		       cmp->sreg, expr_cmp_str[cmp->op]);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	ret = nft_data_reg_snprintf(buf+offset, len, &cmp->data,
+	if (e->flags & (1 << NFT_EXPR_CMP_SREG)) {
+		ret = snprintf(buf + offset, len, "\"sreg\":%u,", cmp->sreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_CMP_OP)) {
+		ret = snprintf(buf + offset, len, "\"op\":\"%s\",",
+			       expr_cmp_str[cmp->op]);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	ret = nft_data_reg_snprintf(buf + offset, len, &cmp->data,
 				    NFT_OUTPUT_JSON, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-- 
2.0.0

