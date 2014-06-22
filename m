From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/4] expr: payload: Do not print unset values in xml file
Date: Sun, 22 Jun 2014 20:32:20 +0200
Message-ID: <1403461941-21605-4-git-send-email-anarey@gmail.com>
References: <1403461941-21605-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60477 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaFVScg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:32:36 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so3000376wib.11
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2014 11:32:35 -0700 (PDT)
In-Reply-To: <1403461941-21605-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/payload.c | 54 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/src/expr/payload.c b/src/expr/payload.c
index 6c08e48..3cf2362 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -247,32 +247,25 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	uint32_t dreg, offset, len;
 
 	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
-			       NFT_XML_MAND, err) != 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, dreg);
+			       NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, dreg);
 
 	base_str = nft_mxml_str_parse(tree, "base", MXML_DESCEND_FIRST,
 				      NFT_XML_MAND, err);
-	if (base_str == NULL)
-		return -1;
-
-	base = nft_str2base(base_str);
-	if (base < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_BASE, base);
+	if (base_str != NULL) {
+		base = nft_str2base(base_str);
+		if (base >= 0)
+			nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_BASE, base);
+	}
 
 	if (nft_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
-			       &offset, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET, offset);
+			       &offset, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET, offset);
 
 
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &len, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, len);
+			       &len, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, len);
 
 	return 0;
 #else
@@ -288,13 +281,24 @@ nft_rule_expr_payload_snprintf_xml(char *buf, size_t len, uint32_t flags,
 	struct nft_expr_payload *payload = nft_expr_data(e);
 	int size = len, offset = 0, ret;
 
-	ret = snprintf(buf, len, "<dreg>%u</dreg>"
-				 "<offset>%u</offset>"
-				 "<len>%u</len>"
-				 "<base>%s</base>",
-		       payload->dreg, payload->offset, payload->len,
-		       base2str(payload->base));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_PAYLOAD_DREG)) {
+		ret = snprintf(buf, len, "<dreg>%u</dreg>", payload->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_PAYLOAD_OFFSET)) {
+		ret = snprintf(buf + offset, len, "<offset>%u</offset>",
+			       payload->offset);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_PAYLOAD_LEN)) {
+		ret = snprintf(buf + offset, len, "<len>%u</len>", payload->len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_PAYLOAD_BASE)) {
+		ret = snprintf(buf + offset, len, "<base>%s</base>",
+			       base2str(payload->base));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	return offset;
 }
-- 
2.0.0

