From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] immediate: xml: fix name inconsistency
Date: Thu, 25 Jul 2013 22:54:11 +0200
Message-ID: <20130725205411.22962.57274.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:33451 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752713Ab3GYUyU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:54:20 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 1ADED51EE82
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 20:54:19 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0w2ljF6y+REO for <netfilter-devel@vger.kernel.org>;
	Thu, 25 Jul 2013 22:54:14 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 071AB51EDBE
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 22:54:14 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

<immdata> must be <immediatedata>.

This bug was introduced at (1e8e5d4 src: xml: consolidate parsing of data_reg via nft_mxml_data_reg_parse).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/immediate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 48e9d1e..e65bd7c 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -192,7 +192,8 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	imm->dreg = reg;
 	e->flags |= (1 << NFT_EXPR_IMM_DREG);
 
-	datareg_type = nft_mxml_data_reg_parse(tree, "immdata", &imm->data);
+	datareg_type = nft_mxml_data_reg_parse(tree, "immediatedata",
+					       &imm->data);
 	if (datareg_type < 0)
 		return -1;
 

