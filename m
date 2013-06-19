From: Eric Leblond <eric@regit.org>
Subject: [PATCH] netfilter: nf_tables: add insert operation
Date: Wed, 19 Jun 2013 10:03:17 +0200
Message-ID: <1371628997-13548-2-git-send-email-eric@regit.org>
References: <1371628997-13548-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:46688 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328Ab3FSIDr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:03:47 -0400
In-Reply-To: <1371628997-13548-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By providing a create command and specifying an handle, the rule is
inserted after the rule with the provided handle.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 net/netfilter/nf_tables_api.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cfe0c58..4f3e112 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1563,7 +1563,10 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			old_rule = rule;
-		else
+		else if (nlh->nlmsg_flags & NLM_F_CREATE) {
+			old_rule = rule;
+			handle = nf_tables_alloc_handle(table);
+		} else
 			return -EOPNOTSUPP;
 	} else {
 		if (!create || nlh->nlmsg_flags & NLM_F_REPLACE)
@@ -1626,8 +1629,12 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 		}
 	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
 		list_add_tail_rcu(&rule->list, &chain->rules);
-	else
-		list_add_rcu(&rule->list, &chain->rules);
+	else {
+		if (old_rule)
+			list_add_rcu(&rule->list, &old_rule->list);
+		else
+			list_add_rcu(&rule->list, &chain->rules);
+	}
 
 	if (flags & NFT_RULE_F_COMMIT)
 		list_add(&rule->dirty_list, &chain->dirty_rules);
-- 
1.8.3.1

