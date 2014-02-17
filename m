From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: compile queue expression support
Date: Mon, 17 Feb 2014 22:01:00 +0100
Message-ID: <1392670860-16011-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59372 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbaBQVBN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:01:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This got lost in 29fd6a1df9 when merging major changes in master
to next-3.14.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/Makefile.am  |    1 +
 src/expr/queue.c |   21 +++++++++++++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 450279f..047bf01 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -32,6 +32,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/meta.c	\
 		      expr/nat.c	\
 		      expr/payload.c	\
+		      expr/queue.c	\
 		      expr/reject.c	\
 		      expr/target.c	\
 		      expr/data_reg.h	\
diff --git a/src/expr/queue.c b/src/expr/queue.c
index c3d0e19..9f269e7 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -130,23 +130,24 @@ nft_rule_expr_queue_parse(struct nft_rule_expr *e, struct nlattr *attr)
 }
 
 static int
-nft_rule_expr_queue_json_parse(struct nft_rule_expr *e, json_t *root)
+nft_rule_expr_queue_json_parse(struct nft_rule_expr *e, json_t *root,
+			       struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	uint32_t type;
 	uint16_t code;
 
-	if (nft_jansson_parse_val(root, "num", NFT_TYPE_U16, &type) < 0)
+	if (nft_jansson_parse_val(root, "num", NFT_TYPE_U16, &type, err) < 0)
 		return -1;
 
 	nft_rule_expr_set_u32(e, NFT_EXPR_QUEUE_NUM, type);
 
-	if (nft_jansson_parse_val(root, "total", NFT_TYPE_U16, &code) < 0)
+	if (nft_jansson_parse_val(root, "total", NFT_TYPE_U16, &code, err) < 0)
 		return -1;
 
 	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_TOTAL, code);
 
-	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U16, &code) < 0)
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U16, &code, err) < 0)
 		return -1;
 
 	nft_rule_expr_set_u16(e, NFT_EXPR_QUEUE_FLAGS, code);
@@ -159,25 +160,29 @@ nft_rule_expr_queue_json_parse(struct nft_rule_expr *e, json_t *root)
 }
 
 static int
-nft_rule_expr_queue_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
+nft_rule_expr_queue_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
+			      struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_queue *queue = nft_expr_data(e);
 
 	if (nft_mxml_num_parse(tree, "num", MXML_DESCEND_FIRST, BASE_DEC,
-			       &queue->queuenum, NFT_TYPE_U16, NFT_XML_MAND) != 0)
+			       &queue->queuenum, NFT_TYPE_U16, NFT_XML_MAND,
+			       err) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_QUEUE_NUM);
 
 	if (nft_mxml_num_parse(tree, "total", MXML_DESCEND_FIRST, BASE_DEC,
-			       &queue->queues_total, NFT_TYPE_U8, NFT_XML_MAND) != 0)
+			       &queue->queues_total, NFT_TYPE_U8,
+			       NFT_XML_MAND, err) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_QUEUE_TOTAL);
 
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &queue->flags, NFT_TYPE_U8, NFT_XML_MAND) != 0)
+			       &queue->flags, NFT_TYPE_U8,
+			       NFT_XML_MAND, err) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_QUEUE_FLAGS);
-- 
1.7.10.4

