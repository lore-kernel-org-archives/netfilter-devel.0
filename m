From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 04/13] netfilter: nf_tables: fix chain type module reference handling
Date: Thu,  9 Jan 2014 18:42:34 +0000
Message-ID: <1389292963-4089-5-git-send-email-kaber@trash.net>
References: <1389292963-4089-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51683 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870AbaAISnR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:43:17 -0500
In-Reply-To: <1389292963-4089-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The chain type module reference handling makes no sense at all: we take
a reference immediately when the module is registered, preventing the
module from ever being unloaded.

Fix by taking a reference when we're actually creating a chain of the
chain type and release the reference when destroying the chain.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 45 +++++++++++++++++++++------------------
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5d2b703..e9b9786 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -436,7 +436,7 @@ struct nft_stats {
  */
 struct nft_base_chain {
 	struct nf_hook_ops		ops[NFT_HOOK_OPS_MAX];
-	enum nft_chain_type		type;
+	struct nf_chain_type		*type;
 	u8				policy;
 	struct nft_stats __percpu	*stats;
 	struct nft_chain		chain;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 290472c..d913fb0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -126,27 +126,29 @@ static inline u64 nf_tables_alloc_handle(struct nft_table *table)
 
 static struct nf_chain_type *chain_type[AF_MAX][NFT_CHAIN_T_MAX];
 
-static int __nf_tables_chain_type_lookup(int family, const struct nlattr *nla)
+static struct nf_chain_type *
+__nf_tables_chain_type_lookup(int family, const struct nlattr *nla)
 {
 	int i;
 
-	for (i=0; i<NFT_CHAIN_T_MAX; i++) {
+	for (i = 0; i < NFT_CHAIN_T_MAX; i++) {
 		if (chain_type[family][i] != NULL &&
 		    !nla_strcmp(nla, chain_type[family][i]->name))
-			return i;
+			return chain_type[family][i];
 	}
-	return -1;
+	return NULL;
 }
 
-static int nf_tables_chain_type_lookup(const struct nft_af_info *afi,
-				       const struct nlattr *nla,
-				       bool autoload)
+static struct nf_chain_type *
+nf_tables_chain_type_lookup(const struct nft_af_info *afi,
+			    const struct nlattr *nla,
+			    bool autoload)
 {
-	int type;
+	struct nf_chain_type *type;
 
 	type = __nf_tables_chain_type_lookup(afi->family, nla);
 #ifdef CONFIG_MODULES
-	if (type < 0 && autoload) {
+	if (type == NULL && autoload) {
 		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 		request_module("nft-chain-%u-%*.s", afi->family,
 			       nla_len(nla)-1, (const char *)nla_data(nla));
@@ -478,10 +480,6 @@ int nft_register_chain_type(struct nf_chain_type *ctype)
 		err = -EBUSY;
 		goto out;
 	}
-
-	if (!try_module_get(ctype->me))
-		goto out;
-
 	chain_type[ctype->family][ctype->type] = ctype;
 out:
 	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
@@ -493,7 +491,6 @@ void nft_unregister_chain_type(struct nf_chain_type *ctype)
 {
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	chain_type[ctype->family][ctype->type] = NULL;
-	module_put(ctype->me);
 	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 }
 EXPORT_SYMBOL_GPL(nft_unregister_chain_type);
@@ -617,9 +614,8 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, u32 portid, u32 seq,
 				 htonl(basechain->policy)))
 			goto nla_put_failure;
 
-		if (nla_put_string(skb, NFTA_CHAIN_TYPE,
-			chain_type[ops->pf][nft_base_chain(chain)->type]->name))
-				goto nla_put_failure;
+		if (nla_put_string(skb, NFTA_CHAIN_TYPE, basechain->type->name))
+			goto nla_put_failure;
 
 		if (nft_dump_stats(skb, nft_base_chain(chain)->stats))
 			goto nla_put_failure;
@@ -900,16 +896,17 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		return -EOVERFLOW;
 
 	if (nla[NFTA_CHAIN_HOOK]) {
+		struct nf_chain_type *type;
 		struct nf_hook_ops *ops;
 		nf_hookfn *hookfn;
 		u32 hooknum, priority;
-		int type = NFT_CHAIN_T_DEFAULT;
 
+		type = chain_type[family][NFT_CHAIN_T_DEFAULT];
 		if (nla[NFTA_CHAIN_TYPE]) {
 			type = nf_tables_chain_type_lookup(afi,
 							   nla[NFTA_CHAIN_TYPE],
 							   create);
-			if (type < 0)
+			if (type == NULL)
 				return -ENOENT;
 		}
 
@@ -926,9 +923,11 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			return -EINVAL;
 		priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
 
-		if (!(chain_type[family][type]->hook_mask & (1 << hooknum)))
+		if (!(type->hook_mask & (1 << hooknum)))
 			return -EOPNOTSUPP;
-		hookfn = chain_type[family][type]->fn[hooknum];
+		if (!try_module_get(type->me))
+			return -ENOENT;
+		hookfn = type->fn[hooknum];
 
 		basechain = kzalloc(sizeof(*basechain), GFP_KERNEL);
 		if (basechain == NULL)
@@ -938,6 +937,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			err = nf_tables_counters(basechain,
 						 nla[NFTA_CHAIN_COUNTERS]);
 			if (err < 0) {
+				module_put(type->me);
 				kfree(basechain);
 				return err;
 			}
@@ -946,6 +946,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 
 			newstats = alloc_percpu(struct nft_stats);
 			if (newstats == NULL) {
+				module_put(type->me);
 				kfree(basechain);
 				return -ENOMEM;
 			}
@@ -987,6 +988,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	    chain->flags & NFT_BASE_CHAIN) {
 		err = nf_register_hooks(nft_base_chain(chain)->ops, afi->nops);
 		if (err < 0) {
+			module_put(basechain->type->me);
 			free_percpu(basechain->stats);
 			kfree(basechain);
 			return err;
@@ -1007,6 +1009,7 @@ static void nf_tables_rcu_chain_destroy(struct rcu_head *head)
 	BUG_ON(chain->use > 0);
 
 	if (chain->flags & NFT_BASE_CHAIN) {
+		module_put(nft_base_chain(chain)->type->me);
 		free_percpu(nft_base_chain(chain)->stats);
 		kfree(nft_base_chain(chain));
 	} else
-- 
1.8.4.2

