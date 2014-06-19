From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/3] expr: bitwise: Get a nft_rule_expr type in nft_rule_expr_bitwise_snprintf_* functions
Date: Thu, 19 Jun 2014 12:05:37 +0200
Message-ID: <1403172339-29786-2-git-send-email-anarey@gmail.com>
References: <1403172339-29786-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:38601 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaFSKFv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:05:51 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so2115896wes.13
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 03:05:50 -0700 (PDT)
In-Reply-To: <1403172339-29786-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring in nft_rule_expr_bitwise_snprintf_* functions to get a
nft_rule_expr type instead of nft_expr_bitwise type.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/bitwise.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index c8fd0ec..148ee08 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -279,11 +279,11 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #endif
 }
 
-static int
-nft_rule_expr_bitwise_snprintf_json(char *buf, size_t size,
-				   struct nft_expr_bitwise *bitwise)
+static int nft_rule_expr_bitwise_snprintf_json(char *buf, size_t size,
+					       struct nft_rule_expr *e)
 {
 	int len = size, offset = 0, ret;
+	struct nft_expr_bitwise *bitwise = nft_expr_data(e);
 
 	ret = snprintf(buf, len, "\"sreg\":%u,"
 				 "\"dreg\":%u,"
@@ -311,10 +311,10 @@ nft_rule_expr_bitwise_snprintf_json(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
-				   struct nft_expr_bitwise *bitwise)
+static int nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
+					      struct nft_rule_expr *e)
 {
+	struct nft_expr_bitwise *bitwise = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "<sreg>%u</sreg>"
@@ -343,10 +343,10 @@ nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nft_rule_expr_bitwise_snprintf_default(char *buf, size_t size,
-				       struct nft_expr_bitwise *bitwise)
+static int nft_rule_expr_bitwise_snprintf_default(char *buf, size_t size,
+						  struct nft_rule_expr *e)
 {
+	struct nft_expr_bitwise *bitwise = nft_expr_data(e);
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "reg %u = (reg=%u & ",
@@ -371,16 +371,13 @@ static int
 nft_rule_expr_bitwise_snprintf(char *buf, size_t size, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)
 {
-	struct nft_expr_bitwise *bitwise = nft_expr_data(e);
-
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return nft_rule_expr_bitwise_snprintf_default(buf, size,
-							      bitwise);
+		return nft_rule_expr_bitwise_snprintf_default(buf, size, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_bitwise_snprintf_xml(buf, size, bitwise);
+		return nft_rule_expr_bitwise_snprintf_xml(buf, size, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_bitwise_snprintf_json(buf, size, bitwise);
+		return nft_rule_expr_bitwise_snprintf_json(buf, size, e);
 	default:
 		break;
 	}
-- 
2.0.0

