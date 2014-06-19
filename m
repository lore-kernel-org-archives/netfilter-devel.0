From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/5] expr: byteorder: Rename variables in nft_rule_expr_byteorder_json_parse functions
Date: Thu, 19 Jun 2014 17:07:09 +0200
Message-ID: <1403190430-22173-5-git-send-email-anarey@gmail.com>
References: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:53736 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbaFSPH2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:07:28 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so2525358wes.3
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 08:07:26 -0700 (PDT)
In-Reply-To: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Renames some variables for code readability reasons.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/byteorder.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index ad7721f..e56af3f 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -199,18 +199,18 @@ nft_rule_expr_byteorder_json_parse(struct nft_rule_expr *e, json_t *root,
 {
 #ifdef JSON_PARSING
 	const char *op;
-	uint32_t uval32;
+	uint32_t sreg, dreg, len, size;
 	int ntoh;
 
-	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &uval32, err) < 0)
+	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &sreg, err) < 0)
 		return -1;
 
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SREG, uval32);
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SREG, sreg);
 
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &uval32, err) < 0)
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &dreg, err) < 0)
 		return -1;
 
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_DREG, uval32);
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_DREG, dreg);
 
 	op = nft_jansson_parse_str(root, "op", err);
 	if (op == NULL)
@@ -222,15 +222,15 @@ nft_rule_expr_byteorder_json_parse(struct nft_rule_expr *e, json_t *root,
 
 	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_OP, ntoh);
 
-	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &uval32, err) < 0)
+	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &len, err) < 0)
 		return -1;
 
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_LEN, uval32);
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_LEN, len);
 
-	if (nft_jansson_parse_val(root, "size", NFT_TYPE_U32, &uval32, err) < 0)
+	if (nft_jansson_parse_val(root, "size", NFT_TYPE_U32, &size, err) < 0)
 		return -1;
 
-	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SIZE, uval32);
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SIZE, size);
 
 	return 0;
 #else
-- 
2.0.0

