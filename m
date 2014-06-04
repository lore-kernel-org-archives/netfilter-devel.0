From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/5] expr: reject: Do not print unset values in xml
Date: Wed,  4 Jun 2014 13:38:09 +0200
Message-ID: <1401881891-4990-4-git-send-email-anarey@gmail.com>
References: <1401881891-4990-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:52577 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbaFDLiZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:38:25 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so8420982wev.3
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jun 2014 04:38:24 -0700 (PDT)
In-Reply-To: <1401881891-4990-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

If we used this rule:
nft add rule ip test output reject

It gets this xml file:
[...]
<expr type="reject">
	<type>0</type>
	<code>0</code>
</expr>
</rule></nftables>

Now, That rule creates this xml file without null values:

[...]
<expr type="reject">
</expr>
</rule></nftables>

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/reject.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/src/expr/reject.c b/src/expr/reject.c
index 4db3461..5aa555a 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -157,14 +157,12 @@ nft_rule_expr_reject_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	uint8_t code;
 
 	if (nft_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
-			       &type, NFT_TYPE_U32, NFT_XML_MAND, err) < 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_REJECT_TYPE, type);
+			       &type, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_REJECT_TYPE, type);
 
 	if (nft_mxml_num_parse(tree, "code", MXML_DESCEND_FIRST, BASE_DEC,
-			       &code, NFT_TYPE_U8, NFT_XML_MAND, err) < 0)
-		return -1;
-	nft_rule_expr_set_u8(e, NFT_EXPR_REJECT_CODE, code);
+			       &code, NFT_TYPE_U8, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u8(e, NFT_EXPR_REJECT_CODE, code);
 
 	return 0;
 #else
@@ -185,11 +183,21 @@ static int nft_rule_expr_reject_snprintf_default(char *buf, size_t len,
 static int nft_rule_expr_reject_snprintf_xml(char *buf, size_t len,
 					     struct nft_rule_expr *e)
 {
+	int ret, size = len, offset = 0;
 	struct nft_expr_reject *reject = nft_expr_data(e);
 
-	return snprintf(buf, len, "<type>%u</type>"
-				  "<code>%u</code>",
-			reject->type, reject->icmp_code);
+	if (e->flags & (1 << NFT_EXPR_REJECT_TYPE)) {
+		ret = snprintf(buf+offset, len, "<type>%u</type>",
+			       reject->type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_REJECT_CODE)) {
+		ret = snprintf(buf+offset, len, "<code>%u</code>",
+			       reject->icmp_code);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 
 static int nft_rule_expr_reject_snprintf_json(char *buf, size_t len,
-- 
2.0.0.rc2

