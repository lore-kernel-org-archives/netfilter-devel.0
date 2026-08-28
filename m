Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6BF353A6A
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2026 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787930636; cv=none; b=IsM7WdZ2Uh5p0HkUkjp9qY1vXLsMTG7eSPZ+iebM3HS6hXZnYz7GT3YHyxtoWZmuqAC3YVjim4I9ykdkvVnaA0KuMh+xiX6G3irK5EiNqcBQEkLVmIVjv91eXGl8YdY4E40CoJLJNO2hphQTvgQ6xj4bXFovhvi1QAoeApnejUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787930636; c=relaxed/simple;
	bh=4BnB+KVz9HuPcKEPc+I9f0OF2k0+wtHkzAKn+09Nw4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/nCdJBkAthkB+1MdZOXNdTSyBpYETXQbYcw/Sl7sGGAOIQbbVgKdGkw/4X4ccJDXGFUMLsTe+H3LosJV1V2mNAapX52Qzqlh+Elw1isMhYmZ9Jn2gPw18dPNOvbEcNpB6dPo1IeBucVc8ITjDUvVifZQq7oalndCNCnOUfkBhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 90D1860795; Fri, 28 Aug 2026 17:23:50 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v3 3/5] netfilter: ipset: replace internal hash table with rhashtable
Date: Fri, 28 Aug 2026 17:22:54 +0200
Message-ID: <20260828152256.8759-4-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260828152256.8759-1-fw@strlen.de>
References: <20260828152256.8759-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace ipset hash tables with rhashtable.

The IP_SET_HASH_WITH_MULTI hash type is converted to an rhltable:
It stores *lists* of identical hash keys that contain different data.
For this set type (netiface) the hash is the address/netmask and the data
part also stores an interface name.

Matching in such a set needs to first obtain a the best net/mask match,
and then walk the rhlist to search for a matching interface name.
This optionally allows wildcard matching / partial matching of the name
prefix.

The hash table replaced here supported this via the "multi" flag, which
is now obsolete and will be removed later.

The replaced hash table also had a AHASH_MAX_TUNED value of 64: this
provided an implicit upper bound of identical hash keys that could be
inserted. An existing test in ipset.git fails if more than 64 entries can
be added.

As the chain list walk becomes expensive with increasing length, keep
this limit but make it explicit via RHL_MAX_CHAINLEN.

FORCEADD is removed to reduce diff size, it is added back later.

Initval, bucket size and hashtable bits configuration options are
kept for backwards compatibility; they are not used anymore.

Rename mtype_ext_size() to mtype_rht_size() because the function
returns the size of the rhashtable.

automatic rhashtable shrinking remains disabled for now.  Quoting
Jozsef: "the hash types of ipset presently can only grow to the max size
but can never shrink. [..] if automatic_shrinking is set to false, then
both the current behaviour is kept and no resizing happens due to running
a gc before listing head/dumping the whole set."

Setting rhashtable .automatic_shrinking to true will not break the
kernel, but it does cause test flakiness in a few ipset test cases:
those check that timed out elements disappear after a few seconds.
With automatic_shrinking enabled, that can cause the dump walker to
hit -EAGAIN during resize which may results in duplicate or omitted
elements.

Followup patch should also mark such dumps as interrupted so userspace
can retry, but this problem is not limited to ipset.

Several left-overs from the old implementation remain:

- resize callback and resize checks
- data_next stubs
- region locking
- multi-flag

These will be removed in a followup series.

Joint work with Jozsef Kadlecisk.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3:
 serialize rhltable insertion with set->lock, else we can inject identical elements.
 nit: also rename mtype_rht_size toke-replace
 add kdoc comment to say that mtype_flush cannot guarantee set is empty
 after flush (parallel re-add).
 I ignored the LLM review wrt 'skipped elements' on set walks, with
 parallel mutations (internal resizes, deletes) a stable walk would
 require significantly more work, such as keeping elements on a
 dedicated list.  It should be ok as-is.

 net/netfilter/ipset/ip_set_hash_gen.h | 1447 ++++++++-----------------
 1 file changed, 462 insertions(+), 985 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 220fc9e79c76..bce83006e2a2 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -5,7 +5,6 @@
 #define _IP_SET_HASH_GEN_H
 
 #include <linux/rcupdate.h>
-#include <linux/rcupdate_wait.h>
 #include <linux/jhash.h>
 #include <linux/types.h>
 #include <linux/rhashtable.h>
@@ -18,84 +17,23 @@
 #define ipset_dereference_nfnl(p)	\
 	rcu_dereference_protected(p,	\
 		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
-#define ipset_dereference_set(p, set) 	\
-	rcu_dereference_protected(p,	\
-		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET) || \
-		lockdep_is_held(&(set)->lock))
 #define ipset_dereference_bh_nfnl(p)	\
 	rcu_dereference_bh_check(p, 	\
 		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
 
-/* Hashing which uses arrays to resolve clashing. The hash table is resized
- * (doubled) when searching becomes too long.
- * Internally jhash is used with the assumption that the size of the
- * stored data is a multiple of sizeof(u32).
- *
- * Readers and resizing
- *
- * Resizing can be triggered by userspace command only, and those
- * are serialized by the nfnl mutex. During resizing the set is
- * read-locked, so the only possible concurrent operations are
- * the kernel side readers. Those must be protected by proper RCU locking.
- */
-
-/* Number of elements to store in an initial array block */
+/* Kept for backward compatibility */
 #define AHASH_INIT_SIZE			2
-/* Max number of elements to store in an array block */
 #define AHASH_MAX_SIZE			(6 * AHASH_INIT_SIZE)
-/* Max muber of elements in the array block when tuned */
-#define AHASH_MAX_TUNED			64
-#define AHASH_MAX(h)			((h)->bucketsize)
-
-/* A hash bucket */
-struct hbucket {
-	struct rcu_head rcu;	/* for call_rcu */
-	/* Which positions are used in the array */
-	DECLARE_BITMAP(used, AHASH_MAX_TUNED);
-	u8 size;		/* size of the array */
-	u8 pos;			/* position of the first free entry */
-	unsigned char value[]	/* the array of the values */
-		__aligned(__alignof__(u64));
-};
 
-/* Region size for locking == 2^HTABLE_REGION_BITS */
-#define HTABLE_REGION_BITS	10
-#define ahash_numof_locks(htable_bits)		\
-	((htable_bits) < HTABLE_REGION_BITS ? 1	\
-		: jhash_size((htable_bits) - HTABLE_REGION_BITS))
-#define ahash_sizeof_regions(htable_bits)		\
-	(ahash_numof_locks(htable_bits) * sizeof(struct ip_set_region))
-#define ahash_region(n)		\
-	((n) / jhash_size(HTABLE_REGION_BITS))
-#define ahash_bucket_start(h,  htable_bits)	\
-	((htable_bits) < HTABLE_REGION_BITS ? 0	\
-		: (h) * jhash_size(HTABLE_REGION_BITS))
-#define ahash_bucket_end(h,  htable_bits)	\
-	((htable_bits) < HTABLE_REGION_BITS ? jhash_size(htable_bits)	\
-		: ((h) + 1) * jhash_size(HTABLE_REGION_BITS))
+#ifdef IP_SET_HASH_WITH_MULTI
+#define RHL_MAX_CHAINLEN	64
+#endif
 
 struct htable_gc {
 	struct delayed_work dwork;
 	struct ip_set *set;	/* Set the gc belongs to */
-	spinlock_t lock;	/* Lock to exclude gc and resize */
-	u32 region;		/* Last gc run position */
 };
 
-/* The hash table: the table size stored here in order to make resizing easy */
-struct htable {
-	bool resizing;		/* Mark ongoing resize */
-	atomic_t uref;		/* References for dumping and gc */
-	u8 htable_bits;		/* size of hash table == 2^htable_bits */
-	u32 maxelem;		/* Maxelem per region */
-	struct list_head ad;	/* Resize add|del backlist */
-	struct ip_set_region *hregion;	/* Region locks and ext sizes */
-	struct hbucket __rcu *bucket[]; /* hashtable buckets */
-};
-
-#define hbucket(h, i)		((h)->bucket[i])
-#define ext_size(n, dsize)	\
-	(sizeof(struct hbucket) + (n) * (dsize))
-
 #ifndef IPSET_NET_COUNT
 #define IPSET_NET_COUNT		1
 #endif
@@ -132,23 +70,6 @@ struct net_prefixes {
 	struct net_prefix nets[] __counted_by(len);
 };
 
-/* Compute the hash table size */
-static size_t
-htable_size(u8 hbits)
-{
-	size_t hsize;
-
-	/* We must fit both into u32 in jhash and INT_MAX in kvmalloc_node() */
-	if (hbits > 31)
-		return 0;
-	hsize = jhash_size(hbits);
-	if ((INT_MAX - sizeof(struct htable)) / sizeof(struct hbucket *)
-	    < hsize)
-		return 0;
-
-	return hsize * sizeof(struct hbucket *) + sizeof(struct htable);
-}
-
 #ifdef IP_SET_HASH_WITH_NETS
 #if IPSET_NET_COUNT > 1
 #define __CIDR(cidr, i)		(cidr[i])
@@ -217,8 +138,6 @@ static const union nf_inet_addr zeromask = {};
 #undef mtype_data_next
 #undef mtype_elem
 
-#undef mtype_ahash_destroy
-#undef mtype_ext_cleanup
 #undef mtype_rht_elem
 #undef mtype_rht_hashfn
 #undef mtype_rht_obj_hashfn
@@ -229,23 +148,19 @@ static const union nf_inet_addr zeromask = {};
 #undef mtype_del_cidr
 #undef mtype_del_cidr_all
 #undef mtype_flush_elem
-#undef mtype_ahash_memsize
 #undef mtype_flush
 #undef mtype_destroy
 #undef mtype_same_set
 #undef mtype_kadt
 #undef mtype_uadt
-#undef mtype_bucket_size
-#undef mtype_hash_size
 
 #undef mtype_add
+#undef mtype_do_set_exts
 #undef mtype_del
 #undef mtype_test_cidrs
 #undef mtype_test
 #undef mtype_uref
-#undef mtype_resize
-#undef mtype_ext_size
-#undef mtype_resize_ad
+#undef mtype_rht_size
 #undef mtype_head
 #undef mtype_list
 #undef mtype_gc_do
@@ -256,7 +171,6 @@ static const union nf_inet_addr zeromask = {};
 #undef mtype_data_match
 
 #undef htype
-#undef HKEY
 
 #ifdef IP_SET_HASH_WITH_MULTI
 #define mtype_key_equal	IPSET_TOKEN(MTYPE, _key_equal)
@@ -275,9 +189,6 @@ static const union nf_inet_addr zeromask = {};
 #define mtype_data_next		IPSET_TOKEN(MTYPE, _data_next)
 #define mtype_elem		IPSET_TOKEN(MTYPE, _elem)
 
-#define mtype_ahash_destroy	IPSET_TOKEN(MTYPE, _ahash_destroy)
-#define mtype_ext_cleanup	IPSET_TOKEN(MTYPE, _ext_cleanup)
-
 #define mtype_rht_elem		IPSET_TOKEN(MTYPE, _rht_elem)
 #define mtype_rht_hashfn	IPSET_TOKEN(MTYPE, _rht_hashfn)
 #define mtype_rht_obj_hashfn	IPSET_TOKEN(MTYPE, _rht_obj_hashfn)
@@ -288,23 +199,18 @@ static const union nf_inet_addr zeromask = {};
 #define mtype_del_cidr		IPSET_TOKEN(MTYPE, _del_cidr)
 #define mtype_del_cidr_all	IPSET_TOKEN(MTYPE, _del_cidr_all)
 #define mtype_flush_elem	IPSET_TOKEN(MTYPE, _flush_elem)
-#define mtype_ahash_memsize	IPSET_TOKEN(MTYPE, _ahash_memsize)
 #define mtype_flush		IPSET_TOKEN(MTYPE, _flush)
 #define mtype_destroy		IPSET_TOKEN(MTYPE, _destroy)
 #define mtype_same_set		IPSET_TOKEN(MTYPE, _same_set)
 #define mtype_kadt		IPSET_TOKEN(MTYPE, _kadt)
 #define mtype_uadt		IPSET_TOKEN(MTYPE, _uadt)
-#define mtype_bucket_size	IPSET_TOKEN(MTYPE, _bucket_size)
-#define mtype_hash_size		IPSET_TOKEN(MTYPE, _hash_size)
 
 #define mtype_add		IPSET_TOKEN(MTYPE, _add)
 #define mtype_del		IPSET_TOKEN(MTYPE, _del)
 #define mtype_test_cidrs	IPSET_TOKEN(MTYPE, _test_cidrs)
 #define mtype_test		IPSET_TOKEN(MTYPE, _test)
 #define mtype_uref		IPSET_TOKEN(MTYPE, _uref)
-#define mtype_resize		IPSET_TOKEN(MTYPE, _resize)
-#define mtype_ext_size		IPSET_TOKEN(MTYPE, _ext_size)
-#define mtype_resize_ad		IPSET_TOKEN(MTYPE, _resize_ad)
+#define mtype_rht_size		IPSET_TOKEN(MTYPE, _rht_size)
 #define mtype_head		IPSET_TOKEN(MTYPE, _head)
 #define mtype_list		IPSET_TOKEN(MTYPE, _list)
 #define mtype_gc_do		IPSET_TOKEN(MTYPE, _gc_do)
@@ -366,13 +272,12 @@ static int mtype_rht_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
 {
 	const struct mtype_rht_elem *e = obj;
 #ifdef IP_SET_HASH_WITH_MULTI
-	return !mtype_key_equal(&e->elem,
-				(const struct mtype_elem *)arg->key);
+	return !mtype_key_equal(&e->elem, (const struct mtype_elem *)arg->key);
 #else
 	u32 multi = 0;
 
 	return !mtype_data_equal(&e->elem,
-				(const struct mtype_elem *)arg->key, &multi);
+				 (const struct mtype_elem *)arg->key, &multi);
 #endif
 }
 
@@ -385,19 +290,8 @@ static const struct rhashtable_params mtype_rht_params = {
 	.key_len	= HKEY_DATALEN,
 };
 
-#define HKEY(data, initval, htable_bits)			\
-({								\
-	const u32 *__k = (const u32 *)data;			\
-	u32 __l = HKEY_DATALEN / sizeof(u32);			\
-								\
-	BUILD_BUG_ON(HKEY_DATALEN % sizeof(u32) != 0);		\
-								\
-	jhash2(__k, __l, initval) & jhash_mask(htable_bits);	\
-})
-
-/* The generic hash structure */
+/* The hash set type */
 struct htype {
-	struct htable __rcu *table; /* the hash table */
 #ifdef IP_SET_HASH_WITH_MULTI
 	struct rhltable rhlt;	/* the hashlist table */
 #else
@@ -406,11 +300,12 @@ struct htype {
 	struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
 	struct htable_gc gc;	/* gc workqueue */
 	u32 maxelem;		/* max elements in the hash */
-	u32 initval;		/* random jhash init value */
+	u32 initval;		/* kept for backward compatibility */
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	u32 markmask;		/* markmask value for mark mask to store */
 #endif
-	u8 bucketsize;		/* max elements in an array block */
+	u8 htable_bits;		/* kept for backward compatibility */
+	u8 bucketsize;		/* kept for backward compatibility */
 #if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
 	u8 netmask;		/* netmask value for subnets to store */
 	union nf_inet_addr bitmask;	/* stores bitmask */
@@ -421,6 +316,15 @@ struct htype {
 	struct mtype_elem next; /* temporary storage for uadd */
 };
 
+#define ipset_hash_elem_destroy_free(set, h, e) do {				\
+	typeof(set) __set = (set);						\
+	typeof(h) __h = (h);							\
+	typeof(e) __e = (e);							\
+	mtype_del_cidr_all(__set, __h, &__e->elem);				\
+	ip_set_ext_destroy(__set, &__e->elem);					\
+	kfree_rcu(__e, rcu);							\
+} while (0)
+
 #ifdef IP_SET_HASH_WITH_MULTI
 #define ipset_hash_nelems(h) atomic_read(&(h)->rhlt.ht.nelems)
 #define ipset_hash_walk_enter(h, iter)	rhltable_walk_enter(&(h)->rhlt, (iter))
@@ -431,16 +335,6 @@ struct htype {
 #define ipset_hash_remove(h, e) rhashtable_remove_fast(&(h)->ht, &(e)->node, mtype_rht_params)
 #endif
 
-/* ADD|DEL entries saved during resize */
-struct mtype_resize_ad {
-	struct list_head list;
-	enum ipset_adt ad;	/* ADD|DEL element */
-	struct mtype_elem d;	/* Element value */
-	struct ip_set_ext ext;	/* Extensions for ADD */
-	struct ip_set_ext mext;	/* Target extensions for ADD */
-	u32 flags;		/* Flags for ADD */
-};
-
 #ifdef IP_SET_HASH_WITH_NETS
 /**
  * mtype_add_cidr - Add a CIDR entry to hash table bookkeeping
@@ -592,100 +486,49 @@ mtype_flush_elem(void *ptr, void *arg)
 	ip_set_ext_destroy(set, &e->elem);
 	kfree_rcu(e, rcu);
 }
-/* Calculate the actual memory size of the set data */
-static size_t
-mtype_ahash_memsize(const struct htype *h, const struct htable *t)
-{
-	return sizeof(*h) + sizeof(*t) + ahash_sizeof_regions(t->htable_bits);
-}
-
-/* Get the ith element from the array block n */
-#define ahash_data(n, i, dsize)	\
-	((struct mtype_elem *)((n)->value + ((i) * (dsize))))
-
-static void
-mtype_ext_cleanup(struct ip_set *set, struct hbucket *n)
-{
-	int i;
-	u8 pos = smp_load_acquire(&n->pos);
-
-	for (i = 0; i < pos; i++)
-		if (test_bit(i, n->used))
-			ip_set_ext_destroy(set, ahash_data(n, i, set->dsize));
-}
 
-/* Flush a hash type of set: destroy all elements */
+/**
+ * mtype_flush() - Flush a hash set type by destroying all elements.
+ * @set: Pointer to the ip_set.
+ *
+ * Because other CPUs may concurrently insert new entries into the table
+ * while flush is in progress, there is no guarantee that the table will
+ * be empty upon return.
+ */
 static void
 mtype_flush(struct ip_set *set)
 {
 	struct htype *h = set->data;
-#ifdef IP_SET_HASH_WITH_NETS
-	struct net_prefixes *nets;
-#endif
-	struct htable *t;
-	struct hbucket *n;
-	u32 r, i;
-
-	t = ipset_dereference_nfnl(h->table);
-	for (r = 0; r < ahash_numof_locks(t->htable_bits); r++) {
-		spin_lock_bh(&t->hregion[r].lock);
-		for (i = ahash_bucket_start(r, t->htable_bits);
-		     i < ahash_bucket_end(r, t->htable_bits); i++) {
-			n = __ipset_dereference(hbucket(t, i));
-			if (!n)
+	struct rhashtable_iter hti;
+	struct mtype_rht_elem *e;
+	unsigned int dropped;
+
+	ipset_hash_walk_enter(h, &hti);
+restart:
+	dropped = 0;
+	rhashtable_walk_start(&hti);
+
+	while ((e = rhashtable_walk_next(&hti))) {
+		if (IS_ERR(e)) {
+			if (PTR_ERR(e) == -EAGAIN)
 				continue;
-			if (set->extensions & IPSET_EXT_DESTROY)
-				mtype_ext_cleanup(set, n);
-			/* FIXME: use slab cache */
-			rcu_assign_pointer(hbucket(t, i), NULL);
-			kfree_rcu(n, rcu);
+			break;
+		}
+		if (ipset_hash_remove(h, e))
+			continue; /* Concurrent delete? skip */
+		mtype_del_cidr_all(set, h, &e->elem);
+		ip_set_ext_destroy(set, &e->elem);
+		kfree_rcu(e, rcu);
+
+		if (dropped++ > 128 && need_resched()) {
+			rhashtable_walk_stop(&hti);
+			cond_resched();
+			goto restart;
 		}
-		t->hregion[r].ext_size = 0;
-		t->hregion[r].elements = 0;
-		spin_unlock_bh(&t->hregion[r].lock);
-	}
-#ifdef IP_SET_HASH_WITH_NETS
-	for (i = 0; i < IPSET_NET_COUNT; i++) {
-		u8 j;
-
-		spin_lock_bh(&set->lock);
-		nets = ipset_dereference_nfnl(h->rnets[i]);
-		write_seqcount_begin(&nets->seq);
-		for (j = 0; j < nets->len; j++)
-			WRITE_ONCE(nets->nets[j], (struct net_prefix){});
-		write_seqcount_end(&nets->seq);
-		spin_unlock_bh(&set->lock);
-	}
-#endif
-}
-
-/* Destroy the hashtable part of the set */
-static void
-mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
-{
-#ifdef IP_SET_HASH_WITH_NETS
-	struct htype *h = set->data;
-#endif
-	struct hbucket *n;
-	u32 i;
-
-	for (i = 0; i < jhash_size(t->htable_bits); i++) {
-		n = (__force struct hbucket *)hbucket(t, i);
-		if (!n)
-			continue;
-		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
-			mtype_ext_cleanup(set, n);
-		/* FIXME: use slab cache */
-		kfree(n);
 	}
 
-#ifdef IP_SET_HASH_WITH_NETS
-	if (ext_destroy)
-		for (i = 0; i < IPSET_NET_COUNT; i++)
-			kfree(rcu_dereference_raw(h->rnets[i]));
-#endif
-	ip_set_free(t->hregion);
-	ip_set_free(t);
+	rhashtable_walk_stop(&hti);
+	rhashtable_walk_exit(&hti);
 }
 
 /* Destroy a hash type of set */
@@ -693,8 +536,9 @@ static void
 mtype_destroy(struct ip_set *set)
 {
 	struct htype *h = set->data;
-	struct htable *t = (__force struct htable *)h->table;
-	struct list_head *l, *lt;
+#ifdef IP_SET_HASH_WITH_NETS
+	u32 i;
+#endif
 
 #ifdef IP_SET_HASH_WITH_MULTI
 	rhltable_free_and_destroy(&h->rhlt, mtype_flush_elem, set);
@@ -702,11 +546,10 @@ mtype_destroy(struct ip_set *set)
 	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
 #endif
 
-	list_for_each_safe(l, lt, &t->ad) {
-		list_del(l);
-		kfree(l);
-	}
-	mtype_ahash_destroy(set, t, true);
+#ifdef IP_SET_HASH_WITH_NETS
+	for (i = 0; i < IPSET_NET_COUNT; i++)
+		kfree(rcu_dereference_raw(h->rnets[i]));
+#endif
 	kfree(h);
 
 	set->data = NULL;
@@ -718,7 +561,6 @@ mtype_same_set(const struct ip_set *a, const struct ip_set *b)
 	const struct htype *x = a->data;
 	const struct htype *y = b->data;
 
-	/* Resizing changes htable_bits, so we ignore it */
 	return x->maxelem == y->maxelem &&
 	       a->timeout == b->timeout &&
 #if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
@@ -731,69 +573,43 @@ mtype_same_set(const struct ip_set *a, const struct ip_set *b)
 }
 
 static void
-mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
+mtype_gc_do(struct ip_set *set)
 {
-	struct hbucket *n, *tmp;
-	struct mtype_elem *data;
-	u32 i, j, d;
-	size_t dsize = set->dsize;
-	u8 pos, htable_bits = t->htable_bits;
-
-	spin_lock_bh(&t->hregion[r].lock);
-	for (i = ahash_bucket_start(r, htable_bits);
-	     i < ahash_bucket_end(r, htable_bits); i++) {
-		n = __ipset_dereference(hbucket(t, i));
-		if (!n)
-			continue;
-		pos = smp_load_acquire(&n->pos);
-		for (j = 0, d = 0; j < pos; j++) {
-			if (!test_bit(j, n->used)) {
-				d++;
-				continue;
-			}
-			data = ahash_data(n, j, dsize);
-			if (!ip_set_timeout_expired(ext_timeout(data, set)))
+	struct htype *h = set->data;
+	struct rhashtable_iter hti;
+	struct mtype_rht_elem *e;
+	unsigned int seen;
+
+	ipset_hash_walk_enter(h, &hti);
+restart:
+	seen = 0;
+	rhashtable_walk_start(&hti);
+
+	while ((e = rhashtable_walk_next(&hti))) {
+		if (IS_ERR(e)) {
+			if (PTR_ERR(e) == -EAGAIN)
 				continue;
-			pr_debug("expired %u/%u\n", i, j);
-			clear_bit(j, n->used);
-			smp_mb__after_atomic();
-			mtype_del_cidr_all(set, h, data);
-			t->hregion[r].elements--;
-			ip_set_ext_destroy(set, data);
-			d++;
+			break;
 		}
-		if (d >= AHASH_INIT_SIZE) {
-			if (d >= n->size) {
-				t->hregion[r].ext_size -=
-					ext_size(n->size, dsize);
-				rcu_assign_pointer(hbucket(t, i), NULL);
-				kfree_rcu(n, rcu);
-				continue;
-			}
-			tmp = kzalloc(sizeof(*tmp) +
-				(n->size - AHASH_INIT_SIZE) * dsize,
-				GFP_ATOMIC);
-			if (!tmp)
-				/* Still try to delete expired elements. */
-				continue;
-			tmp->size = n->size - AHASH_INIT_SIZE;
-			for (j = 0, d = 0; j < pos; j++) {
-				if (!test_bit(j, n->used))
-					continue;
-				data = ahash_data(n, j, dsize);
-				memcpy(tmp->value + d * dsize,
-				       data, dsize);
-				set_bit(d, tmp->used);
-				d++;
-			}
-			tmp->pos = d;
-			t->hregion[r].ext_size -=
-				ext_size(AHASH_INIT_SIZE, dsize);
-			rcu_assign_pointer(hbucket(t, i), tmp);
-			kfree_rcu(n, rcu);
+
+		if (ip_set_timeout_expired(ext_timeout(&e->elem, set)) &&
+		    ipset_hash_remove(h, e) == 0) {
+			ip_set_ext_destroy(set, &e->elem);
+			mtype_del_cidr_all(set, h, &e->elem);
+			kfree_rcu(e, rcu);
+		}
+
+		if (seen++ > 128 && need_resched()) {
+			/* stop+start can miss entries (we might have unlinked
+			 * the element). This is harmless.
+			 */
+			rhashtable_walk_stop(&hti);
+			cond_resched();
+			goto restart;
 		}
 	}
-	spin_unlock_bh(&t->hregion[r].lock);
+	rhashtable_walk_stop(&hti);
+	rhashtable_walk_exit(&hti);
 }
 
 static void
@@ -801,40 +617,18 @@ mtype_gc(struct work_struct *work)
 {
 	struct htable_gc *gc;
 	struct ip_set *set;
-	struct htype *h;
-	struct htable *t;
-	u32 r, numof_locks;
 	unsigned int next_run;
 
 	gc = container_of(work, struct htable_gc, dwork.work);
 	set = gc->set;
-	h = set->data;
 
-	rcu_read_lock_bh();
-	t = rcu_dereference_bh(h->table);
-	atomic_inc(&t->uref);
-	rcu_read_unlock_bh();
-	numof_locks = ahash_numof_locks(t->htable_bits);
-	r = gc->region++;
-	if (r >= numof_locks) {
-		r = gc->region = 0;
-	}
-	next_run = (IPSET_GC_PERIOD(set->timeout) * HZ) / numof_locks;
-	if (next_run < HZ/10)
-		next_run = HZ/10;
-
-	spin_lock_bh(&gc->lock);
-	if (!t->resizing)
-		mtype_gc_do(set, h, t, r);
-	spin_unlock_bh(&gc->lock);
-
-	if (atomic_dec_and_test(&t->uref) && t->resizing) {
-		pr_debug("Table destroy after resize by expire: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
-	}
+	next_run = IPSET_GC_PERIOD(set->timeout) * HZ;
+	if (next_run < HZ)
+		next_run = HZ;
 
-	queue_delayed_work(system_power_efficient_wq, &gc->dwork, next_run);
+	mtype_gc_do(set);
 
+	queue_delayed_work(system_power_efficient_wq, &gc->dwork, next_run);
 }
 
 static void
@@ -853,550 +647,270 @@ mtype_cancel_gc(struct ip_set *set)
 		disable_delayed_work_sync(&h->gc.dwork);
 }
 
-static int
-mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
-	  struct ip_set_ext *mext, u32 flags);
-static int
-mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
-	  struct ip_set_ext *mext, u32 flags);
+/* Get the current number of elements and per-element memory in the set */
+static void
+mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
+{
+	const struct htype *h = set->data;
+
+	/* Do GC to collect expired elements now so that the reported
+	 * element count doesn't include expired elements.
+	 */
+	if (SET_WITH_TIMEOUT(set))
+		mtype_gc_do(set);
+
+	*elements = ipset_hash_nelems(h);
+	*ext_size = *elements *
+		    (offsetof(struct mtype_rht_elem, elem) + set->dsize);
+}
 
-/* Resize a hash: create a new hash table with doubling the hashsize
- * and inserting the elements to it. Repeat until we succeed or
- * fail due to memory pressures.
+/* Add an element to a hash and update the internal counters when succeeded,
+ * otherwise report the proper error code.
  */
 static int
-mtype_resize(struct ip_set *set, bool retried)
+mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
+	  struct ip_set_ext *mext, u32 flags)
 {
+	bool flag_exist = flags & IPSET_FLAG_EXIST;
+	struct mtype_rht_elem *e, *old = NULL;
+	const struct mtype_elem *d = value;
 	struct htype *h = set->data;
-	struct htable *t, *orig;
-	u8 pos, htable_bits;
-	size_t hsize, dsize = set->dsize;
-#ifdef IP_SET_HASH_WITH_NETS
-	u8 flags;
-	struct mtype_elem *tmp;
-#endif
-	struct mtype_elem *data;
-	struct mtype_elem *d;
-	struct hbucket *n, *m;
-	struct list_head *l, *lt;
-	struct mtype_resize_ad *x;
-	u32 i, j, r, nr, key;
-	int ret;
-
+	int ret = 0;
 #ifdef IP_SET_HASH_WITH_NETS
-	tmp = kmalloc(dsize, GFP_KERNEL);
-	if (!tmp)
-		return -ENOMEM;
+	int i;
 #endif
-	orig = ipset_dereference_bh_nfnl(h->table);
-	htable_bits = orig->htable_bits;
 
-retry:
-	ret = 0;
-	htable_bits++;
-	if (!htable_bits)
-		goto hbwarn;
-	hsize = htable_size(htable_bits);
-	if (!hsize)
-		goto hbwarn;
-	t = ip_set_alloc(hsize);
-	if (!t) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	t->hregion = ip_set_alloc(ahash_sizeof_regions(htable_bits));
-	if (!t->hregion) {
-		ip_set_free(t);
-		ret = -ENOMEM;
-		goto out;
-	}
-	t->htable_bits = htable_bits;
-	t->maxelem = h->maxelem / ahash_numof_locks(htable_bits);
-	INIT_LIST_HEAD(&t->ad);
-	for (i = 0; i < ahash_numof_locks(htable_bits); i++)
-		spin_lock_init(&t->hregion[i].lock);
-
-	/* There can't be another parallel resizing,
-	 * but dumping and kernel side add/del are possible
-	 */
-	orig = ipset_dereference_bh_nfnl(h->table);
-	atomic_inc(&orig->uref);
-	spin_lock_bh(&h->gc.lock);
-	orig->resizing = true;
-	spin_unlock_bh(&h->gc.lock);
-	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
-		 set->name, orig->htable_bits, htable_bits, orig);
-	for (r = 0; r < ahash_numof_locks(orig->htable_bits); r++) {
-		/* Expire may replace a hbucket with another one */
-		rcu_read_lock_bh();
-		for (i = ahash_bucket_start(r, orig->htable_bits);
-		     i < ahash_bucket_end(r, orig->htable_bits); i++) {
-			n = __ipset_dereference(hbucket(orig, i));
-			if (!n)
+	rcu_read_lock_bh();
+#ifdef IP_SET_HASH_WITH_MULTI
+	{
+		struct rhlist_head *tmp, *list;
+		unsigned int seen = 0;
+		u32 multi = 0;
+
+		list = rhltable_lookup(&h->rhlt, d, mtype_rht_params);
+		if (!list)
+			goto insert;
+
+		rhl_for_each_entry_rcu(old, tmp, list, node) {
+			if (SET_ELEM_EXPIRED(set, &old->elem)) {
+				if (rhltable_remove(&h->rhlt, &old->node, mtype_rht_params) == 0)
+					ipset_hash_elem_destroy_free(set, h, old);
 				continue;
-			pos = smp_load_acquire(&n->pos);
-			for (j = 0; j < pos; j++) {
-				if (!test_bit_acquire(j, n->used))
-					continue;
-				data = ahash_data(n, j, dsize);
-				if (SET_ELEM_EXPIRED(set, data))
-					continue;
-#ifdef IP_SET_HASH_WITH_NETS
-				/* We have readers running parallel with us,
-				 * so the live data cannot be modified.
-				 */
-				flags = 0;
-				memcpy(tmp, data, dsize);
-				data = tmp;
-				mtype_data_reset_flags(data, &flags);
-#endif
-				key = HKEY(data, h->initval, htable_bits);
-				m = __ipset_dereference(hbucket(t, key));
-				nr = ahash_region(key);
-				if (!m) {
-					m = kzalloc(sizeof(*m) +
-					    AHASH_INIT_SIZE * dsize,
-					    GFP_ATOMIC);
-					if (!m) {
-						ret = -ENOMEM;
-						goto cleanup;
-					}
-					m->size = AHASH_INIT_SIZE;
-					t->hregion[nr].ext_size +=
-						ext_size(AHASH_INIT_SIZE,
-							 dsize);
-					RCU_INIT_POINTER(hbucket(t, key), m);
-				} else if (m->pos >= m->size) {
-					struct hbucket *ht;
-
-					if (m->size >= AHASH_MAX(h)) {
-						ret = -EAGAIN;
-					} else {
-						ht = kzalloc(sizeof(*ht) +
-						(m->size + AHASH_INIT_SIZE)
-						* dsize,
-						GFP_ATOMIC);
-						if (!ht)
-							ret = -ENOMEM;
-					}
-					if (ret < 0)
-						goto cleanup;
-					memcpy(ht, m, sizeof(struct hbucket) +
-					       m->size * dsize);
-					ht->size = m->size + AHASH_INIT_SIZE;
-					t->hregion[nr].ext_size +=
-						ext_size(AHASH_INIT_SIZE,
-							 dsize);
-					kfree(m);
-					m = ht;
-					RCU_INIT_POINTER(hbucket(t, key), ht);
-				}
-				d = ahash_data(m, m->pos, dsize);
-				memcpy(d, data, dsize);
-				set_bit(m->pos++, m->used);
-				t->hregion[nr].elements++;
-#ifdef IP_SET_HASH_WITH_NETS
-				mtype_data_reset_flags(d, &flags);
-#endif
 			}
-		}
-		rcu_read_unlock_bh();
-	}
-
-	/* There can't be any other writer. */
-	rcu_assign_pointer(h->table, t);
 
-	/* Give time to other readers of the set */
-	synchronize_rcu();
+			if (mtype_data_equal(&old->elem, d, &multi))
+				goto insert;
+			++seen;
+		}
 
-	pr_debug("set %s resized from %u (%p) to %u (%p)\n", set->name,
-		 orig->htable_bits, orig, t->htable_bits, t);
-	/* Add/delete elements processed by the SET target during resize.
-	 * Kernel-side add cannot trigger a resize and userspace actions
-	 * are serialized by the mutex.
-	 */
-	list_for_each_safe(l, lt, &orig->ad) {
-		x = list_entry(l, struct mtype_resize_ad, list);
-		if (x->ad == IPSET_ADD) {
-			mtype_add(set, &x->d, &x->ext, &x->mext, x->flags);
-		} else {
-			mtype_del(set, &x->d, NULL, NULL, 0);
+		if (seen >= RHL_MAX_CHAINLEN) {
+			ret = -IPSET_ERR_HASH_FULL;
+			goto out_rcu_unlock;
 		}
-		list_del(l);
-		kfree(l);
+		old = NULL;
 	}
-	/* If there's nobody else using the table, destroy it */
-	if (atomic_dec_and_test(&orig->uref)) {
-		pr_debug("Table destroy by resize %p\n", orig);
-		mtype_ahash_destroy(set, orig, false);
+#else
+	old = rhashtable_lookup(&h->ht, d, mtype_rht_params);
+	if (!old)
+		goto insert;
+	/* simple case 1: element is expired, same as old == NULL. */
+	if (SET_ELEM_EXPIRED(set, &old->elem)) {
+		if (rhashtable_remove_fast(&h->ht, &old->node,
+					   mtype_rht_params) == 0)
+			ipset_hash_elem_destroy_free(set, h, old);
+		old = NULL;
 	}
-
-out:
-#ifdef IP_SET_HASH_WITH_NETS
-	kfree(tmp);
 #endif
-	return ret;
+insert:
+	/* simple case 2: exists and we are not replacing.
+	 * Can't do in-place extension updates, this can race with GC
+	 * and mtype_del(): could end up adding new comment to an
+	 * element that had kfree_rcu() called on it.
+	 */
+	if (old && !flag_exist) {
+		ret = -IPSET_ERR_EXIST;
+		goto out_rcu_unlock;
+	}
 
-cleanup:
-	rcu_read_unlock_bh();
-	spin_lock_bh(&h->gc.lock);
-	orig->resizing = false;
-	spin_unlock_bh(&h->gc.lock);
-	/* Make sure parallel readers see that orig->resizing is false
-	 * before we decrement uref */
-	synchronize_rcu();
-	atomic_dec(&orig->uref);
-	mtype_ahash_destroy(set, t, false);
-	if (ret == -EAGAIN)
-		goto retry;
+	if (!old && ipset_hash_nelems(h) >= h->maxelem) {
+		if (net_ratelimit())
+			pr_warn("Set %s is full, maxelem %u reached\n",
+				set->name, h->maxelem);
+		ret = -IPSET_ERR_HASH_FULL;
+		goto out_rcu_unlock;
+	}
 
-	/* Cleanup the backlog of ADD/DEL elements */
-	spin_lock_bh(&set->lock);
-	list_for_each_safe(l, lt, &orig->ad) {
-		list_del(l);
-		kfree(l);
+	e = kzalloc(offsetof(struct mtype_rht_elem, elem) + set->dsize,
+		    GFP_ATOMIC);
+	if (!e) {
+		ret = -ENOMEM;
+		goto out_rcu_unlock;
 	}
-	spin_unlock_bh(&set->lock);
-	goto out;
 
-hbwarn:
-	/* In case we have plenty of memory :-) */
-	pr_warn("Cannot increase the hashsize of set %s further\n", set->name);
-	ret = -IPSET_ERR_HASH_FULL;
-	goto out;
-}
+	memcpy(&e->elem, d, sizeof(struct mtype_elem));
 
-/* Get the current number of elements and ext_size in the set  */
-static void
-mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
-{
-	struct htype *h = set->data;
-	const struct htable *t;
-	struct hbucket *n;
-	struct mtype_elem *data;
-	u32 i, j, r;
-	u8 pos;
-
-	t = rcu_dereference_bh(h->table);
-	for (r = 0; r < ahash_numof_locks(t->htable_bits); r++) {
-		for (i = ahash_bucket_start(r, t->htable_bits);
-		     i < ahash_bucket_end(r, t->htable_bits); i++) {
-			n = rcu_dereference_bh(hbucket(t, i));
-			if (!n)
-				continue;
-			pos = smp_load_acquire(&n->pos);
-			for (j = 0; j < pos; j++) {
-				if (!test_bit_acquire(j, n->used))
-					continue;
-				data = ahash_data(n, j, set->dsize);
-				if (!SET_ELEM_EXPIRED(set, data))
-					(*elements)++;
+#ifdef IP_SET_HASH_WITH_NETS
+	for (i = 0; i < IPSET_NET_COUNT; i++) {
+		ret = mtype_add_cidr(set, h, DCIDR_GET(d->cidr, i), i);
+		if (ret) {
+			while (i > 0) {
+				--i;
+				mtype_del_cidr(set, h, DCIDR_GET(d->cidr, i), i);
 			}
+			kfree(e);
+			goto out_rcu_unlock;
 		}
-		*ext_size += t->hregion[r].ext_size;
 	}
-}
 
-/* Add an element to a hash and update the internal counters when succeeded,
- * otherwise report the proper error code.
- */
-static int
-mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
-	  struct ip_set_ext *mext, u32 flags)
-{
-	struct htype *h = set->data;
-	struct htable *t;
-	const struct mtype_elem *d = value;
-	struct mtype_elem *data;
-	struct hbucket *n, *old = ERR_PTR(-ENOENT);
-	int i, j = -1, ret;
-	bool flag_exist = flags & IPSET_FLAG_EXIST;
-	bool deleted = false, forceadd = false, reuse = false;
-	u32 r, key, multi = 0, elements, maxelem;
-	u8 npos = 0;
+	mtype_data_set_flags(&e->elem, flags);
+#endif
+	if (SET_WITH_COUNTER(set))
+		ip_set_init_counter(ext_counter(&e->elem, set), ext);
+	if (SET_WITH_COMMENT(set) && !ext->target)
+		ip_set_init_comment(set, ext_comment(&e->elem, set), ext);
+	if (SET_WITH_SKBINFO(set))
+		ip_set_init_skbinfo(ext_skbinfo(&e->elem, set), ext);
+	if (SET_WITH_TIMEOUT(set))
+		ip_set_timeout_set(ext_timeout(&e->elem, set), ext->timeout);
 
-	rcu_read_lock_bh();
-	t = rcu_dereference_bh(h->table);
-	key = HKEY(value, h->initval, t->htable_bits);
-	r = ahash_region(key);
-	atomic_inc(&t->uref);
-	rcu_read_unlock_bh();
-	elements = t->hregion[r].elements;
-	maxelem = t->maxelem;
-	if (elements >= maxelem) {
-		u32 e;
-		if (SET_WITH_TIMEOUT(set))
-			mtype_gc_do(set, h, t, r);
-		maxelem = h->maxelem;
-		elements = 0;
-		for (e = 0; e < ahash_numof_locks(t->htable_bits); e++)
-			elements += t->hregion[e].elements;
-		if (elements >= maxelem && SET_WITH_FORCEADD(set))
-			forceadd = true;
-	}
+#ifdef IP_SET_HASH_WITH_MULTI
+	spin_lock_bh(&set->lock);
+	ret = rhltable_insert_key(&h->rhlt, &e->elem, &e->node, mtype_rht_params);
+	if (ret == 0) {
+		struct rhlist_head *list;
+
+		/* rhltable_remove can fail here in case of parallel GC: harmless. */
+		if (old && rhltable_remove(&h->rhlt, &old->node, mtype_rht_params) != 0)
+			old = NULL;
+
+		list = rhltable_lookup(&h->rhlt, d, mtype_rht_params);
+		if (list) {
+			const struct mtype_rht_elem *dup;
+			struct rhlist_head *tmp;
+			u32 multi = 0;
+
+			rhl_for_each_entry_rcu(dup, tmp, list, node) {
+				if (dup == e || !mtype_data_equal(&dup->elem, d, &multi))
+					continue;
 
-	spin_lock_bh(&t->hregion[r].lock);
-	n = rcu_dereference_bh(hbucket(t, key));
-	if (!n) {
-		if (forceadd || elements >= maxelem)
-			goto set_full;
-		old = NULL;
-		n = kzalloc(sizeof(*n) + AHASH_INIT_SIZE * set->dsize,
-			    GFP_ATOMIC);
-		if (!n) {
-			ret = -ENOMEM;
-			goto unlock;
-		}
-		n->size = AHASH_INIT_SIZE;
-		t->hregion[r].ext_size +=
-			ext_size(AHASH_INIT_SIZE, set->dsize);
-		goto copy_elem;
-	}
-	npos = smp_load_acquire(&n->pos);
-	for (i = 0; i < npos; i++) {
-		if (!test_bit(i, n->used)) {
-			/* Reuse first deleted entry */
-			if (j == -1) {
-				deleted = reuse = true;
-				j = i;
-			}
-			continue;
-		}
-		data = ahash_data(n, i, set->dsize);
-		if (mtype_data_equal(data, d, &multi)) {
-			if (flag_exist || SET_ELEM_EXPIRED(set, data)) {
-				/* Just the extensions could be overwritten */
-				j = i;
-				goto overwrite_extensions;
+				/* check for duplicate key insertion: unlikely,
+				 * but several CPUs can race to insert same key
+				 * with same interface. We inserted e, but dup
+				 * has same content: remove e again.
+				 */
+				if (rhltable_remove(&h->rhlt, &e->node, mtype_rht_params) == 0) {
+					spin_unlock_bh(&set->lock);
+					if (old) {
+						ipset_hash_elem_destroy_free(set, h, old);
+						old = NULL;
+					}
+					ret = -EEXIST;
+					goto out_duplicate;
+				}
 			}
-			ret = -IPSET_ERR_EXIST;
-			goto unlock;
-		}
-		/* Reuse first timed out entry */
-		if (SET_ELEM_EXPIRED(set, data) && j == -1) {
-			j = i;
-			reuse = true;
 		}
 	}
-	if (reuse || forceadd) {
-		if (j == -1)
-			j = 0;
-		data = ahash_data(n, j, set->dsize);
-		if (!deleted) {
-			mtype_del_cidr_all(set, h, data);
-			ip_set_ext_destroy(set, data);
-			t->hregion[r].elements--;
-		}
-		goto copy_data;
+	spin_unlock_bh(&set->lock);
+out_duplicate:
+#else
+	if (old)
+		ret = rhashtable_replace_fast(&h->ht, &old->node, &e->node, mtype_rht_params);
+	else
+		ret = rhashtable_lookup_insert_key(&h->ht, d, &e->node, mtype_rht_params);
+
+	if (ret == -ENOENT && old) {
+		/* replace failed: maybe GC or concurrent mtype_del()
+		 * reaped old element right now.
+		 *
+		 * Try once more with plain insert.
+		 */
+		old = NULL;
+		ret = rhashtable_lookup_insert_key(&h->ht, d, &e->node, mtype_rht_params);
 	}
-	if (elements >= maxelem)
-		goto set_full;
-	/* Create a new slot */
-	if (npos >= n->size) {
-#ifdef IP_SET_HASH_WITH_MULTI
-		if (h->bucketsize >= AHASH_MAX_TUNED)
-			goto set_full;
-		else if (h->bucketsize <= multi)
-			h->bucketsize += AHASH_INIT_SIZE;
 #endif
-		if (n->size >= AHASH_MAX(h)) {
-			/* Trigger rehashing */
-			mtype_data_next(&h->next, d);
-			ret = -EAGAIN;
-			goto resize;
-		}
-		old = n;
-		n = kzalloc(sizeof(*n) +
-			    (old->size + AHASH_INIT_SIZE) * set->dsize,
-			    GFP_ATOMIC);
-		if (!n) {
-			ret = -ENOMEM;
-			goto unlock;
+	if (ret) {
+		ip_set_ext_destroy(set, &e->elem);
+		kfree_rcu(e, rcu);
+		/* error: Undo mtype_add_cidr(). */
+		mtype_del_cidr_all(set, h, d);
+	} else if (old) {
+		/* Update the new elements counters with the replaced one,
+		 * unless userspace gave specific start values. old has
+		 * been unlinked from table, but is still visible to other
+		 * CPUs, so this is best-effort only.
+		 */
+		if (ext->packets == ULLONG_MAX &&
+		    SET_WITH_COUNTER(set) &&
+		    !SET_ELEM_EXPIRED(set, &old->elem)) {
+			const struct ip_set_counter *old_c = ext_counter(&old->elem, set);
+			struct ip_set_counter *new_c = ext_counter(&e->elem, set);
+
+			atomic64_add(atomic64_read(&old_c->bytes), &new_c->bytes);
+			atomic64_add(atomic64_read(&old_c->packets), &new_c->packets);
 		}
-		memcpy(n, old, sizeof(struct hbucket) +
-		       old->size * set->dsize);
-		n->size = old->size + AHASH_INIT_SIZE;
-		t->hregion[r].ext_size +=
-			ext_size(AHASH_INIT_SIZE, set->dsize);
+		ip_set_ext_destroy(set, &old->elem);
+		kfree_rcu(old, rcu);
+		/* successful replace: Undo mtype_add_cidr(). */
+		mtype_del_cidr_all(set, h, d);
 	}
 
-copy_elem:
-	j = npos++;
-	data = ahash_data(n, j, set->dsize);
-copy_data:
-	t->hregion[r].elements++;
-#ifdef IP_SET_HASH_WITH_NETS
-	for (i = 0; i < IPSET_NET_COUNT; i++)
-		mtype_add_cidr(set, h, DCIDR_GET(d->cidr, i), i);
-#endif
-	memcpy(data, d, sizeof(struct mtype_elem));
-overwrite_extensions:
-#ifdef IP_SET_HASH_WITH_NETS
-	mtype_data_set_flags(data, flags);
-#endif
-	if (SET_WITH_COUNTER(set))
-		ip_set_init_counter(ext_counter(data, set), ext);
-	if (SET_WITH_COMMENT(set) && !ext->target)
-		ip_set_init_comment(set, ext_comment(data, set), ext);
-	if (SET_WITH_SKBINFO(set))
-		ip_set_init_skbinfo(ext_skbinfo(data, set), ext);
-	/* Must come last for the case when timed out entry is reused */
-	if (SET_WITH_TIMEOUT(set))
-		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
-	smp_mb__before_atomic();
-	/* Ensure all data writes are visible before updating position */
-	smp_store_release(&n->pos, npos);
-	set_bit(j, n->used);
-	if (old != ERR_PTR(-ENOENT)) {
-		rcu_assign_pointer(hbucket(t, key), n);
-		if (old)
-			kfree_rcu(old, rcu);
-	}
-	ret = 0;
-resize:
-	spin_unlock_bh(&t->hregion[r].lock);
-	if (t->resizing && ext && ext->target) {
-		/* Resize is in process and kernel side add, save values */
-		struct mtype_resize_ad *x;
-
-		x = kzalloc_obj(struct mtype_resize_ad, GFP_ATOMIC);
-		if (!x)
-			/* Don't bother */
-			goto out;
-		x->ad = IPSET_ADD;
-		memcpy(&x->d, value, sizeof(struct mtype_elem));
-		memcpy(&x->ext, ext, sizeof(struct ip_set_ext));
-		memcpy(&x->mext, mext, sizeof(struct ip_set_ext));
-		x->flags = flags;
-		spin_lock_bh(&set->lock);
-		list_add_tail(&x->list, &t->ad);
-		spin_unlock_bh(&set->lock);
-	}
-	goto out;
+	if (ret == -EEXIST)
+		ret = flag_exist ? 0 : -IPSET_ERR_EXIST;
 
-set_full:
-	if (net_ratelimit())
-		pr_warn("Set %s is full, maxelem %u reached\n",
-			set->name, maxelem);
-	ret = -IPSET_ERR_HASH_FULL;
-unlock:
-	spin_unlock_bh(&t->hregion[r].lock);
-out:
-	if (atomic_dec_and_test(&t->uref) && t->resizing) {
-		pr_debug("Table destroy after resize by add: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
-	}
+	if (0)	/* to be removed */
+		mtype_data_next(&h->next, d);
+out_rcu_unlock:
+	rcu_read_unlock_bh();
 	return ret;
 }
 
-/* Delete an element from the hash and free up space if possible.
- */
+/* Delete an element from the hash */
 static int
 mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	  struct ip_set_ext *mext, u32 flags)
 {
 	struct htype *h = set->data;
-	struct htable *t;
 	const struct mtype_elem *d = value;
-	struct mtype_elem *data;
-	struct hbucket *n;
-	struct mtype_resize_ad *x = NULL;
-	int i, j, k, r, ret = -IPSET_ERR_EXIST;
-	u32 key, multi = 0;
-	size_t dsize = set->dsize;
-	u8 pos;
-
-	/* Userspace add and resize is excluded by the mutex.
-	 * Kernespace add does not trigger resize.
-	 */
-	rcu_read_lock_bh();
-	t = rcu_dereference_bh(h->table);
-	key = HKEY(value, h->initval, t->htable_bits);
-	r = ahash_region(key);
-	atomic_inc(&t->uref);
-	rcu_read_unlock_bh();
+	struct mtype_rht_elem *e;
+	int ret = -IPSET_ERR_EXIST;
 
-	spin_lock_bh(&t->hregion[r].lock);
-	n = rcu_dereference_bh(hbucket(t, key));
-	if (!n)
-		goto out;
-	pos = smp_load_acquire(&n->pos);
-	for (i = 0, k = 0; i < pos; i++) {
-		if (!test_bit(i, n->used)) {
-			k++;
-			continue;
-		}
-		data = ahash_data(n, i, dsize);
-		if (!mtype_data_equal(data, d, &multi))
-			continue;
-		if (SET_ELEM_EXPIRED(set, data))
-			goto out;
-
-		ret = 0;
-		clear_bit(i, n->used);
-		smp_mb__after_atomic();
-		if (i + 1 == pos)
-			smp_store_release(&n->pos, --pos);
-		t->hregion[r].elements--;
-		mtype_del_cidr_all(set, h, d);
-		ip_set_ext_destroy(set, data);
-
-		if (t->resizing && ext && ext->target) {
-			/* Resize is in process and kernel side del,
-			 * save values
-			 */
-			x = kzalloc_obj(struct mtype_resize_ad, GFP_ATOMIC);
-			if (x) {
-				x->ad = IPSET_DEL;
-				memcpy(&x->d, value,
-				       sizeof(struct mtype_elem));
-				x->flags = flags;
-			}
-		}
-		for (; i < pos; i++) {
-			if (!test_bit(i, n->used))
-				k++;
-		}
-		if (k == pos) {
-			t->hregion[r].ext_size -= ext_size(n->size, dsize);
-			rcu_assign_pointer(hbucket(t, key), NULL);
-			kfree_rcu(n, rcu);
-		} else if (k >= AHASH_INIT_SIZE) {
-			struct hbucket *tmp = kzalloc(sizeof(*tmp) +
-					(n->size - AHASH_INIT_SIZE) * dsize,
-					GFP_ATOMIC);
-			if (!tmp)
-				goto out;
-			tmp->size = n->size - AHASH_INIT_SIZE;
-			for (j = 0, k = 0; j < pos; j++) {
-				if (!test_bit(j, n->used))
-					continue;
-				data = ahash_data(n, j, dsize);
-				memcpy(tmp->value + k * dsize, data, dsize);
-				set_bit(k, tmp->used);
-				k++;
-			}
-			tmp->pos = k;
-			t->hregion[r].ext_size -=
-				ext_size(AHASH_INIT_SIZE, dsize);
-			rcu_assign_pointer(hbucket(t, key), tmp);
-			kfree_rcu(n, rcu);
+	rcu_read_lock_bh();
+#ifdef IP_SET_HASH_WITH_MULTI
+	{
+		struct rhlist_head *tmp, *list;
+		u32 multi = 0;
+
+		list = rhltable_lookup(&h->rhlt, d, mtype_rht_params);
+		if (!list)
+			goto out_unlock;
+		rhl_for_each_entry_rcu(e, tmp, list, node) {
+			if (!mtype_data_equal(&e->elem, d, &multi))
+				continue;
+			if (SET_ELEM_EXPIRED(set, &e->elem))
+				goto out_unlock;
+			/* fails if GC evicts this entry right now. */
+			ret = rhltable_remove(&h->rhlt, &e->node, mtype_rht_params);
+			break;
 		}
-		goto out;
-	}
 
-out:
-	spin_unlock_bh(&t->hregion[r].lock);
-	if (x) {
-		spin_lock_bh(&set->lock);
-		list_add(&x->list, &t->ad);
-		spin_unlock_bh(&set->lock);
+		/* either no entry found or race with GC */
+		if (ret)
+			goto out_unlock;
 	}
-	if (atomic_dec_and_test(&t->uref) && t->resizing) {
-		pr_debug("Table destroy after resize by del: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
-	}
-	return ret;
+#else
+	e = rhashtable_lookup(&h->ht, d, mtype_rht_params);
+	if (!e || SET_ELEM_EXPIRED(set, &e->elem))
+		goto out_unlock;
+	ret = rhashtable_remove_fast(&h->ht, &e->node, mtype_rht_params);
+	if (ret)
+		goto out_unlock;
+#endif
+	mtype_del_cidr_all(set, h, d);
+	ip_set_ext_destroy(set, &e->elem);
+	kfree_rcu(e, rcu);
+out_unlock:
+	rcu_read_unlock_bh();
+	return ret ? -IPSET_ERR_EXIST : 0;
 }
 
 static int
@@ -1419,30 +933,26 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 		 struct ip_set_ext *mext, u32 flags)
 {
 	struct htype *h = set->data;
-	struct htable *t = rcu_dereference_bh(h->table);
 	struct net_prefixes *nets0;
-	struct hbucket *n;
-	struct mtype_elem *data;
+	struct mtype_rht_elem *e;
 #if IPSET_NET_COUNT == 2
 	struct net_prefixes *nets1;
 	struct mtype_elem orig = *d;
 	unsigned int seq1;
-	int ret, i, j, k;
+	int ret, j, k;
 #else
-	int ret, i, j;
+	int ret, j;
 #endif
 	unsigned int seq0;
-	u32 key, multi;
-	u8 pos;
+	u32 multi;
 
 	pr_debug("test by nets\n");
-	rcu_read_lock_bh();
 retry:
 	multi = 0;
-	nets0 = rcu_dereference_bh(h->rnets[0]);
+	nets0 = ipset_dereference_bh_nfnl(h->rnets[0]);
 	seq0 = read_seqcount_begin(&nets0->seq);
 #if IPSET_NET_COUNT == 2
-	nets1 = rcu_dereference_bh(h->rnets[1]);
+	nets1 = ipset_dereference_bh_nfnl(h->rnets[1]);
 	seq1 = read_seqcount_begin(&nets1->seq);
 #endif
 	for (j = 0; j < nets0->len && !multi; j++) {
@@ -1462,38 +972,48 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 #else
 		mtype_data_netmask(d, p0.cidr);
 #endif
-		key = HKEY(d, h->initval, t->htable_bits);
-		n = rcu_dereference_bh(hbucket(t, key));
-		if (!n)
+#ifdef IP_SET_HASH_WITH_MULTI
+		{
+		struct rhlist_head *tmp, *list;
+
+		list = rhltable_lookup(&h->rhlt, d, mtype_rht_params);
+		if (!list)
 			continue;
-		pos = smp_load_acquire(&n->pos);
-		for (i = 0; i < pos; i++) {
-			if (!test_bit_acquire(i, n->used))
-				continue;
-			data = ahash_data(n, i, set->dsize);
-			if (!mtype_data_equal(data, d, &multi))
+
+		rhl_for_each_entry_rcu(e, tmp, list, node) {
+			if (!SET_ELEM_EXPIRED(set, &e->elem))
+				multi = true;
+			if (!mtype_data_equal(&e->elem, d, &multi))
 				continue;
-			ret = mtype_data_match(data, ext, mext, set, flags);
+			ret = mtype_data_match(&e->elem, ext, mext, set, flags);
+			if (ret)
+				goto check_retry;
+			multi = false;
+		}
+		}
+#else
+		e = rhashtable_lookup(&h->ht, d, mtype_rht_params);
+		if (e) {
+			if (!SET_ELEM_EXPIRED(set, &e->elem))
+				multi = true;
+			ret = mtype_data_match(&e->elem, ext, mext, set, flags);
 			if (ret != 0)
-				goto unlock;
-#ifdef IP_SET_HASH_WITH_MULTI
-			/* No match, reset multiple match flag */
-			multi = 0;
-#endif
+				goto check_retry;
+			multi = false;
 		}
+#endif
 #if IPSET_NET_COUNT == 2
 		}
 #endif
 	}
 	ret = 0;
-unlock:
+check_retry:
 	if (read_seqcount_retry(&nets0->seq, seq0))
 		goto retry;
 #if IPSET_NET_COUNT == 2
 	if (read_seqcount_retry(&nets1->seq, seq1))
 		goto retry;
 #endif
-	rcu_read_unlock_bh();
 	return ret;
 }
 #endif
@@ -1504,16 +1024,14 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	   struct ip_set_ext *mext, u32 flags)
 {
 	struct htype *h = set->data;
-	struct htable *t;
 	struct mtype_elem *d = value;
-	struct hbucket *n;
-	struct mtype_elem *data;
-	int i, ret = 0;
-	u32 key, multi = 0;
-	u8 pos;
+	struct mtype_rht_elem *e;
+	int ret = 0;
+#ifdef IP_SET_HASH_WITH_NETS
+	int i;
+#endif
 
 	rcu_read_lock_bh();
-	t = rcu_dereference_bh(h->table);
 #ifdef IP_SET_HASH_WITH_NETS
 	/* If we test an IP address and not a network address,
 	 * try all possible network sizes
@@ -1527,68 +1045,53 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 #endif
 
-	key = HKEY(d, h->initval, t->htable_bits);
-	n = rcu_dereference_bh(hbucket(t, key));
-	if (!n) {
-		ret = 0;
-		goto out;
-	}
-	pos = smp_load_acquire(&n->pos);
-	for (i = 0; i < pos; i++) {
-		if (!test_bit_acquire(i, n->used))
-			continue;
-		data = ahash_data(n, i, set->dsize);
-		if (!mtype_data_equal(data, d, &multi))
-			continue;
-		ret = mtype_data_match(data, ext, mext, set, flags);
-		if (ret != 0)
+#ifdef IP_SET_HASH_WITH_MULTI
+	{
+		struct rhlist_head *tmp, *list;
+		u32 multi = 0;
+
+		list = rhltable_lookup(&h->rhlt, d, mtype_rht_params);
+		if (!list)
 			goto out;
+
+		rhl_for_each_entry_rcu(e, tmp, list, node) {
+			if (!mtype_data_equal(&e->elem, d, &multi))
+				continue;
+			ret = mtype_data_match(&e->elem, ext, mext, set, flags);
+			if (ret)
+				goto out;
+		}
 	}
+#else
+	e = rhashtable_lookup(&h->ht, d, mtype_rht_params);
+	if (!e)
+		goto out;
+
+	ret = mtype_data_match(&e->elem, ext, mext, set, flags);
+#endif
 out:
 	rcu_read_unlock_bh();
 	return ret;
 }
 
-static u32 mtype_hash_size(const struct htype *h)
-{
-	const struct htable *t;
-	u8 htable_bits;
-
-	rcu_read_lock();
-	t = rcu_dereference(h->table);
-	htable_bits = t->htable_bits;
-	rcu_read_unlock();
-
-	return jhash_size(htable_bits);
-}
-
-static u32 mtype_bucket_size(const struct htype *h)
-{
-	return h->bucketsize;
-}
-
 /* Reply a HEADER request: fill out the header part of the set */
 static int
 mtype_head(struct ip_set *set, struct sk_buff *skb)
 {
 	struct htype *h = set->data;
-	const struct htable *t;
 	struct nlattr *nested;
 	size_t memsize;
 	u32 elements = 0;
 	size_t ext_size = 0;
 
-	rcu_read_lock_bh();
-	t = rcu_dereference_bh(h->table);
-	mtype_ext_size(set, &elements, &ext_size);
-	memsize = mtype_ahash_memsize(h, t) + ext_size + atomic64_read(&set->ext_size);
-	rcu_read_unlock_bh();
+	mtype_rht_size(set, &elements, &ext_size);
+	memsize = sizeof(*h) + ext_size + atomic64_read(&set->ext_size);
 
 	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
 		goto nla_put_failure;
 
-	if (nla_put_net32(skb, IPSET_ATTR_HASHSIZE, htonl(mtype_hash_size(h))))
+	if (nla_put_net32(skb, IPSET_ATTR_HASHSIZE, htonl(jhash_size(h->htable_bits))))
 		goto nla_put_failure;
 	if (nla_put_net32(skb, IPSET_ATTR_MAXELEM, htonl(h->maxelem)))
 		goto nla_put_failure;
@@ -1614,7 +1117,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 		goto nla_put_failure;
 #endif
 	if (set->flags & IPSET_CREATE_FLAG_BUCKETSIZE) {
-		if (nla_put_u8(skb, IPSET_ATTR_BUCKETSIZE, mtype_bucket_size(h)))
+		if (nla_put_u8(skb, IPSET_ATTR_BUCKETSIZE, h->bucketsize))
 			goto nla_put_failure;
 		if (nla_put_net32(skb, IPSET_ATTR_INITVAL, htonl(h->initval)))
 			goto nla_put_failure;
@@ -1632,25 +1135,23 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	return -EMSGSIZE;
 }
 
-/* Make possible to run dumping parallel with resizing */
+/* Manage the rhashtable_iter lifetime for dump operations */
 static void
 mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
 {
 	struct htype *h = set->data;
-	struct htable *t;
+	struct rhashtable_iter *hti;
 
 	if (start) {
-		rcu_read_lock_bh();
-		t = ipset_dereference_bh_nfnl(h->table);
-		atomic_inc(&t->uref);
-		cb->args[IPSET_CB_PRIVATE] = (unsigned long)t;
-		rcu_read_unlock_bh();
-	} else if (cb->args[IPSET_CB_PRIVATE]) {
-		t = (struct htable *)cb->args[IPSET_CB_PRIVATE];
-		if (atomic_dec_and_test(&t->uref) && t->resizing) {
-			pr_debug("Table destroy after resize "
-				 " by dump: %p\n", t);
-			mtype_ahash_destroy(set, t, false);
+		hti = kmalloc_obj(*hti, GFP_ATOMIC);
+		if (hti)
+			ipset_hash_walk_enter(h, hti);
+		cb->args[IPSET_CB_PRIVATE] = (unsigned long)hti;
+	} else {
+		hti = (struct rhashtable_iter *)cb->args[IPSET_CB_PRIVATE];
+		if (hti) {
+			rhashtable_walk_exit(hti);
+			kfree(hti);
 		}
 		cb->args[IPSET_CB_PRIVATE] = 0;
 	}
@@ -1661,77 +1162,77 @@ static int
 mtype_list(const struct ip_set *set,
 	   struct sk_buff *skb, struct netlink_callback *cb)
 {
-	const struct htable *t;
+	struct rhashtable_iter *hti =
+		(struct rhashtable_iter *)cb->args[IPSET_CB_PRIVATE];
+	struct mtype_rht_elem *e, *peeked;
 	struct nlattr *atd, *nested;
-	const struct hbucket *n;
-	const struct mtype_elem *e;
-	u32 first = cb->args[IPSET_CB_ARG0];
-	/* We assume that one hash bucket fills into one page */
 	void *incomplete;
-	int i, ret = 0;
-	u8 pos;
+	u32 emitted = 0;
+	int ret = 0;
+
+	if (!hti)
+		return -EMSGSIZE;
 
 	atd = nla_nest_start(skb, IPSET_ATTR_ADT);
 	if (!atd)
 		return -EMSGSIZE;
 
-	pr_debug("list hash set %s\n", set->name);
-	t = (const struct htable *)cb->args[IPSET_CB_PRIVATE];
-	/* Expire may replace a hbucket with another one */
-	rcu_read_lock();
-	for (; cb->args[IPSET_CB_ARG0] < jhash_size(t->htable_bits);
-	     cb->args[IPSET_CB_ARG0]++) {
-		cond_resched_rcu();
-		incomplete = skb_tail_pointer(skb);
-		n = rcu_dereference(hbucket(t, cb->args[IPSET_CB_ARG0]));
-		pr_debug("cb->arg bucket: %lu, t %p n %p\n",
-			 cb->args[IPSET_CB_ARG0], t, n);
-		if (!n)
-			continue;
-		pos = smp_load_acquire(&n->pos);
-		for (i = 0; i < pos; i++) {
-			if (!test_bit_acquire(i, n->used))
-				continue;
-			e = ahash_data(n, i, set->dsize);
-			if (SET_ELEM_EXPIRED(set, e))
+	rhashtable_walk_start(hti);
+	while ((e = rhashtable_walk_peek(hti))) {
+		if (IS_ERR(e)) {
+			if (PTR_ERR(e) == -EAGAIN)
 				continue;
-			pr_debug("list hash %lu hbucket %p i %u, data %p\n",
-				 cb->args[IPSET_CB_ARG0], n, i, e);
-			nested = nla_nest_start(skb, IPSET_ATTR_DATA);
-			if (!nested) {
-				if (cb->args[IPSET_CB_ARG0] == first) {
-					nla_nest_cancel(skb, atd);
-					ret = -EMSGSIZE;
-					goto out;
-				}
-				goto nla_put_failure;
-			}
-			if (mtype_data_list(skb, e))
-				goto nla_put_failure;
-			if (ip_set_put_extensions(skb, set, e, true))
-				goto nla_put_failure;
-			nla_nest_end(skb, nested);
+			ret = PTR_ERR(e);
+			break;
+		}
+		peeked = e;
+next_dump:
+		if (SET_ELEM_EXPIRED(set, &e->elem))
+			goto next_entry;
+
+		incomplete = skb_tail_pointer(skb);
+		nested = nla_nest_start(skb, IPSET_ATTR_DATA);
+		if (!nested) {
+			nlmsg_trim(skb, incomplete);
+			goto paused;
+		}
+		if (mtype_data_list(skb, &e->elem) ||
+		    ip_set_put_extensions(skb, set, &e->elem, true)) {
+			nla_nest_cancel(skb, nested);
+			nlmsg_trim(skb, incomplete);
+			goto paused;
+		}
+		nla_nest_end(skb, nested);
+		emitted++;
+next_entry:
+		e = rhashtable_walk_next(hti);
+		if (IS_ERR(e)) {
+			ret = PTR_ERR(e);
+			if (ret != -EAGAIN)
+				break;
+			ret = 0;
+		} else if (peeked && e != peeked) {
+			peeked = NULL;
+			if (e)
+				goto next_dump;
 		}
 	}
+	/* Walk exhausted: listing done */
 	nla_nest_end(skb, atd);
-	/* Set listing finished */
+	rhashtable_walk_stop(hti);
 	cb->args[IPSET_CB_ARG0] = 0;
+	return ret;
 
-	goto out;
-
-nla_put_failure:
-	nlmsg_trim(skb, incomplete);
-	if (unlikely(first == cb->args[IPSET_CB_ARG0])) {
-		pr_warn("Can't list set %s: one bucket does not fit into a message. Please report it!\n",
-			set->name);
-		cb->args[IPSET_CB_ARG0] = 0;
-		ret = -EMSGSIZE;
-	} else {
-		nla_nest_end(skb, atd);
+paused:
+	if (emitted == 0) {
+		nla_nest_cancel(skb, atd);
+		rhashtable_walk_stop(hti);
+		return -EMSGSIZE;
 	}
-out:
-	rcu_read_unlock();
-	return ret;
+	cb->args[IPSET_CB_ARG0] = 1;
+	nla_nest_end(skb, atd);
+	rhashtable_walk_stop(hti);
+	return 0;
 }
 
 static int
@@ -1757,7 +1258,7 @@ static const struct ip_set_type_variant mtype_variant = {
 	.head	= mtype_head,
 	.list	= mtype_list,
 	.uref	= mtype_uref,
-	.resize	= mtype_resize,
+	.resize	= NULL,
 	.same_set = mtype_same_set,
 	.cancel_gc = mtype_cancel_gc,
 	.region_lock = true,
@@ -1768,12 +1269,11 @@ static int
 IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 			    struct nlattr *tb[], u32 flags)
 {
-	struct rhashtable_params params;
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
+	struct rhashtable_params params;
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	u32 markmask;
 #endif
-	u8 hbits;
 #if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
 	int ret __attribute__((unused)) = 0;
 	u8 netmask = set->family == NFPROTO_IPV4 ? 32 : 128;
@@ -1781,12 +1281,11 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #endif
 #ifdef IP_SET_HASH_WITH_NETS
 	struct net_prefixes *nets;
+	int i;
 #endif
 	size_t hsize;
 	struct htype *h;
-	struct htable *t;
 	int err;
-	u32 i;
 
 	pr_debug("Create set %s with family %s\n",
 		 set->name, set->family == NFPROTO_IPV4 ? "inet" : "inet6");
@@ -1857,7 +1356,12 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #endif
 
 	if (tb[IPSET_ATTR_HASHSIZE]) {
+		/* Not used anymore, just for backwards compat, old hash
+		 * implementation used to -ENOMEM on too large hashsize.
+		 */
 		hashsize = ip_set_get_h32(tb[IPSET_ATTR_HASHSIZE]);
+		if (hashsize > INT_MAX)
+			return -ENOMEM;
 		if (hashsize < IPSET_MIMINAL_HASHSIZE)
 			hashsize = IPSET_MIMINAL_HASHSIZE;
 	}
@@ -1892,36 +1396,19 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	if (err)
 		goto free_h;
 
-	/* Compute htable_bits from the user input parameter hashsize.
-	 * Assume that hashsize == 2^htable_bits,
-	 * otherwise round up to the first 2^n value.
-	 */
-	hbits = fls(hashsize - 1);
-	hsize = htable_size(hbits);
-	if (hsize == 0)
-		goto free_rht;
-	t = ip_set_alloc(hsize);
-	if (!t)
-		goto free_rht;
-	t->hregion = ip_set_alloc(ahash_sizeof_regions(hbits));
-	if (!t->hregion)
-		goto free_t;
 #ifdef IP_SET_HASH_WITH_NETS
 	for (i = 0; i < IPSET_NET_COUNT; i++) {
 		nets = kzalloc_obj(*nets);
 		if (!nets) {
 			while (i > 0)
 				kfree(rcu_dereference_raw(h->rnets[--i]));
-			goto free_hregion;
+			goto free_rht;
 		}
 		seqcount_spinlock_init(&nets->seq, &set->lock);
 		RCU_INIT_POINTER(h->rnets[i], nets);
 	}
 #endif
 	h->gc.set = set;
-	spin_lock_init(&h->gc.lock);
-	for (i = 0; i < ahash_numof_locks(hbits); i++)
-		spin_lock_init(&t->hregion[i].lock);
 	h->maxelem = maxelem;
 #if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
 	h->bitmask = bitmask;
@@ -1930,10 +1417,8 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	h->markmask = markmask;
 #endif
-	if (tb[IPSET_ATTR_INITVAL])
+	if (tb[IPSET_ATTR_INITVAL]) /* only stored for userspace dump compatibility */
 		h->initval = ntohl(nla_get_be32(tb[IPSET_ATTR_INITVAL]));
-	else
-		get_random_bytes(&h->initval, sizeof(h->initval));
 	h->bucketsize = AHASH_MAX_SIZE;
 	if (tb[IPSET_ATTR_BUCKETSIZE]) {
 		h->bucketsize = nla_get_u8(tb[IPSET_ATTR_BUCKETSIZE]);
@@ -1944,10 +1429,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 		else if (h->bucketsize % 2)
 			h->bucketsize += 1;
 	}
-	t->htable_bits = hbits;
-	t->maxelem = h->maxelem / ahash_numof_locks(hbits);
-	INIT_LIST_HEAD(&t->ad);
-	RCU_INIT_POINTER(h->table, t);
+	h->htable_bits = fls(hashsize - 1);
 	set->data = h;
 
 #ifndef IP_SET_PROTO_UNDEF
@@ -1977,27 +1459,22 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 			IPSET_TOKEN(HTYPE, 6_gc_init)(&h->gc);
 #endif
 	}
-	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)\n",
-		 set->name, mtype_hash_size(h),
-		 t->htable_bits, h->maxelem, set->data, t);
+	pr_debug("create %s hashsize %u maxelem %u\n",
+		 set->name, jhash_size(h->htable_bits), h->maxelem);
 
 	return 0;
 
 #ifdef IP_SET_HASH_WITH_NETS
-free_hregion:
-	ip_set_free(t->hregion);
-#endif
-free_t:
-	ip_set_free(t);
 free_rht:
 #ifdef IP_SET_HASH_WITH_MULTI
 	rhltable_free_and_destroy(&h->rhlt, mtype_flush_elem, set);
 #else
 	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
 #endif
+#endif
 free_h:
 	kfree(h);
-	return -ENOMEM;
+	return err ? err : -ENOMEM;
 }
 #endif /* IP_SET_EMIT_CREATE */
 
-- 
2.54.0

