Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=94.136.29.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395606;
	b=HbVhIW9xA7GdX69MUcbvAGJtUagWOQ7gLHQ9Qww7kiUS2i5g1NnDp+v4BSoYam+7I9Z2
	 I6X4NZNyGF8RN5b1eshk65lk4gx+RahrZ8D2KHjFh9tvuLdi9GtG+F280uMUMKnP5Fqjm
	 Bj6HT/Y02pX1lVLEACWYgVX0QlG4koNnU85bT9tc9UNZ4lrkzmDL01lGwUKXNvqwa2Xoj
	 uL2sOeYFsEBBJj5ncWefVBUJjorKoTCbVhoSe18ODVlTehjLmSGUnwSkO1A/LwL0PLJID
	 /bx9wlaNs5UH2s4qINDnsNupiBkR4SPcTq4phtr4fDs9K9jBcHJ30GK+jhtNE+SuPzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395606;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-Bm-Milter-Handled:X-Bm-Transport-Timestamp;
	bh=+C5Mh1jQp2x4DJwRRumFNbkbRDfL43kB0UrIIiieYg4=;
	b=0c80vGjjsFZHHBR1DmjSmceE6CgO0vyY2PhMcE+T+AICifdWRm2CcjI7PUABR5akLB2n
	 qILj2rYnSe5xet2WVVtH5qqvHJfwS1c9Kkx3FQSLtj7NiFeJusrWOMc0eSZ/XqxMXjyF/
	 1TrAIQoXbs1M1FmrObRy8ssDgJN/Mp3exArQpJDCQmdgaEPr/qpZhNjwA9A1KwqqVVXwa
	 rXTJQcCkdO6+ai/p+Eu3Ehz3cnrNyaYDN4MUkUnKmolHcTiwEjLgQmR27bzyNpcgVVr4b
	 E4n2xnAMqWUWNqI9LhyGF2BKxgyTaUYl/YbNbblrFV9k8ySvluU6u2j1XDDbfMDXm8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=proxmox.com;
	spf=pass smtp.mailfrom=proxmox.com;
	arc=none smtp.remote-ip=94.136.29.106
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174C6606A324
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 11:13:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 174C6606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id B8D13475AB;
	Wed, 11 Nov 2026 12:13:17 +0100 (CET)
From: Stefan Hanreich <s.hanreich@proxmox.com>
To: netfilter-devel@vger.kernel.org
Cc: Stefan Hanreich <s.hanreich@proxmox.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next 1/3] netfilter: nf_tables: use a hashtable for set lookups by name
Date: Wed, 11 Nov 2026 12:12:44 +0100
Message-ID: <20261111111250.226432-2-s.hanreich@proxmox.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111111250.226432-1-s.hanreich@proxmox.com>
References: <20261111111250.226432-1-s.hanreich@proxmox.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1794395595857

Sets of a table are kept in a linked list, which is walked for every
lookup by name. This happens when creating a set (duplicate check),
when adding, deleting or getting set elements and when a lookup,
dynset or objref expression refers to a set by name. Loading a ruleset
with many named sets therefore takes time quadratic in the number of
sets.

Add an rhltable keyed by the set name to struct nft_table, as is
already done for chains. An rhltable is needed since a deleted set and
a new set of the same name can coexist until the transaction is
committed; only one of them is active in a given generation. The list
is kept for stable walks during dumps and table flushes.

Use the hashtable in the duplicate name check of
nf_tables_set_alloc_name() as well.

Like for chains and objects, the name is now copied with nla_strscpy()
before the lookup, which cuts it off at the first NUL byte. A name
like "foo\0bar" now refers to an existing set "foo" instead of
matching no set. Creating a set with such a name used to fail with
-ENFILE if "foo" exists, since the name of a new set is cut off at the
NUL as well. It is now handled like a request for "foo".

Signed-off-by: Stefan Hanreich <s.hanreich@proxmox.com>
---
 include/net/netfilter/nf_tables.h |   8 ++-
 net/netfilter/nf_tables_api.c     | 114 ++++++++++++++++++++++++------
 2 files changed, 98 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9d597482363d..d09959eea8ba 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -545,6 +545,7 @@ struct nft_set_elem_expr {
  * 	struct nft_set - nf_tables set instance
  *
  *	@list: table set list node
+ *	@rhlhead: table set hashtable node
  *	@bindings: list of set bindings
  *	@refs: internal refcounting for async set destruction
  *	@table: table this set belongs to
@@ -580,6 +581,7 @@ struct nft_set_elem_expr {
  */
 struct nft_set {
 	struct list_head		list;
+	struct rhlist_head		rhlhead;
 	struct list_head		bindings;
 	refcount_t			refs;
 	struct nft_table		*table;
@@ -642,7 +644,7 @@ static inline struct nft_set *nft_set_container_of(const void *priv)
 }
 
 struct nft_set *nft_set_lookup_global(const struct net *net,
-				      const struct nft_table *table,
+				      struct nft_table *table,
 				      const struct nlattr *nla_set_name,
 				      const struct nlattr *nla_set_id,
 				      u8 genmask);
@@ -1289,7 +1291,8 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@list: used internally
  *	@chains_ht: chains in the table
  *	@chains: same, for stable walks
- *	@sets: sets in the table
+ *	@sets_ht: sets in the table
+ *	@sets: same, for stable walks
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
  *	@objname_ht: hashtable for objects lookup by name
@@ -1309,6 +1312,7 @@ struct nft_table {
 	struct list_head		list;
 	struct rhltable			chains_ht;
 	struct list_head		chains;
+	struct rhltable			sets_ht;
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 59ac623e6805..9fe234e329df 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -49,6 +49,9 @@ static u32 nft_chain_hash(const void *data, u32 len, u32 seed);
 static u32 nft_chain_hash_obj(const void *data, u32 len, u32 seed);
 static int nft_chain_hash_cmp(struct rhashtable_compare_arg *, const void *);
 
+static u32 nft_set_hash_obj(const void *data, u32 len, u32 seed);
+static int nft_set_hash_cmp(struct rhashtable_compare_arg *, const void *);
+
 static u32 nft_objname_hash(const void *data, u32 len, u32 seed);
 static u32 nft_objname_hash_obj(const void *data, u32 len, u32 seed);
 static int nft_objname_hash_cmp(struct rhashtable_compare_arg *, const void *);
@@ -62,6 +65,15 @@ static const struct rhashtable_params nft_chain_ht_params = {
 	.automatic_shrinking	= true,
 };
 
+static const struct rhashtable_params nft_set_ht_params = {
+	.head_offset		= offsetof(struct nft_set, rhlhead),
+	.key_offset		= offsetof(struct nft_set, name),
+	.hashfn			= nft_chain_hash,
+	.obj_hashfn		= nft_set_hash_obj,
+	.obj_cmpfn		= nft_set_hash_cmp,
+	.automatic_shrinking	= true,
+};
+
 static const struct rhashtable_params nft_objname_ht_params = {
 	.head_offset		= offsetof(struct nft_object, rhlhead),
 	.key_offset		= offsetof(struct nft_object, key),
@@ -1556,6 +1568,22 @@ static int nft_chain_hash_cmp(struct rhashtable_compare_arg *arg,
 	return strcmp(chain->name, name);
 }
 
+static u32 nft_set_hash_obj(const void *data, u32 len, u32 seed)
+{
+	const struct nft_set *set = data;
+
+	return nft_chain_hash(set->name, 0, seed);
+}
+
+static int nft_set_hash_cmp(struct rhashtable_compare_arg *arg,
+			    const void *ptr)
+{
+	const struct nft_set *set = ptr;
+	const char *name = arg->key;
+
+	return strcmp(set->name, name);
+}
+
 static u32 nft_objname_hash(const void *data, u32 len, u32 seed)
 {
 	const struct nft_object_hash_key *k = data;
@@ -1677,6 +1705,10 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_obj_ht;
 
+	err = rhltable_init(&table->sets_ht, &nft_set_ht_params);
+	if (err < 0)
+		goto err_set_ht;
+
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
@@ -1695,6 +1727,8 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	list_add_tail_rcu(&table->list, &nft_net->tables);
 	return 0;
 err_trans:
+	rhltable_destroy(&table->sets_ht);
+err_set_ht:
 	rhltable_destroy(&table->objname_ht);
 err_obj_ht:
 	rhltable_destroy(&table->chains_ht);
@@ -1864,6 +1898,7 @@ static void nf_tables_table_destroy(struct nft_table *table)
 
 	rhltable_destroy(&table->chains_ht);
 	rhltable_destroy(&table->objname_ht);
+	rhltable_destroy(&table->sets_ht);
 	kfree(table->name);
 	kfree(table->udata);
 	kfree(table);
@@ -4815,22 +4850,50 @@ static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
 	[NFTA_SET_DESC_CONCAT]		= NLA_POLICY_NESTED_ARRAY(nft_concat_policy),
 };
 
+static struct nft_set *__nft_set_lookup(const struct net *net,
+					struct nft_table *table,
+					const char *name, u8 genmask)
+{
+	struct rhlist_head *tmp, *list;
+	struct nft_set *set;
+
+	WARN_ON(!rcu_read_lock_held() &&
+		!lockdep_commit_lock_is_held(net));
+
+	set = ERR_PTR(-ENOENT);
+	rcu_read_lock();
+	list = rhltable_lookup(&table->sets_ht, name, nft_set_ht_params);
+	if (!list)
+		goto out_unlock;
+
+	rhl_for_each_entry_rcu(set, tmp, list, rhlhead) {
+		if (nft_active_genmask(set, genmask))
+			goto out_unlock;
+	}
+	set = ERR_PTR(-ENOENT);
+out_unlock:
+	rcu_read_unlock();
+	return set;
+}
+
 static struct nft_set *nft_set_lookup(const struct net *net,
-				      const struct nft_table *table,
+				      struct nft_table *table,
 				      const struct nlattr *nla, u8 genmask)
 {
-	struct nft_set *set;
+	char search[NFT_SET_MAXNAMELEN];
 
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	list_for_each_entry_rcu(set, &table->sets, list,
-				lockdep_commit_lock_is_held(net)) {
-		if (!nla_strcmp(nla, set->name) &&
-		    nft_active_genmask(set, genmask))
-			return set;
-	}
-	return ERR_PTR(-ENOENT);
+	nla_strscpy(search, nla, sizeof(search));
+
+	return __nft_set_lookup(net, table, search, genmask);
+}
+
+static void nft_set_del(struct nft_set *set)
+{
+	rhltable_remove(&set->table->sets_ht, &set->rhlhead, nft_set_ht_params);
+	list_del_rcu(&set->list);
 }
 
 static struct nft_set *nft_set_lookup_byhandle(const struct nft_table *table,
@@ -4868,7 +4931,7 @@ static struct nft_set *nft_set_lookup_byid(const struct net *net,
 }
 
 struct nft_set *nft_set_lookup_global(const struct net *net,
-				      const struct nft_table *table,
+				      struct nft_table *table,
 				      const struct nlattr *nla_set_name,
 				      const struct nlattr *nla_set_id,
 				      u8 genmask)
@@ -4931,14 +4994,11 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 	if (!set->name)
 		return -ENOMEM;
 
-	list_for_each_entry(i, &ctx->table->sets, list) {
-		if (!nft_is_active_next(ctx->net, i))
-			continue;
-		if (!strcmp(set->name, i->name)) {
-			kfree(set->name);
-			set->name = NULL;
-			return -ENFILE;
-		}
+	if (!IS_ERR(__nft_set_lookup(ctx->net, ctx->table, set->name,
+				     nft_genmask_next(ctx->net)))) {
+		kfree(set->name);
+		set->name = NULL;
+		return -ENFILE;
 	}
 	return 0;
 }
@@ -5757,10 +5817,20 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_set_expr_alloc;
 
+	err = rhltable_insert_key(&table->sets_ht, set->name, &set->rhlhead,
+				  nft_set_ht_params);
+	if (err < 0)
+		goto err_set_ht;
+
 	list_add_tail_rcu(&set->list, &table->sets);
 
 	return 0;
 
+err_set_ht:
+	/* queued in transaction log */
+	INIT_LIST_HEAD(&set->list);
+	return err;
+
 err_set_expr_alloc:
 	for (i = 0; i < set->num_exprs; i++)
 		nft_expr_destroy(&ctx, set->exprs[i]);
@@ -5963,7 +6033,7 @@ static void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	list_del_rcu(&binding->list);
 
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
-		list_del_rcu(&set->list);
+		nft_set_del(set);
 		set->dead = 1;
 		if (event)
 			nf_tables_set_notify(ctx, set, NFT_MSG_DELSET,
@@ -11172,7 +11242,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_DELSET:
 		case NFT_MSG_DESTROYSET:
 			nft_trans_set(trans)->dead = 1;
-			list_del_rcu(&nft_trans_set(trans)->list);
+			nft_set_del(nft_trans_set(trans));
 			nf_tables_set_notify(&ctx, nft_trans_set(trans),
 					     trans->msg_type, GFP_KERNEL);
 			break;
@@ -11447,7 +11517,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				break;
 			}
 			nft_trans_set(trans)->dead = 1;
-			list_del_rcu(&nft_trans_set(trans)->list);
+			nft_set_del(nft_trans_set(trans));
 			break;
 		case NFT_MSG_DELSET:
 		case NFT_MSG_DESTROYSET:
@@ -12102,7 +12172,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		nf_tables_flowtable_destroy(flowtable);
 	}
 	list_for_each_entry_safe(set, ns, &table->sets, list) {
-		list_del(&set->list);
+		nft_set_del(set);
 		nft_use_dec(&table->use);
 		if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
 			nft_map_deactivate(&ctx, set);
-- 
2.47.3


