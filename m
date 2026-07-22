Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A845043F4B9;
	Wed, 22 Jul 2026 21:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754881; cv=none; b=YcJQHJueW4iBW3cKPEZOhjOHdgjp6id10Y86l/SNEEy7CaZrwkXuY9ag3Bt5dq6vES6mw+8Rv1kIdh9wWFhSRfd0py7lCh2pJpLAVWOXDpgaH4axgkBD13sp9mIhNLnzKHlGIRPkxbUKHYjVIcUqBb6WWYE0ijvgg2uEo0CIBfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754881; c=relaxed/simple;
	bh=a9eW5UjiUsFokzTmtIEO7TdW6abvQIWyBducaKV8pBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hX+l6dgDYE6HNUyj9llov2TWGNBtTZbzcAzhrk0nunZllpA+BoJwXqt6jzMfJsWa7XRGHNyxzqGKe8zcWKTTdcFT5nlz83rwENSXZrORorgpBsshfgGThZBeFn0Dl+h1+dBUWG4Z5pODVjLFAAZDBP2/4mn6wh50KRQqvMnOcaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ttAiwAv6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ttAiwAv6"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 91BCB601A2;
	Wed, 22 Jul 2026 23:14:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784754877;
	bh=JwWpIydl3SpAL6+o5OaEr9U9ih1HXtxWQcRbvltUBEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttAiwAv6clZQfR+IxxS0oERzhLCSvzExY/AiE1EPtXOvz0gGtVgTlddkrpm6M8oSD
	 HEEHl65+XYK00NC+QEC+t+5uefaMPLEcYPHTSnhGbq3DNp6xi8I8e3WEPUf6SQJgIH
	 5rs2I0xD1W4JrJNODd0L8QL8oqgrREDYXZr9dxIAQVMReWKhZvzJ5GBpaRy66RIzde
	 HNI/fEDKk+wkFYVAQIcemGCncF1/WYxaq55zh3RTlkJMEoOyblx3LyEfpGJTbNtNDo
	 eF9Vkgy5Y4oLGvUOIXljqUG8bzXYusqg4ZhCGk+rxqzqR67I3oD/pkSUQDedcjRst+
	 WpVSKhOQmZZyw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 07/13] netfilter: nf_tables: make nft_object rhltable per table
Date: Wed, 22 Jul 2026 23:14:14 +0200
Message-ID: <20260722211420.153933-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722211420.153933-1-pablo@netfilter.org>
References: <20260722211420.153933-1-pablo@netfilter.org>
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

