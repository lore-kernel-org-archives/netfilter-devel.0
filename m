From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] expr: remove alignment through XT_ALIGN in match and target
Date: Fri, 20 Jun 2014 12:12:22 +0200
Message-ID: <1403259142-5911-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34545 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976AbaFTKMd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:12:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The info area that this gets via the setter should be already
aligned. The caller has to care of this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/match.c  |    2 +-
 src/expr/target.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/expr/match.c b/src/expr/match.c
index a65d3e5..a78bd69 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -124,7 +124,7 @@ nft_rule_expr_match_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 	if (e->flags & (1 << NFT_EXPR_MT_REV))
 		mnl_attr_put_u32(nlh, NFTA_MATCH_REV, htonl(mt->rev));
 	if (e->flags & (1 << NFT_EXPR_MT_INFO))
-		mnl_attr_put(nlh, NFTA_MATCH_INFO, XT_ALIGN(mt->data_len), mt->data);
+		mnl_attr_put(nlh, NFTA_MATCH_INFO, mt->data_len, mt->data);
 }
 
 static int nft_rule_expr_match_parse(struct nft_rule_expr *e, struct nlattr *attr)
diff --git a/src/expr/target.c b/src/expr/target.c
index ff0e56f..6a2b405 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -124,7 +124,7 @@ nft_rule_expr_target_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 	if (e->flags & (1 << NFT_EXPR_TG_REV))
 		mnl_attr_put_u32(nlh, NFTA_TARGET_REV, htonl(tg->rev));
 	if (e->flags & (1 << NFT_EXPR_TG_INFO))
-		mnl_attr_put(nlh, NFTA_TARGET_INFO, XT_ALIGN(tg->data_len), tg->data);
+		mnl_attr_put(nlh, NFTA_TARGET_INFO, tg->data_len, tg->data);
 }
 
 static int nft_rule_expr_target_parse(struct nft_rule_expr *e, struct nlattr *attr)
-- 
1.7.10.4

