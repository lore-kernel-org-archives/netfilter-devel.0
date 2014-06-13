From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/5] expr: queue: Do not print unset values in json
Date: Fri, 13 Jun 2014 11:31:52 +0200
Message-ID: <1402651913-15065-5-git-send-email-anarey@gmail.com>
References: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50589 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaFMJcL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:32:11 -0400
Received: by mail-wg0-f50.google.com with SMTP id x13so2488634wgg.9
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2014 02:32:10 -0700 (PDT)
In-Reply-To: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

This json file is gotten for a queue:

{"expr":[{"type":"queue","num":0,"total":1,"flags":0}]}

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/queue.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/src/expr/queue.c b/src/expr/queue.c
index 5235027..55d2ab0 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -137,20 +137,14 @@ nft_rule_expr_queue_json_parse(struct nft_rule_expr *e, json_t *root,
 	uint32_t type;
 	uint16_t code;
 
-	if (nft_jansson_parse_val(root, "num", NFT_TYPE_U16, &type, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_QUEUE_NUM, type);
-
-	if (nft_jansson_parse_val(root, "total", NFT_TYPE_U16, &code, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_TOTAL, code);
+	if (nft_jansson_parse_val(root, "num", NFT_TYPE_U16, &type, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_QUEUE_NUM, type);
 
-	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U16, &code, err) < 0)
-		return -1;
+	if (nft_jansson_parse_val(root, "total", NFT_TYPE_U16, &code, err) == 0)
+		nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_TOTAL, code);
 
-	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_FLAGS, code);
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U16, &code, err) == 0)
+		nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_FLAGS, code);
 
 	return 0;
 #else
@@ -241,13 +235,31 @@ static int nft_rule_expr_queue_snprintf_xml(char *buf, size_t len,
 static int nft_rule_expr_queue_snprintf_json(char *buf, size_t len,
 					     struct nft_rule_expr *e)
 {
+	int ret, size = len, offset = 0;
 	struct nft_expr_queue *queue = nft_expr_data(e);
 
-	return snprintf(buf, len, "\"num\":%u,"
-				  "\"total\":%u,"
-				  "\"flags\":%u,",
-			queue->queuenum, queue->queues_total,
-			queue->flags);
+	if (e->flags & (1 << NFT_EXPR_QUEUE_NUM)) {
+		ret = snprintf(buf + offset, len, "\"num\":%u,",
+			       queue->queuenum);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_QUEUE_TOTAL)) {
+		ret = snprintf(buf + offset, len, "\"total\":%u,",
+			       queue->queues_total);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_QUEUE_FLAGS)) {
+		ret = snprintf(buf + offset, len, "\"flags\":%u,",
+			       queue->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	/* Remove the last comma characther */
+	if (offset > 0)
+		offset--;
+
+	return offset;
 }
 
 static int
-- 
2.0.0

