From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/4] expr: match: Use nft_rule_expr_set_* in the xml parsing code
Date: Tue, 24 Jun 2014 19:15:02 +0200
Message-ID: <1403630104-13118-3-git-send-email-anarey@gmail.com>
References: <1403630104-13118-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42769 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbaFXRP0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:15:26 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so691890wes.5
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 10:15:25 -0700 (PDT)
In-Reply-To: <1403630104-13118-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/match.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/src/expr/match.c b/src/expr/match.c
index 05f9aff..572d0f9 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -194,17 +194,13 @@ static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, mxml_node_t *t
 					 struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_match *mt = nft_expr_data(e);
 	const char *name;
 
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND, err);
 	if (name == NULL)
 		return -1;
-
-	strncpy(mt->name, name, XT_EXTENSION_MAXNAMELEN);
-	mt->name[XT_EXTENSION_MAXNAMELEN-1] = '\0';
-	e->flags |= (1 << NFT_EXPR_MT_NAME);
+	nft_rule_expr_set_str(e, NFT_EXPR_MT_NAME, name);
 
 	/* mt->info is ignored until other solution is reached */
 
-- 
2.0.0

