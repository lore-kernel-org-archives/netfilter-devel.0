From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/4] expr: target: Do not print unset values in xml file
Date: Mon, 23 Jun 2014 11:38:19 +0200
Message-ID: <1403516300-32649-4-git-send-email-anarey@gmail.com>
References: <1403516300-32649-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:50544 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaFWJig (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:38:36 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so6589065wev.34
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 02:38:33 -0700 (PDT)
In-Reply-To: <1403516300-32649-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/target.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/expr/target.c b/src/expr/target.c
index da25e68..01bf69d 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -199,10 +199,8 @@ nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND, err);
-	if (name == NULL)
-		return -1;
-
-	nft_rule_expr_set_str(e, NFT_EXPR_TG_NAME, name);
+	if (name != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_TG_NAME, name);
 
 	/* tg->info is ignored until other solution is reached */
 
@@ -233,8 +231,10 @@ static int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
 	int ret, size=len;
 	int offset = 0;
 
-	ret = snprintf(buf, len, "<name>%s</name>", target->name);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_TG_NAME)) {
+		ret = snprintf(buf, len, "<name>%s</name>", target->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	return offset;
 }
-- 
2.0.0

