From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/4] expr: counter: Do not print unset values in xml
Date: Tue, 24 Jun 2014 09:15:37 +0200
Message-ID: <1403594138-6148-4-git-send-email-anarey@gmail.com>
References: <1403594138-6148-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55481 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaFXHP6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:15:58 -0400
Received: by mail-wg0-f43.google.com with SMTP id b13so7411977wgh.2
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 00:15:57 -0700 (PDT)
In-Reply-To: <1403594138-6148-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/counter.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/src/expr/counter.c b/src/expr/counter.c
index 9d85a96..6f6a7ee 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -150,16 +150,12 @@ nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	uint64_t pkts, bytes;
 
 	if (nft_mxml_num_parse(tree, "pkts", MXML_DESCEND_FIRST, BASE_DEC,
-			       &pkts, NFT_TYPE_U64, NFT_XML_MAND,
-			       err) != 0)
-		return -1;
-	nft_rule_expr_set_u64(e, NFT_EXPR_CTR_PACKETS, pkts);
+			       &pkts, NFT_TYPE_U64, NFT_XML_MAND,  err) == 0)
+		nft_rule_expr_set_u64(e, NFT_EXPR_CTR_PACKETS, pkts);
 
 	if (nft_mxml_num_parse(tree, "bytes", MXML_DESCEND_FIRST, BASE_DEC,
-			       &bytes, NFT_TYPE_U64, NFT_XML_MAND,
-			       err) != 0)
-		return -1;
-	nft_rule_expr_set_u64(e, NFT_EXPR_CTR_BYTES, bytes);
+			       &bytes, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u64(e, NFT_EXPR_CTR_BYTES, bytes);
 
 	return 0;
 #else
@@ -179,11 +175,20 @@ static int nft_rule_expr_counter_snprintf_json(char *buf, size_t len,
 static int nft_rule_expr_counter_snprintf_xml(char *buf, size_t len,
 					      struct nft_rule_expr *e)
 {
+	int ret, size = len, offset = 0;
 	struct nft_expr_counter *ctr = nft_expr_data(e);
 
-	return snprintf(buf, len, "<pkts>%"PRIu64"</pkts>"
-				  "<bytes>%"PRIu64"</bytes>",
-			ctr->pkts, ctr->bytes);
+	if (e->flags & (1 << NFT_EXPR_CTR_PACKETS)) {
+		ret = snprintf(buf, len, "<pkts>%"PRIu64"</pkts>", ctr->pkts);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_CTR_BYTES)) {
+		ret = snprintf(buf + offset, len, "<bytes>%"PRIu64"</bytes>",
+			       ctr->bytes);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 
 static int nft_rule_expr_counter_snprintf_default(char *buf, size_t len,
-- 
2.0.0

