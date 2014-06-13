From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 5/5] expr: queue: Use the correct data type.
Date: Fri, 13 Jun 2014 11:31:53 +0200
Message-ID: <1402651913-15065-6-git-send-email-anarey@gmail.com>
References: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36970 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaFMJcM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:32:12 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so1988128wib.5
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2014 02:32:11 -0700 (PDT)
In-Reply-To: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes some data type for their correct type.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/queue.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/expr/queue.c b/src/expr/queue.c
index 55d2ab0..78540b6 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -134,11 +134,12 @@ nft_rule_expr_queue_json_parse(struct nft_rule_expr *e, json_t *root,
 			       struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
-	uint32_t type;
+	uint16_t type;
 	uint16_t code;
 
 	if (nft_jansson_parse_val(root, "num", NFT_TYPE_U16, &type, err) == 0)
-		nft_rule_expr_set_u32(e, NFT_EXPR_QUEUE_NUM, type);
+		nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_NUM, type);
+	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_NUM, type);
 
 	if (nft_jansson_parse_val(root, "total", NFT_TYPE_U16, &code, err) == 0)
 		nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_TOTAL, code);
@@ -166,12 +167,12 @@ nft_rule_expr_queue_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 		nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_NUM, queue_num);
 
 	if (nft_mxml_num_parse(tree, "total", MXML_DESCEND_FIRST, BASE_DEC,
-			       &queue_total, NFT_TYPE_U8,
+			       &queue_total, NFT_TYPE_U16,
 			       NFT_XML_MAND, err) == 0)
 		nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_TOTAL, queue_total);
 
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &flags, NFT_TYPE_U8,
+			       &flags, NFT_TYPE_U16,
 			       NFT_XML_MAND, err) == 0)
 		nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_FLAGS, flags);
 
-- 
2.0.0

