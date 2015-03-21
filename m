From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/5] netfilter: nf_tables: move struct net pointer to base chain
Date: Sat, 21 Mar 2015 15:19:15 +0000
Message-ID: <1426951158-18168-3-git-send-email-kaber@trash.net>
References: <1426951158-18168-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46421 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbCUPTX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Mar 2015 11:19:23 -0400
In-Reply-To: <1426951158-18168-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The network namespace is only needed for base chains to get at the
gencursor. Also convert to possible_net_t.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h | 4 ++--
 net/netfilter/nf_tables_api.c     | 2 +-
 net/netfilter/nf_tables_core.c    | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d756af5..ace67a5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -449,7 +449,6 @@ enum nft_chain_flags {
  *
  *	@rules: list of rules in the chain
  *	@list: used internally
- *	@net: net namespace that this chain belongs to
  *	@table: table that this chain belongs to
  *	@handle: chain handle
  *	@use: number of jump references to this chain
@@ -460,7 +459,6 @@ enum nft_chain_flags {
 struct nft_chain {
 	struct list_head		rules;
 	struct list_head		list;
-	struct net			*net;
 	struct nft_table		*table;
 	u64				handle;
 	u32				use;
@@ -512,6 +510,7 @@ struct nft_stats {
  *	struct nft_base_chain - nf_tables base chain
  *
  *	@ops: netfilter hook ops
+ *	@pnet: net namespace that this chain belongs to
  *	@type: chain type
  *	@policy: default policy
  *	@stats: per-cpu chain stats
@@ -519,6 +518,7 @@ struct nft_stats {
  */
 struct nft_base_chain {
 	struct nf_hook_ops		ops[NFT_HOOK_OPS_MAX];
+	possible_net_t			pnet;
 	const struct nf_chain_type	*type;
 	u8				policy;
 	struct nft_stats __percpu	*stats;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ea51833..334bf9c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1349,6 +1349,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			rcu_assign_pointer(basechain->stats, stats);
 		}
 
+		write_pnet(&basechain->pnet, net);
 		basechain->type = type;
 		chain = &basechain->chain;
 
@@ -1376,7 +1377,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 
 	INIT_LIST_HEAD(&chain->rules);
 	chain->handle = nf_tables_alloc_handle(table);
-	chain->net = net;
 	chain->table = table;
 	nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
 
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 77165bf..4c921a3 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -112,6 +112,7 @@ unsigned int
 nft_do_chain(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 {
 	const struct nft_chain *chain = ops->priv, *basechain = chain;
+	const struct net *net = read_pnet(&nft_base_chain(basechain)->pnet);
 	const struct nft_rule *rule;
 	const struct nft_expr *expr, *last;
 	struct nft_data data[NFT_REG_MAX + 1];
@@ -123,7 +124,7 @@ nft_do_chain(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 	 * Cache cursor to avoid problems in case that the cursor is updated
 	 * while traversing the ruleset.
 	 */
-	unsigned int gencursor = ACCESS_ONCE(chain->net->nft.gencursor);
+	unsigned int gencursor = ACCESS_ONCE(net->nft.gencursor);
 
 do_chain:
 	rulenum = 0;
-- 
2.1.0

