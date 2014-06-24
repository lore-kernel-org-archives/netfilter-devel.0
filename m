From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/4] expr: match: Do not print unset values in json file
Date: Tue, 24 Jun 2014 19:15:04 +0200
Message-ID: <1403630104-13118-5-git-send-email-anarey@gmail.com>
References: <1403630104-13118-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:48790 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbaFXRP3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:15:29 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so687011wes.41
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 10:15:27 -0700 (PDT)
In-Reply-To: <1403630104-13118-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions json to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/match.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/src/expr/match.c b/src/expr/match.c
index 604a8e6..2c4b3dc 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -177,10 +177,8 @@ static int nft_rule_expr_match_json_parse(struct nft_rule_expr *e, json_t *root,
 	const char *name;
 
 	name = nft_jansson_parse_str(root, "name", err);
-	if (name == NULL)
-		return -1;
-
-	nft_rule_expr_set_str(e, NFT_EXPR_MT_NAME, name);
+	if (name != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_MT_NAME, name);
 
 	return 0;
 #else
@@ -216,9 +214,10 @@ static int nft_rule_expr_match_snprintf_json(char *buf, size_t len,
 	struct nft_expr_match *mt = nft_expr_data(e);
 	int ret, size = len, offset = 0;
 
-	ret = snprintf(buf, len, "\"name\":\"%s\"",
-				mt->name);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_MT_NAME)) {
+		ret = snprintf(buf, len, "\"name\":\"%s\"", mt->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	return offset;
 }
-- 
2.0.0

