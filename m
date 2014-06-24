From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/4] expr: counter: Use nft_rule_expr_set_* in the xml parsing code
Date: Tue, 24 Jun 2014 09:15:36 +0200
Message-ID: <1403594138-6148-3-git-send-email-anarey@gmail.com>
References: <1403594138-6148-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58146 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaFXHP5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:15:57 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so7352602wgg.13
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 00:15:55 -0700 (PDT)
In-Reply-To: <1403594138-6148-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/counter.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/src/expr/counter.c b/src/expr/counter.c
index 65acee3..9d85a96 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -147,21 +147,19 @@ nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 				struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_counter *ctr = nft_expr_data(e);
+	uint64_t pkts, bytes;
 
 	if (nft_mxml_num_parse(tree, "pkts", MXML_DESCEND_FIRST, BASE_DEC,
-			       &ctr->pkts, NFT_TYPE_U64, NFT_XML_MAND,
+			       &pkts, NFT_TYPE_U64, NFT_XML_MAND,
 			       err) != 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_CTR_PACKETS);
+	nft_rule_expr_set_u64(e, NFT_EXPR_CTR_PACKETS, pkts);
 
 	if (nft_mxml_num_parse(tree, "bytes", MXML_DESCEND_FIRST, BASE_DEC,
-			       &ctr->bytes, NFT_TYPE_U64, NFT_XML_MAND,
+			       &bytes, NFT_TYPE_U64, NFT_XML_MAND,
 			       err) != 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_CTR_BYTES);
+	nft_rule_expr_set_u64(e, NFT_EXPR_CTR_BYTES, bytes);
 
 	return 0;
 #else
-- 
2.0.0

