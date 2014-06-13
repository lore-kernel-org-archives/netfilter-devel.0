From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/5] expr: queue: Do not print unset values in xml
Date: Fri, 13 Jun 2014 11:31:51 +0200
Message-ID: <1402651913-15065-4-git-send-email-anarey@gmail.com>
References: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39771 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaFMJcJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:32:09 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so2484213wgh.16
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2014 02:32:08 -0700 (PDT)
In-Reply-To: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

This xml file is gotten for a queue:

[...]
<expr type="queue">
	<num>0</num>
	<total>1</total>
	<flags>0</flags>
</expr>
[...]

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/queue.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/src/expr/queue.c b/src/expr/queue.c
index 1d47d48..5235027 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -168,21 +168,18 @@ nft_rule_expr_queue_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 
 	if (nft_mxml_num_parse(tree, "num", MXML_DESCEND_FIRST, BASE_DEC,
 			       &queue_num, NFT_TYPE_U16, NFT_XML_MAND,
-			       err) != 0)
-		return -1;
-	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_NUM, queue_num);
+			       err) == 0)
+		nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_NUM, queue_num);
 
 	if (nft_mxml_num_parse(tree, "total", MXML_DESCEND_FIRST, BASE_DEC,
 			       &queue_total, NFT_TYPE_U8,
-			       NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_TOTAL, queue_total);
+			       NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_TOTAL, queue_total);
 
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
 			       &flags, NFT_TYPE_U8,
-			       NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_FLAGS, flags);
+			       NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_FLAGS, flags);
 
 	return 0;
 #else
@@ -218,13 +215,27 @@ static int nft_rule_expr_queue_snprintf_default(char *buf, size_t len,
 static int nft_rule_expr_queue_snprintf_xml(char *buf, size_t len,
 					    struct nft_rule_expr *e)
 {
+	int ret, size = len, offset = 0;
 	struct nft_expr_queue *queue = nft_expr_data(e);
 
-	return snprintf(buf, len, "<num>%u</num>"
-				  "<total>%u</total>"
-				  "<flags>%u</flags>",
-			queue->queuenum, queue->queues_total,
-			queue->flags);
+
+	if (e->flags & (1 << NFT_EXPR_QUEUE_NUM)) {
+		ret = snprintf(buf + offset, len, "<num>%u</num>",
+			       queue->queuenum);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_QUEUE_TOTAL)) {
+		ret = snprintf(buf + offset, len, "<total>%u</total>",
+			       queue->queues_total);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_QUEUE_FLAGS)) {
+		ret = snprintf(buf + offset, len, "<flags>%u</flags>",
+			       queue->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	return offset;
 }
 
 static int nft_rule_expr_queue_snprintf_json(char *buf, size_t len,
-- 
2.0.0

