From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/4] expr: counter: Do not print unset values in json
Date: Tue, 24 Jun 2014 09:15:38 +0200
Message-ID: <1403594138-6148-5-git-send-email-anarey@gmail.com>
References: <1403594138-6148-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:50811 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaFXHQC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:16:02 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so7958895wes.24
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 00:16:00 -0700 (PDT)
In-Reply-To: <1403594138-6148-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/counter.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/src/expr/counter.c b/src/expr/counter.c
index 6f6a7ee..5ab9a5a 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -125,15 +125,13 @@ nft_rule_expr_counter_json_parse(struct nft_rule_expr *e, json_t *root,
 #ifdef JSON_PARSING
 	uint64_t uval64;
 
-	if (nft_jansson_parse_val(root, "pkts", NFT_TYPE_U64, &uval64, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u64(e, NFT_EXPR_CTR_PACKETS, uval64);
-
-	if (nft_jansson_parse_val(root, "bytes", NFT_TYPE_U64, &uval64, err) < 0)
-		return -1;
+	if (nft_jansson_parse_val(root, "pkts", NFT_TYPE_U64, &uval64,
+				  err) == 0)
+		nft_rule_expr_set_u64(e, NFT_EXPR_CTR_PACKETS, uval64);
 
-	nft_rule_expr_set_u64(e, NFT_EXPR_CTR_BYTES, uval64);
+	if (nft_jansson_parse_val(root, "bytes", NFT_TYPE_U64, &uval64,
+				  err) == 0)
+		nft_rule_expr_set_u64(e, NFT_EXPR_CTR_BYTES, uval64);
 
 	return 0;
 #else
@@ -166,10 +164,23 @@ nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 static int nft_rule_expr_counter_snprintf_json(char *buf, size_t len,
 					       struct nft_rule_expr *e)
 {
+	int ret, size = len, offset = 0;
 	struct nft_expr_counter *ctr = nft_expr_data(e);
 
-	return snprintf(buf, len, "\"pkts\":%"PRIu64",\"bytes\":%"PRIu64"",
-			ctr->pkts, ctr->bytes);
+	if (e->flags & (1 << NFT_EXPR_CTR_PACKETS)) {
+		ret = snprintf(buf, len,"\"pkts\":%"PRIu64",", ctr->pkts);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_CTR_BYTES)) {
+		ret = snprintf(buf + offset, len, "\"bytes\":%"PRIu64",", ctr->bytes);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	/* Remove the last comma characther */
+	if (offset > 0)
+		offset--;
+
+	return offset;
 }
 
 static int nft_rule_expr_counter_snprintf_xml(char *buf, size_t len,
-- 
2.0.0

