From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable] netfilter: nf_tables: fix error handling of rule replacement
Date: Sat, 16 May 2015 20:50:45 +0200
Message-ID: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[ upstream commit 59900e0a019e7c2bdb7809a03ed5742d311b15b3 ]

In general, if a transaction object is added to the list successfully,
we can rely on the abort path to undo what we've done. This allows us to
simplify the error handling of the rule replacement path in
nf_tables_newrule().

This implicitly fixes an unnecessary removal of the old rule, which
needs to be left in place if we fail to replace.

Cc: <stable@vger.kernel.org> # 3.18.x
Cc: <stable@vger.kernel.org> # 3.19.x
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 74e4b87..6ab7779 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2045,12 +2045,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 
 err3:
 	list_del_rcu(&rule->list);
-	if (trans) {
-		list_del_rcu(&nft_trans_rule(trans)->list);
-		nft_rule_clear(net, nft_trans_rule(trans));
-		nft_trans_destroy(trans);
-		chain->use++;
-	}
 err2:
 	nf_tables_rule_destroy(&ctx, rule);
 err1:
-- 
1.7.10.4
