From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/4] expr: payload: Do not print unset values in json file
Date: Sun, 22 Jun 2014 20:32:21 +0200
Message-ID: <1403461941-21605-5-git-send-email-anarey@gmail.com>
References: <1403461941-21605-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:38712 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaFVSch (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:32:37 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so5913100wes.36
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2014 11:32:36 -0700 (PDT)
In-Reply-To: <1403461941-21605-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/payload.c | 56 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/src/expr/payload.c b/src/expr/payload.c
index 3cf2362..3f89ca3 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -170,14 +170,25 @@ nft_rule_expr_payload_snprintf_json(char *buf, size_t len, uint32_t flags,
 	struct nft_expr_payload *payload = nft_expr_data(e);
 	int size = len, offset = 0, ret;
 
-	ret = snprintf(buf, len, "\"dreg\":%u,"
-				 "\"offset\":%u,"
-				 "\"len\":%u,"
-				 "\"base\":\"%s\"",
-		       payload->dreg, payload->offset, payload->len,
-		       base2str(payload->base));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_PAYLOAD_DREG)) {
+		ret = snprintf(buf, len, "\"dreg\":%u,", payload->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_PAYLOAD_OFFSET)) {
+		ret = snprintf(buf + offset, len, "\"offset\":%u,",
+			       payload->offset);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_PAYLOAD_LEN)) {
+		ret = snprintf(buf + offset, len, "\"len\":%u,", payload->len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_PAYLOAD_BASE)) {
+		ret = snprintf(buf + offset, len, "\"base\":\"%s\"",
+			       base2str(payload->base));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 	return offset;
 }
 
@@ -204,31 +215,22 @@ nft_rule_expr_payload_json_parse(struct nft_rule_expr *e, json_t *root,
 	uint32_t reg, uval32;
 	int base;
 
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, reg);
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, reg);
 
 	base_str = nft_jansson_parse_str(root, "base", err);
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
 
 	if (nft_jansson_parse_val(root, "offset", NFT_TYPE_U32, &uval32,
-				  err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET, uval32);
-
-	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &uval32, err) < 0)
-		return -1;
+				  err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET, uval32);
 
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, uval32);
+	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &uval32, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, uval32);
 
 	return 0;
 #else
-- 
2.0.0

