From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/4] netfilter: nf_tables: use RCU-safe list insertion when replacing rules
Date: Tue, 10 Jun 2014 10:53:00 +0200
Message-ID: <1402390383-5185-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35043 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbaFJIxP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:53:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The patch 5e94846 ("netfilter: nf_tables: add insert operation") did
not include RCU-safe list insertion when replacing rules.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 624e083..ba37c10 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1796,7 +1796,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 				goto err2;
 			}
 			nft_rule_disactivate_next(net, old_rule);
-			list_add_tail(&rule->list, &old_rule->list);
+			list_add_tail_rcu(&rule->list, &old_rule->list);
 		} else {
 			err = -ENOENT;
 			goto err2;
-- 
1.7.10.4

