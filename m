From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/4] expr: ct: Do not print unset values in xml file
Date: Tue, 24 Jun 2014 08:46:38 +0200
Message-ID: <1403592401-5057-3-git-send-email-anarey@gmail.com>
References: <1403592401-5057-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:52252 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaFXGrF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:47:05 -0400
Received: by mail-we0-f171.google.com with SMTP id q58so8233246wes.30
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 23:47:04 -0700 (PDT)
In-Reply-To: <1403592401-5057-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/ct.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index 0f1c050..49fe238 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -292,24 +292,20 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 	uint32_t dreg, sreg;
 
 	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
-			       NFT_XML_OPT, err) >= 0)
+			       NFT_XML_OPT, err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_CT_DREG, dreg);
 
 	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
-			       NFT_XML_OPT, err) >= 0)
+			       NFT_XML_OPT, err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_CT_SREG, sreg);
 
 	key_str = nft_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST,
 				     NFT_XML_MAND, err);
-	if (key_str == NULL)
-		return -1;
-
-	key = str2ctkey(key_str);
-	if (key < 0)
-		goto err;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_CT_KEY, key);
-
+	if (key_str != NULL) {
+		key = str2ctkey(key_str);
+		if (key >= 0)
+			nft_rule_expr_set_u32(e, NFT_EXPR_CT_KEY, key);
+	}
 	dir_str = nft_mxml_str_parse(tree, "dir", MXML_DESCEND_FIRST,
 				     NFT_XML_OPT, err);
 	if (dir_str != NULL) {
@@ -318,7 +314,6 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 			err->error = NFT_PARSE_EBADTYPE;
 			goto err;
 		}
-
 		nft_rule_expr_set_u8(e, NFT_EXPR_CT_DIR, dir);
 	}
 
@@ -373,23 +368,23 @@ nft_expr_ct_snprintf_xml(char *buf, size_t size, struct nft_rule_expr *e)
 	struct nft_expr_ct *ct = nft_expr_data(e);
 
 	if (e->flags & (1 << NFT_EXPR_CT_DREG)) {
-		ret = snprintf(buf+offset, len, "<dreg>%u</dreg>", ct->dreg);
+		ret = snprintf(buf + offset, len, "<dreg>%u</dreg>", ct->dreg);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (e->flags & (1 << NFT_EXPR_CT_SREG)) {
-		ret = snprintf(buf+offset, len, "<sreg>%u</sreg>", ct->sreg);
+		ret = snprintf(buf + offset, len, "<sreg>%u</sreg>", ct->sreg);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (e->flags & (1 << NFT_EXPR_CT_KEY)) {
-		ret = snprintf(buf+offset, len, "<key>%s</key>",
+		ret = snprintf(buf + offset, len, "<key>%s</key>",
 			       ctkey2str(ct->key));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (nft_rule_expr_is_set(e, NFT_EXPR_CT_DIR)) {
-		ret = snprintf(buf+offset, len, "<dir>%s</dir>",
+		ret = snprintf(buf + offset, len, "<dir>%s</dir>",
 			       ctdir2str(ct->dir));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
-- 
2.0.0

