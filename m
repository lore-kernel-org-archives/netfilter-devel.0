From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/4] expr: limit: Use nft_rule_expr_set_* in the xml parsing code
Date: Mon, 16 Jun 2014 11:10:15 +0200
Message-ID: <1402909817-25325-3-git-send-email-anarey@gmail.com>
References: <1402909817-25325-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33745 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaFPJKb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:10:31 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so5147566wgg.17
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2014 02:10:30 -0700 (PDT)
In-Reply-To: <1402909817-25325-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/limit.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/src/expr/limit.c b/src/expr/limit.c
index b7cd32d..6e0a732 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -146,21 +146,19 @@ static int nft_rule_expr_limit_xml_parse(struct nft_rule_expr *e,
 					 struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_limit *limit = nft_expr_data(e);
+	uint64_t rate, unit;
 
 	if (nft_mxml_num_parse(tree, "rate", MXML_DESCEND_FIRST, BASE_DEC,
-			       &limit->rate, NFT_TYPE_U64, NFT_XML_MAND,
-			       err) != 0)
+			       &rate, NFT_TYPE_U64, NFT_XML_MAND,
+			       err) < 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_LIMIT_RATE);
+	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_RATE, rate);
 
 	if (nft_mxml_num_parse(tree, "unit", MXML_DESCEND_FIRST, BASE_DEC,
-			       &limit->unit, NFT_TYPE_U64, NFT_XML_MAND,
-			       err) != 0)
+			       &unit, NFT_TYPE_U64, NFT_XML_MAND,
+			       err) < 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_LIMIT_UNIT);
+	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_UNIT, unit);
 
 	return 0;
 #else
-- 
2.0.0

