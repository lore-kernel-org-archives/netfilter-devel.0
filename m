From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next/nf_tables-experiments - v2 PATCH 4/4] nf_tables: Add support for replacing a rule by another one.
Date: Thu,  1 Nov 2012 13:38:33 +0200
Message-ID: <1351769913-5851-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1351769913-5851-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53694 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab2KALim (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:38:42 -0400
In-Reply-To: <1351769913-5851-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 net/netfilter/nf_tables_api.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 43eccbb..72881d2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1309,7 +1309,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	const struct nft_af_info *afi;
 	const struct nft_table *table;
 	struct nft_chain *chain;
-	struct nft_rule *rule;
+	struct nft_rule *rule, *old_rule = NULL;
 	struct nft_expr_info info[NFT_RULE_MAXEXPRS];
 	struct nft_expr *expr;
 	struct nft_ctx ctx;
@@ -1345,9 +1345,11 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
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
@@ -1390,7 +1392,19 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
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

