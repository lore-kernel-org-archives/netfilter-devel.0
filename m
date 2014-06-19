From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/5] expr: byteorder: Get a nft_rule_expr type in nft_rule_expr_byteorder_snprintf_* functions
Date: Thu, 19 Jun 2014 17:07:06 +0200
Message-ID: <1403190430-22173-2-git-send-email-anarey@gmail.com>
References: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57766 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbaFSPHX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:07:23 -0400
Received: by mail-wi0-f171.google.com with SMTP id n15so9528376wiw.10
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 08:07:22 -0700 (PDT)
In-Reply-To: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring in nft_rule_expr_byteorder_snprintf_* functions to get a
nft_rule_expr type instead of nft_expr_byorder type.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/byteorder.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 4889e80..e42d7b6 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -296,10 +296,10 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #endif
 }
 
-static int
-nft_rule_expr_byteorder_snprintf_json(char *buf, size_t size,
-				       struct nft_expr_byteorder *byteorder)
+static int nft_rule_expr_byteorder_snprintf_json(char *buf, size_t size,
+						 struct nft_rule_expr *e)
 {
+	struct nft_expr_byteorder *byteorder = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "\"sreg\":%u,"
@@ -315,10 +315,10 @@ nft_rule_expr_byteorder_snprintf_json(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nft_rule_expr_byteorder_snprintf_xml(char *buf, size_t size,
-				   struct nft_expr_byteorder *byteorder)
+static int nft_rule_expr_byteorder_snprintf_xml(char *buf, size_t size,
+						struct nft_rule_expr *e)
 {
+	struct nft_expr_byteorder *byteorder = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "<sreg>%u</sreg>"
@@ -334,10 +334,10 @@ nft_rule_expr_byteorder_snprintf_xml(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nft_rule_expr_byteorder_snprintf_default(char *buf, size_t size,
-				       struct nft_expr_byteorder *byteorder)
+static int nft_rule_expr_byteorder_snprintf_default(char *buf, size_t size,
+						    struct nft_rule_expr *e)
 {
+	struct nft_expr_byteorder *byteorder = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "reg %u = %s(reg %u, %u, %u) ",
@@ -350,20 +350,15 @@ nft_rule_expr_byteorder_snprintf_default(char *buf, size_t size,
 
 static int
 nft_rule_expr_byteorder_snprintf(char *buf, size_t size, uint32_t type,
-			       uint32_t flags, struct nft_rule_expr *e)
+				 uint32_t flags, struct nft_rule_expr *e)
 {
-	struct nft_expr_byteorder *byteorder = nft_expr_data(e);
-
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return nft_rule_expr_byteorder_snprintf_default(buf, size,
-								byteorder);
+		return nft_rule_expr_byteorder_snprintf_default(buf, size, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_byteorder_snprintf_xml(buf, size,
-							    byteorder);
+		return nft_rule_expr_byteorder_snprintf_xml(buf, size, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_byteorder_snprintf_json(buf, size,
-							    byteorder);
+		return nft_rule_expr_byteorder_snprintf_json(buf, size, e);
 	default:
 		break;
 	}
-- 
2.0.0

