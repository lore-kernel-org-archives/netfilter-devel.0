From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: fix racy rule deletion
Date: Sat, 25 Jan 2014 14:03:51 +0100
Message-ID: <1390655031-4115-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44754 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbaAYNEC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jan 2014 08:04:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We may lost race if we flush the rule-set (which happens asynchronously
via call_rcu) and we try to remove the table (that userspace assumes
to be empty).

Fix this by recovering synchronous rule and chain deletion. This was
introduced time ago before we had no batch support, and synchronous
rule deletion performance was not good. Now that we have the batch
support, we can just postpone the purge of old rule in a second step
in the commit phase. All object deletions are synchronous after this
patch.

As a side effect, we save memory as we don't need rcu_head per rule
anymore.

Cc: Patrick McHardy <kaber@trash.net>
Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
We still have a bug somewhere else. When creating 10000 rules like:
tcp dport { 22, 23 }, I can see more than 10000 sets.

# ./nft-set-get ip | wc -l
10016

It seems set 511 is not being used. See below:

# ./nft-rule-get
ip filter output 513 512
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ lookup reg 1 set set510 ]
  [ counter pkts 0 bytes 0 ]

ip filter output 514 513
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ lookup reg 1 set set512 ]
  [ counter pkts 0 bytes 0 ]

It seems to happen every 512 sets are added. Still investigating, so
this needs a second follow up patch to resolve what Arturo is reporting.

 include/net/netfilter/nf_tables.h |    4 ----
 net/netfilter/nf_tables_api.c     |   40 +++++++++++++++++++++----------------
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 57c8ff7..ec5e885 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -320,7 +320,6 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
  *	struct nft_rule - nf_tables rule
  *
  *	@list: used internally
- *	@rcu_head: used internally for rcu
  *	@handle: rule handle
  *	@genmask: generation mask
  *	@dlen: length of expression data
@@ -328,7 +327,6 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
  */
 struct nft_rule {
 	struct list_head		list;
-	struct rcu_head			rcu_head;
 	u64				handle:46,
 					genmask:2,
 					dlen:16;
@@ -389,7 +387,6 @@ enum nft_chain_flags {
  *
  *	@rules: list of rules in the chain
  *	@list: used internally
- *	@rcu_head: used internally
  *	@net: net namespace that this chain belongs to
  *	@table: table that this chain belongs to
  *	@handle: chain handle
@@ -401,7 +398,6 @@ enum nft_chain_flags {
 struct nft_chain {
 	struct list_head		rules;
 	struct list_head		list;
-	struct rcu_head			rcu_head;
 	struct net			*net;
 	struct nft_table		*table;
 	u64				handle;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 117bbaa..a74ee39 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1008,10 +1008,8 @@ notify:
 	return 0;
 }
 
-static void nf_tables_rcu_chain_destroy(struct rcu_head *head)
+static void nf_tables_chain_destroy(struct nft_chain *chain)
 {
-	struct nft_chain *chain = container_of(head, struct nft_chain, rcu_head);
-
 	BUG_ON(chain->use > 0);
 
 	if (chain->flags & NFT_BASE_CHAIN) {
@@ -1059,7 +1057,9 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 			       family);
 
 	/* Make sure all rule references are gone before this is released */
-	call_rcu(&chain->rcu_head, nf_tables_rcu_chain_destroy);
+	synchronize_rcu();
+
+	nf_tables_chain_destroy(chain);
 	return 0;
 }
 
@@ -1521,9 +1521,8 @@ err:
 	return err;
 }
 
-static void nf_tables_rcu_rule_destroy(struct rcu_head *head)
+static void nf_tables_rule_destroy(struct nft_rule *rule)
 {
-	struct nft_rule *rule = container_of(head, struct nft_rule, rcu_head);
 	struct nft_expr *expr;
 
 	/*
@@ -1538,11 +1537,6 @@ static void nf_tables_rcu_rule_destroy(struct rcu_head *head)
 	kfree(rule);
 }
 
-static void nf_tables_rule_destroy(struct nft_rule *rule)
-{
-	call_rcu(&rule->rcu_head, nf_tables_rcu_rule_destroy);
-}
-
 #define NFT_RULE_MAXEXPRS	128
 
 static struct nft_expr_info *info;
@@ -1809,9 +1803,6 @@ static int nf_tables_commit(struct sk_buff *skb)
 	synchronize_rcu();
 
 	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
-		/* Delete this rule from the dirty list */
-		list_del(&rupd->list);
-
 		/* This rule was inactive in the past and just became active.
 		 * Clear the next bit of the genmask since its meaning has
 		 * changed, now it is the future.
@@ -1822,6 +1813,7 @@ static int nf_tables_commit(struct sk_buff *skb)
 					      rupd->chain, rupd->rule,
 					      NFT_MSG_NEWRULE, 0,
 					      rupd->family);
+			list_del(&rupd->list);
 			kfree(rupd);
 			continue;
 		}
@@ -1831,7 +1823,15 @@ static int nf_tables_commit(struct sk_buff *skb)
 		nf_tables_rule_notify(skb, rupd->nlh, rupd->table, rupd->chain,
 				      rupd->rule, NFT_MSG_DELRULE, 0,
 				      rupd->family);
+	}
+
+	/* Make sure we don't see any packet traversing old rules */
+	synchronize_rcu();
+
+	/* Now we can safely release unused old rules */
+	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
 		nf_tables_rule_destroy(rupd->rule);
+		list_del(&rupd->list);
 		kfree(rupd);
 	}
 
@@ -1844,20 +1844,26 @@ static int nf_tables_abort(struct sk_buff *skb)
 	struct nft_rule_trans *rupd, *tmp;
 
 	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
-		/* Delete all rules from the dirty list */
-		list_del(&rupd->list);
-
 		if (!nft_rule_is_active_next(net, rupd->rule)) {
 			nft_rule_clear(net, rupd->rule);
+			list_del(&rupd->list);
 			kfree(rupd);
 			continue;
 		}
 
 		/* This rule is inactive, get rid of it */
 		list_del_rcu(&rupd->rule->list);
+	}
+
+	/* Make sure we don't see any packet accessing aborted rules */
+	synchronize_rcu();
+
+	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
 		nf_tables_rule_destroy(rupd->rule);
+		list_del(&rupd->list);
 		kfree(rupd);
 	}
+
 	return 0;
 }
 
-- 
1.7.10.4

