From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next/nf_tables-experiments - PATCH 2/2] nf_tables: Add support for replacing a rule by another one.
Date: Wed, 31 Oct 2012 11:28:29 +0200
Message-ID: <1351675709-14127-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1351675709-14127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795Ab2JaJ2g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:28:36 -0400
In-Reply-To: <1351675709-14127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 net/netfilter/nf_tables_api.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fd1b624..3ce8aa1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1321,7 +1321,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	const struct nft_af_info *afi;
 	const struct nft_table *table;
 	struct nft_chain *chain;
-	struct nft_rule *rule;
+	struct nft_rule *rule, *old_rule = NULL;
 	struct nft_expr_info info[NFT_RULE_MAXEXPRS];
 	struct nft_expr *expr;
 	struct nft_ctx ctx;
@@ -1357,9 +1357,11 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 		if (rule != NULL) {
 			if (nlh->nlmsg_flags & NLM_F_EXCL)
 				return -EEXIST;
-			if (nlh->nlmsg_flags & NLM_F_REPLACE)
-				return -EOPNOTSUPP;
-			return 0;
+			if (nlh->nlmsg_flags & NLM_F_REPLACE) {
+				old_rule = rule;
+				rule = NULL;
+			} else
+				return 0;
 		}
 	} else
 		handle = nf_tables_rule_alloc_handle(chain);
@@ -1402,7 +1404,19 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 		expr = nft_expr_next(expr);
 	}
 
-	if (nlh->nlmsg_flags & NLM_F_APPEND)
+	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
+		if (old_rule == NULL)
+			goto err2;
+
+		list_replace_rcu(&old_rule->list, &rule->list);
+
+		// FIXME: this makes deletion performance *really* suck
+		synchronize_rcu();
+
+		nf_tables_rule_notify(skb, nlh, table, chain, old_rule,
+				      NFT_MSG_DELRULE, nfmsg->nfgen_family);
+		nf_tables_rule_destroy(&ctx, old_rule);
+	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
 		list_add_tail_rcu(&rule->list, &chain->rules);
 	else
 		list_add_rcu(&rule->list, &chain->rules);
-- 
1.7.12.4

