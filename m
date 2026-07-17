Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425103F39D3
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2026 11:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784286400; cv=none; b=sdB7LlLklTbA/6a6oSKMj2eY8uNI36DAqe1QWqdGNeSWsuaJzq1SScTYE+M+llwrvejPdjDoSA/aWbYZfyDg87kFAtDWaE4i4pFKK8VkwD5qCxkkNRdDbsTPEkuXhePa2OOyKYD+50/3DHG/Z5tXb4xSh/dwOPyDFnRS86RFlX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784286400; c=relaxed/simple;
	bh=wHUcByUxVW3rbfhtzi8Qa5Ty81oZVNK6L6YgVvnV/zs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PAcls2XlPPXSAMkjnq9E7J2tg7AMoPeLtlrVNgO3o47FLybuPinYNXQMqoIPmAoRH8XaGQBz2hnCeRL2I1ulaszOiHdeErtr/D+/+MdqAd5PcOyQzVotFfQ0kHQnoVUm2n5nWSVdv4NLi3fp0ZBB/ngLkFRAPhkQ2ebVkOVT14Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZFe/HEaC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZFe/HEaC"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CE91F6019D;
	Fri, 17 Jul 2026 13:06:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784286387;
	bh=12moMw+L2T/JH0w5RGutjm4wfuDrPigs5o6AsWy+fsY=;
	h=From:To:Cc:Subject:Date:From;
	b=ZFe/HEaCyZYrNZmUixIimc9uO5AKr8HDDqUMtJc/QXxWYnMQzChpvc6o5V8hPjqEF
	 jSUJ/UxtpT5dVNeYVOS6t0fXE28qub5kvoKjubP1mcgH9fzSJcml/4QiMG2q7Sh4Oi
	 FahtsDCJ3QyIOAYP4jGSomiJdXc2jz5duTvlkjkn9Y9RTCylkUFGFTqeLNx0ZreSOB
	 E7qpuqk/S3t88zEriQh+vCXh3CxWBY0+AivL7UPIsw2WWgSUsghi2ngCsBC7ZSCCPW
	 iLpw0moiNHiYGltPSRpR/hdsGp7M+QQ8ZSo1kWH3J+dhPY3hPwuuT5ChqgPdUvsdtW
	 yBt1ViVJrlRsw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v3] netfilter: nf_tables: make nft_object rhltable per table
Date: Fri, 17 Jul 2026 13:06:21 +0200
Message-ID: <20260717110621.254943-1-pablo@netfilter.org>
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
Make the existing rhltable per table to address this issue to deal with
with the nft_rcv_nl_event() path too.

Update nft_obj_lookup() to take the table as non-const, otherwise,
compiler complains when passing the objname_ht to rhltable_lookup().

Fixes: 4d44175aa5bb ("netfilter: nf_tables: handle nft_object lookups via rhltable")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: remove oneliner leftover definition from the pernetns approach.

 include/net/netfilter/nf_tables.h |  4 +++-
 net/netfilter/nf_tables_api.c     | 34 +++++++++++++++----------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9d844354c4d9..3be612145c13 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1294,6 +1294,7 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@sets: sets in the table
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
+ *	@objname_ht: hashtable for objects lookup by name
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
@@ -1313,6 +1314,7 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
+	struct rhltable			objname_ht;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
@@ -1400,7 +1402,7 @@ static inline void *nft_obj_data(const struct nft_object *obj)
 #define nft_expr_obj(expr)	*((struct nft_object **)nft_expr_priv(expr))
 
 struct nft_object *nft_obj_lookup(const struct net *net,
-				  const struct nft_table *table,
+				  struct nft_table *table,
 				  const struct nlattr *nla, u32 objtype,
 				  u8 genmask);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a9eaf9455c77..af357f6c5070 100644
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
@@ -1635,6 +1633,10 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err)
 		goto err_chain_ht;
 
+	err = rhltable_init(&table->objname_ht, &nft_objname_ht_params);
+	if (err < 0)
+		goto err_obj_ht;
+
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
@@ -1653,6 +1655,8 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	list_add_tail_rcu(&table->list, &nft_net->tables);
 	return 0;
 err_trans:
+	rhltable_destroy(&table->objname_ht);
+err_obj_ht:
 	rhltable_destroy(&table->chains_ht);
 err_chain_ht:
 	kfree(table->udata);
@@ -1819,6 +1823,7 @@ static void nf_tables_table_destroy(struct nft_table *table)
 		return;
 
 	rhltable_destroy(&table->chains_ht);
+	rhltable_destroy(&table->objname_ht);
 	kfree(table->name);
 	kfree(table->udata);
 	kfree(table);
@@ -8086,7 +8091,7 @@ void nft_unregister_obj(struct nft_object_type *obj_type)
 EXPORT_SYMBOL_GPL(nft_unregister_obj);
 
 struct nft_object *nft_obj_lookup(const struct net *net,
-				  const struct nft_table *table,
+				  struct nft_table *table,
 				  const struct nlattr *nla, u32 objtype,
 				  u8 genmask)
 {
@@ -8102,7 +8107,7 @@ struct nft_object *nft_obj_lookup(const struct net *net,
 		     !lockdep_commit_lock_is_held(net));
 
 	rcu_read_lock();
-	list = rhltable_lookup(&nft_objname_ht, &k, nft_objname_ht_params);
+	list = rhltable_lookup(&table->objname_ht, &k, nft_objname_ht_params);
 	if (!list)
 		goto out;
 
@@ -8382,7 +8387,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_trans;
 
-	err = rhltable_insert(&nft_objname_ht, &obj->rhlhead,
+	err = rhltable_insert(&table->objname_ht, &obj->rhlhead,
 			      nft_objname_ht_params);
 	if (err < 0)
 		goto err_obj_ht;
@@ -8567,8 +8572,8 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
-	const struct nft_table *table;
 	struct net *net = info->net;
+	struct nft_table *table;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
 	u32 objtype;
@@ -10437,9 +10442,9 @@ static void nf_tables_commit_chain(struct net *net, struct nft_chain *chain)
 		nf_tables_commit_chain_free_rules_old(g0);
 }
 
-static void nft_obj_del(struct nft_object *obj)
+static void nft_obj_del(struct nft_table *table, struct nft_object *obj)
 {
-	rhltable_remove(&nft_objname_ht, &obj->rhlhead, nft_objname_ht_params);
+	rhltable_remove(&table->objname_ht, &obj->rhlhead, nft_objname_ht_params);
 	list_del_rcu(&obj->list);
 }
 
@@ -11124,7 +11129,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELOBJ:
 		case NFT_MSG_DESTROYOBJ:
-			nft_obj_del(nft_trans_obj(trans));
+			nft_obj_del(table, nft_trans_obj(trans));
 			nf_tables_obj_notify(&ctx, nft_trans_obj(trans),
 					     trans->msg_type);
 			break;
@@ -11416,7 +11421,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 			} else {
 				nft_use_dec_restore(&table->use);
-				nft_obj_del(nft_trans_obj(trans));
+				nft_obj_del(table, nft_trans_obj(trans));
 			}
 			break;
 		case NFT_MSG_DELOBJ:
@@ -12043,7 +12048,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		nft_set_destroy(&ctx, set);
 	}
 	list_for_each_entry_safe(obj, ne, &table->objects, list) {
-		nft_obj_del(obj);
+		nft_obj_del(table, obj);
 		nft_use_dec(&table->use);
 		nft_obj_destroy(&ctx, obj);
 	}
@@ -12225,10 +12230,6 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err_netdev_notifier;
 
-	err = rhltable_init(&nft_objname_ht, &nft_objname_ht_params);
-	if (err < 0)
-		goto err_rht_objname;
-
 	err = nft_offload_init();
 	if (err < 0)
 		goto err_offload;
@@ -12251,8 +12252,6 @@ static int __init nf_tables_module_init(void)
 err_netlink_notifier:
 	nft_offload_exit();
 err_offload:
-	rhltable_destroy(&nft_objname_ht);
-err_rht_objname:
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 err_netdev_notifier:
 	nf_tables_core_module_exit();
@@ -12274,7 +12273,6 @@ static void __exit nf_tables_module_exit(void)
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	cancel_work_sync(&trans_gc_work);
 	rcu_barrier();
-	rhltable_destroy(&nft_objname_ht);
 	nf_tables_core_module_exit();
 }
 
-- 
2.47.3

