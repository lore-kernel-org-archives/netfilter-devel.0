From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/4] expr: meta: Do not print unset values in xml file
Date: Sat, 21 Jun 2014 18:29:58 +0200
Message-ID: <1403368200-8860-3-git-send-email-anarey@gmail.com>
References: <1403368200-8860-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:45855 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaFUQaQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2014 12:30:16 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so5050770wes.13
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2014 09:30:13 -0700 (PDT)
In-Reply-To: <1403368200-8860-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/meta.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/src/expr/meta.c b/src/expr/meta.c
index c325742..25026a9 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -231,20 +231,18 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_node_t *tr
 
 	key_str = nft_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST,
 				     NFT_XML_MAND, err);
-	if (key_str == NULL)
-		return -1;
-
-	key = str2meta_key(key_str);
-	if (key < 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_META_KEY, key);
+	if (key_str != NULL) {
+		key = str2meta_key(key_str);
+		if (key >= 0)
+			nft_rule_expr_set_u32(e, NFT_EXPR_META_KEY, key);
+	}
 
 	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
-			       NFT_XML_OPT, err) >= 0)
+			       NFT_XML_OPT, err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_META_DREG, dreg);
 
 	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
-			       NFT_XML_OPT, err) >= 0)
+			       NFT_XML_OPT, err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_META_SREG, sreg);
 
 	return 0;
@@ -279,19 +277,18 @@ nft_rule_expr_meta_snprintf_xml(char *buf, size_t size,
 	struct nft_expr_meta *meta = nft_expr_data(e);
 
 	if (e->flags & (1 << NFT_EXPR_META_DREG)) {
-		ret = snprintf(buf+offset, len, "<dreg>%u</dreg>",
-			       meta->dreg);
+		ret = snprintf(buf, len, "<dreg>%u</dreg>", meta->dreg);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (e->flags & (1 << NFT_EXPR_META_KEY)) {
-		ret = snprintf(buf+offset, len, "<key>%s</key>",
-						meta_key2str(meta->key));
+		ret = snprintf(buf + offset, len, "<key>%s</key>",
+			       meta_key2str(meta->key));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (e->flags & (1 << NFT_EXPR_META_SREG)) {
-		ret = snprintf(buf+offset, len, "<sreg>%u</sreg>",
+		ret = snprintf(buf + offset, len, "<sreg>%u</sreg>",
 			       meta->sreg);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
-- 
2.0.0

