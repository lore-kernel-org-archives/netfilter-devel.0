From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/2] src: expr: log: Code refactoring in nft_rule_expr_log_snprintf
Date: Thu, 29 May 2014 13:26:39 +0200
Message-ID: <1401362800-30749-2-git-send-email-anarey@gmail.com>
References: <1401362800-30749-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62770 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaE2L06 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 07:26:58 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so231467wgh.14
        for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2014 04:26:56 -0700 (PDT)
In-Reply-To: <1401362800-30749-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This process adds three new functions:

* nft_rule_expr_log_snprintf_default
* nft_rule_expr_log_snprintf_xml
* nft_rule_expr_log_snprintf_json

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/log.c | 58 ++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index 5119c20..a61a8d3 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -243,32 +243,54 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e,
 #endif
 }
 
+static int nft_rule_expr_log_snprintf_default(char *buf, size_t len,
+					      struct nft_rule_expr *e)
+{
+	struct nft_expr_log *log = nft_expr_data(e);
+
+	return snprintf(buf, len, "prefix '%s' group %u snaplen %u"
+				  "qthreshold %u ",
+			log->prefix, log->group, log->snaplen, log->qthreshold);
+}
+
+static int nft_rule_expr_log_snprintf_xml(char *buf, size_t size,
+					  struct nft_rule_expr *e)
+{
+	struct nft_expr_log *log = nft_expr_data(e);
+
+	return snprintf(buf, size, "<prefix>%s</prefix>"
+				   "<group>%u</group>"
+				   "<snaplen>%u</snaplen>"
+				   "<qthreshold>%u</qthreshold>",
+			log->prefix, log->group,
+			log->snaplen, log->qthreshold);
+}
+
+static int nft_rule_expr_log_snprintf_json(char *buf, size_t len,
+					   struct nft_rule_expr *e)
+{
+	struct nft_expr_log *log = nft_expr_data(e);
+
+	return snprintf(buf, len, "\"prefix\":\"%s\","
+				  "\"group\":%u,"
+				  "\"snaplen\":%u,"
+				  "\"qthreshold\":%u",
+			log->prefix, log->group,
+			log->snaplen, log->qthreshold);
+}
+
+
 static int
 nft_rule_expr_log_snprintf(char *buf, size_t len, uint32_t type,
 			    uint32_t flags, struct nft_rule_expr *e)
 {
-	struct nft_expr_log *log = nft_expr_data(e);
-
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return snprintf(buf, len, "prefix '%s' group %u "
-					  "snaplen %u qthreshold %u ",
-				log->prefix, log->group,
-				log->snaplen, log->qthreshold);
+		return nft_rule_expr_log_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return snprintf(buf, len, "<prefix>%s</prefix>"
-					  "<group>%u</group>"
-					  "<snaplen>%u</snaplen>"
-					  "<qthreshold>%u</qthreshold>",
-				log->prefix, log->group,
-				log->snaplen, log->qthreshold);
+		return nft_rule_expr_log_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return snprintf(buf, len, "\"prefix\":\"%s\","
-					  "\"group\":%u,"
-					  "\"snaplen\":%u,"
-					  "\"qthreshold\":%u",
-				log->prefix, log->group,
-				log->snaplen, log->qthreshold);
+		return nft_rule_expr_log_snprintf_json(buf, len, e);
 	default:
 		break;
 	}
-- 
2.0.0.rc2

