From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/3] expr: immediate: Use nft_rule_expr_set_* in the xml parsing code
Date: Sat, 21 Jun 2014 17:53:41 +0200
Message-ID: <1403366023-6385-2-git-send-email-anarey@gmail.com>
References: <1403366023-6385-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33571 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaFUPyG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2014 11:54:06 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so2144821wiv.15
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2014 08:54:05 -0700 (PDT)
In-Reply-To: <1403366023-6385-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/immediate.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 2ea4636..eab1497 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -229,9 +229,7 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
 			       NFT_XML_MAND, err) != 0)
 		return -1;
-
-	imm->dreg = reg;
-	e->flags |= (1 << NFT_EXPR_IMM_DREG);
+	nft_rule_expr_set_u32(e, NFT_EXPR_IMM_DREG, reg);
 
 	datareg_type = nft_mxml_data_reg_parse(tree, "immediatedata",
 					       &imm->data, NFT_XML_MAND, err);
-- 
2.0.0

