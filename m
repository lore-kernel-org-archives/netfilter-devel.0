From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 5/5] expr: reject: Do not print unset values in json
Date: Wed,  4 Jun 2014 13:38:11 +0200
Message-ID: <1401881891-4990-6-git-send-email-anarey@gmail.com>
References: <1401881891-4990-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51775 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaFDLi3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:38:29 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so8172735wib.11
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jun 2014 04:38:27 -0700 (PDT)
In-Reply-To: <1401881891-4990-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

If It uses this rule:
nft add rule ip test output input

It gets this json file:
[...] "expr":[{"type":"reject","type":0,"code":0}]}

Now, That rule creates this json file without null values:
[...] "expr":[{"type":"reject"}]}

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/reject.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/src/expr/reject.c b/src/expr/reject.c
index 8fc99af..39de634 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -130,15 +130,11 @@ nft_rule_expr_reject_json_parse(struct nft_rule_expr *e, json_t *root,
 	uint32_t type;
 	uint8_t code;
 
-	if (nft_jansson_parse_val(root, "type", NFT_TYPE_U32, &type, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_REJECT_TYPE, type);
-
-	if (nft_jansson_parse_val(root, "code", NFT_TYPE_U8, &code, err) < 0)
-		return -1;
+	if (nft_jansson_parse_val(root, "type", NFT_TYPE_U32, &type, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_REJECT_TYPE, type);
 
-	nft_rule_expr_set_u8(e, NFT_EXPR_REJECT_CODE, code);
+	if (nft_jansson_parse_val(root, "code", NFT_TYPE_U8, &code, err) == 0)
+		nft_rule_expr_set_u8(e, NFT_EXPR_REJECT_CODE, code);
 
 	return 0;
 #else
@@ -203,11 +199,24 @@ static int nft_rule_expr_reject_snprintf_xml(char *buf, size_t len,
 static int nft_rule_expr_reject_snprintf_json(char *buf, size_t len,
 					      struct nft_rule_expr *e)
 {
+	int ret, size = len, offset = 0;
 	struct nft_expr_reject *reject = nft_expr_data(e);
 
-	return snprintf(buf, len, "\"type\":%u,"
-				  "\"code\":%u,",
-			reject->type, reject->icmp_code);
+	if (e->flags & (1 << NFT_EXPR_REJECT_TYPE)) {
+		ret = snprintf(buf+offset, len, "\"type\":%u,",
+			       reject->type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_REJECT_CODE)) {
+		ret = snprintf(buf+offset, len, "\"code\":%u,",
+			       reject->icmp_code);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (offset > 0) {
+		return offset-1;
+	}
+	return offset;
 }
 
 static int
-- 
2.0.0.rc2

