From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: nf_tables: attach replacement rule after stale one
Date: Wed, 18 Sep 2013 00:14:54 +0200
Message-ID: <1379456095-4070-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35577 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab3IQWPI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:15:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Insert the new rule after the existing stale one that
will be removed in the commit phase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 755d596..0e55e1b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1659,7 +1659,8 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 		rupd = nf_tables_trans_add(old_rule, &ctx);
 		if (rupd == NULL)
 			goto err2;
-		list_add_tail_rcu(&rule->list, &chain->rules);
+
+		list_add_tail(&rule->list, &old_rule->list);
 	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
 		if (old_rule)
 			list_add_rcu(&rule->list, &old_rule->list);
-- 
1.7.10.4

