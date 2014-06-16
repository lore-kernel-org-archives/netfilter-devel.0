From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/4] expr: limit: Do not print unset values in xml
Date: Mon, 16 Jun 2014 11:10:17 +0200
Message-ID: <1402909817-25325-5-git-send-email-anarey@gmail.com>
References: <1402909817-25325-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:48552 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaFPJKe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:10:34 -0400
Received: by mail-we0-f171.google.com with SMTP id q58so5400152wes.16
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2014 02:10:33 -0700 (PDT)
In-Reply-To: <1402909817-25325-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

Now, This part of a xml file is gotten without unset elements.

<expr type="limit">
	<rate>400</rate>
	<unit>60</unit>
</expr>

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/limit.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/src/expr/limit.c b/src/expr/limit.c
index 6732318..3410597 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -145,16 +145,12 @@ static int nft_rule_expr_limit_xml_parse(struct nft_rule_expr *e,
 	uint64_t rate, unit;
 
 	if (nft_mxml_num_parse(tree, "rate", MXML_DESCEND_FIRST, BASE_DEC,
-			       &rate, NFT_TYPE_U64, NFT_XML_MAND,
-			       err) < 0)
-		return -1;
-	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_RATE, rate);
+			       &rate, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_RATE, rate);
 
 	if (nft_mxml_num_parse(tree, "unit", MXML_DESCEND_FIRST, BASE_DEC,
-			       &unit, NFT_TYPE_U64, NFT_XML_MAND,
-			       err) < 0)
-		return -1;
-	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_UNIT, unit);
+			       &unit, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_UNIT, unit);
 
 	return 0;
 #else
@@ -178,10 +174,20 @@ static const char *get_unit(uint64_t u)
 static int nft_rule_expr_limit_snprintf_xml(char *buf, size_t len,
 					    struct nft_rule_expr *e) {
 	struct nft_expr_limit *limit = nft_expr_data(e);
+	int ret, size = len, offset = 0;
 
-	return snprintf(buf, len, "<rate>%"PRIu64"</rate>"
-				  "<unit>%"PRIu64"</unit>",
-			limit->rate, limit->unit);
+	if (e->flags & (1 << NFT_EXPR_LIMIT_RATE)) {
+		ret = snprintf(buf + offset, len, "<rate>%"PRIu64"</rate>",
+			       limit->rate);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_LIMIT_UNIT)) {
+		ret = snprintf(buf + offset, len, "<unit>%"PRIu64"</unit>",
+			       limit->unit);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 
 static int nft_rule_expr_limit_snprintf_json(char *buf, size_t len,
-- 
2.0.0

