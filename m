Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324FD265CC8
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 10:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747735908; cv=none; b=i/62sYRB287liw6uBwERcxsVSGWPeOCnCwIQpO++USLp21Yp/m7LAk7s471X61nEtnxdPw/+v5cYfPE07ByBR3u1cQOLXLwb2VEhZz9z0Tl8ma+Kfgtt8SfQPwQ2ttZVG+ry+3hOMg7JSEg1jOW1OFvFT+Oz+oeptOrQ9iN0ZKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747735908; c=relaxed/simple;
	bh=76M/IAnoOoQVo9KKMSZbhZE6QRtwH2yLJHSHMY435Uk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ApVYNJmz9dwZUODVhAi1h82O2VkIr6sM0HF+bMF+gpqwSHuk5Ezcd/7Xr1Ur2UCfids50oD2On0qQosEdeVfw2ps0i1AJvEg5bxnbM17ZaY+lPk3Nv0gIEpHr7s8B1XQ1pkeDN+zZHLhTuLOTjR7ymT9hvQJiMknP3Pav50hTRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AcvACHIX; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ezXKikL9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AcvACHIX";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ezXKikL9"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C10756075E; Tue, 20 May 2025 12:11:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747735904;
	bh=3/QjFI+N0INGo4wnfxBygzsGT1wwxsGyIIfQGen63Sk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AcvACHIX96pyfpHXNLKN6gDfAPrvjpIkZcZ09m6fzB7mfog9p800Ja4tNJ7zZ0vd1
	 jlmZy4Twqe5mGuUYbtexaug+JftkOedY0ZQkUVGAV6K5yu6eNcrODsR7Lz6wZgUNcr
	 yxe5uB+0RELol6LWbd7O+BGfvMf2bRh0r1pFp2MWmpNQiW2Nqzyz/ZHAKtYDjCfCZz
	 11jZEmLYjTX4EbOwh5XFgAMr7H/VSiUw3POoWuV+Drx8m0BnNmT2fwqIsocxp0Nrkh
	 Bg5WiCszEHTMfuTrfimDL2r9v10+C9krMCSLunJlMcGyX4MyFziGL1eX6sV6yOsu1L
	 R1Al4LVbT5euQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C1E7E60753
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 12:09:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747735751;
	bh=3/QjFI+N0INGo4wnfxBygzsGT1wwxsGyIIfQGen63Sk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ezXKikL9F3+Ga75yscbmkUZAzTzjKQnG5G8nKkLK7G7PvYmXFLfPx+qG8KPpr0VJw
	 VidHLuTm+fpbfnAl0ghfPXzC9uTbFSgmfph2dGjqFI5QRYIMZob23ED80VGsvddZ30
	 xuQUOATT0STFSCYkNV744Bd/NJMibLk92EzCiNadDZWiU+p16bx3vSnTezn2fzh+9p
	 cw5Ofo+03pCEZ0vEgrcSQfrnJznU8cyhlLdhUpNdm/sPFF+I2X5ZCrAiJlwRzQPaRL
	 hTUlcSve7lIB8OwDzY0JrzyJ+EOEzGdQinh/uA4A+bEX1KgoHodedW2Sye3fIWUTmO
	 K3ccuYujJjLkg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 2/4] netfilter: nf_tables: add new binding infrastructure
Date: Tue, 20 May 2025 12:09:05 +0200
Message-Id: <20250520100907.191244-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250520100907.191244-1-pablo@netfilter.org>
References: <20250520100907.191244-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add new binding infrastructure to build a graph that relates chains and
sets via jump/goto such as:

- chain to chain, ie. rule jump/goto chain.
- set to chain, ie. set element jump/goto chain.
- chain to set, ie. rule lookup to set.

The binding is composed of two tuples that describe [ from, to ], each
component of this tuple is defined as the object type and the pointer to
the object. This patch adds a hashtable for bindings per table to allow
for lookups of existing bindings in the preparation phase.

The bindings allows to backtrack to the basechain that refers to
this object for validation, and to go forward to check for loops
and to perform the rule validation.

This patch adds interfaces to deactivate/activate these bindings during
the preparation phase. Reference counter of zero tells us this binding
will be removed after this transaction.

This is still a preparation patch, a follow patch uses this infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 include/net/netfilter/nf_tables.h |  45 ++++
 net/netfilter/nf_tables_api.c     | 352 ++++++++++++++++++++++++++++++
 2 files changed, 397 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d391990d1a96..807097746d24 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -585,6 +585,8 @@ struct nft_set_elem_expr {
 struct nft_set {
 	struct list_head		list;
 	struct list_head		bindings;
+	struct list_head		binding_list;
+	struct list_head		backbinding_list;
 	refcount_t			refs;
 	struct nft_table		*table;
 	possible_net_t			net;
@@ -1117,6 +1119,8 @@ struct nft_rule_blob {
 struct nft_chain {
 	struct nft_rule_blob		__rcu *blob_gen_0;
 	struct nft_rule_blob		__rcu *blob_gen_1;
+	struct list_head		binding_list;
+	struct list_head		backbinding_list;
 	struct list_head		rules;
 	struct list_head		list;
 	struct list_head		validate_list;
@@ -1293,6 +1297,7 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
+	struct rhashtable		bindings_ht;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
@@ -1628,6 +1633,46 @@ static inline int nft_set_elem_is_dead(const struct nft_set_ext *ext)
 	return test_bit(NFT_SET_ELEM_DEAD_BIT, word);
 }
 
+enum nft_binding_type {
+        NFT_BIND_CHAIN	= 0,
+        NFT_BIND_SET,
+};
+
+/* Bindings. */
+struct nft_binding_key {
+	union {
+		const struct nft_chain	*chain;
+		const struct nft_set	*set;
+		const void		*ptr;
+	};
+	enum nft_binding_type		type;
+};
+
+struct nft_binding {
+	struct rhash_head		node;
+	struct list_head		list;
+	struct list_head		backlist;
+	struct nft_binding_key		from;
+	struct nft_binding_key		to;
+	uint32_t			use;
+};
+
+struct nft_chain;
+struct nft_set;
+
+int nft_add_chain_binding(struct nft_chain *chain1, struct nft_chain *chain2);
+void nft_activate_chain_binding(struct nft_chain *chain1, struct nft_chain *chain2);
+void nft_deactivate_chain_binding(struct nft_chain *chain1, struct nft_chain *chain2);
+void nft_del_chain_binding(struct nft_chain *chain1, struct nft_chain *chain2);
+int nft_add_chain_set_binding(struct nft_chain *chain, struct nft_set *set);
+void nft_deactivate_chain_set_binding(struct nft_chain *chain, struct nft_set *set);
+void nft_activate_chain_set_binding(struct nft_chain *chain, struct nft_set *set);
+void nft_del_chain_set_binding(struct nft_chain *chain, struct nft_set *set);
+int nft_add_set_chain_binding(struct nft_set *set, struct nft_chain *chain);
+void nft_deactivate_set_chain_binding(struct nft_set *set, struct nft_chain *chain);
+void nft_activate_set_chain_binding(struct nft_set *set, struct nft_chain *chain);
+void nft_del_set_chain_binding(struct nft_set *set, struct nft_chain *chain);
+
 /**
  * struct nft_trans - nf_tables object update in transaction
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 397d775072f9..2053e7093e3a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -954,6 +954,347 @@ void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg)
 }
 EXPORT_SYMBOL_GPL(__nft_reg_track_cancel);
 
+struct nft_binding_cmp_key {
+	const struct nft_binding_key	*from;
+	const struct nft_binding_key	*to;
+};
+
+static u32 nft_binding_hash(const void *data, u32 len, u32 seed)
+{
+	const struct nft_binding_cmp_key *key = data;
+	unsigned long tuple[4];
+
+	tuple[0] = (unsigned long)key->from->ptr;
+	tuple[1] = (unsigned long)key->from->type;
+	tuple[2] = (unsigned long)key->to->ptr;
+	tuple[3] = (unsigned long)key->to->type;
+
+	return jhash(tuple, sizeof(tuple), seed);
+}
+
+static u32 nft_binding_hash_obj(const void *data, u32 len, u32 seed)
+{
+	const struct nft_binding *binding = data;
+	unsigned long tuple[4];
+
+	tuple[0] = (unsigned long)binding->from.ptr;
+	tuple[1] = (unsigned long)binding->from.type;
+	tuple[2] = (unsigned long)binding->to.ptr;
+	tuple[3] = (unsigned long)binding->to.type;
+
+	return jhash(tuple, sizeof(tuple), seed);
+}
+
+static int nft_binding_hash_cmp(struct rhashtable_compare_arg *arg,
+				const void *ptr)
+{
+	const struct nft_binding_cmp_key *key = arg->key;
+	const struct nft_binding *binding = ptr;
+
+	return key->from->ptr != binding->from.ptr ||
+	       key->from->type != binding->from.type ||
+	       key->to->ptr != binding->to.ptr ||
+	       key->to->type != binding->to.type;
+}
+
+static const struct rhashtable_params nft_binding_ht_params = {
+	.head_offset		= offsetof(struct nft_binding, node),
+	.hashfn			= nft_binding_hash,
+	.obj_hashfn		= nft_binding_hash_obj,
+	.obj_cmpfn		= nft_binding_hash_cmp,
+	.automatic_shrinking	= true,
+};
+
+static struct nft_binding *nft_binding_lookup(struct nft_table *table,
+					      const struct nft_binding_key *from,
+					      const struct nft_binding_key *to)
+{
+	struct nft_binding_cmp_key key = {
+		.from	= from,
+		.to	= to,
+	};
+
+	return rhashtable_lookup_fast(&table->bindings_ht, &key,
+				      nft_binding_ht_params);
+}
+
+static void nft_deactivate_binding(struct nft_table *table,
+				   const struct nft_binding_key *from,
+				   const struct nft_binding_key *to)
+{
+	struct nft_binding *binding;
+
+	binding = nft_binding_lookup(table, from, to);
+	if (WARN_ON_ONCE(!binding))
+		return;
+	if (WARN_ON_ONCE(binding->use == 0))
+		return;
+
+	binding->use--;
+}
+
+void nft_deactivate_chain_binding(struct nft_chain *chain1,
+				  struct nft_chain *chain2)
+{
+	struct nft_binding_key from = {
+		.ptr	= chain1,
+		.type	= NFT_BIND_CHAIN,
+	};
+	struct nft_binding_key to = {
+		.ptr	= chain2,
+		.type	= NFT_BIND_CHAIN,
+	};
+
+	nft_deactivate_binding(chain1->table, &from, &to);
+}
+
+void nft_deactivate_chain_set_binding(struct nft_chain *chain,
+				      struct nft_set *set)
+{
+	struct nft_binding_key from = {
+		.ptr	= chain,
+		.type	= NFT_BIND_CHAIN,
+	};
+	struct nft_binding_key to = {
+		.ptr	= set,
+		.type	= NFT_BIND_SET,
+	};
+
+	nft_deactivate_binding(chain->table, &from, &to);
+}
+
+void nft_deactivate_set_chain_binding(struct nft_set *set,
+				      struct nft_chain *chain)
+{
+	struct nft_binding_key from = {
+		.ptr	= set,
+		.type	= NFT_BIND_SET,
+	};
+	struct nft_binding_key to = {
+		.ptr	= chain,
+		.type	= NFT_BIND_CHAIN,
+	};
+
+	nft_deactivate_binding(chain->table, &from, &to);
+}
+
+static void nft_activate_binding(struct nft_table *table,
+				 const struct nft_binding_key *from,
+				 const struct nft_binding_key *to)
+{
+	struct nft_binding *binding;
+
+	binding = nft_binding_lookup(table, from, to);
+	if (WARN_ON_ONCE(!binding))
+		return;
+
+	binding->use++;
+}
+
+void nft_activate_chain_binding(struct nft_chain *chain1,
+				struct nft_chain *chain2)
+{
+	struct nft_binding_key from = {
+		.ptr	= chain1,
+		.type	= NFT_BIND_CHAIN,
+	};
+	struct nft_binding_key to = {
+		.ptr	= chain2,
+		.type	= NFT_BIND_CHAIN,
+	};
+
+	nft_activate_binding(chain1->table, &from, &to);
+}
+
+void nft_activate_chain_set_binding(struct nft_chain *chain,
+				    struct nft_set *set)
+{
+	struct nft_binding_key from = {
+		.ptr	= chain,
+		.type	= NFT_BIND_CHAIN,
+	};
+	struct nft_binding_key to = {
+		.ptr	= set,
+		.type	= NFT_BIND_SET,
+	};
+
+	nft_activate_binding(chain->table, &from, &to);
+}
+
+void nft_activate_set_chain_binding(struct nft_set *set,
+				    struct nft_chain *chain)
+{
+	struct nft_binding_key from = {
+		.ptr	= set,
+		.type	= NFT_BIND_SET,
+	};
+	struct nft_binding_key to = {
+		.ptr	= chain,
+		.type	= NFT_BIND_CHAIN,
+	};
+
+	nft_activate_binding(chain->table, &from, &to);
+}
+
+static void nft_del_binding(struct nft_table *table,
+			    const struct nft_binding_key *from,
+			    const struct nft_binding_key *to)
+{
+	struct nft_binding *binding;
+	int err;
+
+	binding = nft_binding_lookup(table, from, to);
+	/* With several references to object, deactivate deals to zero use,
+	 * then first delete binding call remove it.
+	 */
+	if (!binding)
+		return;
+
+	if (binding->use != 0)
+		return;
+
+	list_del(&binding->list);
+	list_del(&binding->backlist);
+
+	err = rhashtable_remove_fast(&table->bindings_ht,
+				     &binding->node, nft_binding_ht_params);
+	if (WARN_ON_ONCE(err < 0))
+		return;
+
+	kfree(binding);
+}
+
+void nft_del_chain_binding(struct nft_chain *chain1, struct nft_chain *chain2)
+{
+	struct nft_binding_key from = {
+		.ptr	= chain1,
+		.type	= NFT_BIND_CHAIN,
+	};
+	struct nft_binding_key to = {
+		.ptr	= chain2,
+		.type	= NFT_BIND_CHAIN,
+	};
+
+	nft_del_binding(chain1->table, &from, &to);
+}
+
+void nft_del_chain_set_binding(struct nft_chain *chain, struct nft_set *set)
+{
+	struct nft_binding_key from = {
+		.ptr	= chain,
+		.type	= NFT_BIND_CHAIN,
+	};
+	struct nft_binding_key to = {
+		.ptr	= set,
+		.type	= NFT_BIND_SET,
+	};
+
+	nft_del_binding(chain->table, &from, &to);
+}
+
+void nft_del_set_chain_binding(struct nft_set *set, struct nft_chain *chain)
+{
+	struct nft_binding_key from = {
+		.ptr	= set,
+		.type	= NFT_BIND_SET,
+	};
+	struct nft_binding_key to = {
+		.ptr	= chain,
+		.type	= NFT_BIND_CHAIN,
+	};
+
+	nft_del_binding(chain->table, &from, &to);
+}
+
+static int __nft_add_binding(struct nft_table *table,
+			     const struct nft_binding_key *from,
+			     const struct nft_binding_key *to,
+			     struct list_head *binding_list,
+			     struct list_head *backbinding_list)
+{
+	struct nft_binding *binding;
+
+	binding = kzalloc(sizeof(struct nft_binding), GFP_KERNEL);
+	if (!binding)
+		return -ENOMEM;
+
+	binding->from = *from;
+	binding->to = *to;
+	binding->use++;
+
+	list_add_tail(&binding->list, binding_list);
+	list_add_tail(&binding->backlist, backbinding_list);
+
+	return rhashtable_insert_fast(&table->bindings_ht, &binding->node,
+				      nft_binding_ht_params);
+}
+
+static int nft_add_binding(struct nft_table *table,
+			   const struct nft_binding_key *from,
+			   const struct nft_binding_key *to,
+			   struct list_head *binding_list,
+			   struct list_head *backbinding_list)
+{
+	struct nft_binding *binding;
+
+	binding = nft_binding_lookup(table, from, to);
+	if (!binding)
+		return __nft_add_binding(table, from, to,
+					 binding_list, backbinding_list);
+
+	if (binding->use == UINT_MAX)
+		return -EOVERFLOW;
+
+	binding->use++;
+
+	return 0;
+}
+
+int nft_add_chain_binding(struct nft_chain *chain1, struct nft_chain *chain2)
+{
+	struct nft_binding_key from = {
+		.ptr	= chain1,
+		.type	= NFT_BIND_CHAIN,
+	};
+	struct nft_binding_key to = {
+		.ptr	= chain2,
+		.type	= NFT_BIND_CHAIN,
+	};
+
+	return nft_add_binding(chain1->table, &from, &to,
+			       &chain1->binding_list, &chain2->backbinding_list);
+}
+
+int nft_add_chain_set_binding(struct nft_chain *chain, struct nft_set *set)
+{
+	struct nft_binding_key from = {
+		.ptr	= chain,
+		.type	= NFT_BIND_CHAIN,
+	};
+	struct nft_binding_key to = {
+		.ptr	= set,
+		.type	= NFT_BIND_SET,
+	};
+
+	return nft_add_binding(chain->table, &from, &to,
+			       &chain->binding_list, &set->backbinding_list);
+}
+
+int nft_add_set_chain_binding(struct nft_set *set, struct nft_chain *chain)
+{
+	struct nft_binding_key from = {
+		.ptr	= set,
+		.type	= NFT_BIND_SET,
+	};
+	struct nft_binding_key to = {
+		.ptr	= chain,
+		.type	= NFT_BIND_CHAIN,
+	};
+
+	return nft_add_binding(chain->table, &from, &to,
+			       &set->binding_list, &chain->backbinding_list);
+}
+
 /*
  * Tables
  */
@@ -1611,6 +1952,10 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err)
 		goto err_chain_ht;
 
+	err = rhashtable_init(&table->bindings_ht, &nft_binding_ht_params);
+	if (err)
+		goto err_binding_ht;
+
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
@@ -1629,6 +1974,8 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	list_add_tail_rcu(&table->list, &nft_net->tables);
 	return 0;
 err_trans:
+	rhashtable_destroy(&table->bindings_ht);
+err_binding_ht:
 	rhltable_destroy(&table->chains_ht);
 err_chain_ht:
 	kfree(table->udata);
@@ -1794,6 +2141,7 @@ static void nf_tables_table_destroy(struct nft_table *table)
 	if (WARN_ON(table->use > 0))
 		return;
 
+	rhashtable_destroy(&table->bindings_ht);
 	rhltable_destroy(&table->chains_ht);
 	kfree(table->name);
 	kfree(table->udata);
@@ -2691,6 +3039,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
 	ctx->chain = chain;
 
 	INIT_LIST_HEAD(&chain->rules);
+	INIT_LIST_HEAD(&chain->binding_list);
+	INIT_LIST_HEAD(&chain->backbinding_list);
 	chain->handle = nf_tables_alloc_handle(table);
 	chain->table = table;
 
@@ -5523,6 +5873,8 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	INIT_LIST_HEAD(&set->bindings);
+	INIT_LIST_HEAD(&set->binding_list);
+	INIT_LIST_HEAD(&set->backbinding_list);
 	INIT_LIST_HEAD(&set->catchall_list);
 	refcount_set(&set->refs, 1);
 	set->table = table;
-- 
2.30.2

