From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/16] netfilter: nf_tables: don't skip inactive chains during update
Date: Wed, 28 Nov 2018 11:17:29 +0100
Message-ID: <20181128101741.20924-5-pablo@netfilter.org>
References: <20181128101741.20924-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128101741.20924-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

There is no synchronization between packet path and the configuration plane.

The packet path uses two arrays with rules, one contains the current (active)
generation.  The other either contains the last (obsolete) generation or
the future one.

Consider:
cpu1               cpu2
                   nft_do_chain(c);
delete c
net->gen++;
                   genbit = !!net->gen;
                   rules = c->rg[genbit];

cpu1 ignores c when updating if c is not active anymore in the new
generation.

On cpu2, we now use rules from wrong generation, as c->rg[old]
contains the rules matching 'c' whereas c->rg[new] was not updated and
can even point to rules that have been free'd already, causing a crash.

To fix this, make sure that 'current' to the 'next' generation are
identical for chains that are going away so that c->rg[new] will just
use the matching rules even if genbit was incremented already.

Fixes: 0cbc06b3faba7 ("netfilter: nf_tables: remove synchronize_rcu in commit phase")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 42487d01a3ed..dd577e7d100c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6324,7 +6324,7 @@ static void nf_tables_commit_chain_free_rules_old(struct nft_rule **rules)
 	call_rcu(&old->h, __nf_tables_commit_chain_free_rules_old);
 }
 
-static void nf_tables_commit_chain_active(struct net *net, struct nft_chain *chain)
+static void nf_tables_commit_chain(struct net *net, struct nft_chain *chain)
 {
 	struct nft_rule **g0, **g1;
 	bool next_genbit;
@@ -6441,11 +6441,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 	/* step 2.  Make rules_gen_X visible to packet path */
 	list_for_each_entry(table, &net->nft.tables, list) {
-		list_for_each_entry(chain, &table->chains, list) {
-			if (!nft_is_active_next(net, chain))
-				continue;
-			nf_tables_commit_chain_active(net, chain);
-		}
+		list_for_each_entry(chain, &table->chains, list)
+			nf_tables_commit_chain(net, chain);
 	}
 
 	/*
-- 
2.11.0
