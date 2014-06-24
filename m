From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/4] expr: ct: Do not print unset values in json
Date: Tue, 24 Jun 2014 08:46:41 +0200
Message-ID: <1403592401-5057-6-git-send-email-anarey@gmail.com>
References: <1403592401-5057-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:55526 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaFXGrJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:47:09 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so8167765wes.29
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 23:47:08 -0700 (PDT)
In-Reply-To: <1403592401-5057-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/ct.c | 44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index f2718f9..28ac13b 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -231,44 +231,36 @@ static int nft_rule_expr_ct_json_parse(struct nft_rule_expr *e, json_t *root,
 	int key;
 
 	if (nft_jansson_node_exist(root, "dreg")) {
-		if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) < 0)
-			return -1;
-
-		nft_rule_expr_set_u32(e, NFT_EXPR_CT_DREG, reg);
+		if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg,
+					  err) == 0)
+			nft_rule_expr_set_u32(e, NFT_EXPR_CT_DREG, reg);
 	}
 
 	if (nft_jansson_node_exist(root, "sreg")) {
-		if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &reg, err) < 0)
-			return -1;
-
-		nft_rule_expr_set_u32(e, NFT_EXPR_CT_SREG, reg);
+		if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &reg,
+					  err) == 0)
+			nft_rule_expr_set_u32(e, NFT_EXPR_CT_SREG, reg);
 	}
 
 	if (nft_jansson_node_exist(root, "key")) {
 		key_str = nft_jansson_parse_str(root, "key", err);
-		if (key_str == NULL)
-			return -1;
-
-		key = str2ctkey(key_str);
-		if (key < 0)
-			goto err;
-
-		nft_rule_expr_set_u32(e, NFT_EXPR_CT_KEY, key);
-
+		if (key_str != NULL) {
+			key = str2ctkey(key_str);
+			if (key >= 0)
+				nft_rule_expr_set_u32(e, NFT_EXPR_CT_KEY, key);
+		}
 	}
 
 	if (nft_jansson_node_exist(root, "dir")) {
 		dir_str = nft_jansson_parse_str(root, "dir", err);
-		if (dir_str == NULL)
-			return -1;
-
-		if (str2ctdir(dir_str, &dir) != 0) {
-			err->node_name = "dir";
-			err->error = NFT_PARSE_EBADTYPE;
-			goto err;
-		}
-
+		if (dir_str != NULL) {
+			if (str2ctdir(dir_str, &dir) != 0) {
+				err->node_name = "dir";
+				err->error = NFT_PARSE_EBADTYPE;
+				goto err;
+			}
 		nft_rule_expr_set_u8(e, NFT_EXPR_CT_DIR, dir);
+		}
 	}
 
 	return 0;
-- 
2.0.0

