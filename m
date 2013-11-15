From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] expr: match: fix wrong flag setting in nft_rule_expr_match_parse
Date: Fri, 15 Nov 2013 15:19:45 +0100
Message-ID: <1384525185-6675-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54328 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab3KOOTy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:19:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Expression flags were incorrectly set. It should not manifest in any
bug as NFTA_MATCH_* and NFT_EXPR_MT_* are overlapping. Still incorrect
from the semantic side.

Reported-by: Ana Rey Botello <anarey@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/match.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/expr/match.c b/src/expr/match.c
index 5d02ee7..c7863b8 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -140,12 +140,12 @@ static int nft_rule_expr_match_parse(struct nft_rule_expr *e, struct nlattr *att
 			 mnl_attr_get_str(tb[NFTA_MATCH_NAME]));
 
 		match->name[XT_EXTENSION_MAXNAMELEN-1] = '\0';
-		e->flags |= (1 << NFTA_MATCH_NAME);
+		e->flags |= (1 << NFT_EXPR_MT_NAME);
 	}
 
 	if (tb[NFTA_MATCH_REV]) {
 		match->rev = ntohl(mnl_attr_get_u32(tb[NFTA_MATCH_REV]));
-		e->flags |= (1 << NFTA_MATCH_REV);
+		e->flags |= (1 << NFT_EXPR_MT_REV);
 	}
 
 	if (tb[NFTA_MATCH_INFO]) {
@@ -164,7 +164,7 @@ static int nft_rule_expr_match_parse(struct nft_rule_expr *e, struct nlattr *att
 		match->data = match_data;
 		match->data_len = len;
 
-		e->flags |= (1 << NFTA_MATCH_INFO);
+		e->flags |= (1 << NFT_EXPR_MT_INFO);
 	}
 
 	return 0;
-- 
1.7.10.4

