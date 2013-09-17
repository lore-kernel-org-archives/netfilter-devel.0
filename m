From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: nf_tables: do not allow deletion/replacement of stale rules
Date: Wed, 18 Sep 2013 00:14:55 +0200
Message-ID: <1379456095-4070-2-git-send-email-pablo@netfilter.org>
References: <1379456095-4070-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35578 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab3IQWPJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:15:09 -0400
In-Reply-To: <1379456095-4070-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stale rules are those that will be purge out in the commit step.
Do not allow to delete/replace a rule that is stale.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0e55e1b..0627023 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1655,12 +1655,17 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-		nft_rule_disactivate_next(net, old_rule);
-		rupd = nf_tables_trans_add(old_rule, &ctx);
-		if (rupd == NULL)
-			goto err2;
+		if (nft_rule_is_active_next(net, old_rule)) {
+			nft_rule_disactivate_next(net, old_rule);
+			rupd = nf_tables_trans_add(old_rule, &ctx);
+			if (rupd == NULL)
+				goto err2;
 
-		list_add_tail(&rule->list, &old_rule->list);
+			list_add_tail(&rule->list, &old_rule->list);
+		} else {
+			nf_tables_rule_destroy(rule);
+			return -ENOENT;
+		}
 	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
 		if (old_rule)
 			list_add_rcu(&rule->list, &old_rule->list);
@@ -1698,11 +1703,15 @@ err1:
 static int
 nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule)
 {
-	nft_rule_disactivate_next(ctx->net, rule);
-	if (nf_tables_trans_add(rule, ctx) == NULL)
-		return -ENOMEM;
+	/* You cannot delete the same rule twice */
+	if (nft_rule_is_active_next(ctx->net, rule)) {
+		nft_rule_disactivate_next(ctx->net, rule);
+		if (nf_tables_trans_add(rule, ctx) == NULL)
+			return -ENOMEM;
 
-	return 0;
+		return 0;
+	}
+	return -ENOENT;
 }
 
 static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
-- 
1.7.10.4

