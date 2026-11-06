Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979524;
	b=QJeZJsfYtlYt9IiDHKwlAUC0iQD9A+iyJ/932h47l2RisWpNfPQm/A2MzK2GTGBEAT2V
	 NF5tdPLAxKx1+lxN1Dj2j3ds7Ly17typLCNOdSZZthA5osvmy1o/RY5Ph2EOlTJBZL/eE
	 7ZiHGpeFfayJbr7HrAFsnNXilCp0s0OvvMV3H2lGZswlgASc26iYCM3AeLzdVU4aVEOsK
	 DfgzmowOVNJCLBrMhQu1TxEH2jf6uO6viGceKCjJOonA3BzKTHqul9hrrVOXjekrU3vMN
	 sr4KuVFRpsqyWEFtqW9938OTAaVecbZHSr8McBGP7iLnQncN6lcBfE+k3//u+ympvVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979524;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SrjLHEITpVYYcbFWlqPcPH/gfUYYuUFPfREUiP2mCFg=;
	b=TPFbNvRlGsoeDu6KYrOBgirYq3WLqpzInFrzRrO7T/iZQCppK1koZpy63Xrd6J6adCSG
	 ghH1IJz0Ph8e+0I+g2j404A7p+E+nbJEHbIUZmsR6DaAiY3j6T5/1kdS3mtI1Tb0lRGgD
	 Y/HrnoFlkV0ceFSx9nvOsux2CFqUVwoXLGvEZYFHHvJF2kUWXHKywpq7wIUMQYYUMzuFE
	 uyly2xtqWEkWmWDRKJZ4Z2dYzm2RnZbYkSrX7CW5VW0A27VDT8vjgmyuI+unWXkTc0A6Y
	 DWm9wgd31nI2WtMgX6x0criZEL3Tf0NQcYFmQXoW48WKu0ttNcbAGDVbFqGySXGyw7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE38606A329
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 15:38:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDE38606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E06A66060B; Fri, 06 Nov 2026 16:38:40 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: herbert@gondor.apana.org.au,
	kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v7 5/6] netfilter: ipset: re-add IP_SET_HASH_WITH_MULTI support
Date: Fri,  6 Nov 2026 16:38:07 +0100
Message-ID: <20261106153808.25148-6-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106153808.25148-1-fw@strlen.de>
References: <20261106153808.25148-1-fw@strlen.de>
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

Reimplement hash:net,iface set type on top of rhashtable.

A net/cidr/physdev key maps to one struct mtype_group, which owns a small
RCU-protected list of the actual elements.

Each element holds one distinct interface/wildcard value that shares
the key with that of the group.

An earlier attempt uses rhltable, but hash:net,iface requires control
of the insertion order.

mtype_group_find() and mtype_group_test() give each normal elements
priority over a wildcard element explicitly via the mtype_data_isexact
hook, independent of list order:

 - mtype_del() must not remove a wildcard element instead of
   the specific element named in the request.
 - mtype_test()/mtype_test_cidrs() must not shadow a more specific
   (e.g. nomatch) element added earlier.
 - mtype_add() with IPSET_FLAG_EXIST must not tear down an unrelated
   wildcard element as a side effect of refreshing a specific
   element sharing its key.

Element count is tracked explicitly via htype->nelems so account for
the elements and not thhe rhastable-inserted group heads.

The IPSET_GROUP_MAX_ENTRIES limit bounds the list length of group-attached
entries.  This limit is not new. The original hash table implementation
had a AHASH_MAX_TUNED value of 64: this provided an implicit upper bound
of identical hash keys that could be inserted.
As chain list walk becomes expensive with increasing lengths, this
limit is kept as the new, explicit IPSET_GROUP_MAX_ENTRIES cap.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v7: new in this series, LLM reimplementation of
 hash:net,iface set type on top of rhashtable, based
 off the old code and the ipset tests for this set type.

 net/netfilter/ipset/ip_set_hash_gen.h        | 751 +++++++++++++++++--
 net/netfilter/ipset/ip_set_hash_ip.c         |   6 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c      |   6 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c     |   6 +-
 net/netfilter/ipset/ip_set_hash_ipport.c     |   6 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |   6 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   6 +-
 net/netfilter/ipset/ip_set_hash_mac.c        |   3 +-
 net/netfilter/ipset/ip_set_hash_net.c        |   6 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |  74 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |   6 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |   6 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |   6 +-
 13 files changed, 777 insertions(+), 111 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 32dd333fe790..e3d0f83e6d9d 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -134,12 +134,27 @@ static const union nf_inet_addr zeromask = {};
 #undef mtype_data_next
 #undef mtype_elem
 
+#undef mtype_data_isexact
+#undef mtype_data_isequal
+
 #undef mtype_rht_elem
 #undef mtype_rht_hashfn
 #undef mtype_rht_obj_hashfn
 #undef mtype_rht_cmpfn
 #undef mtype_rht_params
 
+#undef mtype_group
+#undef mtype_group_rht_params
+#undef mtype_group_obj_hashfn
+#undef mtype_group_cmpfn
+#undef mtype_group_get_or_create
+#undef mtype_group_remove_elem
+#undef mtype_group_put
+#undef mtype_group_find
+#undef mtype_group_test
+#undef mtype_group_list
+#undef mtype_flush_group
+
 #undef mtype_add_cidr
 #undef mtype_del_cidr
 #undef mtype_del_cidr_all
@@ -171,6 +186,11 @@ static const union nf_inet_addr zeromask = {};
 #undef htype
 
 #define mtype_data_equal	IPSET_TOKEN(MTYPE, _data_equal)
+#ifdef IP_SET_HASH_WITH_MULTI
+#define mtype_key_equal		IPSET_TOKEN(MTYPE, _key_equal)
+#define mtype_data_isexact	IPSET_TOKEN(MTYPE, _data_isexact)
+#define mtype_data_isequal	IPSET_TOKEN(MTYPE, _data_isequal)
+#endif
 #ifdef IP_SET_HASH_WITH_NETS
 #define mtype_do_data_match	IPSET_TOKEN(MTYPE, _do_data_match)
 #else
@@ -190,6 +210,20 @@ static const union nf_inet_addr zeromask = {};
 #define mtype_rht_cmpfn		IPSET_TOKEN(MTYPE, _rht_cmpfn)
 #define mtype_rht_params	IPSET_TOKEN(MTYPE, _rht_params)
 
+#ifdef IP_SET_HASH_WITH_MULTI
+#define mtype_group		IPSET_TOKEN(MTYPE, _group)
+#define mtype_group_rht_params	IPSET_TOKEN(MTYPE, _group_rht_params)
+#define mtype_group_obj_hashfn	IPSET_TOKEN(MTYPE, _group_obj_hashfn)
+#define mtype_group_cmpfn	IPSET_TOKEN(MTYPE, _group_cmpfn)
+#define mtype_group_get_or_create IPSET_TOKEN(MTYPE, _group_get_or_create)
+#define mtype_group_remove_elem IPSET_TOKEN(MTYPE, _group_remove_elem)
+#define mtype_group_put		IPSET_TOKEN(MTYPE, _group_put)
+#define mtype_group_find	IPSET_TOKEN(MTYPE, _group_find)
+#define mtype_group_test	IPSET_TOKEN(MTYPE, _group_test)
+#define mtype_group_list	IPSET_TOKEN(MTYPE, _group_list)
+#define mtype_flush_group	IPSET_TOKEN(MTYPE, _flush_group)
+#endif
+
 #define mtype_add_cidr		IPSET_TOKEN(MTYPE, _add_cidr)
 #define mtype_del_cidr		IPSET_TOKEN(MTYPE, _del_cidr)
 #define mtype_del_cidr_all	IPSET_TOKEN(MTYPE, _del_cidr_all)
@@ -227,13 +261,48 @@ static const union nf_inet_addr zeromask = {};
  * allocate as offsetof(struct mtype_rht_elem, elem) + set->dsize bytes.
  */
 struct mtype_rht_elem {
+#ifdef IP_SET_HASH_WITH_MULTI
+	struct hlist_node node;	/* linked into the owning group's iface_list */
+#else
 	struct rhash_head node;
+#endif
 	struct rcu_head rcu;		/* deferred free after removal */
 
 	/* element data; must be last. extensions follow. */
 	struct mtype_elem elem __aligned(__alignof__(u64));
 };
 
+#ifdef IP_SET_HASH_WITH_MULTI
+/* Max number of interface-differentiated elements sharing one net/cidr/
+ * physdev key. Chain length is bounded so test/add/del stay cheap.
+ */
+#define IPSET_GROUP_MAX_ENTRIES	64
+
+/**
+ * struct mtype_group - all elements sharing one net/cidr/physdev key
+ * @node: linkage in @htype.ht, keyed by @key via mtype_key_equal()
+ * @key: representative net/cidr/physdev key, used for hashing/lookup only
+ * @lock: protects @iface_list and @dead
+ * @dead: true once unlinked from @htype.ht; group is being freed
+ * @iface_list: RCU-protected list of mtype_rht_elem sharing @key
+ * @rcu: RCU head for deferred free
+ *
+ * hash:net,iface stores several elements under the same net/cidr/physdev
+ * key, differentiated by interface name (and, optionally, an interface
+ * name prefix via the wildcard flag). A group owns that small, bounded
+ * set of elements so lookups can apply iface-matching precedence (exact
+ * beats wildcard) without depending on list insertion order.
+ */
+struct mtype_group {
+	struct rhash_head node;
+	struct mtype_elem key;
+	spinlock_t lock;
+	bool dead;
+	struct hlist_head iface_list;
+	struct rcu_head rcu;
+};
+#endif
+
 /* jhash of the lookup key */
 static u32 mtype_rht_hashfn(const void *data, u32 len, u32 seed)
 {
@@ -241,6 +310,7 @@ static u32 mtype_rht_hashfn(const void *data, u32 len, u32 seed)
 	return jhash2((const u32 *)data, HKEY_DATALEN / sizeof(u32), seed);
 }
 
+#ifndef IP_SET_HASH_WITH_MULTI
 /* jhash of an existing element object */
 static u32 mtype_rht_obj_hashfn(const void *obj, u32 len, u32 seed)
 {
@@ -264,10 +334,9 @@ static u32 mtype_rht_obj_hashfn(const void *obj, u32 len, u32 seed)
 static int mtype_rht_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
 {
 	const struct mtype_rht_elem *e = obj;
-	u32 multi = 0;
 
 	return !mtype_data_equal(&e->elem,
-				 (const struct mtype_elem *)arg->key, &multi);
+				 (const struct mtype_elem *)arg->key);
 }
 
 static const struct rhashtable_params mtype_rht_params = {
@@ -278,10 +347,50 @@ static const struct rhashtable_params mtype_rht_params = {
 	.obj_cmpfn	= mtype_rht_cmpfn,
 	.key_len	= HKEY_DATALEN,
 };
+#else /* IP_SET_HASH_WITH_MULTI */
+/* jhash of an existing group's representative key */
+static u32 mtype_group_obj_hashfn(const void *obj, u32 len, u32 seed)
+{
+	const struct mtype_group *grp = obj;
+#ifdef IP_SET_HASH_WITH_NETS
+	struct mtype_elem tmp;
+	u8 flags = 0;
+
+	memcpy(&tmp, &grp->key, HKEY_DATALEN);
+	mtype_data_reset_flags(&tmp, &flags);
+	return jhash2((const u32 *)&tmp, HKEY_DATALEN / sizeof(u32), seed);
+#else
+	return jhash2((const u32 *)&grp->key, HKEY_DATALEN / sizeof(u32), seed);
+#endif
+}
+
+/* 0 = key matches group (equal), non-zero = not equal. Only the narrow
+ * net/cidr/physdev key is compared: iface/wildcard differentiate elements
+ * *within* a group, not which group an element belongs to.
+ */
+static int mtype_group_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
+{
+	const struct mtype_group *grp = obj;
+
+	return !mtype_key_equal(&grp->key, (const struct mtype_elem *)arg->key);
+}
+
+static const struct rhashtable_params mtype_group_rht_params = {
+	.head_offset	= offsetof(struct mtype_group, node),
+	.key_offset	= offsetof(struct mtype_group, key),
+	.hashfn		= mtype_rht_hashfn,
+	.obj_hashfn	= mtype_group_obj_hashfn,
+	.obj_cmpfn	= mtype_group_cmpfn,
+	.key_len	= HKEY_DATALEN,
+};
+#endif /* IP_SET_HASH_WITH_MULTI */
 
 /* The hash set type */
 struct htype {
-	struct rhashtable ht;	/* the hash table */
+	struct rhashtable ht;	/* the hash table: elements, or groups for "multi" */
+#ifdef IP_SET_HASH_WITH_MULTI
+	atomic_t nelems;	/* total elements across all groups */
+#endif
 	struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
 	struct htable_gc gc;	/* gc workqueue */
 	u32 maxelem;		/* max elements in the hash */
@@ -309,7 +418,11 @@ struct htype {
 	kfree_rcu(__e, rcu);							\
 } while (0)
 
+#ifdef IP_SET_HASH_WITH_MULTI
+#define ipset_hash_nelems(h) atomic_read(&(h)->nelems)
+#else
 #define ipset_hash_nelems(h) atomic_read(&(h)->ht.nelems)
+#endif
 
 #ifdef IP_SET_HASH_WITH_NETS
 /**
@@ -452,6 +565,171 @@ mtype_del_cidr_all(struct ip_set *set, struct htype *h, const struct mtype_elem
 #endif
 }
 
+#ifdef IP_SET_HASH_WITH_MULTI
+/**
+ * mtype_group_get_or_create() - find or create the group for @d's key
+ * @h: Pointer to the htype
+ * @d: Element whose net/cidr/physdev key identifies the group
+ * @errp: Set to a negative errno when NULL is returned
+ *
+ * Return: the group with @grp->lock held (caller must unlock), or NULL
+ * with *@errp set.
+ */
+static struct mtype_group *
+mtype_group_get_or_create(struct htype *h, const struct mtype_elem *d, int *errp)
+	__cond_acquires(nonnull, &grp->lock)
+{
+	struct mtype_group *grp;
+	int err;
+
+retry:
+	grp = rhashtable_lookup(&h->ht, d, mtype_group_rht_params);
+	if (grp) {
+		spin_lock_bh(&grp->lock);
+		if (!grp->dead)
+			return grp;
+		/* Lost the race with mtype_group_remove_elem(): by the time
+		 * it released @grp->lock, @grp was already unlinked from
+		 * h->ht, so a fresh lookup cannot find it again.
+		 */
+		spin_unlock_bh(&grp->lock);
+		goto retry;
+	}
+
+	grp = kzalloc(sizeof(*grp), GFP_ATOMIC);
+	if (!grp) {
+		*errp = -ENOMEM;
+		return NULL;
+	}
+	INIT_HLIST_HEAD(&grp->iface_list);
+	spin_lock_init(&grp->lock);
+	memcpy(&grp->key, d, sizeof(grp->key));
+
+	spin_lock_bh(&grp->lock);
+	err = rhashtable_lookup_insert_key(&h->ht, d, &grp->node, mtype_group_rht_params);
+	if (err) {
+		spin_unlock_bh(&grp->lock);
+		kfree(grp);
+		if (err == -EEXIST) /* someone else created the group first */
+			goto retry;
+		*errp = err;
+		return NULL;
+	}
+	return grp;
+}
+
+/**
+ * mtype_group_remove_elem() - unlink and free @e, releasing @grp->lock
+ * @set: Pointer to the ip_set
+ * @h: Pointer to the htype
+ * @grp: Group owning @e, with @grp->lock held
+ * @e: Element to remove; must currently be linked into @grp->iface_list
+ *
+ * Frees @grp too if @e was its last element. Always releases @grp->lock.
+ */
+static void
+mtype_group_remove_elem(struct ip_set *set, struct htype *h,
+			struct mtype_group *grp, struct mtype_rht_elem *e)
+	__releases(&grp->lock)
+{
+	bool empty;
+
+	hlist_del_rcu(&e->node);
+	atomic_dec(&h->nelems);
+	empty = hlist_empty(&grp->iface_list);
+	if (empty) {
+		grp->dead = true;
+		rhashtable_remove_fast(&h->ht, &grp->node, mtype_group_rht_params);
+	}
+	spin_unlock_bh(&grp->lock);
+
+	ipset_hash_elem_destroy_free(set, e);
+	if (empty)
+		kfree_rcu(grp, rcu);
+}
+
+/**
+ * mtype_group_put() - release @grp->lock, freeing @grp if it ended up empty
+ * @h: Pointer to the htype
+ * @grp: Group to release, with @grp->lock held
+ *
+ * Call this instead of a bare spin_unlock_bh(&grp->lock) whenever returning
+ * from mtype_add() without having linked a new element into @grp: a group
+ * just created by mtype_group_get_or_create() has an empty @iface_list, and
+ * leaving it in h->ht would otherwise leak it forever on sets without gc
+ * (no IPSET_ATTR_TIMEOUT).
+ */
+static void
+mtype_group_put(struct htype *h, struct mtype_group *grp)
+	__releases(&grp->lock)
+{
+	bool empty = hlist_empty(&grp->iface_list);
+
+	if (empty) {
+		grp->dead = true;
+		rhashtable_remove_fast(&h->ht, &grp->node, mtype_group_rht_params);
+	}
+	spin_unlock_bh(&grp->lock);
+	if (empty)
+		kfree_rcu(grp, rcu);
+}
+
+/**
+ * mtype_group_find() - pick the element a non-wildcard request affects
+ * @grp: Group to search, with @grp->lock held
+ * @d: Lookup key (net/cidr/physdev and interface)
+ *
+ * An exact (non-wildcard) element always takes priority over a wildcard
+ * element, independent of @grp's list order. Must be called with
+ * @grp->lock held: the result is only valid as long as the lock prevents
+ * a concurrent mtype_add() from linking a higher-priority element into
+ * @grp after this scan but before the caller acts on its result.
+ *
+ * Intentionally does not use mtype_data_isequal() (strict identity,
+ * including @d's wildcard flag): "ipset del" must be able to remove a
+ * wildcard element even if @d->wildcard is false.
+ *
+ * Return: the matching element, or NULL.
+ */
+static struct mtype_rht_elem *
+mtype_group_find(struct mtype_group *grp, const struct mtype_elem *d)
+{
+	struct mtype_rht_elem *e, *best = NULL;
+
+	hlist_for_each_entry_rcu(e, &grp->iface_list, node) {
+		if (!mtype_data_equal(&e->elem, d))
+			continue;
+		if (mtype_data_isexact(&e->elem))
+			return e;
+		if (!best)
+			best = e;
+	}
+	return best;
+}
+#endif /* IP_SET_HASH_WITH_MULTI */
+
+#ifdef IP_SET_HASH_WITH_MULTI
+/* Free one group and all its elements: called by rhashtable_free_and_destroy
+ * and rhashtable_flush_and_free.
+ */
+static void
+mtype_flush_group(void *ptr, void *arg)
+{
+	struct mtype_group *grp = ptr;
+	struct ip_set *set = arg;
+	struct htype *h = set->data;
+	struct hlist_node *n;
+	struct mtype_rht_elem *e;
+
+	rcu_read_lock();
+	hlist_for_each_entry_safe(e, n, &grp->iface_list, node) {
+		ipset_hash_elem_destroy_free(set, e);
+		atomic_dec(&h->nelems);
+	}
+	rcu_read_unlock();
+	kfree_rcu(grp, rcu);
+}
+#else
 /* Free one element: called by rhashtable_free_and_destroy */
 static void
 mtype_flush_elem(void *ptr, void *arg)
@@ -463,6 +741,7 @@ mtype_flush_elem(void *ptr, void *arg)
 	ipset_hash_elem_destroy_free(set, e);
 	rcu_read_unlock();
 }
+#endif
 
 /**
  * mtype_flush() - Flush a hash set type by destroying all elements.
@@ -477,7 +756,11 @@ mtype_flush(struct ip_set *set)
 {
 	struct htype *h = set->data;
 
+#ifdef IP_SET_HASH_WITH_MULTI
+	rhashtable_flush_and_free(&h->ht, mtype_flush_group, set);
+#else
 	rhashtable_flush_and_free(&h->ht, mtype_flush_elem, set);
+#endif
 }
 
 /* Destroy a hash type of set */
@@ -489,7 +772,12 @@ mtype_destroy(struct ip_set *set)
 	u32 i;
 #endif
 
+#ifdef IP_SET_HASH_WITH_MULTI
+	rhashtable_free_and_destroy(&h->ht, mtype_flush_group, set);
+	DEBUG_NET_WARN_ON_ONCE(ipset_hash_nelems(h));
+#else
 	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
+#endif
 
 #ifdef IP_SET_HASH_WITH_NETS
 	for (i = 0; i < IPSET_NET_COUNT; i++)
@@ -543,23 +831,70 @@ mtype_gc_do(struct ip_set *set)
 	seen = 0;
 	rhashtable_walk_start(&hti);
 
-	while ((e = rhashtable_walk_next(&hti))) {
-		if (IS_ERR(e)) {
-			if (PTR_ERR(e) == -EAGAIN)
-				continue;
-			break;
+#ifdef IP_SET_HASH_WITH_MULTI
+	{
+		struct mtype_group *grp;
+
+		while ((grp = rhashtable_walk_next(&hti))) {
+			struct hlist_node *n;
+			bool empty = false;
+
+			if (IS_ERR(grp)) {
+				if (PTR_ERR(grp) == -EAGAIN)
+					continue;
+				break;
+			}
+
+			spin_lock_bh(&grp->lock);
+			if (!grp->dead) {
+				hlist_for_each_entry_safe(e, n, &grp->iface_list, node) {
+					if (!ip_set_timeout_expired(ext_timeout(&e->elem, set)))
+						continue;
+					hlist_del_rcu(&e->node);
+					atomic_dec(&h->nelems);
+					ipset_hash_elem_destroy_free(set, e);
+				}
+				empty = hlist_empty(&grp->iface_list);
+				if (empty) {
+					grp->dead = true;
+					rhashtable_remove_fast(&h->ht, &grp->node,
+							       mtype_group_rht_params);
+				}
+			}
+			/* else: already unlinked and scheduled for kfree_rcu()
+			 * by a concurrent mtype_del()/mtype_add() or gc pass;
+			 * touching @grp->iface_list or freeing @grp again
+			 * would double-free it.
+			 */
+			spin_unlock_bh(&grp->lock);
+			if (empty)
+				kfree_rcu(grp, rcu);
+
+			if (mtype_gc_resched(&hti, seen))
+				goto restart;
 		}
+	}
+#else
+	{
+		while ((e = rhashtable_walk_next(&hti))) {
+			if (IS_ERR(e)) {
+				if (PTR_ERR(e) == -EAGAIN)
+					continue;
+				break;
+			}
 
-		if (ip_set_timeout_expired(ext_timeout(&e->elem, set)) &&
-		    rhashtable_remove_fast(&h->ht, &e->node, mtype_rht_params) == 0)
-			ipset_hash_elem_destroy_free(set, e);
+			if (ip_set_timeout_expired(ext_timeout(&e->elem, set)) &&
+			    rhashtable_remove_fast(&h->ht, &e->node, mtype_rht_params) == 0)
+				ipset_hash_elem_destroy_free(set, e);
 
-		/* stop+start can miss entries (we might have unlinked the
-		 * element). This is harmless.
-		 */
-		if (mtype_gc_resched(&hti, seen))
-			goto restart;
+			/* stop+start can miss entries (we might have unlinked the
+			 * element). This is harmless.
+			 */
+			if (mtype_gc_resched(&hti, seen))
+				goto restart;
+		}
 	}
+#endif
 	rhashtable_walk_stop(&hti);
 	rhashtable_walk_exit(&hti);
 }
@@ -614,6 +949,12 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 	*elements = ipset_hash_nelems(h);
 	*ext_size = *elements *
 		    (offsetof(struct mtype_rht_elem, elem) + set->dsize);
+#ifdef IP_SET_HASH_WITH_MULTI
+	/* h->ht now holds one struct mtype_group per net/cidr/physdev key,
+	 * not per element; account for that separately from *elements.
+	 */
+	*ext_size += atomic_read(&h->ht.nelems) * sizeof(struct mtype_group);
+#endif
 
 #ifdef IP_SET_HASH_WITH_NETS
 	{
@@ -643,8 +984,9 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
  * @old: The element we're replacing (can be NULL)
  * @flag_exist: Whether the request carried IPSET_FLAG_EXIST
  *
- * allocates the element and initializes its data, cidr bookkeeping and
- * extensions.
+ * Common to both the plain rhashtable and the "multi" group element
+ * insertion paths: validates the maxelem condition, allocates
+ * the element and initializes its data, cidr bookkeeping and extensions.
  *
  * The caller still has to link the returned element into the hash.
  *
@@ -773,6 +1115,63 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	int ret = 0;
 
 	rcu_read_lock_bh();
+#ifdef IP_SET_HASH_WITH_MULTI
+	{
+		struct mtype_group *grp;
+		unsigned int seen = 0;
+
+		grp = mtype_group_get_or_create(h, d, &ret);
+		if (!grp)
+			goto out_rcu_unlock;
+
+		old = NULL;
+		hlist_for_each_entry_rcu(e, &grp->iface_list, node) {
+			if (SET_ELEM_EXPIRED(set, &e->elem)) {
+				hlist_del_rcu(&e->node);
+				atomic_dec(&h->nelems);
+				ipset_hash_elem_destroy_free(set, e);
+				continue;
+			}
+			/* mtype_data_equal() implements test-time, pattern
+			 * matching semantics (a wildcard element's prefix
+			 * matching any interface it covers): it must not be
+			 * used here to find the element @d refreshes, or
+			 * adding/refreshing a specific interface could replace
+			 * an unrelated wildcard element covering it (or vice
+			 * versa). Use strict representation identity instead.
+			 */
+			if (mtype_data_isequal(&e->elem, d)) {
+				old = e;
+				break;
+			}
+			++seen;
+		}
+
+		if (!old && seen >= IPSET_GROUP_MAX_ENTRIES) {
+			spin_unlock_bh(&grp->lock);
+			ret = -IPSET_ERR_HASH_FULL;
+			goto out_rcu_unlock;
+		}
+
+		e = mtype_new_elem(set, h, d, ext, flags, old, flag_exist);
+		if (IS_ERR(e)) {
+			mtype_group_put(h, grp);
+			ret = PTR_ERR(e);
+			goto out_rcu_unlock;
+		}
+
+		if (old) {
+			hlist_replace_rcu(&old->node, &e->node);
+		} else {
+			/* new entries are added at the tail for compatibility
+			 * with the old array-based implementation.
+			 */
+			hlist_add_tail_rcu(&e->node, &grp->iface_list);
+			atomic_inc(&h->nelems);
+		}
+		spin_unlock_bh(&grp->lock);
+	}
+#else
 	old = rhashtable_lookup(&h->ht, d, mtype_rht_params);
 	if (old) {
 		if (SET_ELEM_EXPIRED(set, &old->elem)) {
@@ -810,6 +1209,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		/* error: Undo mtype_add_cidr(). */
 		mtype_del_cidr_all(set, h, d);
 	}
+#endif
 	if (ret == 0 && old)
 		mtype_add_replace_old(set, h, d, ext, e, old);
 
@@ -839,6 +1239,37 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	int ret = -IPSET_ERR_EXIST;
 
 	rcu_read_lock_bh();
+#ifdef IP_SET_HASH_WITH_MULTI
+	{
+		struct mtype_group *grp;
+
+		grp = rhashtable_lookup(&h->ht, d, mtype_group_rht_params);
+		if (!grp)
+			goto out_unlock;
+
+		spin_lock_bh(&grp->lock);
+		if (grp->dead) {
+			/* raced with mtype_group_remove_elem()/mtype_group_put()
+			 * removing @grp's last element.
+			 */
+			spin_unlock_bh(&grp->lock);
+			goto out_unlock;
+		}
+
+		/* Decide which element this request affects while holding
+		 * @grp->lock, so a concurrent mtype_add() cannot link a
+		 * higher-priority (exact) element in between this decision
+		 * and mtype_group_remove_elem() acting on it below.
+		 */
+		e = mtype_group_find(grp, d);
+		if (!e || SET_ELEM_EXPIRED(set, &e->elem)) {
+			spin_unlock_bh(&grp->lock);
+			goto out_unlock;
+		}
+		mtype_group_remove_elem(set, h, grp, e);
+		ret = 0;
+	}
+#else
 	e = rhashtable_lookup(&h->ht, d, mtype_rht_params);
 	if (!e || SET_ELEM_EXPIRED(set, &e->elem))
 		goto out_unlock;
@@ -848,6 +1279,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	mtype_del_cidr_all(set, h, d);
 	ip_set_ext_destroy(set, &e->elem);
 	kfree_rcu(e, rcu);
+#endif
 out_unlock:
 	rcu_read_unlock_bh();
 	return ret ? -IPSET_ERR_EXIST : 0;
@@ -863,6 +1295,78 @@ mtype_data_match(struct mtype_elem *data, const struct ip_set_ext *ext,
 	return mtype_do_data_match(data);
 }
 
+#ifdef IP_SET_HASH_WITH_MULTI
+/**
+ * mtype_group_test() - test @d against the elements sharing its key
+ * @h: Pointer to the htype
+ * @d: Lookup key
+ * @iface_matched_p: set status of interface matching
+ * @ext: Match extensions from the caller
+ * @mext: Match extensions to fill in
+ * @set: Pointer to the ip_set
+ * @flags: Match flags
+ *
+ * An exact element is tried before any wildcard element, independent of
+ * list order, mirroring mtype_group_find()'s precedence. Must be called
+ * under rcu_read_lock().
+ *
+ * @multi is set when a group exists for @d's key but none of its elements
+ * match @d's interface: some other interface's entry is registered at
+ * this netmask length, so the caller must not fall through to a broader
+ * (less specific) one. @multi is left false when no candidate's interface
+ * matches @d at all (nothing registered here), or when a candidate's
+ * interface matches but it is filtered out by its extensions (e.g. timed
+ * out): either way, this netmask length is unresolved and the caller may
+ * still fall through.
+ *
+ * Return: mtype_data_match()'s result for the first candidate it accepts
+ * (match or nomatch), or 0 if no candidate in this group is accepted.
+ */
+static int
+mtype_group_test(struct htype *h, const struct mtype_elem *d,
+		 bool *iface_matched_p,
+		 const struct ip_set_ext *ext, struct ip_set_ext *mext,
+		 struct ip_set *set, u32 flags)
+{
+	struct mtype_group *grp;
+	struct mtype_rht_elem *e, *exact = NULL;
+	bool iface_matched = false;
+	int ret;
+
+	grp = rhashtable_lookup(&h->ht, d, mtype_group_rht_params);
+	if (!grp)
+		return 0;
+
+	hlist_for_each_entry_rcu(e, &grp->iface_list, node) {
+		if (!mtype_data_equal(&e->elem, d))
+			continue;
+		if (mtype_data_isexact(&e->elem)) {
+			exact = e;
+			break;
+		}
+	}
+
+	if (exact) {
+		ret = mtype_data_match(&exact->elem, ext, mext, set, flags);
+		if (ret)
+			return ret;
+		iface_matched = true;
+	}
+
+	hlist_for_each_entry_rcu(e, &grp->iface_list, node) {
+		if (e == exact || !mtype_data_equal(&e->elem, d))
+			continue;
+		iface_matched = true;
+		ret = mtype_data_match(&e->elem, ext, mext, set, flags);
+		if (ret)
+			return ret;
+	}
+
+	*iface_matched_p = !iface_matched;
+	return 0;
+}
+#endif /* IP_SET_HASH_WITH_MULTI */
+
 #ifdef IP_SET_HASH_WITH_NETS
 /* Special test function which takes into account the different network
  * sizes added to the set
@@ -874,7 +1378,9 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 {
 	struct htype *h = set->data;
 	struct net_prefixes *nets0;
+#ifndef IP_SET_HASH_WITH_MULTI
 	struct mtype_rht_elem *e;
+#endif
 #if IPSET_NET_COUNT == 2
 	struct net_prefixes *nets1;
 	struct mtype_elem orig = *d;
@@ -884,11 +1390,11 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 	int ret, j;
 #endif
 	unsigned int seq0;
-	u32 multi;
+	bool multi;
 
 	pr_debug("test by nets\n");
 retry:
-	multi = 0;
+	multi = false;
 	nets0 = ipset_dereference_bh_nfnl(h->rnets[0]);
 	seq0 = read_seqcount_begin(&nets0->seq);
 #if IPSET_NET_COUNT == 2
@@ -912,6 +1418,17 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 #else
 		mtype_data_netmask(d, p0.cidr);
 #endif
+#ifdef IP_SET_HASH_WITH_MULTI
+		/* mtype_group_test() sets multi itself: the outer loop
+		 * stops here when some other interface's entry is
+		 * registered at this netmask, but still falls through if
+		 * nothing here matches our interface at all, or if it did
+		 * but got filtered by its extensions (e.g. timed out).
+		 */
+		ret = mtype_group_test(h, d, &multi, ext, mext, set, flags);
+		if (ret)
+			goto check_retry;
+#else
 		e = rhashtable_lookup(&h->ht, d, mtype_rht_params);
 		if (e) {
 			ret = mtype_data_match(&e->elem, ext, mext, set, flags);
@@ -919,6 +1436,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 				goto check_retry;
 			multi = false;
 		}
+#endif
 #if IPSET_NET_COUNT == 2
 		}
 #endif
@@ -942,7 +1460,9 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 {
 	struct htype *h = set->data;
 	struct mtype_elem *d = value;
+#ifndef IP_SET_HASH_WITH_MULTI
 	struct mtype_rht_elem *e;
+#endif
 	int ret = 0;
 #ifdef IP_SET_HASH_WITH_NETS
 	int i;
@@ -962,11 +1482,19 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 #endif
 
+#ifdef IP_SET_HASH_WITH_MULTI
+	{
+		bool multi = false;
+
+		ret = mtype_group_test(h, d, &multi, ext, mext, set, flags);
+	}
+#else
 	e = rhashtable_lookup(&h->ht, d, mtype_rht_params);
 	if (!e)
 		goto out;
 
 	ret = mtype_data_match(&e->elem, ext, mext, set, flags);
+#endif
 out:
 	rcu_read_unlock_bh();
 	return ret;
@@ -1055,6 +1583,62 @@ mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
 	}
 }
 
+#ifdef IP_SET_HASH_WITH_MULTI
+/**
+ * mtype_group_list() - dump as much of a group's elements as fits
+ * @set: Pointer to the ip_set
+ * @grp: Group to dump
+ * @skb: Target skb
+ * @emitted: Incremented by the number of elements this call added
+ * @skip: Elements of @grp already dumped in previous calls; updated
+ *	  in place to reflect how far this call got
+ *
+ * Groups can hold up to IPSET_GROUP_MAX_ENTRIES elements with arbitrary
+ * extensions (comment, skbinfo, ...), so a group is not guaranteed to fit
+ * into a single dump skb. Elements are therefore emitted one at a time,
+ * same as for the non-"multi" types: on failure, only the element that
+ * didn't fit is rewound, @skip is left pointing at it, and the caller
+ * resumes this same group from @skip on the next, fresh skb.
+ *
+ * Return: 0 once @grp is fully dumped, -EMSGSIZE if an element didn't fit.
+ */
+static int
+mtype_group_list(const struct ip_set *set, struct mtype_group *grp,
+		 struct sk_buff *skb, u32 *emitted, u32 *skip)
+{
+	struct mtype_rht_elem *e;
+	struct nlattr *nested;
+	void *incomplete;
+	u32 pos = 0;
+
+	hlist_for_each_entry_rcu(e, &grp->iface_list, node) {
+		if (pos++ < *skip)
+			continue;
+
+		if (SET_ELEM_EXPIRED(set, &e->elem)) {
+			(*skip)++;
+			continue;
+		}
+
+		incomplete = skb_tail_pointer(skb);
+		nested = nla_nest_start(skb, IPSET_ATTR_DATA);
+		if (!nested ||
+		    mtype_data_list(skb, &e->elem) ||
+		    ip_set_put_extensions(skb, set, &e->elem, true)) {
+			if (nested)
+				nla_nest_cancel(skb, nested);
+			nlmsg_trim(skb, incomplete);
+			return -EMSGSIZE;
+		}
+		nla_nest_end(skb, nested);
+		(*emitted)++;
+		(*skip)++;
+	}
+	*skip = 0;
+	return 0;
+}
+#endif
+
 /* Reply a LIST/SAVE request: dump the elements of the specified set */
 static int
 mtype_list(const struct ip_set *set,
@@ -1062,11 +1646,16 @@ mtype_list(const struct ip_set *set,
 {
 	struct rhashtable_iter *hti =
 		(struct rhashtable_iter *)cb->args[IPSET_CB_PRIVATE];
-	struct mtype_rht_elem *e, *peeked;
-	struct nlattr *atd, *nested;
-	void *incomplete;
+	struct nlattr *atd;
 	u32 emitted = 0;
 	int ret = 0;
+#ifdef IP_SET_HASH_WITH_MULTI
+	/* Elements of the group currently being dumped that earlier,
+	 * paused calls already emitted; cb->args[IPSET_CB_ARG0] stores
+	 * this as skip + 1 so that 0 keeps meaning "nothing pending".
+	 */
+	u32 skip = cb->args[IPSET_CB_ARG0] ? cb->args[IPSET_CB_ARG0] - 1 : 0;
+#endif
 
 	if (!hti)
 		return -ENOMEM;
@@ -1076,45 +1665,77 @@ mtype_list(const struct ip_set *set,
 		return -EMSGSIZE;
 
 	rhashtable_walk_start(hti);
-	while ((e = rhashtable_walk_peek(hti))) {
-		if (IS_ERR(e)) {
-			if (PTR_ERR(e) == -EAGAIN)
-				continue;
-			ret = PTR_ERR(e);
-			break;
-		}
-		peeked = e;
-next_dump:
-		if (SET_ELEM_EXPIRED(set, &e->elem))
-			goto next_entry;
+#ifdef IP_SET_HASH_WITH_MULTI
+	{
+		struct mtype_group *grp;
 
-		incomplete = skb_tail_pointer(skb);
-		nested = nla_nest_start(skb, IPSET_ATTR_DATA);
-		if (!nested) {
-			nlmsg_trim(skb, incomplete);
-			goto paused;
-		}
-		if (mtype_data_list(skb, &e->elem) ||
-		    ip_set_put_extensions(skb, set, &e->elem, true)) {
-			nla_nest_cancel(skb, nested);
-			nlmsg_trim(skb, incomplete);
-			goto paused;
+		while ((grp = rhashtable_walk_peek(hti))) {
+			if (IS_ERR(grp)) {
+				if (PTR_ERR(grp) == -EAGAIN)
+					continue;
+				ret = PTR_ERR(grp);
+				break;
+			}
+			if (mtype_group_list(set, grp, skb, &emitted, &skip))
+				goto paused;
+
+			/* Only advance once the whole group is dumped. */
+			grp = rhashtable_walk_next(hti);
+			if (IS_ERR(grp)) {
+				ret = PTR_ERR(grp);
+				if (ret != -EAGAIN)
+					break;
+				ret = 0;
+			}
 		}
-		nla_nest_end(skb, nested);
-		emitted++;
-next_entry:
-		e = rhashtable_walk_next(hti);
-		if (IS_ERR(e)) {
-			ret = PTR_ERR(e);
-			if (ret != -EAGAIN)
+	}
+#else
+	{
+		struct mtype_rht_elem *e, *peeked;
+		void *incomplete;
+		struct nlattr *nested;
+
+		while ((e = rhashtable_walk_peek(hti))) {
+			if (IS_ERR(e)) {
+				if (PTR_ERR(e) == -EAGAIN)
+					continue;
+				ret = PTR_ERR(e);
 				break;
-			ret = 0;
-		} else if (peeked && e != peeked) {
-			peeked = NULL;
-			if (e)
-				goto next_dump;
+			}
+			peeked = e;
+next_dump:
+			if (SET_ELEM_EXPIRED(set, &e->elem))
+				goto next_entry;
+
+			incomplete = skb_tail_pointer(skb);
+			nested = nla_nest_start(skb, IPSET_ATTR_DATA);
+			if (!nested) {
+				nlmsg_trim(skb, incomplete);
+				goto paused;
+			}
+			if (mtype_data_list(skb, &e->elem) ||
+			    ip_set_put_extensions(skb, set, &e->elem, true)) {
+				nla_nest_cancel(skb, nested);
+				nlmsg_trim(skb, incomplete);
+				goto paused;
+			}
+			nla_nest_end(skb, nested);
+			emitted++;
+next_entry:
+			e = rhashtable_walk_next(hti);
+			if (IS_ERR(e)) {
+				ret = PTR_ERR(e);
+				if (ret != -EAGAIN)
+					break;
+				ret = 0;
+			} else if (peeked && e != peeked) {
+				peeked = NULL;
+				if (e)
+					goto next_dump;
+			}
 		}
 	}
+#endif
 	/* Walk exhausted: listing done */
 	nla_nest_end(skb, atd);
 	rhashtable_walk_stop(hti);
@@ -1127,7 +1748,11 @@ mtype_list(const struct ip_set *set,
 		rhashtable_walk_stop(hti);
 		return -EMSGSIZE;
 	}
+#ifdef IP_SET_HASH_WITH_MULTI
+	cb->args[IPSET_CB_ARG0] = skip + 1;
+#else
 	cb->args[IPSET_CB_ARG0] = 1;
+#endif
 	nla_nest_end(skb, atd);
 	rhashtable_walk_stop(hti);
 	return 0;
@@ -1269,14 +1894,26 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 
 #ifdef IP_SET_PROTO_UNDEF
 	hsize = sizeof(struct htype);
+#ifdef IP_SET_HASH_WITH_MULTI
+	params = mtype_group_rht_params;
+#else
 	params = mtype_rht_params;
+#endif
 #else
 	if (set->family == NFPROTO_IPV6) {
 		hsize = sizeof(struct IPSET_TOKEN(HTYPE, 6));
+#ifdef IP_SET_HASH_WITH_MULTI
+		params = IPSET_TOKEN(HTYPE, 6_group_rht_params);
+#else
 		params = IPSET_TOKEN(HTYPE, 6_rht_params);
+#endif
 	} else {
 		hsize = sizeof(struct IPSET_TOKEN(HTYPE, 4));
+#ifdef IP_SET_HASH_WITH_MULTI
+		params = IPSET_TOKEN(HTYPE, 4_group_rht_params);
+#else
 		params = IPSET_TOKEN(HTYPE, 4_rht_params);
+#endif
 	}
 #endif
 	h = kzalloc(hsize, GFP_KERNEL);
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index c9f4e3859663..226c9f9195aa 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -49,8 +49,7 @@ struct hash_ip4_elem {
 
 static bool
 hash_ip4_data_equal(const struct hash_ip4_elem *e1,
-		    const struct hash_ip4_elem *e2,
-		    u32 *multi)
+		    const struct hash_ip4_elem *e2)
 {
 	return e1->ip == e2->ip;
 }
@@ -181,8 +180,7 @@ struct hash_ip6_elem {
 
 static bool
 hash_ip6_data_equal(const struct hash_ip6_elem *ip1,
-		    const struct hash_ip6_elem *ip2,
-		    u32 *multi)
+		    const struct hash_ip6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6);
 }
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index b9a2681e2488..6389dbb8b48b 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -50,8 +50,7 @@ struct hash_ipmac4_elem {
 
 static bool
 hash_ipmac4_data_equal(const struct hash_ipmac4_elem *e1,
-		       const struct hash_ipmac4_elem *e2,
-		       u32 *multi)
+		       const struct hash_ipmac4_elem *e2)
 {
 	return e1->ip == e2->ip && ether_addr_equal(e1->ether, e2->ether);
 }
@@ -157,8 +156,7 @@ struct hash_ipmac6_elem {
 
 static bool
 hash_ipmac6_data_equal(const struct hash_ipmac6_elem *e1,
-		       const struct hash_ipmac6_elem *e2,
-		       u32 *multi)
+		       const struct hash_ipmac6_elem *e2)
 {
 	return ipv6_addr_equal(&e1->ip.in6, &e2->ip.in6) &&
 		ether_addr_equal(e1->ether, e2->ether);
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index e26ca2a370e3..c1eb78b0c7c4 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -45,8 +45,7 @@ struct hash_ipmark4_elem {
 
 static bool
 hash_ipmark4_data_equal(const struct hash_ipmark4_elem *ip1,
-			const struct hash_ipmark4_elem *ip2,
-			u32 *multi)
+			const struct hash_ipmark4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->mark == ip2->mark;
@@ -181,8 +180,7 @@ struct hash_ipmark6_elem {
 
 static bool
 hash_ipmark6_data_equal(const struct hash_ipmark6_elem *ip1,
-			const struct hash_ipmark6_elem *ip2,
-			u32 *multi)
+			const struct hash_ipmark6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ip1->mark == ip2->mark;
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 41ca24a22a02..29f55d6bb659 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -53,8 +53,7 @@ struct hash_ipport4_elem {
 
 static bool
 hash_ipport4_data_equal(const struct hash_ipport4_elem *ip1,
-			const struct hash_ipport4_elem *ip2,
-			u32 *multi)
+			const struct hash_ipport4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->port == ip2->port &&
@@ -223,8 +222,7 @@ struct hash_ipport6_elem {
 
 static bool
 hash_ipport6_data_equal(const struct hash_ipport6_elem *ip1,
-			const struct hash_ipport6_elem *ip2,
-			u32 *multi)
+			const struct hash_ipport6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ip1->port == ip2->port &&
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index b9ac2efaa15c..4115d7c9afef 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -49,8 +49,7 @@ struct hash_ipportip4_elem {
 
 static bool
 hash_ipportip4_data_equal(const struct hash_ipportip4_elem *ip1,
-			  const struct hash_ipportip4_elem *ip2,
-			  u32 *multi)
+			  const struct hash_ipportip4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->ip2 == ip2->ip2 &&
@@ -220,8 +219,7 @@ struct hash_ipportip6_elem {
 
 static bool
 hash_ipportip6_data_equal(const struct hash_ipportip6_elem *ip1,
-			  const struct hash_ipportip6_elem *ip2,
-			  u32 *multi)
+			  const struct hash_ipportip6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ipv6_addr_equal(&ip1->ip2.in6, &ip2->ip2.in6) &&
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 195853a25b06..0cc5c7e1805a 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -62,8 +62,7 @@ struct hash_ipportnet4_elem {
 
 static bool
 hash_ipportnet4_data_equal(const struct hash_ipportnet4_elem *ip1,
-			   const struct hash_ipportnet4_elem *ip2,
-			   u32 *multi)
+			   const struct hash_ipportnet4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->ip2 == ip2->ip2 &&
@@ -320,8 +319,7 @@ struct hash_ipportnet6_elem {
 
 static bool
 hash_ipportnet6_data_equal(const struct hash_ipportnet6_elem *ip1,
-			   const struct hash_ipportnet6_elem *ip2,
-			   u32 *multi)
+			   const struct hash_ipportnet6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ipv6_addr_equal(&ip1->ip2.in6, &ip2->ip2.in6) &&
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index 41a122591fe2..af96243d5796 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -40,8 +40,7 @@ struct hash_mac4_elem {
 
 static bool
 hash_mac4_data_equal(const struct hash_mac4_elem *e1,
-		     const struct hash_mac4_elem *e2,
-		     u32 *multi)
+		     const struct hash_mac4_elem *e2)
 {
 	return ether_addr_equal(e1->ether, e2->ether);
 }
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 092f3c9281b8..4324e68df0e5 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -50,8 +50,7 @@ struct hash_net4_elem {
 
 static bool
 hash_net4_data_equal(const struct hash_net4_elem *ip1,
-		     const struct hash_net4_elem *ip2,
-		     u32 *multi)
+		     const struct hash_net4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->cidr == ip2->cidr;
@@ -221,8 +220,7 @@ struct hash_net6_elem {
 
 static bool
 hash_net6_data_equal(const struct hash_net6_elem *ip1,
-		     const struct hash_net6_elem *ip2,
-		     u32 *multi)
+		     const struct hash_net6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ip1->cidr == ip2->cidr;
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index b602cc43565d..e4d48274e7bc 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -63,16 +63,20 @@ struct hash_netiface4_elem {
 };
 
 /* Common functions */
-
 static bool
-hash_netiface4_data_equal(const struct hash_netiface4_elem *ip1,
-			  const struct hash_netiface4_elem *ip2,
-			  u32 *multi)
+hash_netiface4_key_equal(const struct hash_netiface4_elem *ip1,
+			 const struct hash_netiface4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->cidr == ip2->cidr &&
-	       (++*multi) &&
-	       ip1->physdev == ip2->physdev &&
+	       ip1->physdev == ip2->physdev;
+}
+
+static bool
+hash_netiface4_data_equal(const struct hash_netiface4_elem *ip1,
+			  const struct hash_netiface4_elem *ip2)
+{
+	return hash_netiface4_key_equal(ip1, ip2) &&
 	       (ip1->wildcard ?
 		strncmp(ip1->iface, ip2->iface, strlen(ip1->iface)) == 0 :
 		strcmp(ip1->iface, ip2->iface) == 0);
@@ -84,6 +88,29 @@ hash_netiface4_do_data_match(const struct hash_netiface4_elem *elem)
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
+/* An exact (non-wildcard) element always takes priority over a wildcard
+ * element for the same net/cidr/physdev key, regardless of which one a
+ * group's element list happens to return first.
+ */
+static bool
+hash_netiface4_data_isexact(const struct hash_netiface4_elem *elem)
+{
+	return !elem->wildcard;
+}
+
+/* Whether @ip1 and @ip2 are the very same stored representation, as opposed
+ * to whether @ip2's interface merely matches the pattern @ip1 represents.
+ * Used to find the element an add request refreshes.
+ */
+static bool
+hash_netiface4_data_isequal(const struct hash_netiface4_elem *ip1,
+			    const struct hash_netiface4_elem *ip2)
+{
+	return hash_netiface4_key_equal(ip1, ip2) &&
+	       ip1->wildcard == ip2->wildcard &&
+	       strcmp(ip1->iface, ip2->iface) == 0;
+}
+
 static void
 hash_netiface4_data_set_flags(struct hash_netiface4_elem *elem, u32 flags)
 {
@@ -297,16 +324,20 @@ struct hash_netiface6_elem {
 };
 
 /* Common functions */
-
 static bool
-hash_netiface6_data_equal(const struct hash_netiface6_elem *ip1,
-			  const struct hash_netiface6_elem *ip2,
-			  u32 *multi)
+hash_netiface6_key_equal(const struct hash_netiface6_elem *ip1,
+			 const struct hash_netiface6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ip1->cidr == ip2->cidr &&
-	       (++*multi) &&
-	       ip1->physdev == ip2->physdev &&
+	       ip1->physdev == ip2->physdev;
+}
+
+static bool
+hash_netiface6_data_equal(const struct hash_netiface6_elem *ip1,
+			  const struct hash_netiface6_elem *ip2)
+{
+	return hash_netiface6_key_equal(ip1, ip2) &&
 	       (ip1->wildcard ?
 		strncmp(ip1->iface, ip2->iface, strlen(ip1->iface)) == 0 :
 		strcmp(ip1->iface, ip2->iface) == 0);
@@ -318,6 +349,25 @@ hash_netiface6_do_data_match(const struct hash_netiface6_elem *elem)
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
+static bool
+hash_netiface6_data_isexact(const struct hash_netiface6_elem *elem)
+{
+	return !elem->wildcard;
+}
+
+/* Whether @ip1 and @ip2 are the very same stored representation, as opposed
+ * to whether @ip2's interface merely matches the pattern @ip1 represents.
+ * Used to find the element an add request refreshes.
+ */
+static bool
+hash_netiface6_data_isequal(const struct hash_netiface6_elem *ip1,
+			    const struct hash_netiface6_elem *ip2)
+{
+	return hash_netiface6_key_equal(ip1, ip2) &&
+	       ip1->wildcard == ip2->wildcard &&
+	       strcmp(ip1->iface, ip2->iface) == 0;
+}
+
 static void
 hash_netiface6_data_set_flags(struct hash_netiface6_elem *elem, u32 flags)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index f7c8a1cc30fc..fe2c9e32da86 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -58,8 +58,7 @@ struct hash_netnet4_elem {
 
 static bool
 hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
-			const struct hash_netnet4_elem *ip2,
-			u32 *multi)
+			const struct hash_netnet4_elem *ip2)
 {
 	return ip1->ipcmp == ip2->ipcmp &&
 	       ip1->ccmp == ip2->ccmp;
@@ -295,8 +294,7 @@ struct hash_netnet6_elem {
 
 static bool
 hash_netnet6_data_equal(const struct hash_netnet6_elem *ip1,
-			const struct hash_netnet6_elem *ip2,
-			u32 *multi)
+			const struct hash_netnet6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
 	       ipv6_addr_equal(&ip1->ip[1].in6, &ip2->ip[1].in6) &&
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 5de4b511de76..eaa96c7dcd47 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -60,8 +60,7 @@ struct hash_netport4_elem {
 
 static bool
 hash_netport4_data_equal(const struct hash_netport4_elem *ip1,
-			 const struct hash_netport4_elem *ip2,
-			 u32 *multi)
+			 const struct hash_netport4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->port == ip2->port &&
@@ -277,8 +276,7 @@ struct hash_netport6_elem {
 
 static bool
 hash_netport6_data_equal(const struct hash_netport6_elem *ip1,
-			 const struct hash_netport6_elem *ip2,
-			 u32 *multi)
+			 const struct hash_netport6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ip1->port == ip2->port &&
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 61af1ce27127..e9d08c5de4fb 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -59,8 +59,7 @@ struct hash_netportnet4_elem {
 
 static bool
 hash_netportnet4_data_equal(const struct hash_netportnet4_elem *ip1,
-			    const struct hash_netportnet4_elem *ip2,
-			    u32 *multi)
+			    const struct hash_netportnet4_elem *ip2)
 {
 	return ip1->ipcmp == ip2->ipcmp &&
 	       ip1->ccmp == ip2->ccmp &&
@@ -352,8 +351,7 @@ struct hash_netportnet6_elem {
 
 static bool
 hash_netportnet6_data_equal(const struct hash_netportnet6_elem *ip1,
-			    const struct hash_netportnet6_elem *ip2,
-			    u32 *multi)
+			    const struct hash_netportnet6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
 	       ipv6_addr_equal(&ip1->ip[1].in6, &ip2->ip[1].in6) &&
-- 
2.56.0

