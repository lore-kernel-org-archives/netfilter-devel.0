From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/3] expr: nat: Use nft_rule_expr_set_* in the xml
Date: Fri, 13 Jun 2014 14:08:27 +0200
Message-ID: <1402661309-17839-2-git-send-email-anarey@gmail.com>
References: <1402661309-17839-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45424 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaFMMIt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:08:49 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so2603166wgg.25
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2014 05:08:47 -0700 (PDT)
In-Reply-To: <1402661309-17839-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse xml functions. Also,
It renames some variables for code readability reasons and It converts some
variables from int to uint32_t.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/nat.c | 46 +++++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index 42f2b49..46d5ed7 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -259,10 +259,10 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 				       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_nat *nat = nft_expr_data(e);
 	const char *nat_type;
-	int family, nat_type_value;
-	uint32_t reg;
+	uint32_t family, nat_type_value;
+	uint32_t reg_addr_min, reg_addr_max;
+	uint32_t reg_proto_min, reg_proto_max;
 
 	nat_type = nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST,
 				      NFT_XML_MAND, err);
@@ -272,9 +272,7 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	nat_type_value = nft_str2nat(nat_type);
 	if (nat_type_value < 0)
 		return -1;
-
-	nat->type = nat_type_value;
-	e->flags |= (1 << NFT_EXPR_NAT_TYPE);
+	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_TYPE, nat_type_value);
 
 	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND, err);
@@ -282,37 +280,27 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 		mxmlDelete(tree);
 		return -1;
 	}
+	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_FAMILY, family);
 
-	nat->family = family;
-	e->flags |= (1 << NFT_EXPR_NAT_FAMILY);
-
-	if (nft_mxml_reg_parse(tree, "sreg_addr_min", &reg,
-			       MXML_DESCEND, NFT_XML_MAND, err) != 0)
+	if (nft_mxml_reg_parse(tree, "sreg_addr_min", &reg_addr_min,
+			       MXML_DESCEND, NFT_XML_MAND, err) < 0)
 		return -1;
+	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MIN, reg_addr_min);
 
-	nat->sreg_addr_min = reg;
-	e->flags |= (1 << NFT_EXPR_NAT_REG_ADDR_MIN);
-
-	if (nft_mxml_reg_parse(tree, "sreg_addr_max", &reg,
-			       MXML_DESCEND, NFT_XML_MAND, err) != 0)
+	if (nft_mxml_reg_parse(tree, "sreg_addr_max", &reg_addr_max,
+			       MXML_DESCEND, NFT_XML_MAND, err) < 0)
 		return -1;
+	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MAX, reg_addr_max);
 
-	nat->sreg_addr_max = reg;
-	e->flags |= (1 << NFT_EXPR_NAT_REG_ADDR_MAX);
-
-	if (nft_mxml_reg_parse(tree, "sreg_proto_min", &reg,
-			       MXML_DESCEND, NFT_XML_MAND, err) != 0)
+	if (nft_mxml_reg_parse(tree, "sreg_proto_min", &reg_proto_min,
+			       MXML_DESCEND, NFT_XML_MAND, err) < 0)
 		return -1;
+	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MIN, reg_proto_min);
 
-	nat->sreg_proto_min = reg;
-	e->flags |= (1 << NFT_EXPR_NAT_REG_PROTO_MIN);
-
-	if (nft_mxml_reg_parse(tree, "sreg_proto_max", &reg,
-			       MXML_DESCEND, NFT_XML_MAND, err) != 0)
+	if (nft_mxml_reg_parse(tree, "sreg_proto_max", &reg_proto_max,
+			       MXML_DESCEND, NFT_XML_MAND, err) < 0)
 		return -1;
-
-	nat->sreg_proto_max = reg;
-	e->flags |= (1 << NFT_EXPR_NAT_REG_PROTO_MAX);
+	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MAX, reg_proto_max);
 
 	return 0;
 #else
-- 
2.0.0

