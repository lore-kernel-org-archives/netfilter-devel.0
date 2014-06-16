From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/4] expr: limit: Add nft_rule_expr_limit_snprinf_* functions
Date: Mon, 16 Jun 2014 11:10:14 +0200
Message-ID: <1402909817-25325-2-git-send-email-anarey@gmail.com>
References: <1402909817-25325-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:41095 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaFPJKa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:10:30 -0400
Received: by mail-we0-f180.google.com with SMTP id x48so5304757wes.39
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2014 02:10:29 -0700 (PDT)
In-Reply-To: <1402909817-25325-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring in nft_rule_expr_limit_snprinf functions.
This process adds three new functions:

* nft_rule_expr_limit_snprinf_default
* nft_rule_expr_limit_snprinf_xml
* nft_rule_expr_limit_snprinf_json

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/limit.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/src/expr/limit.c b/src/expr/limit.c
index 7d10340..b7cd32d 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -181,24 +181,44 @@ static const char *get_unit(uint64_t u)
 	return "error";
 }
 
+static int nft_rule_expr_limit_snprintf_xml(char *buf, size_t len,
+					    struct nft_rule_expr *e) {
+	struct nft_expr_limit *limit = nft_expr_data(e);
+
+	return snprintf(buf, len, "<rate>%"PRIu64"</rate>"
+				  "<unit>%"PRIu64"</unit>",
+			limit->rate, limit->unit);
+}
+
+static int nft_rule_expr_limit_snprintf_json(char *buf, size_t len,
+					    struct nft_rule_expr *e) {
+	struct nft_expr_limit *limit = nft_expr_data(e);
+
+	return snprintf(buf, len, "\"rate\":%"PRIu64","
+				  "\"unit\":%"PRIu64"",
+			limit->rate, limit->unit);
+}
+
+static int nft_rule_expr_limit_snprintf_default(char *buf, size_t len,
+						struct nft_rule_expr *e) {
+	struct nft_expr_limit *limit = nft_expr_data(e);
+
+	return snprintf(buf, len, "rate %"PRIu64"/%s ",
+			limit->rate, get_unit(limit->unit));
+}
+
 static int
 nft_rule_expr_limit_snprintf(char *buf, size_t len, uint32_t type,
 			    uint32_t flags, struct nft_rule_expr *e)
 {
-	struct nft_expr_limit *limit = nft_expr_data(e);
 
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return snprintf(buf, len, "rate %"PRIu64"/%s ",
-				limit->rate, get_unit(limit->unit));
+		return nft_rule_expr_limit_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return snprintf(buf, len, "<rate>%"PRIu64"</rate>"
-					  "<unit>%"PRIu64"</unit>",
-				limit->rate, limit->unit);
+		return nft_rule_expr_limit_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return snprintf(buf, len, "\"rate\":%"PRIu64","
-					  "\"unit\":%"PRIu64"",
-				limit->rate, limit->unit);
+		return nft_rule_expr_limit_snprintf_json(buf, len, e);
 	default:
 		break;
 	}
-- 
2.0.0

