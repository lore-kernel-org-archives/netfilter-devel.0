From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/4] expr: match: Do not print unset values in xml file
Date: Tue, 24 Jun 2014 19:15:03 +0200
Message-ID: <1403630104-13118-4-git-send-email-anarey@gmail.com>
References: <1403630104-13118-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:55148 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbaFXRP3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:15:29 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so719719wes.23
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 10:15:26 -0700 (PDT)
In-Reply-To: <1403630104-13118-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/match.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/expr/match.c b/src/expr/match.c
index 572d0f9..604a8e6 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -198,9 +198,8 @@ static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, mxml_node_t *t
 
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND, err);
-	if (name == NULL)
-		return -1;
-	nft_rule_expr_set_str(e, NFT_EXPR_MT_NAME, name);
+	if (name != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_MT_NAME, name);
 
 	/* mt->info is ignored until other solution is reached */
 
@@ -231,13 +230,14 @@ static int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
 	int ret, size=len;
 	int offset = 0;
 
-	ret = snprintf(buf, len, "<name>%s</name>", mt->name);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_MT_NAME)) {
+		ret = snprintf(buf, len, "<name>%s</name>", mt->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	return offset;
 }
 
-
 static int
 nft_rule_expr_match_snprintf(char *buf, size_t len, uint32_t type,
 			     uint32_t flags, struct nft_rule_expr *e)
-- 
2.0.0

