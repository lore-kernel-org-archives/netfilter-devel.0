From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/4] expr: cmp: Get a nft_rule_expr type in nft_rule_expr_cmp_snprintf_* functions
Date: Thu, 19 Jun 2014 19:34:21 +0200
Message-ID: <1403199264-14271-2-git-send-email-anarey@gmail.com>
References: <1403199264-14271-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:58955 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaFSRek (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:34:40 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so2656128wes.37
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 10:34:39 -0700 (PDT)
In-Reply-To: <1403199264-14271-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring in nft_rule_expr_cmp_snprintf_* functions to get a
nft_rule_expr type instead of nft_expr_cmp type.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/cmp.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 2c334ab..b21fa9d 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -253,9 +253,10 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 #endif
 }
 
-static int
-nft_rule_expr_cmp_snprintf_json(char *buf, size_t size, struct nft_expr_cmp *cmp)
+static int nft_rule_expr_cmp_snprintf_json(char *buf, size_t size,
+					   struct nft_rule_expr *e)
 {
+	struct nft_expr_cmp *cmp = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "\"sreg\":%u,\"op\":\"%s\",",
@@ -269,9 +270,10 @@ nft_rule_expr_cmp_snprintf_json(char *buf, size_t size, struct nft_expr_cmp *cmp
 	return offset;
 }
 
-static int
-nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_expr_cmp *cmp)
+static int nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size,
+					  struct nft_rule_expr *e)
 {
+	struct nft_expr_cmp *cmp = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "<sreg>%u</sreg><op>%s</op>",
@@ -285,10 +287,10 @@ nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_expr_cmp *cmp)
 	return offset;
 }
 
-static int
-nft_rule_expr_cmp_snprintf_default(char *buf, size_t size,
-				   struct nft_expr_cmp *cmp)
+static int nft_rule_expr_cmp_snprintf_default(char *buf, size_t size,
+					      struct nft_rule_expr *e)
 {
+	struct nft_expr_cmp *cmp = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "%s reg %u ",
@@ -306,15 +308,13 @@ static int
 nft_rule_expr_cmp_snprintf(char *buf, size_t size, uint32_t type,
 			   uint32_t flags, struct nft_rule_expr *e)
 {
-	struct nft_expr_cmp *cmp = nft_expr_data(e);
-
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return nft_rule_expr_cmp_snprintf_default(buf, size, cmp);
+		return nft_rule_expr_cmp_snprintf_default(buf, size, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_cmp_snprintf_xml(buf, size, cmp);
+		return nft_rule_expr_cmp_snprintf_xml(buf, size, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_cmp_snprintf_json(buf, size, cmp);
+		return nft_rule_expr_cmp_snprintf_json(buf, size, e);
 	default:
 		break;
 	}
-- 
2.0.0

