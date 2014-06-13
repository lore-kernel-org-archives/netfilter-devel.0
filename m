From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/5] expr: queue: Use nft_rule_expr_* in the xml
Date: Fri, 13 Jun 2014 11:31:50 +0200
Message-ID: <1402651913-15065-3-git-send-email-anarey@gmail.com>
References: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52379 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaFMJcI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:32:08 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so528329wib.0
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2014 02:32:07 -0700 (PDT)
In-Reply-To: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_* in parse xml functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/queue.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/src/expr/queue.c b/src/expr/queue.c
index 5dad84a..1d47d48 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -164,28 +164,25 @@ nft_rule_expr_queue_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 			      struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_queue *queue = nft_expr_data(e);
+	uint16_t queue_num, queue_total, flags;
 
 	if (nft_mxml_num_parse(tree, "num", MXML_DESCEND_FIRST, BASE_DEC,
-			       &queue->queuenum, NFT_TYPE_U16, NFT_XML_MAND,
+			       &queue_num, NFT_TYPE_U16, NFT_XML_MAND,
 			       err) != 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_QUEUE_NUM);
+	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_NUM, queue_num);
 
 	if (nft_mxml_num_parse(tree, "total", MXML_DESCEND_FIRST, BASE_DEC,
-			       &queue->queues_total, NFT_TYPE_U8,
+			       &queue_total, NFT_TYPE_U8,
 			       NFT_XML_MAND, err) != 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_QUEUE_TOTAL);
+	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_TOTAL, queue_total);
 
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &queue->flags, NFT_TYPE_U8,
+			       &flags, NFT_TYPE_U8,
 			       NFT_XML_MAND, err) != 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_QUEUE_FLAGS);
+	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_FLAGS, flags);
 
 	return 0;
 #else
-- 
2.0.0

