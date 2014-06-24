From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/4] expr: counter: Add nft_rule_expr_counter_snprinf_* functions
Date: Tue, 24 Jun 2014 09:15:35 +0200
Message-ID: <1403594138-6148-2-git-send-email-anarey@gmail.com>
References: <1403594138-6148-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:33468 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFXHP4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:15:56 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so8020561wes.4
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 00:15:54 -0700 (PDT)
In-Reply-To: <1403594138-6148-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring in nft_rule_expr_counter_snprinf functions.

This patch adds three new functions:
 * nft_rule_expr_counter_snprinf_default
 * nft_rule_expr_counter_snprinf_xml
 * nft_rule_expr_counter_snprinf_json

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/counter.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/src/expr/counter.c b/src/expr/counter.c
index 4bb7f1b..65acee3 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -169,23 +169,45 @@ nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	return -1;
 #endif
 }
+static int nft_rule_expr_counter_snprintf_json(char *buf, size_t len,
+					       struct nft_rule_expr *e)
+{
+	struct nft_expr_counter *ctr = nft_expr_data(e);
 
-static int
-nft_rule_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
-			       uint32_t flags, struct nft_rule_expr *e)
+	return snprintf(buf, len, "\"pkts\":%"PRIu64",\"bytes\":%"PRIu64"",
+			ctr->pkts, ctr->bytes);
+}
+
+static int nft_rule_expr_counter_snprintf_xml(char *buf, size_t len,
+					      struct nft_rule_expr *e)
 {
 	struct nft_expr_counter *ctr = nft_expr_data(e);
 
+	return snprintf(buf, len, "<pkts>%"PRIu64"</pkts>"
+				  "<bytes>%"PRIu64"</bytes>",
+			ctr->pkts, ctr->bytes);
+}
+
+static int nft_rule_expr_counter_snprintf_default(char *buf, size_t len,
+						  struct nft_rule_expr *e)
+{
+	struct nft_expr_counter *ctr = nft_expr_data(e);
+
+	return snprintf(buf, len, "pkts %"PRIu64" bytes %"PRIu64" ",
+			ctr->pkts, ctr->bytes);
+}
+
+static int nft_rule_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
+					  uint32_t flags,
+					  struct nft_rule_expr *e)
+{
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return snprintf(buf, len, "pkts %"PRIu64" bytes %"PRIu64" ",
-				ctr->pkts, ctr->bytes);
+		return nft_rule_expr_counter_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return snprintf(buf, len, "<pkts>%"PRIu64"</pkts><bytes>%"PRIu64"</bytes>",
-				ctr->pkts, ctr->bytes);
+		return nft_rule_expr_counter_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return snprintf(buf, len, "\"pkts\":%"PRIu64",\"bytes\":%"PRIu64"",
-				ctr->pkts, ctr->bytes);
+		return nft_rule_expr_counter_snprintf_json(buf, len, e);
 	default:
 		break;
 	}
-- 
2.0.0

