From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/4] expr: target: Do not print unset values in json file
Date: Mon, 23 Jun 2014 11:38:20 +0200
Message-ID: <1403516300-32649-5-git-send-email-anarey@gmail.com>
References: <1403516300-32649-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45979 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaFWJig (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:38:36 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so3818782wiv.2
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 02:38:34 -0700 (PDT)
In-Reply-To: <1403516300-32649-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snrintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/target.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/expr/target.c b/src/expr/target.c
index 01bf69d..c4201cb 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -178,10 +178,8 @@ nft_rule_expr_target_json_parse(struct nft_rule_expr *e, json_t *root,
 	const char *name;
 
 	name = nft_jansson_parse_str(root, "name", err);
-	if (name == NULL)
-		return -1;
-
-	nft_rule_expr_set_str(e, NFT_EXPR_TG_NAME, name);
+	if (name != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_TG_NAME, name);
 
 	return 0;
 #else
@@ -218,8 +216,10 @@ int nft_rule_exp_target_snprintf_json(char *buf, size_t len,
 	struct nft_expr_target *target = nft_expr_data(e);
 	int ret, size = len, offset = 0;
 
-	ret = snprintf(buf, len, "\"name\":\"%s\"", target->name);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_TG_NAME)) {
+		ret = snprintf(buf, len, "\"name\":\"%s\"", target->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	return offset;
 }
-- 
2.0.0

