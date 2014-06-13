From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/3] expr: nat: Do not print unset values in xml file
Date: Fri, 13 Jun 2014 14:08:28 +0200
Message-ID: <1402661309-17839-3-git-send-email-anarey@gmail.com>
References: <1402661309-17839-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34328 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaFMMIu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:08:50 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so751712wib.17
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2014 05:08:49 -0700 (PDT)
In-Reply-To: <1402661309-17839-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse functions to omit unset values.

Now, It possible to use a xml file like this:
[...]
<expr type="nat">
        <type>snat</type>
        <family>ip</family>
        <sreg_addr_min>1</sreg_addr_min>
        <sreg_addr_max>1</sreg_addr_max>
</expr></rule>

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/nat.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index 46d5ed7..c10f0ff 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -283,24 +283,20 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_FAMILY, family);
 
 	if (nft_mxml_reg_parse(tree, "sreg_addr_min", &reg_addr_min,
-			       MXML_DESCEND, NFT_XML_MAND, err) < 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MIN, reg_addr_min);
+			       MXML_DESCEND, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MIN, reg_addr_min);
 
 	if (nft_mxml_reg_parse(tree, "sreg_addr_max", &reg_addr_max,
-			       MXML_DESCEND, NFT_XML_MAND, err) < 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MAX, reg_addr_max);
+			       MXML_DESCEND, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MAX, reg_addr_max);
 
 	if (nft_mxml_reg_parse(tree, "sreg_proto_min", &reg_proto_min,
-			       MXML_DESCEND, NFT_XML_MAND, err) < 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MIN, reg_proto_min);
+			       MXML_DESCEND, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MIN, reg_proto_min);
 
 	if (nft_mxml_reg_parse(tree, "sreg_proto_max", &reg_proto_max,
-			       MXML_DESCEND, NFT_XML_MAND, err) < 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MAX, reg_proto_max);
+			       MXML_DESCEND, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MAX, reg_proto_max);
 
 	return 0;
 #else
-- 
2.0.0

