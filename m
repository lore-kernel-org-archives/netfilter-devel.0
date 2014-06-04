From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/5] expr: reject: Add nft_rule_expr_reject_snprinf_* functions
Date: Wed,  4 Jun 2014 13:38:07 +0200
Message-ID: <1401881891-4990-2-git-send-email-anarey@gmail.com>
References: <1401881891-4990-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43109 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaFDLiW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:38:22 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so1254550wib.13
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jun 2014 04:38:20 -0700 (PDT)
In-Reply-To: <1401881891-4990-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring in nft_rule_expr_reject_snprinf functions. This process
adds three new functions:

* nft_rule_expr_reject_snprinf_default
* nft_rule_expr_reject_snprinf_xml
* nft_rule_expr_reject_snprinf_json

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/reject.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/src/expr/reject.c b/src/expr/reject.c
index 62346e9..cefaf98 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -174,24 +174,46 @@ nft_rule_expr_reject_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #endif
 }
 
+static int nft_rule_expr_reject_snprintf_default(char *buf, size_t len,
+						 struct nft_rule_expr *e)
+{
+	struct nft_expr_reject *reject = nft_expr_data(e);
+
+	return snprintf(buf, len, "type %u code %u  ",
+			reject->type, reject->icmp_code);
+}
+
+static int nft_rule_expr_reject_snprintf_xml(char *buf, size_t len,
+					     struct nft_rule_expr *e)
+{
+	struct nft_expr_reject *reject = nft_expr_data(e);
+
+	return snprintf(buf, len, "<type>%u</type>"
+				  "<code>%u</code>",
+			reject->type, reject->icmp_code);
+}
+
+static int nft_rule_expr_reject_snprintf_json(char *buf, size_t len,
+					      struct nft_rule_expr *e)
+{
+	struct nft_expr_reject *reject = nft_expr_data(e);
+
+	return snprintf(buf, len, "\"type\":%u,"
+				  "\"code\":%u,",
+			reject->type, reject->icmp_code);
+}
+
 static int
 nft_rule_expr_reject_snprintf(char *buf, size_t len, uint32_t type,
 			      uint32_t flags, struct nft_rule_expr *e)
 {
-	struct nft_expr_reject *reject = nft_expr_data(e);
-
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return snprintf(buf, len, "type %u code %u  ",
-				reject->type, reject->icmp_code);
+		return nft_rule_expr_reject_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return snprintf(buf, len, "<type>%u</type>"
-					  "<code>%u</code>",
-				reject->type, reject->icmp_code);
+		return nft_rule_expr_reject_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return snprintf(buf, len, "\"type\":%u,"
-					  "\"code\":%u,",
-				reject->type, reject->icmp_code);
+		return nft_rule_expr_reject_snprintf_json(buf, len, e);
 	default:
 		break;
 	}
-- 
2.0.0.rc2

