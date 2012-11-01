From: pablo@netfilter.org
Subject: [PATCH 2/2] netfilter: nf_tables: improve deletion performance
Date: Thu,  1 Nov 2012 17:02:24 +0100
Message-ID: <1351785744-7492-3-git-send-email-pablo@netfilter.org>
References: <1351785744-7492-1-git-send-email-pablo@netfilter.org>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37651 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964813Ab2KAQCj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:02:39 -0400
In-Reply-To: <1351785744-7492-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Simple solution: Use kfree_rcu instead of synchronize_rcu. This
gets struct nft_rule fatter.

Regarding caching issues, it would be good to place struct rcu_head
at the end of struct nft_rule. However, the expression area of one
rule has variable length.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    2 ++
 net/netfilter/nf_tables_api.c     |   11 +----------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3289e0d..a179a6b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -296,12 +296,14 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
  *	struct nft_rule - nf_tables rule
  *
  *	@list: used internally
+ *	@rcu_head: used internally for rcu
  *	@handle: rule handle
  *	@dlen: length of expression data
  *	@data: expression data
  */
 struct nft_rule {
 	struct list_head		list;
+	struct rcu_head			rcu_head;
 	u64				handle;
 	u16				dlen;
 	unsigned char			data[]
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cfe6b85..5ed8b06 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1289,7 +1289,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 		nf_tables_expr_destroy(ctx, expr);
 		expr = nft_expr_next(expr);
 	}
-	kfree(rule);
+	kfree_rcu(rule, rcu_head);
 }
 
 #define NFT_RULE_MAXEXPRS	12
@@ -1391,9 +1391,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 
 		list_replace_rcu(&old_rule->list, &rule->list);
 
-		// FIXME: this makes deletion performance *really* suck
-		synchronize_rcu();
-
 		nf_tables_rule_notify(skb, nlh, table, chain, old_rule,
 				      NFT_MSG_DELRULE, nfmsg->nfgen_family);
 		nf_tables_rule_destroy(&ctx, old_rule);
@@ -1448,9 +1445,6 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 		/* List removal must be visible before destroying expressions */
 		list_del_rcu(&rule->list);
 
-		// FIXME: this makes deletion performance *really* suck
-		synchronize_rcu();
-
 		nf_tables_rule_notify(skb, nlh, table, chain, rule,
 				      NFT_MSG_DELRULE, family);
 		nft_ctx_init(&ctx, skb, nlh, afi, table, chain);
@@ -1460,9 +1454,6 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 		list_for_each_entry_safe(rule, tmp, &chain->rules, list) {
 			list_del_rcu(&rule->list);
 
-			// FIXME: this makes deletion performance *really* suck
-			synchronize_rcu();
-
 			nf_tables_rule_notify(skb, nlh, table, chain, rule,
 					      NFT_MSG_DELRULE, family);
 
-- 
1.7.10.4

