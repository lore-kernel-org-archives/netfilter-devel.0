From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/4] netfilter: nf_tables: decrement chain use counter when replacing rules
Date: Tue, 10 Jun 2014 10:53:02 +0200
Message-ID: <1402390383-5185-3-git-send-email-pablo@netfilter.org>
References: <1402390383-5185-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35061 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbaFJIxS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:53:18 -0400
In-Reply-To: <1402390383-5185-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thus, the chain use counter remains with the same value after the
rule replacement.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5586426..19f438d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1799,6 +1799,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 				goto err2;
 			}
 			nft_rule_disactivate_next(net, old_rule);
+			chain->use--;
 			list_add_tail_rcu(&rule->list, &old_rule->list);
 		} else {
 			err = -ENOENT;
@@ -1829,6 +1830,7 @@ err3:
 		list_del_rcu(&nft_trans_rule(trans)->list);
 		nft_rule_clear(net, nft_trans_rule(trans));
 		nft_trans_destroy(trans);
+		chain->use++;
 	}
 err2:
 	nf_tables_rule_destroy(&ctx, rule);
-- 
1.7.10.4

