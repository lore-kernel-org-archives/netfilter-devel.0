Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302412D8DB0
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jul 2026 13:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784035153; cv=none; b=r01G68JjR0hxUmUWUpJ5dSbfkJhsr5vqZ+xXaLVqaE9xbG1IyluB3083nOydiK6i/tj1UXy4trLpbv3dl6SGmfT1epas+TjnT3NHvBQTfDULGi4LT1S6XZEgY9NOz9Lnmlz37ncKkOy847grCabHFT5VLbfQvct48BQBVyUllbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784035153; c=relaxed/simple;
	bh=zpILKG1R05Q0Ih2it9YYKLIdv/de6XTz9FI4dqiSRXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJSgdqxa6SfU1pxzYe1HTtNkrqKrLRpxZiZeu8M1IzB1txy5GIidY2jjQaK+mLagStS9OdgHLfYJMp9CEmriQc8k5fbEw4k10SvoLz0IBaeykg2Kd2Byf3M5R5/CwyK03QzHkyyPuLPtH97LnPBNjsWZUqf9lEbq4vDYuIif2ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B256660503; Tue, 14 Jul 2026 15:19:10 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 07/12] netfilter: ipset: add rhashtable boilerplate stubs
Date: Tue, 14 Jul 2026 15:18:23 +0200
Message-ID: <20260714131828.10685-8-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714131828.10685-1-fw@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Preparation patch.  Adds an rhashtable to the set and initialised
and destroys it.  No elements are ever added to this hashtable.

This change is supposed to be devoid of side effects and is
separate to reduce size of the conversion patch.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 104 +++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 1eff2c065bb3..8f5f15fdf61b 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -8,6 +8,7 @@
 #include <linux/rcupdate_wait.h>
 #include <linux/jhash.h>
 #include <linux/types.h>
+#include <linux/rhashtable.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/ipset/ip_set.h>
 
@@ -192,9 +193,16 @@ static const union nf_inet_addr zeromask = {};
 
 #undef mtype_ahash_destroy
 #undef mtype_ext_cleanup
+#undef mtype_rht_elem
+#undef mtype_rht_hashfn
+#undef mtype_rht_obj_hashfn
+#undef mtype_rht_cmpfn
+#undef mtype_rht_params
+
 #undef mtype_add_cidr
 #undef mtype_del_cidr
 #undef mtype_del_cidr_all
+#undef mtype_flush_elem
 #undef mtype_ahash_memsize
 #undef mtype_flush
 #undef mtype_destroy
@@ -240,9 +248,17 @@ static const union nf_inet_addr zeromask = {};
 
 #define mtype_ahash_destroy	IPSET_TOKEN(MTYPE, _ahash_destroy)
 #define mtype_ext_cleanup	IPSET_TOKEN(MTYPE, _ext_cleanup)
+
+#define mtype_rht_elem		IPSET_TOKEN(MTYPE, _rht_elem)
+#define mtype_rht_hashfn	IPSET_TOKEN(MTYPE, _rht_hashfn)
+#define mtype_rht_obj_hashfn	IPSET_TOKEN(MTYPE, _rht_obj_hashfn)
+#define mtype_rht_cmpfn		IPSET_TOKEN(MTYPE, _rht_cmpfn)
+#define mtype_rht_params	IPSET_TOKEN(MTYPE, _rht_params)
+
 #define mtype_add_cidr		IPSET_TOKEN(MTYPE, _add_cidr)
 #define mtype_del_cidr		IPSET_TOKEN(MTYPE, _del_cidr)
 #define mtype_del_cidr_all	IPSET_TOKEN(MTYPE, _del_cidr_all)
+#define mtype_flush_elem	IPSET_TOKEN(MTYPE, _flush_elem)
 #define mtype_ahash_memsize	IPSET_TOKEN(MTYPE, _ahash_memsize)
 #define mtype_flush		IPSET_TOKEN(MTYPE, _flush)
 #define mtype_destroy		IPSET_TOKEN(MTYPE, _destroy)
@@ -275,6 +291,60 @@ static const union nf_inet_addr zeromask = {};
 
 #define htype			MTYPE
 
+/* Per-element rhashtable object.  Extensions follow the elem field inline;
+ * allocate as offsetof(struct mtype_rht_elem, elem) + set->dsize bytes.
+ */
+struct mtype_rht_elem {
+	struct rhash_head node;
+	struct rcu_head rcu;		/* deferred free after removal */
+	struct mtype_elem elem;		/* element data; extensions follow */
+};
+
+/* jhash of the lookup key */
+static u32 mtype_rht_hashfn(const void *data, u32 len, u32 seed)
+{
+	BUILD_BUG_ON(HKEY_DATALEN % sizeof(u32) != 0);
+	return jhash2((const u32 *)data, HKEY_DATALEN / sizeof(u32), seed);
+}
+
+/* jhash of an existing element object */
+static u32 mtype_rht_obj_hashfn(const void *obj, u32 len, u32 seed)
+{
+	const struct mtype_rht_elem *e = obj;
+#ifdef IP_SET_HASH_WITH_NETS
+	/* Reset transient flags (e.g. nomatch) before hashing so that the
+	 * object hash always equals the lookup-key hash computed by hashfn.
+	 */
+	struct mtype_elem tmp;
+	u8 flags = 0;
+
+	memcpy(&tmp, &e->elem, HKEY_DATALEN);
+	mtype_data_reset_flags(&tmp, &flags);
+	return jhash2((const u32 *)&tmp, HKEY_DATALEN / sizeof(u32), seed);
+#else
+	return jhash2((const u32 *)&e->elem, HKEY_DATALEN / sizeof(u32), seed);
+#endif
+}
+
+/* 0 = key matches object (equal), non-zero = not equal */
+static int mtype_rht_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
+{
+	const struct mtype_rht_elem *e = obj;
+	u32 multi = 0;
+
+	return !mtype_data_equal(&e->elem,
+				 (const struct mtype_elem *)arg->key, &multi);
+}
+
+static const struct rhashtable_params mtype_rht_params = {
+	.head_offset	= offsetof(struct mtype_rht_elem, node),
+	.hashfn		= mtype_rht_hashfn,
+	.obj_hashfn	= mtype_rht_obj_hashfn,
+	.obj_cmpfn	= mtype_rht_cmpfn,
+	.key_len	= HKEY_DATALEN,
+	.automatic_shrinking = true,
+};
+
 #define HKEY(data, initval, htable_bits)			\
 ({								\
 	const u32 *__k = (const u32 *)data;			\
@@ -288,6 +358,7 @@ static const union nf_inet_addr zeromask = {};
 /* The generic hash structure */
 struct htype {
 	struct htable __rcu *table; /* the hash table */
+	struct rhashtable ht;	/* the hash table */
 	struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
 	struct htable_gc gc;	/* gc workqueue */
 	u32 maxelem;		/* max elements in the hash */
@@ -424,6 +495,16 @@ mtype_del_cidr_all(struct ip_set *set, struct htype *h, const struct mtype_elem
 #endif
 }
 
+/* Free one element: called by rhashtable_free_and_destroy */
+static void
+mtype_flush_elem(void *ptr, void *arg)
+{
+	struct ip_set *set = arg;
+	struct mtype_rht_elem *e = ptr;
+
+	ip_set_ext_destroy(set, &e->elem);
+	kfree_rcu(e, rcu);
+}
 /* Calculate the actual memory size of the set data */
 static size_t
 mtype_ahash_memsize(const struct htype *h, const struct htable *t)
@@ -458,6 +539,9 @@ mtype_flush(struct ip_set *set)
 	struct hbucket *n;
 	u32 r, i;
 
+	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
+	rhashtable_init(&h->ht, &mtype_rht_params);
+
 	t = ipset_dereference_nfnl(h->table);
 	for (r = 0; r < ahash_numof_locks(t->htable_bits); r++) {
 		spin_lock_bh(&t->hregion[r].lock);
@@ -530,6 +614,8 @@ mtype_destroy(struct ip_set *set)
 	struct htable *t = (__force struct htable *)h->table;
 	struct list_head *l, *lt;
 
+	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
+
 	list_for_each_safe(l, lt, &t->ad) {
 		list_del(l);
 		kfree(l);
@@ -1580,6 +1666,7 @@ static int
 IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 			    struct nlattr *tb[], u32 flags)
 {
+	struct rhashtable_params params;
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	u32 markmask;
@@ -1596,6 +1683,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	size_t hsize;
 	struct htype *h;
 	struct htable *t;
+	int err;
 	u32 i;
 
 	pr_debug("Create set %s with family %s\n",
@@ -1686,6 +1774,16 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	if (!h)
 		return -ENOMEM;
 
+	/* Initialize rhashtable with the user-requested size as hint */
+	params = mtype_rht_params;
+	params.nelem_hint = hashsize;
+	/* maxsize: maximum bucket table size to expand to */
+	params.max_size = maxelem;
+
+	err = rhashtable_init(&h->ht, &params);
+	if (err)
+		goto free_h;
+
 	/* Compute htable_bits from the user input parameter hashsize.
 	 * Assume that hashsize == 2^htable_bits,
 	 * otherwise round up to the first 2^n value.
@@ -1693,10 +1791,10 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	hbits = fls(hashsize - 1);
 	hsize = htable_size(hbits);
 	if (hsize == 0)
-		goto free_h;
+		goto free_rht;
 	t = ip_set_alloc(hsize);
 	if (!t)
-		goto free_h;
+		goto free_rht;
 	t->hregion = ip_set_alloc(ahash_sizeof_regions(hbits));
 	if (!t->hregion)
 		goto free_t;
@@ -1782,6 +1880,8 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #endif
 free_t:
 	ip_set_free(t);
+free_rht:
+	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
 free_h:
 	kfree(h);
 	return -ENOMEM;
-- 
2.54.0

