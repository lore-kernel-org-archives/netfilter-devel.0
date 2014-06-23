From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/4] expr: target: get a nft_rule_expr type in nft_rule_expr_target_snprintf_* functions
Date: Mon, 23 Jun 2014 11:38:17 +0200
Message-ID: <1403516300-32649-2-git-send-email-anarey@gmail.com>
References: <1403516300-32649-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52423 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaFWJic (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:38:32 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so3892786wib.0
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 02:38:30 -0700 (PDT)
In-Reply-To: <1403516300-32649-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring in nft_rule_expr_target_snprintf_* functions to get a
nft_rule_expr type instead of nft_expr_target type. The nft_rule_expr is
needed to check information into flags variables.

Moreover, It remanes some variables like 'tg' to 'target' for code
readability reasons.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/target.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/src/expr/target.c b/src/expr/target.c
index ff0e56f..8a9f8b0 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -218,25 +218,25 @@ nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 
 static
 int nft_rule_exp_target_snprintf_json(char *buf, size_t len,
-				struct nft_expr_target *tg)
+				struct nft_rule_expr *e)
 {
+	struct nft_expr_target *target = nft_expr_data(e);
 	int ret, size = len, offset = 0;
 
-	ret = snprintf(buf, len, "\"name\":\"%s\"",
-			tg->name);
+	ret = snprintf(buf, len, "\"name\":\"%s\"", target->name);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
 }
 
-static
-int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
-				struct nft_expr_target *tg)
+static int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
+					    struct nft_rule_expr *e)
 {
+	struct nft_expr_target *target = nft_expr_data(e);
 	int ret, size=len;
 	int offset = 0;
 
-	ret = snprintf(buf, len, "<name>%s</name>", tg->name);
+	ret = snprintf(buf, len, "<name>%s</name>", target->name);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
@@ -253,9 +253,9 @@ nft_rule_expr_target_snprintf(char *buf, size_t len, uint32_t type,
 		return snprintf(buf, len, "name %s rev %u ",
 				target->name, target->rev);
 	case NFT_OUTPUT_XML:
-		return nft_rule_exp_target_snprintf_xml(buf, len, target);
+		return nft_rule_exp_target_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_exp_target_snprintf_json(buf, len, target);
+		return nft_rule_exp_target_snprintf_json(buf, len, e);
 	default:
 		break;
 	}
-- 
2.0.0

