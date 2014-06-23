From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/4] expr: target: Use nft_rule_expr_set_* in the xml parsing code
Date: Mon, 23 Jun 2014 11:38:18 +0200
Message-ID: <1403516300-32649-3-git-send-email-anarey@gmail.com>
References: <1403516300-32649-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57637 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbaFWJij (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:38:39 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so3770494wib.3
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 02:38:33 -0700 (PDT)
In-Reply-To: <1403516300-32649-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/target.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/src/expr/target.c b/src/expr/target.c
index 8a9f8b0..da25e68 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -195,7 +195,6 @@ nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 			       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_target *tg = nft_expr_data(e);
 	const char *name;
 
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
@@ -203,9 +202,7 @@ nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	if (name == NULL)
 		return -1;
 
-	strncpy(tg->name, name, XT_EXTENSION_MAXNAMELEN);
-	tg->name[XT_EXTENSION_MAXNAMELEN-1] = '\0';
-	e->flags |= (1 << NFT_EXPR_TG_NAME);
+	nft_rule_expr_set_str(e, NFT_EXPR_TG_NAME, name);
 
 	/* tg->info is ignored until other solution is reached */
 
-- 
2.0.0

