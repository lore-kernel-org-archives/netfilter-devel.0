From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/3] expr: lookup: Do not print unset values in json file
Date: Tue, 24 Jun 2014 19:14:17 +0200
Message-ID: <1403630057-12996-4-git-send-email-anarey@gmail.com>
References: <1403630057-12996-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57096 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaFXROc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:14:32 -0400
Received: by mail-wi0-f178.google.com with SMTP id n15so1017712wiw.11
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 10:14:31 -0700 (PDT)
In-Reply-To: <1403630057-12996-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/lookup.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index d0d81cb..3f77228 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -164,23 +164,17 @@ nft_rule_expr_lookup_json_parse(struct nft_rule_expr *e, json_t *root,
 {
 #ifdef JSON_PARSING
 	const char *set_name;
-	int32_t reg;
+	uint32_t sreg, dreg;
 
 	set_name = nft_jansson_parse_str(root, "set", err);
-	if (set_name == NULL)
-		return -1;
-
-	nft_rule_expr_set_str(e, NFT_EXPR_LOOKUP_SET, set_name);
-
-	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &reg, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_SREG, reg);
+	if (set_name != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_LOOKUP_SET, set_name);
 
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) < 0)
-		return -1;
+	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &sreg, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_SREG, sreg);
 
-	nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_DREG, reg);
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &dreg, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_DREG, dreg);
 
 	return 0;
 #else
@@ -224,19 +218,25 @@ nft_rule_expr_lookup_snprintf_json(char *buf, size_t size,
 	int len = size, offset = 0, ret;
 	struct nft_expr_lookup *l = nft_expr_data(e);
 
-	ret = snprintf(buf, len, "\"set\":\"%s\",\"sreg\":%u",
-			l->set_name, l->sreg);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_SET)) {
+		ret = snprintf(buf, len, "\"set\":\"%s\",", l->set_name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_SREG)) {
+		ret = snprintf(buf + offset, len, "\"sreg\":%u,", l->sreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 	if (e->flags & (1 << NFT_EXPR_LOOKUP_DREG)) {
-		ret = snprintf(buf+offset, len, ",\"dreg\":%u", l->dreg);
+		ret = snprintf(buf + offset, len, "\"dreg\":%u,", l->dreg);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
+	/* Remove the last comma characther */
+	if (offset > 0)
+		offset--;
 
 	return offset;
 }
 
-
 static int
 nft_rule_expr_lookup_snprintf_xml(char *buf, size_t size,
 				  struct nft_rule_expr *e)
-- 
2.0.0

