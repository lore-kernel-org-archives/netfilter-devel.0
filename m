From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/3] expr: nat: Do not print unset values in json file
Date: Fri, 13 Jun 2014 14:08:29 +0200
Message-ID: <1402661309-17839-4-git-send-email-anarey@gmail.com>
References: <1402661309-17839-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48853 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaFMMIv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:08:51 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so750242wib.6
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2014 05:08:50 -0700 (PDT)
In-Reply-To: <1402661309-17839-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse functions to omit unset values.

Now, It possible to use a xml file like this:
[...]
      {
        "type": "nat",
        "nat_type": "snat",
        "family": "ip",
        "sreg_addr_min": 1,
        "sreg_addr_max": 1,
      }

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/nat.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index c10f0ff..0136fca 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -225,28 +225,20 @@ static int nft_rule_expr_nat_json_parse(struct nft_rule_expr *e, json_t *root,
 	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_FAMILY, val32);
 
 	if (nft_jansson_parse_reg(root, "sreg_addr_min", NFT_TYPE_U32,
-				  &reg, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MIN, reg);
+				  &reg, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MIN, reg);
 
 	if (nft_jansson_parse_reg(root, "sreg_addr_max", NFT_TYPE_U32,
-				  &reg, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MAX, reg);
+				  &reg, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MAX, reg);
 
 	if (nft_jansson_parse_reg(root, "sreg_proto_min", NFT_TYPE_U32,
-				  &reg, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MIN, reg);
+				  &reg, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MIN, reg);
 
 	if (nft_jansson_parse_reg(root, "sreg_proto_max", NFT_TYPE_U32,
-				  &reg, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MAX, reg);
+				  &reg, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MAX, reg);
 
 	return 0;
 #else
-- 
2.0.0

