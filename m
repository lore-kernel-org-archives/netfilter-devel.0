Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670C342DFF4
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 14:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212805; cv=none; b=QWqsBuesHdBXASDDAGrzgx59hIzlnSdBx5Q0GnyunWarBG/s5c0Ewb/pYxIb8allDmnexWKAQiiI2j5R2vwcy7s5XEKfeomBYY/irIxluXDZ6qfKUPpEDvhF71RrTmlGGmxLS1etfLOO3i4NutqA0toFubeoMA0OR63+d0lwx4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212805; c=relaxed/simple;
	bh=F3/EyZrZ90GoeQFWPP7/fZokJ2RkkFeLFahXH3vRrjI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y5F31fQXMeCG7ax7bfgRhbSfDveSUACrwa8J6rD1SHbaThghiJMM40FTl0NgFl2HM0BaB4noesUlxm0eEznxJ7I6aeGMvQSRghESfOxSO2GrYFUrNZdHDa7XqXk2sPVh9GLvSZlloMPUYwlXZihvmW9Sy2NpBpBnbbQHzcuwvZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lj6Pr3qV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lj6Pr3qV"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B431B602F3;
	Thu, 16 Jul 2026 16:39:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784212793;
	bh=LROkeGt9gUojvC/cWVbKCc3i7dVH0FjUT/X+pj+W/ao=;
	h=From:To:Cc:Subject:Date:From;
	b=lj6Pr3qV+6EA9k8YHZd1qe/nC255fqQ3D9RAHxzHnbOcWjL4AmcAZqwPcpnVhOMcH
	 hLlJzppfprM9qAeZV8lpMPl7Q6cyq5jCnKhvK+gayoNogoG5DSt+fy8QgnDp6j8Ebq
	 /c7Dj3zwHtcIA5aZd/jltVv8fTP72ypsw9aA4y2Ep5RW+rPi4a54buE2sE3PhZedNA
	 fcGorNSi4OvCehn6+OxmACzOPOjgvy1lrUaItUg8ZvxFX+NNMXerGUGDdYr7bXg8nc
	 H8zCotLyU4A1GbC/nEQxckoVZVfCSx3QKcItRDuJBDopL7mdOi5oKj1dE5X0f/8Y4x
	 qtmvivQEvLf6A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: nf_tables: make nft_object rhltable per netns
Date: Thu, 16 Jul 2026 16:39:46 +0200
Message-ID: <20260716143946.120214-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nft_object rhltable is global, this allows for accessing objects
that are being dismangled from lookup path by other existing netns.
Given the nft_obj_destroy() releases the object inmediately, this might
lead to use-after-free of these objects that are being released.
Make the existing rhltable per netns to address this issue.

Fixes: 4d44175aa5bb ("netfilter: nf_tables: handle nft_object lookups via rhltable")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 36 ++++++++++++++++---------------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9d844354c4d9..bace432fb367 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1948,6 +1948,7 @@ struct nftables_pernet {
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
+	struct rhltable		objname_ht;
 	u64			table_handle;
 	u64			tstamp;
 	unsigned int		gc_seq;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a9eaf9455c77..f91d70d67f02 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -45,8 +45,6 @@ enum {
 	NFT_VALIDATE_DO,
 };
 
-static struct rhltable nft_objname_ht;
-
 static u32 nft_chain_hash(const void *data, u32 len, u32 seed);
 static u32 nft_chain_hash_obj(const void *data, u32 len, u32 seed);
 static int nft_chain_hash_cmp(struct rhashtable_compare_arg *, const void *);
@@ -8091,6 +8089,7 @@ struct nft_object *nft_obj_lookup(const struct net *net,
 				  u8 genmask)
 {
 	struct nft_object_hash_key k = { .table = table };
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	char search[NFT_OBJ_MAXNAMELEN];
 	struct rhlist_head *tmp, *list;
 	struct nft_object *obj;
@@ -8102,7 +8101,7 @@ struct nft_object *nft_obj_lookup(const struct net *net,
 		     !lockdep_commit_lock_is_held(net));
 
 	rcu_read_lock();
-	list = rhltable_lookup(&nft_objname_ht, &k, nft_objname_ht_params);
+	list = rhltable_lookup(&nft_net->objname_ht, &k, nft_objname_ht_params);
 	if (!list)
 		goto out;
 
@@ -8291,6 +8290,7 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -8382,7 +8382,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_trans;
 
-	err = rhltable_insert(&nft_objname_ht, &obj->rhlhead,
+	err = rhltable_insert(&nft_net->objname_ht, &obj->rhlhead,
 			      nft_objname_ht_params);
 	if (err < 0)
 		goto err_obj_ht;
@@ -8475,7 +8475,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
-	struct nftables_pernet *nft_net;
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	const struct nft_table *table;
 	unsigned int entries = 0;
 	struct nft_object *obj;
@@ -10437,9 +10437,11 @@ static void nf_tables_commit_chain(struct net *net, struct nft_chain *chain)
 		nf_tables_commit_chain_free_rules_old(g0);
 }
 
-static void nft_obj_del(struct nft_object *obj)
+static void nft_obj_del(struct net *net, struct nft_object *obj)
 {
-	rhltable_remove(&nft_objname_ht, &obj->rhlhead, nft_objname_ht_params);
+	struct nftables_pernet *nft_net = nft_pernet(net);
+
+	rhltable_remove(&nft_net->objname_ht, &obj->rhlhead, nft_objname_ht_params);
 	list_del_rcu(&obj->list);
 }
 
@@ -11124,7 +11126,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELOBJ:
 		case NFT_MSG_DESTROYOBJ:
-			nft_obj_del(nft_trans_obj(trans));
+			nft_obj_del(net, nft_trans_obj(trans));
 			nf_tables_obj_notify(&ctx, nft_trans_obj(trans),
 					     trans->msg_type);
 			break;
@@ -11416,7 +11418,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 			} else {
 				nft_use_dec_restore(&table->use);
-				nft_obj_del(nft_trans_obj(trans));
+				nft_obj_del(net, nft_trans_obj(trans));
 			}
 			break;
 		case NFT_MSG_DELOBJ:
@@ -12043,7 +12045,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		nft_set_destroy(&ctx, set);
 	}
 	list_for_each_entry_safe(obj, ne, &table->objects, list) {
-		nft_obj_del(obj);
+		nft_obj_del(net, obj);
 		nft_use_dec(&table->use);
 		nft_obj_destroy(&ctx, obj);
 	}
@@ -12129,6 +12131,11 @@ static struct notifier_block nft_nl_notifier = {
 static int __net_init nf_tables_init_net(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
+	int err;
+
+	err = rhltable_init(&nft_net->objname_ht, &nft_objname_ht_params);
+	if (err < 0)
+		return err;
 
 	INIT_LIST_HEAD(&nft_net->tables);
 	INIT_LIST_HEAD(&nft_net->commit_list);
@@ -12175,6 +12182,8 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 
 	nft_gc_seq_end(nft_net, gc_seq);
 
+	rhltable_destroy(&nft_net->objname_ht);
+
 	mutex_unlock(&nft_net->commit_mutex);
 
 	WARN_ON_ONCE(!list_empty(&nft_net->tables));
@@ -12225,10 +12234,6 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err_netdev_notifier;
 
-	err = rhltable_init(&nft_objname_ht, &nft_objname_ht_params);
-	if (err < 0)
-		goto err_rht_objname;
-
 	err = nft_offload_init();
 	if (err < 0)
 		goto err_offload;
@@ -12251,8 +12256,6 @@ static int __init nf_tables_module_init(void)
 err_netlink_notifier:
 	nft_offload_exit();
 err_offload:
-	rhltable_destroy(&nft_objname_ht);
-err_rht_objname:
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 err_netdev_notifier:
 	nf_tables_core_module_exit();
@@ -12274,7 +12277,6 @@ static void __exit nf_tables_module_exit(void)
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	cancel_work_sync(&trans_gc_work);
 	rcu_barrier();
-	rhltable_destroy(&nft_objname_ht);
 	nf_tables_core_module_exit();
 }
 
-- 
2.47.3

