From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/5] expr: reject: Use nft_rule_expr_set_* in the xml and default parsing code
Date: Wed,  4 Jun 2014 13:38:08 +0200
Message-ID: <1401881891-4990-3-git-send-email-anarey@gmail.com>
References: <1401881891-4990-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:61265 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaFDLiX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:38:23 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so8476267wes.0
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jun 2014 04:38:22 -0700 (PDT)
In-Reply-To: <1401881891-4990-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/reject.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/src/expr/reject.c b/src/expr/reject.c
index cefaf98..4db3461 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -103,19 +103,20 @@ nft_rule_expr_reject_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 static int
 nft_rule_expr_reject_parse(struct nft_rule_expr *e, struct nlattr *attr)
 {
-	struct nft_expr_reject *reject = nft_expr_data(e);
 	struct nlattr *tb[NFTA_REJECT_MAX+1] = {};
+	uint32_t type;
+	uint8_t code;
 
 	if (mnl_attr_parse_nested(attr, nft_rule_expr_reject_cb, tb) < 0)
 		return -1;
 
 	if (tb[NFTA_REJECT_TYPE]) {
-		reject->type = ntohl(mnl_attr_get_u32(tb[NFTA_REJECT_TYPE]));
-		e->flags |= (1 << NFT_EXPR_REJECT_TYPE);
+		type = ntohl(mnl_attr_get_u32(tb[NFTA_REJECT_TYPE]));
+		nft_rule_expr_set_u32(e, NFT_EXPR_REJECT_TYPE, type);
 	}
 	if (tb[NFTA_REJECT_ICMP_CODE]) {
-		reject->icmp_code = mnl_attr_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
-		e->flags |= (1 << NFT_EXPR_REJECT_CODE);
+		code = mnl_attr_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
+		nft_rule_expr_set_u8(e, NFT_EXPR_REJECT_CODE, code);
 	}
 
 	return 0;
@@ -151,21 +152,19 @@ nft_rule_expr_reject_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 			       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_reject *reject = nft_expr_data(e);
+
+	uint32_t type;
+	uint8_t code;
 
 	if (nft_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
-			       &reject->type, NFT_TYPE_U32, NFT_XML_MAND,
-			       err) != 0)
+			       &type, NFT_TYPE_U32, NFT_XML_MAND, err) < 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_REJECT_TYPE);
+	nft_rule_expr_set_u32(e, NFT_EXPR_REJECT_TYPE, type);
 
 	if (nft_mxml_num_parse(tree, "code", MXML_DESCEND_FIRST, BASE_DEC,
-			       &reject->icmp_code, NFT_TYPE_U8, NFT_XML_MAND,
-			       err) != 0)
+			       &code, NFT_TYPE_U8, NFT_XML_MAND, err) < 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_REJECT_CODE);
+	nft_rule_expr_set_u8(e, NFT_EXPR_REJECT_CODE, code);
 
 	return 0;
 #else
-- 
2.0.0.rc2

