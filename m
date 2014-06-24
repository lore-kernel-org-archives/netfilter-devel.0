From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/4] expr: exthdr: Add nft_rule_expr_exthdr_snprinf_* functions
Date: Tue, 24 Jun 2014 14:33:44 +0200
Message-ID: <1403613227-14134-2-git-send-email-anarey@gmail.com>
References: <1403613227-14134-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:65207 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaFXMeF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:34:05 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so280437wgg.8
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 05:34:01 -0700 (PDT)
In-Reply-To: <1403613227-14134-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring in nft_rule_expr_exthdr functions.

This patch adds three new functions:
* nft_rule_expr_exthdr_snprinf_default
* nft_rule_expr_exthdr_snprinf_xml
* nft_rule_expr_exthdr_snprinf_json

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/exthdr.c | 56 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 66a6cf5..ad80826 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -285,32 +285,52 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #endif
 }
 
+static int nft_rule_expr_exthdr_snprintf_json(char *buf, size_t len,
+					      struct nft_rule_expr *e)
+{
+	struct nft_expr_exthdr *exthdr = nft_expr_data(e);
+
+	return snprintf(buf, len, "\"dreg\":%u,"
+				  "\"exthdr_type\":\"%s\",\"offset\":%u,"
+				  "\"len\":%u",
+			exthdr->dreg, exthdr_type2str(exthdr->type),
+			exthdr->offset, exthdr->len);
+}
+
+static int nft_rule_expr_exthdr_snprintf_xml(char *buf, size_t len,
+					     struct nft_rule_expr *e)
+{
+	struct nft_expr_exthdr *exthdr = nft_expr_data(e);
+
+	return snprintf(buf, len, "<dreg>%u</dreg>"
+				  "<exthdr_type>%s</exthdr_type>"
+				  "<offset>%u</offset>"
+				  "<len>%u</len>",
+			exthdr->dreg, exthdr_type2str(exthdr->type),
+			exthdr->offset, exthdr->len);
+}
+
+static int nft_rule_expr_exthdr_snprintf_default(char *buf, size_t len,
+						 struct nft_rule_expr *e)
+{
+	struct nft_expr_exthdr *exthdr = nft_expr_data(e);
+
+	return snprintf(buf, len, "load %ub @ %u + %u => reg %u ",
+			exthdr->len, exthdr->type, exthdr->offset,
+			exthdr->dreg);
+}
+
 static int
 nft_rule_expr_exthdr_snprintf(char *buf, size_t len, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)
 {
-	struct nft_expr_exthdr *exthdr = nft_expr_data(e);
-
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return snprintf(buf, len, "load %ub @ %u + %u => reg %u ",
-				exthdr->len, exthdr->type,
-				exthdr->offset, exthdr->dreg);
+		return nft_rule_expr_exthdr_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return snprintf(buf, len, "<dreg>%u</dreg>"
-					  "<exthdr_type>%s</exthdr_type>"
-					  "<offset>%u</offset>"
-					  "<len>%u</len>",
-					exthdr->dreg,
-					exthdr_type2str(exthdr->type),
-					exthdr->offset, exthdr->len);
+		return nft_rule_expr_exthdr_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return snprintf(buf, len, "\"dreg\":%u,"
-					  "\"exthdr_type\":\"%s\",\"offset\":%u,"
-					  "\"len\":%u",
-					exthdr->dreg,
-					exthdr_type2str(exthdr->type),
-					exthdr->offset, exthdr->len);
+		return nft_rule_expr_exthdr_snprintf_json(buf, len, e);
 	default:
 		break;
 	}
-- 
2.0.0

