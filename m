From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/5] netfilter: nf_tables: clean up nf_tables_trans_add() argument order
Date: Fri,  7 Mar 2014 19:08:29 +0100
Message-ID: <1394215713-32049-2-git-send-email-kaber@trash.net>
References: <1394215713-32049-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39699 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaCGSIf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:08:35 -0500
In-Reply-To: <1394215713-32049-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The context argument logically comes first, and this is what every other
function dealing with contexts does.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 89d7ec4..a206405 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1557,7 +1557,7 @@ static void nf_tables_rule_destroy(struct nft_rule *rule)
 static struct nft_expr_info *info;
 
 static struct nft_rule_trans *
-nf_tables_trans_add(struct nft_rule *rule, const struct nft_ctx *ctx)
+nf_tables_trans_add(struct nft_ctx *ctx, struct nft_rule *rule)
 {
 	struct nft_rule_trans *rupd;
 
@@ -1683,7 +1683,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
 		if (nft_rule_is_active_next(net, old_rule)) {
-			repl = nf_tables_trans_add(old_rule, &ctx);
+			repl = nf_tables_trans_add(&ctx, old_rule);
 			if (repl == NULL) {
 				err = -ENOMEM;
 				goto err2;
@@ -1706,7 +1706,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			list_add_rcu(&rule->list, &chain->rules);
 	}
 
-	if (nf_tables_trans_add(rule, &ctx) == NULL) {
+	if (nf_tables_trans_add(&ctx, rule) == NULL) {
 		err = -ENOMEM;
 		goto err3;
 	}
@@ -1735,7 +1735,7 @@ nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule)
 {
 	/* You cannot delete the same rule twice */
 	if (nft_rule_is_active_next(ctx->net, rule)) {
-		if (nf_tables_trans_add(rule, ctx) == NULL)
+		if (nf_tables_trans_add(ctx, rule) == NULL)
 			return -ENOMEM;
 		nft_rule_disactivate_next(ctx->net, rule);
 		return 0;
-- 
1.8.5.3

