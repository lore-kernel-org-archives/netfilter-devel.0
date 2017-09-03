From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/5] netfilter: nf_tables: add nf_tables_addchain()
Date: Sun,  3 Sep 2017 23:54:28 +0200
Message-ID: <1504475668-11293-2-git-send-email-pablo@netfilter.org>
References: <1504475668-11293-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47080 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753005AbdICVyl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2017 17:54:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D3FEA11D8F4
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Sep 2017 23:54:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2ED8B5026
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Sep 2017 23:54:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A65FCB5028
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Sep 2017 23:54:12 +0200 (CEST)
Received: from salvia.here (unknown [31.4.193.113])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 742234265A24
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Sep 2017 23:54:12 +0200 (CEST)
In-Reply-To: <1504475668-11293-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Wrap the chain addition path in a function to make it more maintainable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 199 ++++++++++++++++++++++--------------------
 1 file changed, 106 insertions(+), 93 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 14695062a925..8b86acbb9770 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1335,6 +1335,106 @@ static void nft_chain_release_hook(struct nft_chain_hook *hook)
 		dev_put(hook->dev);
 }
 
+static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
+			      u8 policy, bool create)
+{
+	const struct nlattr * const *nla = ctx->nla;
+	struct nft_table *table = ctx->table;
+	struct nft_af_info *afi = ctx->afi;
+	struct nft_base_chain *basechain;
+	struct nft_stats __percpu *stats;
+	struct net *net = ctx->net;
+	struct nft_chain *chain;
+	unsigned int i;
+	int err;
+
+	if (table->use == UINT_MAX)
+		return -EOVERFLOW;
+
+	if (nla[NFTA_CHAIN_HOOK]) {
+		struct nft_chain_hook hook;
+		struct nf_hook_ops *ops;
+		nf_hookfn *hookfn;
+
+		err = nft_chain_parse_hook(net, nla, afi, &hook, create);
+		if (err < 0)
+			return err;
+
+		basechain = kzalloc(sizeof(*basechain), GFP_KERNEL);
+		if (basechain == NULL) {
+			nft_chain_release_hook(&hook);
+			return -ENOMEM;
+		}
+
+		if (hook.dev != NULL)
+			strncpy(basechain->dev_name, hook.dev->name, IFNAMSIZ);
+
+		if (nla[NFTA_CHAIN_COUNTERS]) {
+			stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
+			if (IS_ERR(stats)) {
+				nft_chain_release_hook(&hook);
+				kfree(basechain);
+				return PTR_ERR(stats);
+			}
+			basechain->stats = stats;
+			static_branch_inc(&nft_counters_enabled);
+		}
+
+		hookfn = hook.type->hooks[hook.num];
+		basechain->type = hook.type;
+		chain = &basechain->chain;
+
+		for (i = 0; i < afi->nops; i++) {
+			ops = &basechain->ops[i];
+			ops->pf		= family;
+			ops->hooknum	= hook.num;
+			ops->priority	= hook.priority;
+			ops->priv	= chain;
+			ops->hook	= afi->hooks[ops->hooknum];
+			ops->dev	= hook.dev;
+			if (hookfn)
+				ops->hook = hookfn;
+			if (afi->hook_ops_init)
+				afi->hook_ops_init(ops, i);
+		}
+
+		chain->flags |= NFT_BASE_CHAIN;
+		basechain->policy = policy;
+	} else {
+		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
+		if (chain == NULL)
+			return -ENOMEM;
+	}
+	INIT_LIST_HEAD(&chain->rules);
+	chain->handle = nf_tables_alloc_handle(table);
+	chain->table = table;
+	chain->name = nla_strdup(nla[NFTA_CHAIN_NAME], GFP_KERNEL);
+	if (!chain->name) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	err = nf_tables_register_hooks(net, table, chain, afi->nops);
+	if (err < 0)
+		goto err1;
+
+	ctx->chain = chain;
+	err = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
+	if (err < 0)
+		goto err2;
+
+	table->use++;
+	list_add_tail_rcu(&chain->list, &table->chains);
+
+	return 0;
+err2:
+	nf_tables_unregister_hooks(net, table, chain, afi->nops);
+err1:
+	nf_tables_chain_destroy(chain);
+
+	return err;
+}
+
 static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			      bool create)
 {
@@ -1433,19 +1533,15 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	const struct nlattr * uninitialized_var(name);
+	u8 genmask = nft_genmask_next(net);
+	int family = nfmsg->nfgen_family;
 	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct nft_chain *chain;
-	struct nft_base_chain *basechain = NULL;
-	u8 genmask = nft_genmask_next(net);
-	int family = nfmsg->nfgen_family;
 	u8 policy = NF_ACCEPT;
+	struct nft_ctx ctx;
 	u64 handle = 0;
-	unsigned int i;
-	struct nft_stats __percpu *stats;
-	int err;
 	bool create;
-	struct nft_ctx ctx;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
@@ -1493,101 +1589,18 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 		}
 	}
 
+	nft_ctx_init(&ctx, net, skb, nlh, afi, table, chain, nla);
+
 	if (chain != NULL) {
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
-		nft_ctx_init(&ctx, net, skb, nlh, afi, table, chain, nla);
-
 		return nf_tables_updchain(&ctx, genmask, policy, create);
 	}
 
-	if (table->use == UINT_MAX)
-		return -EOVERFLOW;
-
-	if (nla[NFTA_CHAIN_HOOK]) {
-		struct nft_chain_hook hook;
-		struct nf_hook_ops *ops;
-		nf_hookfn *hookfn;
-
-		err = nft_chain_parse_hook(net, nla, afi, &hook, create);
-		if (err < 0)
-			return err;
-
-		basechain = kzalloc(sizeof(*basechain), GFP_KERNEL);
-		if (basechain == NULL) {
-			nft_chain_release_hook(&hook);
-			return -ENOMEM;
-		}
-
-		if (hook.dev != NULL)
-			strncpy(basechain->dev_name, hook.dev->name, IFNAMSIZ);
-
-		if (nla[NFTA_CHAIN_COUNTERS]) {
-			stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
-			if (IS_ERR(stats)) {
-				nft_chain_release_hook(&hook);
-				kfree(basechain);
-				return PTR_ERR(stats);
-			}
-			basechain->stats = stats;
-			static_branch_inc(&nft_counters_enabled);
-		}
-
-		hookfn = hook.type->hooks[hook.num];
-		basechain->type = hook.type;
-		chain = &basechain->chain;
-
-		for (i = 0; i < afi->nops; i++) {
-			ops = &basechain->ops[i];
-			ops->pf		= family;
-			ops->hooknum	= hook.num;
-			ops->priority	= hook.priority;
-			ops->priv	= chain;
-			ops->hook	= afi->hooks[ops->hooknum];
-			ops->dev	= hook.dev;
-			if (hookfn)
-				ops->hook = hookfn;
-			if (afi->hook_ops_init)
-				afi->hook_ops_init(ops, i);
-		}
-
-		chain->flags |= NFT_BASE_CHAIN;
-		basechain->policy = policy;
-	} else {
-		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
-		if (chain == NULL)
-			return -ENOMEM;
-	}
-
-	INIT_LIST_HEAD(&chain->rules);
-	chain->handle = nf_tables_alloc_handle(table);
-	chain->table = table;
-	chain->name = nla_strdup(name, GFP_KERNEL);
-	if (!chain->name) {
-		err = -ENOMEM;
-		goto err1;
-	}
-
-	err = nf_tables_register_hooks(net, table, chain, afi->nops);
-	if (err < 0)
-		goto err1;
-
-	nft_ctx_init(&ctx, net, skb, nlh, afi, table, chain, nla);
-	err = nft_trans_chain_add(&ctx, NFT_MSG_NEWCHAIN);
-	if (err < 0)
-		goto err2;
-
-	table->use++;
-	list_add_tail_rcu(&chain->list, &table->chains);
-	return 0;
-err2:
-	nf_tables_unregister_hooks(net, table, chain, afi->nops);
-err1:
-	nf_tables_chain_destroy(chain);
-	return err;
+	return nf_tables_addchain(&ctx, family, genmask, policy, create);
 }
 
 static int nf_tables_delchain(struct net *net, struct sock *nlsk,
-- 
2.1.4


