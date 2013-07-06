From: Eric Leblond <eric@regit.org>
Subject: [PATCH] netfilter: nf_tables: add insert operation
Date: Sat,  6 Jul 2013 17:31:17 +0200
Message-ID: <1373124677-6626-2-git-send-email-eric@regit.org>
References: <20130629102418.GA5518@localhost>
 <1373124677-6626-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59740 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3GFPcA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jul 2013 11:32:00 -0400
In-Reply-To: <1373124677-6626-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new rule attribute NFTA_RULE_POSITION which is
used to store the position of a rule relatively to the others.
By providing a create command and specifying a position, the rule is
inserted after the rule with the handle equal to the provided
position.
Regarding notification, the position attribute is added to specify
the handle of the previous rule in append mode and the handle of
the next rule in the other case.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c            | 47 +++++++++++++++++++++++++++++---
 2 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index d40a7f9..d9bf8ea 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -143,6 +143,7 @@ enum nft_rule_attributes {
 	NFTA_RULE_EXPRESSIONS,
 	NFTA_RULE_FLAGS,
 	NFTA_RULE_COMPAT,
+	NFTA_RULE_POSITION,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b00aca8..ce8a4f0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1267,6 +1267,7 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
 	[NFTA_RULE_FLAGS]	= { .type = NLA_U32 },
 	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
+	[NFTA_RULE_POSITION]	= { .type = NLA_U64 },
 };
 
 static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u32 seq,
@@ -1279,6 +1280,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u32 seq,
 	struct nfgenmsg *nfmsg;
 	const struct nft_expr *expr, *next;
 	struct nlattr *list;
+	const struct nft_rule *prule;
 
 	event |= NFNL_SUBSYS_NFTABLES << 8;
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
@@ -1298,6 +1300,26 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u32 seq,
 	if (nla_put_be64(skb, NFTA_RULE_HANDLE, cpu_to_be64(rule->handle)))
 		goto nla_put_failure;
 
+	if (event & NLM_F_APPEND) {
+		if ((rule->list.prev != LIST_POISON2) &&
+		    (rule->list.prev != &chain->rules)) {
+			prule = list_entry(rule->list.prev,
+					   struct nft_rule, list);
+			if (nla_put_be64(skb, NFTA_RULE_POSITION,
+					 cpu_to_be64(prule->handle)))
+				goto nla_put_failure;
+		}
+	} else {
+		if ((rule->list.next != LIST_POISON1) &&
+		    (rule->list.next != &chain->rules)) {
+			prule = list_entry(rule->list.next,
+					   struct nft_rule, list);
+			if (nla_put_be64(skb, NFTA_RULE_POSITION,
+					 cpu_to_be64(prule->handle)))
+				goto nla_put_failure;
+		}
+	}
+
 	list = nla_nest_start(skb, NFTA_RULE_EXPRESSIONS);
 	if (list == NULL)
 		goto nla_put_failure;
@@ -1537,7 +1559,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	int err, rem;
 	bool create;
 	u32 flags = 0;
-	u64 handle;
+	u64 handle, pos_handle;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
@@ -1571,6 +1593,16 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 		handle = nf_tables_alloc_handle(table);
 	}
 
+	if (nla[NFTA_RULE_POSITION]) {
+		pos_handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_POSITION]));
+		old_rule = __nf_tables_rule_lookup(chain, pos_handle);
+		if (IS_ERR(old_rule))
+			return PTR_ERR(old_rule);
+
+		if (! (nlh->nlmsg_flags & NLM_F_CREATE))
+			return -EOPNOTSUPP;
+	}
+
 	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
 
 	n = 0;
@@ -1625,9 +1657,16 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			nf_tables_rule_destroy(old_rule);
 		}
 	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
-		list_add_tail_rcu(&rule->list, &chain->rules);
-	else
-		list_add_rcu(&rule->list, &chain->rules);
+		if (old_rule)
+			list_add_rcu(&rule->list, &old_rule->list);
+		else
+			list_add_tail_rcu(&rule->list, &chain->rules);
+	else {
+		if (old_rule)
+			list_add_tail_rcu(&rule->list, &old_rule->list);
+		else
+			list_add_rcu(&rule->list, &chain->rules);
+	}
 
 	if (flags & NFT_RULE_F_COMMIT)
 		list_add(&rule->dirty_list, &chain->dirty_rules);
-- 
1.8.3.2

