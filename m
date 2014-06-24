From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/4] expr: match: get a nft_rule_expr type in nft_rule_expr_match_snprintf_* functions
Date: Tue, 24 Jun 2014 19:15:01 +0200
Message-ID: <1403630104-13118-2-git-send-email-anarey@gmail.com>
References: <1403630104-13118-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49854 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbaFXRP1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:15:27 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so6330919wiv.9
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2014 10:15:23 -0700 (PDT)
In-Reply-To: <1403630104-13118-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring in nft_rule_expr_match_snprintf_* functions to get a
nft_rule_expr type instead of nft_expr_match type.

The nft_rule_expr type is needed to check information into flags variables.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/match.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/expr/match.c b/src/expr/match.c
index a78bd69..05f9aff 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -216,8 +216,9 @@ static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, mxml_node_t *t
 }
 
 static int nft_rule_expr_match_snprintf_json(char *buf, size_t len,
-					    struct nft_expr_match *mt)
+					     struct nft_rule_expr *e)
 {
+	struct nft_expr_match *mt = nft_expr_data(e);
 	int ret, size = len, offset = 0;
 
 	ret = snprintf(buf, len, "\"name\":\"%s\"",
@@ -228,8 +229,9 @@ static int nft_rule_expr_match_snprintf_json(char *buf, size_t len,
 }
 
 static int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
-					    struct nft_expr_match *mt)
+					    struct nft_rule_expr *e)
 {
+	struct nft_expr_match *mt = nft_expr_data(e);
 	int ret, size=len;
 	int offset = 0;
 
@@ -251,9 +253,9 @@ nft_rule_expr_match_snprintf(char *buf, size_t len, uint32_t type,
 		return snprintf(buf, len, "name %s rev %u ",
 				match->name, match->rev);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_match_snprintf_xml(buf, len, match);
+		return nft_rule_expr_match_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_match_snprintf_json(buf, len, match);
+		return nft_rule_expr_match_snprintf_json(buf, len, e);
 	default:
 		break;
 	}
-- 
2.0.0

