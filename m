Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D5A2EEE85
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2026 07:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784274709; cv=none; b=KoTg2of6e6BTrAl13Xn+0fmmcpsvWk2zJ2TqH8689BkZ509tQGOrb0rx07aDlPBgaOTLEb1wkCOI98kYuFOsEx0RT0I10sIGPEuy+s3EpwnuT0oLjFaTy47Xc5o82kAKoC1cLUmjk3Qw2RsEzD2Z5He20h8qIKlOmc2W7xCXDNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784274709; c=relaxed/simple;
	bh=dr9HsTnR02fZm9+VY+vh1OtwTMQbIFnoE+n5/wnI3a4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bVqwLRWGb5wWuMaz5DzvnEjJsatwsUQ2b0MVqP+JmzPKCim5rarFC8JYYpC97nTR/hsFNZA+sSnmT+T7CjNfA9DnjXmxLvWC+DUueqa5C+00d8z8/nhc4YZvYK93QFaHQIVm09I5VrV/lBoxvsbEucoIgkEA3C52i4e8iEGR5e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kuVnlEnb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kuVnlEnb"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E7D6760195;
	Fri, 17 Jul 2026 09:51:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784274703;
	bh=Sgq8WkmdQaxDgspP9MBWLPY+5djOvOWgIHK7/6HME9w=;
	h=From:To:Cc:Subject:Date:From;
	b=kuVnlEnb2aUWcnHnZoM7iPQ9UIIdTfPU/EHvarYwHo+VJkd45AhfyH5jGsRJVS+HX
	 3SoTo97YsI6fwy59TJIjlqowWO/lGfNAi6vjRx4r4BZBC3W2vQcZrxM6GcD1i1RDjh
	 eLS72T/2yEbQK54idaMn/vQcFXrlN5WzrxoSsLMC0sp2z+dLM51fJ6XXcdC3rfjbzu
	 MkHXPSsWjLEeLM2b5thsp9cZFanJiSJHuvEkXbROPoj5PLwLXsWsz9hw8EdDwO4Yqm
	 6ukFQg0TXxoHO9GVET9g5n99Kvxm+v46yrIRKlxacvmjsqaQANhx161Mt7wYCh7yIV
	 tStBPxle2TM7w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v2] netfilter: nf_tables: make nft_object rhltable per table
Date: Fri, 17 Jul 2026 09:51:39 +0200
Message-ID: <20260717075139.182629-1-pablo@netfilter.org>
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
v2: repurpose v1 to keep the rhashtable of nft_object under the table hierarchy

 include/net/netfilter/nf_tables.h |  5 ++++-
 net/netfilter/nf_tables_api.c     | 34 +++++++++++++++----------------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9d844354c4d9..623aa28fc1b1 100644
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
 
@@ -1948,6 +1950,7 @@ struct nftables_pernet {
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
+	struct rhltable		objname_ht;
 	u64			table_handle;
 	u64			tstamp;
 	unsigned int		gc_seq;
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

