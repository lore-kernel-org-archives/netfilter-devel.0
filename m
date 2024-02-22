Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25F221869;
	Thu, 22 Feb 2024 00:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560535; cv=none; b=NG8UXUpiqYFPe/hRFJ7wMi1o5fmBJjH1PQvaZvuty9DUlUJHlMjNnxoKPSvAOHn2J+7+grwkwYVBPBLUoM6N5tbUiasgA5m5p4vcZIpD8CxlFtkgHCRgR9GiVCjc7Y1Kv2+q1dhDgtRRPAjaWCq2odQ2dXJfQ0ZBog6JdEtwGUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560535; c=relaxed/simple;
	bh=MioU72Oj17xRp4RxHVNt4e1PkkzKxQ4TlJ92GqoCC/U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WRFkdMj9X46gOkkpdGePvOGmYy4SyiYkrsbE7fLKmJL3ZK3h67UKnsypz5pXbc8VhWjrq/AsJgwRw3JJNhSTEahFyx4aS15BgyAnz0VSct6MWHd6zqpRu7jWczvVJwB5Nftouh8wbfjKfEaV9rX4SQ+AqAEwt7OK+/Zn7uN7w0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 4/5] netfilter: nf_tables: register hooks last when adding new chain/flowtable
Date: Thu, 22 Feb 2024 01:08:42 +0100
Message-Id: <20240222000843.146665-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240222000843.146665-1-pablo@netfilter.org>
References: <20240222000843.146665-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Register hooks last when adding chain/flowtable to ensure that packets do
not walk over datastructure that is being released in the error path
without waiting for the rcu grace period.

Fixes: 91c7b38dc9f0 ("netfilter: nf_tables: use new transaction infrastructure to handle chain")
Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 78 ++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 90038d778f37..485e047d5f98 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -684,15 +684,16 @@ static int nft_delobj(struct nft_ctx *ctx, struct nft_object *obj)
 	return err;
 }
 
-static int nft_trans_flowtable_add(struct nft_ctx *ctx, int msg_type,
-				   struct nft_flowtable *flowtable)
+static struct nft_trans *
+nft_trans_flowtable_add(struct nft_ctx *ctx, int msg_type,
+		        struct nft_flowtable *flowtable)
 {
 	struct nft_trans *trans;
 
 	trans = nft_trans_alloc(ctx, msg_type,
 				sizeof(struct nft_trans_flowtable));
 	if (trans == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	if (msg_type == NFT_MSG_NEWFLOWTABLE)
 		nft_activate_next(ctx->net, flowtable);
@@ -701,22 +702,22 @@ static int nft_trans_flowtable_add(struct nft_ctx *ctx, int msg_type,
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
-	return 0;
+	return trans;
 }
 
 static int nft_delflowtable(struct nft_ctx *ctx,
 			    struct nft_flowtable *flowtable)
 {
-	int err;
+	struct nft_trans *trans;
 
-	err = nft_trans_flowtable_add(ctx, NFT_MSG_DELFLOWTABLE, flowtable);
-	if (err < 0)
-		return err;
+	trans = nft_trans_flowtable_add(ctx, NFT_MSG_DELFLOWTABLE, flowtable);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	nft_deactivate_next(ctx->net, flowtable);
 	nft_use_dec(&ctx->table->use);
 
-	return err;
+	return 0;
 }
 
 static void __nft_reg_track_clobber(struct nft_regs_track *track, u8 dreg)
@@ -2504,19 +2505,15 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	RCU_INIT_POINTER(chain->blob_gen_0, blob);
 	RCU_INIT_POINTER(chain->blob_gen_1, blob);
 
-	err = nf_tables_register_hook(net, table, chain);
-	if (err < 0)
-		goto err_destroy_chain;
-
 	if (!nft_use_inc(&table->use)) {
 		err = -EMFILE;
-		goto err_use;
+		goto err_destroy_chain;
 	}
 
 	trans = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
-		goto err_unregister_hook;
+		goto err_trans;
 	}
 
 	nft_trans_chain_policy(trans) = NFT_CHAIN_POLICY_UNSET;
@@ -2524,17 +2521,22 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		nft_trans_chain_policy(trans) = policy;
 
 	err = nft_chain_add(table, chain);
-	if (err < 0) {
-		nft_trans_destroy(trans);
-		goto err_unregister_hook;
-	}
+	if (err < 0)
+		goto err_chain_add;
+
+	/* This must be LAST to ensure no packets are walking over this chain. */
+	err = nf_tables_register_hook(net, table, chain);
+	if (err < 0)
+		goto err_register_hook;
 
 	return 0;
 
-err_unregister_hook:
+err_register_hook:
+	nft_chain_del(chain);
+err_chain_add:
+	nft_trans_destroy(trans);
+err_trans:
 	nft_use_dec_restore(&table->use);
-err_use:
-	nf_tables_unregister_hook(net, table, chain);
 err_destroy_chain:
 	nf_tables_chain_destroy(ctx);
 
@@ -8456,9 +8458,9 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 	u8 family = info->nfmsg->nfgen_family;
 	const struct nf_flowtable_type *type;
 	struct nft_flowtable *flowtable;
-	struct nft_hook *hook, *next;
 	struct net *net = info->net;
 	struct nft_table *table;
+	struct nft_trans *trans;
 	struct nft_ctx ctx;
 	int err;
 
@@ -8538,34 +8540,34 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 	err = nft_flowtable_parse_hook(&ctx, nla, &flowtable_hook, flowtable,
 				       extack, true);
 	if (err < 0)
-		goto err4;
+		goto err_flowtable_parse_hooks;
 
 	list_splice(&flowtable_hook.list, &flowtable->hook_list);
 	flowtable->data.priority = flowtable_hook.priority;
 	flowtable->hooknum = flowtable_hook.num;
 
+	trans = nft_trans_flowtable_add(&ctx, NFT_MSG_NEWFLOWTABLE, flowtable);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto err_flowtable_trans;
+	}
+
+	/* This must be LAST to ensure no packets are walking over this flowtable. */
 	err = nft_register_flowtable_net_hooks(ctx.net, table,
 					       &flowtable->hook_list,
 					       flowtable);
-	if (err < 0) {
-		nft_hooks_destroy(&flowtable->hook_list);
-		goto err4;
-	}
-
-	err = nft_trans_flowtable_add(&ctx, NFT_MSG_NEWFLOWTABLE, flowtable);
 	if (err < 0)
-		goto err5;
+		goto err_flowtable_hooks;
 
 	list_add_tail_rcu(&flowtable->list, &table->flowtables);
 
 	return 0;
-err5:
-	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		nft_unregister_flowtable_hook(net, flowtable, hook);
-		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
-	}
-err4:
+
+err_flowtable_hooks:
+	nft_trans_destroy(trans);
+err_flowtable_trans:
+	nft_hooks_destroy(&flowtable->hook_list);
+err_flowtable_parse_hooks:
 	flowtable->data.type->free(&flowtable->data);
 err3:
 	module_put(type->owner);
-- 
2.30.2

