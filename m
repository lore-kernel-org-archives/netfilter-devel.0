From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 11/14] netfilter: ipset: Introduce RCU locking in the hash types
Date: Sun, 30 Nov 2014 19:57:02 +0100
Message-ID: <1417373825-3734-12-git-send-email-kadlec@blackhole.kfki.hu>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:58525 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbaK3S4K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:56:10 -0500
In-Reply-To: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Performance is tested by Jesper Dangaard Brouer:

Simple drop in FORWARD
~~~~~~~~~~~~~~~~~~~~

Dropping via simple iptables net-mask match::

 iptables -t raw -N simple || iptables -t raw -F simple
 iptables -t raw -I simple  -s 198.18.0.0/15 -j DROP
 iptables -t raw -D PREROUTING -j simple
 iptables -t raw -I PREROUTING -j simple

Drop performance in "raw": 11.3Mpps

Generator: sending 12.2Mpps (tx:12264083 pps)

Drop via original ipset in RAW table
~~~~~~~~~~~~~~~~~~~~~~~~~

Create a set with lots of elements::
 sudo ./ipset destroy test
 echo "create test hash:ip hashsize 65536" > test.set
 for x in `seq 0 255`; do
    for y in `seq 0 255`; do
        echo "add test 198.18.$x.$y" >> test.set
    done
 done
 sudo ./ipset restore < test.set

Dropping via ipset::

 iptables -t raw -F
 iptables -t raw -N net198 || iptables -t raw -F net198
 iptables -t raw -I net198 -m set --match-set test src -j DROP
 iptables -t raw -I PREROUTING -j net198

Drop performance in "raw" with ipset: 8Mpps

Perf report numbers ipset drop in "raw"::

 +   24.65%  ksoftirqd/1  [ip_set]           [k] ip_set_test
 -   21.42%  ksoftirqd/1  [kernel.kallsyms]  [k] _raw_read_lock_bh
    - _raw_read_lock_bh
       + 99.88% ip_set_test
 -   19.42%  ksoftirqd/1  [kernel.kallsyms]  [k] _raw_read_unlock_bh
    - _raw_read_unlock_bh
       + 99.72% ip_set_test
 +    4.31%  ksoftirqd/1  [ip_set_hash_ip]   [k] hash_ip4_kadt
 +    2.27%  ksoftirqd/1  [ixgbe]            [k] ixgbe_fetch_rx_buffer
 +    2.18%  ksoftirqd/1  [ip_tables]        [k] ipt_do_table
 +    1.81%  ksoftirqd/1  [ip_set_hash_ip]   [k] hash_ip4_test
 +    1.61%  ksoftirqd/1  [kernel.kallsyms]  [k] __netif_receive_skb_core
 +    1.44%  ksoftirqd/1  [kernel.kallsyms]  [k] build_skb
 +    1.42%  ksoftirqd/1  [kernel.kallsyms]  [k] ip_rcv
 +    1.36%  ksoftirqd/1  [kernel.kallsyms]  [k] __local_bh_enable_ip
 +    1.16%  ksoftirqd/1  [kernel.kallsyms]  [k] dev_gro_receive
 +    1.09%  ksoftirqd/1  [kernel.kallsyms]  [k] __rcu_read_unlock
 +    0.96%  ksoftirqd/1  [ixgbe]            [k] ixgbe_clean_rx_irq
 +    0.95%  ksoftirqd/1  [kernel.kallsyms]  [k] __netdev_alloc_frag
 +    0.88%  ksoftirqd/1  [kernel.kallsyms]  [k] kmem_cache_alloc
 +    0.87%  ksoftirqd/1  [xt_set]           [k] set_match_v3
 +    0.85%  ksoftirqd/1  [kernel.kallsyms]  [k] inet_gro_receive
 +    0.83%  ksoftirqd/1  [kernel.kallsyms]  [k] nf_iterate
 +    0.76%  ksoftirqd/1  [kernel.kallsyms]  [k] put_compound_page
 +    0.75%  ksoftirqd/1  [kernel.kallsyms]  [k] __rcu_read_lock

Drop via ipset in RAW table with RCU-locking
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

With RCU locking, the RW-lock is gone.

Drop performance in "raw" with ipset with RCU-locking: 11.3Mpps

Performance-tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 580 ++++++++++++++++++++--------------
 1 file changed, 344 insertions(+), 236 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 974ff38..8f51ba4 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -10,19 +10,19 @@
 
 #include <linux/rcupdate.h>
 #include <linux/jhash.h>
+#include <linux/types.h>
 #include <linux/netfilter/ipset/ip_set_timeout.h>
-#ifndef rcu_dereference_bh
-#define rcu_dereference_bh(p)	rcu_dereference(p)
-#endif
+
+#define __ipset_dereference_protected(p, c)	rcu_dereference_protected(p, c)
+#define ipset_dereference_protected(p, set) \
+	__ipset_dereference_protected(p, spin_is_locked(&(set)->lock))
 
 #define rcu_dereference_bh_nfnl(p)	rcu_dereference_bh_check(p, 1)
 
 /* Hashing which uses arrays to resolve clashing. The hash table is resized
  * (doubled) when searching becomes too long.
  * Internally jhash is used with the assumption that the size of the
- * stored data is a multiple of sizeof(u32). If storage supports timeout,
- * the timeout field must be the last one in the data structure - that field
- * is ignored when computing the hash key.
+ * stored data is a multiple of sizeof(u32).
  *
  * Readers and resizing
  *
@@ -36,6 +36,8 @@
 #define AHASH_INIT_SIZE			4
 /* Max number of elements to store in an array block */
 #define AHASH_MAX_SIZE			(3*AHASH_INIT_SIZE)
+/* Max muber of elements in the array block when tuned */
+#define AHASH_MAX_TUNED			64
 
 /* Max number of elements can be tuned */
 #ifdef IP_SET_HASH_WITH_MULTI
@@ -53,7 +55,7 @@ tune_ahash_max(u8 curr, u32 multi)
 	/* Currently, at listing one hash bucket must fit into a message.
 	 * Therefore we have a hard limit here.
 	 */
-	return n > curr && n <= 64 ? n : curr;
+	return n > curr && n <= AHASH_MAX_TUNED ? n : curr;
 }
 #define TUNE_AHASH_MAX(h, multi)	\
 	((h)->ahash_max = tune_ahash_max((h)->ahash_max, multi))
@@ -64,18 +66,21 @@ tune_ahash_max(u8 curr, u32 multi)
 
 /* A hash bucket */
 struct hbucket {
-	void *value;		/* the array of the values */
+	struct rcu_head rcu;	/* for call_rcu_bh */
+	/* Which positions are used in the array */
+	DECLARE_BITMAP(used, AHASH_MAX_TUNED);
 	u8 size;		/* size of the array */
 	u8 pos;			/* position of the first free entry */
-};
+	unsigned char value[0];	/* the array of the values */
+} __attribute__ ((aligned));
 
 /* The hash table: the table size stored here in order to make resizing easy */
 struct htable {
 	u8 htable_bits;		/* size of hash table == 2^htable_bits */
-	struct hbucket bucket[0]; /* hashtable buckets */
+	struct hbucket __rcu * bucket[0]; /* hashtable buckets */
 };
 
-#define hbucket(h, i)		(&((h)->bucket[i]))
+#define hbucket(h, i)		((h)->bucket[i])
 
 #ifndef IPSET_NET_COUNT
 #define IPSET_NET_COUNT		1
@@ -83,8 +88,8 @@ struct htable {
 
 /* Book-keeping of the prefixes added to the set */
 struct net_prefixes {
-	u32 nets[IPSET_NET_COUNT]; /* number of elements per cidr */
-	u8 cidr[IPSET_NET_COUNT];  /* the different cidr values in the set */
+	u32 nets[IPSET_NET_COUNT]; /* number of elements for this cidr */
+	u8 cidr[IPSET_NET_COUNT];  /* the cidr value */
 };
 
 /* Compute the hash table size */
@@ -97,11 +102,11 @@ htable_size(u8 hbits)
 	if (hbits > 31)
 		return 0;
 	hsize = jhash_size(hbits);
-	if ((((size_t)-1) - sizeof(struct htable))/sizeof(struct hbucket)
+	if ((((size_t)-1) - sizeof(struct htable))/sizeof(struct hbucket *)
 	    < hsize)
 		return 0;
 
-	return hsize * sizeof(struct hbucket) + sizeof(struct htable);
+	return hsize * sizeof(struct hbucket *) + sizeof(struct htable);
 }
 
 /* Compute htable_bits from the user input parameter hashsize */
@@ -110,6 +115,7 @@ htable_bits(u32 hashsize)
 {
 	/* Assume that hashsize == 2^htable_bits */
 	u8 bits = fls(hashsize - 1);
+
 	if (jhash_size(bits) != hashsize)
 		/* Round up to the first 2^n value */
 		bits = fls(hashsize);
@@ -117,30 +123,6 @@ htable_bits(u32 hashsize)
 	return bits;
 }
 
-static int
-hbucket_elem_add(struct hbucket *n, u8 ahash_max, size_t dsize)
-{
-	if (n->pos >= n->size) {
-		void *tmp;
-
-		if (n->size >= ahash_max)
-			/* Trigger rehashing */
-			return -EAGAIN;
-
-		tmp = kzalloc((n->size + AHASH_INIT_SIZE) * dsize,
-			      GFP_ATOMIC);
-		if (!tmp)
-			return -ENOMEM;
-		if (n->size) {
-			memcpy(tmp, n->value, n->size * dsize);
-			kfree(n->value);
-		}
-		n->value = tmp;
-		n->size += AHASH_INIT_SIZE;
-	}
-	return 0;
-}
-
 #ifdef IP_SET_HASH_WITH_NETS
 #if IPSET_NET_COUNT > 1
 #define __CIDR(cidr, i)		(cidr[i])
@@ -280,9 +262,6 @@ struct htype {
 #ifdef IP_SET_HASH_WITH_NETMASK
 	u8 netmask;		/* netmask value for subnets to store */
 #endif
-#ifdef IP_SET_HASH_WITH_RBTREE
-	struct rb_root rbtree;
-#endif
 #ifdef IP_SET_HASH_WITH_NETS
 	struct net_prefixes nets[0]; /* book-keeping of prefixes */
 #endif
@@ -324,8 +303,8 @@ mtype_del_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
 	for (i = 0; i < nets_length; i++) {
 	        if (h->nets[i].cidr[n] != cidr)
 	                continue;
-		h->nets[cidr -1].nets[n]--;
-		if (h->nets[cidr -1].nets[n] > 0)
+		h->nets[cidr - 1].nets[n]--;
+		if (h->nets[cidr - 1].nets[n] > 0)
                         return;
 		for (j = i; j < net_end && h->nets[j].cidr[n]; j++)
 		        h->nets[j].cidr[n] = h->nets[j + 1].cidr[n];
@@ -341,15 +320,18 @@ mtype_ahash_memsize(const struct htype *h, const struct htable *t,
 		    u8 nets_length, size_t dsize)
 {
 	u32 i;
-	size_t memsize = sizeof(*h)
-			 + sizeof(*t)
+	struct hbucket *n;
+	size_t memsize = sizeof(*h) + sizeof(*t);
+
 #ifdef IP_SET_HASH_WITH_NETS
-			 + sizeof(struct net_prefixes) * nets_length
+	memsize += sizeof(struct net_prefixes) * nets_length;
 #endif
-			 + jhash_size(t->htable_bits) * sizeof(struct hbucket);
-
-	for (i = 0; i < jhash_size(t->htable_bits); i++)
-		memsize += t->bucket[i].size * dsize;
+	for (i = 0; i < jhash_size(t->htable_bits); i++) {
+		n = rcu_dereference_bh(hbucket(t, i));
+		if (n == NULL)
+			continue;
+		memsize += sizeof(struct hbucket) + n->size * dsize;
+	}
 
 	return memsize;
 }
@@ -364,7 +346,8 @@ mtype_ext_cleanup(struct ip_set *set, struct hbucket *n)
 	int i;
 
 	for (i = 0; i < n->pos; i++)
-		ip_set_ext_destroy(set, ahash_data(n, i, set->dsize));
+		if (test_bit(i, n->used))
+			ip_set_ext_destroy(set, ahash_data(n, i, set->dsize));
 }
 
 /* Flush a hash type of set: destroy all elements */
@@ -376,16 +359,16 @@ mtype_flush(struct ip_set *set)
 	struct hbucket *n;
 	u32 i;
 
-	t = rcu_dereference_bh_nfnl(h->table);
+	t = ipset_dereference_protected(h->table, set);
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
-		n = hbucket(t, i);
-		if (n->size) {
-			if (set->extensions & IPSET_EXT_DESTROY)
-				mtype_ext_cleanup(set, n);
-			n->size = n->pos = 0;
-			/* FIXME: use slab cache */
-			kfree(n->value);
-		}
+		n = __ipset_dereference_protected(hbucket(t, i), 1);
+		if (n == NULL)
+			continue;
+		if (set->extensions & IPSET_EXT_DESTROY)
+			mtype_ext_cleanup(set, n);
+		/* FIXME: use slab cache */
+		rcu_assign_pointer(hbucket(t, i), NULL);
+		kfree_rcu(n, rcu);
 	}
 #ifdef IP_SET_HASH_WITH_NETS
 	memset(h->nets, 0, sizeof(struct net_prefixes) * NLEN(set->family));
@@ -401,13 +384,13 @@ mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
 	u32 i;
 
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
-		n = hbucket(t, i);
-		if (n->size) {
-			if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
-				mtype_ext_cleanup(set, n);
-			/* FIXME: use slab cache */
-			kfree(n->value);
-		}
+		n = __ipset_dereference_protected(hbucket(t, i), 1);
+		if (n == NULL)
+			continue;
+		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
+			mtype_ext_cleanup(set, n);
+		/* FIXME: use slab cache */
+		kfree(n);
 	}
 
 	ip_set_free(t);
@@ -422,10 +405,8 @@ mtype_destroy(struct ip_set *set)
 	if (set->extensions & IPSET_EXT_TIMEOUT)
 		del_timer_sync(&h->gc);
 
-	mtype_ahash_destroy(set, rcu_dereference_bh_nfnl(h->table), true);
-#ifdef IP_SET_HASH_WITH_RBTREE
-	rbtree_destroy(&h->rbtree);
-#endif
+	mtype_ahash_destroy(set,
+		__ipset_dereference_protected(h->table, 1), true);
 	kfree(h);
 
 	set->data = NULL;
@@ -470,17 +451,21 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 	struct htable *t;
 	struct hbucket *n;
 	struct mtype_elem *data;
-	u32 i;
-	int j;
+	u32 i, j, d;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 k;
 #endif
 
-	rcu_read_lock_bh();
-	t = rcu_dereference_bh(h->table);
+	t = ipset_dereference_protected(h->table, set);
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
-		n = hbucket(t, i);
-		for (j = 0; j < n->pos; j++) {
+		n = __ipset_dereference_protected(hbucket(t, i), 1);
+		if (n == NULL)
+			continue;
+		for (j = 0, d = 0; j < n->pos; j++) {
+			if (!test_bit(j, n->used)) {
+				d++;
+				continue;
+			}
 			data = ahash_data(n, j, dsize);
 			if (ip_set_timeout_expired(ext_timeout(data, set))) {
 				pr_debug("expired %u/%u\n", i, j);
@@ -490,29 +475,32 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 						       nets_length, k);
 #endif
 				ip_set_ext_destroy(set, data);
-				if (j != n->pos - 1)
-					/* Not last one */
-					memcpy(data,
-					       ahash_data(n, n->pos - 1, dsize),
-					       dsize);
-				n->pos--;
+				clear_bit(j, n->used);
 				h->elements--;
+				d++;
 			}
 		}
-		if (n->pos + AHASH_INIT_SIZE < n->size) {
-			void *tmp = kzalloc((n->size - AHASH_INIT_SIZE)
-					    * dsize,
-					    GFP_ATOMIC);
+		if (d >= AHASH_INIT_SIZE) {
+			struct hbucket *tmp = kzalloc(sizeof(struct hbucket) +
+					(n->size - AHASH_INIT_SIZE) * dsize,
+					GFP_ATOMIC);
 			if (!tmp)
 				/* Still try to delete expired elements */
 				continue;
-			n->size -= AHASH_INIT_SIZE;
-			memcpy(tmp, n->value, n->size * dsize);
-			kfree(n->value);
-			n->value = tmp;
+			tmp->size = n->size - AHASH_INIT_SIZE;
+			for (j = 0, d = 0; j < n->pos; j++) {
+				if (!test_bit(j, n->used))
+					continue;
+				data = ahash_data(n, j, dsize);
+				memcpy(tmp->value + d * dsize, data, dsize);
+				set_bit(j, tmp->used);
+				d++;
+			}
+			tmp->pos = d;
+			rcu_assign_pointer(hbucket(t, i), tmp);
+			kfree_rcu(n, rcu);
 		}
 	}
-	rcu_read_unlock_bh();
 }
 
 static void
@@ -522,9 +510,9 @@ mtype_gc(unsigned long ul_set)
 	struct htype *h = set->data;
 
 	pr_debug("called\n");
-	write_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	mtype_expire(set, h, NLEN(set->family), set->dsize);
-	write_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 
 	h->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
 	add_timer(&h->gc);
@@ -537,75 +525,115 @@ static int
 mtype_resize(struct ip_set *set, bool retried)
 {
 	struct htype *h = set->data;
-	struct htable *t, *orig = rcu_dereference_bh_nfnl(h->table);
-	u8 htable_bits = orig->htable_bits;
+	struct htable *t, *orig;
+	u8 htable_bits;
+	size_t dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 flags;
+	struct mtype_elem *tmp;
 #endif
 	struct mtype_elem *data;
 	struct mtype_elem *d;
 	struct hbucket *n, *m;
-	u32 i, j;
+	u32 i, j, key;
 	int ret;
 
-	/* Try to cleanup once */
-	if (SET_WITH_TIMEOUT(set) && !retried) {
-		i = h->elements;
-		write_lock_bh(&set->lock);
-		mtype_expire(set, set->data, NLEN(set->family), set->dsize);
-		write_unlock_bh(&set->lock);
-		if (h->elements < i)
-			return 0;
-	}
+#ifdef IP_SET_HASH_WITH_NETS
+	tmp = kmalloc(dsize, GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+#endif
+	rcu_read_lock_bh();
+	orig = rcu_dereference_bh_nfnl(h->table);
+	htable_bits = orig->htable_bits;
+	rcu_read_unlock_bh();
 
 retry:
 	ret = 0;
 	htable_bits++;
-	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
-		 set->name, orig->htable_bits, htable_bits, orig);
 	if (!htable_bits) {
 		/* In case we have plenty of memory :-) */
 		pr_warn("Cannot increase the hashsize of set %s further\n",
 			set->name);
-		return -IPSET_ERR_HASH_FULL;
+		ret = -IPSET_ERR_HASH_FULL;
+		goto out;
+	}
+	t = ip_set_alloc(htable_size(htable_bits));
+	if (!t) {
+		ret = -ENOMEM;
+		goto out;
 	}
-	t = ip_set_alloc(sizeof(*t)
-			 + jhash_size(htable_bits) * sizeof(struct hbucket));
-	if (!t)
-		return -ENOMEM;
 	t->htable_bits = htable_bits;
 
-	read_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
+	orig = __ipset_dereference_protected(h->table, 1);
+	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
+		 set->name, orig->htable_bits, htable_bits, orig);
 	for (i = 0; i < jhash_size(orig->htable_bits); i++) {
-		n = hbucket(orig, i);
+		n = __ipset_dereference_protected(hbucket(orig, i), 1);
+		if (n == NULL)
+			continue;
 		for (j = 0; j < n->pos; j++) {
-			data = ahash_data(n, j, set->dsize);
+			if (!test_bit(j, n->used))
+				continue;
+			data = ahash_data(n, j, dsize);
 #ifdef IP_SET_HASH_WITH_NETS
+			/* We have readers running parallel with us,
+			 * so the live data cannot be modified.
+			 */
 			flags = 0;
+			memcpy(tmp, data, dsize);
+			data = tmp;
 			mtype_data_reset_flags(data, &flags);
 #endif
-			m = hbucket(t, HKEY(data, h->initval, htable_bits));
-			ret = hbucket_elem_add(m, AHASH_MAX(h), set->dsize);
-			if (ret < 0) {
-#ifdef IP_SET_HASH_WITH_NETS
-				mtype_data_reset_flags(data, &flags);
-#endif
-				read_unlock_bh(&set->lock);
-				mtype_ahash_destroy(set, t, false);
-				if (ret == -EAGAIN)
-					goto retry;
-				return ret;
+			key = HKEY(data, h->initval, htable_bits);
+			m = __ipset_dereference_protected(hbucket(t, key), 1);
+			if (!m) {
+				m = kzalloc(sizeof(struct hbucket) +
+					    AHASH_INIT_SIZE * dsize,
+					    GFP_ATOMIC);
+				if (!m)
+					ret = -ENOMEM;
+				m->size = AHASH_INIT_SIZE;
+				RCU_INIT_POINTER(hbucket(t, key), m);
+			} else if (m->pos >= m->size) {
+				struct hbucket *ht;
+
+				if (m->size >= AHASH_MAX(h))
+					ret = -EAGAIN;
+				else {
+					ht = kzalloc(sizeof(struct hbucket) +
+						(m->size + AHASH_INIT_SIZE)
+						* dsize,
+						GFP_ATOMIC);
+					if (!ht)
+						ret = -ENOMEM;
+				}
+				if (ret < 0) {
+					spin_unlock_bh(&set->lock);
+					mtype_ahash_destroy(set, t, false);
+					if (ret == -EAGAIN)
+						goto retry;
+					goto out;
+				}
+				memcpy(ht, m, sizeof(struct hbucket) +
+					      m->size * dsize);
+				ht->size = m->size + AHASH_INIT_SIZE;
+				kfree(m);
+				m = ht;
+				RCU_INIT_POINTER(hbucket(t, key), ht);
 			}
-			d = ahash_data(m, m->pos++, set->dsize);
-			memcpy(d, data, set->dsize);
+			d = ahash_data(m, m->pos, dsize);
+			memcpy(d, data, dsize);
+			set_bit(m->pos++, m->used);
 #ifdef IP_SET_HASH_WITH_NETS
 			mtype_data_reset_flags(d, &flags);
 #endif
 		}
 	}
-
 	rcu_assign_pointer(h->table, t);
-	read_unlock_bh(&set->lock);
+
+	spin_unlock_bh(&set->lock);
 
 	/* Give time to other readers of the set */
 	synchronize_rcu_bh();
@@ -614,7 +642,12 @@ retry:
 		 orig->htable_bits, orig, t->htable_bits, t);
 	mtype_ahash_destroy(set, orig, false);
 
-	return 0;
+out:
+#ifdef IP_SET_HASH_WITH_NETS
+	kfree(tmp);
+#endif
+	return ret;
+
 }
 
 /* Add an element to a hash and update the internal counters when succeeded,
@@ -627,17 +660,49 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	struct htable *t;
 	const struct mtype_elem *d = value;
 	struct mtype_elem *data;
-	struct hbucket *n;
-	int i, ret = 0;
-	int j = AHASH_MAX(h) + 1;
+	struct hbucket *n, *old = ERR_PTR(-ENOENT);
+	int i, j = -1;
 	bool flag_exist = flags & IPSET_FLAG_EXIST;
+	bool deleted = false, forceadd = false, reuse = false;
 	u32 key, multi = 0;
 
-	rcu_read_lock_bh();
-	t = rcu_dereference_bh(h->table);
+	if (h->elements >= h->maxelem) {
+		if (SET_WITH_TIMEOUT(set))
+			/* FIXME: when set is full, we slow down here */
+			mtype_expire(set, h, NLEN(set->family), set->dsize);
+		if (h->elements >= h->maxelem && SET_WITH_FORCEADD(set))
+			forceadd = true;
+	}
+
+	t = ipset_dereference_protected(h->table, set);
 	key = HKEY(value, h->initval, t->htable_bits);
-	n = hbucket(t, key);
+	n = __ipset_dereference_protected(hbucket(t, key), 1);
+	if (n == NULL) {
+		if (forceadd) {
+			if (net_ratelimit())
+				pr_warn("Set %s is full, maxelem %u reached\n",
+					set->name, h->maxelem);
+			return -IPSET_ERR_HASH_FULL;
+		} else if (h->elements >= h->maxelem)
+			goto set_full;
+		old = NULL;
+		n = kzalloc(sizeof(struct hbucket) +
+			    AHASH_INIT_SIZE * set->dsize,
+			    GFP_ATOMIC);
+		if (n == NULL)
+			return -ENOMEM;
+		n->size = AHASH_INIT_SIZE;
+		goto copy_elem;
+	}
 	for (i = 0; i < n->pos; i++) {
+		if (!test_bit(i, n->used)) {
+			/* Reuse first deleted entry */
+			if (j == -1) {
+				deleted = reuse = true;
+				j = i;
+			}
+			continue;
+		}
 		data = ahash_data(n, i, set->dsize);
 		if (mtype_data_equal(data, d, &multi)) {
 			if (flag_exist ||
@@ -645,85 +710,92 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			     ip_set_timeout_expired(ext_timeout(data, set)))) {
 				/* Just the extensions could be overwritten */
 				j = i;
-				goto reuse_slot;
-			} else {
-				ret = -IPSET_ERR_EXIST;
-				goto out;
-			}
+				goto overwrite_extensions;
+			} else
+				return -IPSET_ERR_EXIST;
 		}
 		/* Reuse first timed out entry */
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(data, set)) &&
-		    j != AHASH_MAX(h) + 1)
+		    j == -1) {
 			j = i;
+			reuse = true;
+		}
 	}
-	if (h->elements >= h->maxelem && SET_WITH_FORCEADD(set) && n->pos) {
-		/* Choosing the first entry in the array to replace */
-		j = 0;
-		goto reuse_slot;
-	}
-	if (SET_WITH_TIMEOUT(set) && h->elements >= h->maxelem)
-		/* FIXME: when set is full, we slow down here */
-		mtype_expire(set, h, NLEN(set->family), set->dsize);
-
-	if (h->elements >= h->maxelem) {
-		if (net_ratelimit())
-			pr_warn("Set %s is full, maxelem %u reached\n",
-				set->name, h->maxelem);
-		ret = -IPSET_ERR_HASH_FULL;
-		goto out;
-	}
-
-reuse_slot:
-	if (j != AHASH_MAX(h) + 1) {
-		/* Fill out reused slot */
+	if (reuse || forceadd) {
 		data = ahash_data(n, j, set->dsize);
+		if (!deleted) {
 #ifdef IP_SET_HASH_WITH_NETS
-		for (i = 0; i < IPSET_NET_COUNT; i++) {
-			mtype_del_cidr(h, SCIDR(data->cidr, i),
-				       NLEN(set->family), i);
-			mtype_add_cidr(h, SCIDR(d->cidr, i),
-				       NLEN(set->family), i);
-		}
+			for (i = 0; i < IPSET_NET_COUNT; i++)
+				mtype_del_cidr(h, SCIDR(data->cidr, i),
+					       NLEN(set->family), i);
 #endif
-		ip_set_ext_destroy(set, data);
-	} else {
-		/* Use/create a new slot */
+			ip_set_ext_destroy(set, data);
+			h->elements--;
+		}
+		goto copy_data;
+	}
+	if (h->elements >= h->maxelem)
+		goto set_full;
+	/* Create a new slot */
+	if (n->pos >= n->size) {
 		TUNE_AHASH_MAX(h, multi);
-		ret = hbucket_elem_add(n, AHASH_MAX(h), set->dsize);
-		if (ret != 0) {
-			if (ret == -EAGAIN)
-				mtype_data_next(&h->next, d);
-			goto out;
+		if (n->size >= AHASH_MAX(h)) {
+			/* Trigger rehashing */
+			mtype_data_next(&h->next, d);
+			return -EAGAIN;
 		}
-		data = ahash_data(n, n->pos++, set->dsize);
+		old = n;
+		n = kzalloc(sizeof(struct hbucket) +
+			    (old->size + AHASH_INIT_SIZE) * set->dsize,
+			    GFP_ATOMIC);
+		if (!n)
+			return -ENOMEM;
+		memcpy(n, old, sizeof(struct hbucket) +
+		       old->size * set->dsize);
+		n->size = old->size + AHASH_INIT_SIZE;
+	}
+
+copy_elem:
+	j = n->pos++;
+	data = ahash_data(n, j, set->dsize);
+copy_data:
+	h->elements++;
 #ifdef IP_SET_HASH_WITH_NETS
-		for (i = 0; i < IPSET_NET_COUNT; i++)
-			mtype_add_cidr(h, SCIDR(d->cidr, i), NLEN(set->family),
-				       i);
+	for (i = 0; i < IPSET_NET_COUNT; i++)
+		mtype_add_cidr(h, SCIDR(d->cidr, i),
+			       NLEN(set->family), i);
 #endif
-		h->elements++;
-	}
 	memcpy(data, d, sizeof(struct mtype_elem));
+overwrite_extensions:
 #ifdef IP_SET_HASH_WITH_NETS
 	mtype_data_set_flags(data, flags);
 #endif
-	if (SET_WITH_TIMEOUT(set))
-		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(data, set), ext);
 	if (SET_WITH_COMMENT(set))
 		ip_set_init_comment(ext_comment(data, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(data, set), ext);
+	/* Must come last */
+	if (SET_WITH_TIMEOUT(set))
+		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
+	set_bit(j, n->used);
+	if (old != ERR_PTR(-ENOENT)) {
+		rcu_assign_pointer(hbucket(t, key), n);
+		if (old)
+			kfree_rcu(old, rcu);
+	}
 
-out:
-	rcu_read_unlock_bh();
-	return ret;
+	return 0;
+set_full:
+	if (net_ratelimit())
+		pr_warn("Set %s is full, maxelem %u reached\n",
+			set->name, h->maxelem);
+	return -IPSET_ERR_HASH_FULL;
 }
 
-/* Delete an element from the hash: swap it with the last element
- * and free up space if possible.
+/* Delete an element from the hash and free up space if possible.
  */
 static int
 mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
@@ -734,29 +806,31 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	const struct mtype_elem *d = value;
 	struct mtype_elem *data;
 	struct hbucket *n;
-	int i, ret = -IPSET_ERR_EXIST;
-#ifdef IP_SET_HASH_WITH_NETS
-	u8 j;
-#endif
+	int i, j, k, ret = -IPSET_ERR_EXIST;
 	u32 key, multi = 0;
+	size_t dsize = set->dsize;
 
-	rcu_read_lock_bh();
-	t = rcu_dereference_bh(h->table);
+	t = ipset_dereference_protected(h->table, set);
 	key = HKEY(value, h->initval, t->htable_bits);
-	n = hbucket(t, key);
-	for (i = 0; i < n->pos; i++) {
-		data = ahash_data(n, i, set->dsize);
+	n = __ipset_dereference_protected(hbucket(t, key), 1);
+	if (!n)
+		goto out;
+	for (i = 0, k = 0; i < n->pos; i++) {
+		if (!test_bit(i, n->used)) {
+			k++;
+			continue;
+		}
+		data = ahash_data(n, i, dsize);
 		if (!mtype_data_equal(data, d, &multi))
 			continue;
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(data, set)))
 			goto out;
-		if (i != n->pos - 1)
-			/* Not last one */
-			memcpy(data, ahash_data(n, n->pos - 1, set->dsize),
-			       set->dsize);
 
-		n->pos--;
+		ret = 0;
+		clear_bit(i, n->used);
+		if (i + 1 == n->pos)
+			n->pos--;
 		h->elements--;
 #ifdef IP_SET_HASH_WITH_NETS
 		for (j = 0; j < IPSET_NET_COUNT; j++)
@@ -764,25 +838,37 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 				       j);
 #endif
 		ip_set_ext_destroy(set, data);
-		if (n->pos + AHASH_INIT_SIZE < n->size) {
-			void *tmp = kzalloc((n->size - AHASH_INIT_SIZE)
-					    * set->dsize,
-					    GFP_ATOMIC);
-			if (!tmp) {
-				ret = 0;
+
+		for (; i < n->pos; i++) {
+			if (!test_bit(i, n->used))
+				k++;
+		}
+		if (n->pos == 0 && k == 0) {
+			rcu_assign_pointer(hbucket(t, key), NULL);
+			kfree_rcu(n, rcu);
+		} else if (k >= AHASH_INIT_SIZE) {
+			struct hbucket *tmp = kzalloc(sizeof(struct hbucket) +
+					(n->size - AHASH_INIT_SIZE) * dsize,
+					GFP_ATOMIC);
+			if (!tmp)
 				goto out;
+			tmp->size = n->size - AHASH_INIT_SIZE;
+			for (j = 0, k = 0; j < n->pos; j++) {
+				if (!test_bit(j, n->used))
+					continue;
+				data = ahash_data(n, j, dsize);
+				memcpy(tmp->value + k * dsize, data, dsize);
+				set_bit(j, tmp->used);
+				k++;
 			}
-			n->size -= AHASH_INIT_SIZE;
-			memcpy(tmp, n->value, n->size * set->dsize);
-			kfree(n->value);
-			n->value = tmp;
+			tmp->pos = k;
+			rcu_assign_pointer(hbucket(t, key), tmp);
+			kfree_rcu(n, rcu);
 		}
-		ret = 0;
 		goto out;
 	}
 
 out:
-	rcu_read_unlock_bh();
 	return ret;
 }
 
@@ -832,8 +918,12 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 		mtype_data_netmask(d, NCIDR(h->nets[j].cidr[0]));
 #endif
 		key = HKEY(d, h->initval, t->htable_bits);
-		n = hbucket(t, key);
+		n =  rcu_dereference_bh(hbucket(t, key));
+		if (n == NULL)
+			continue;
 		for (i = 0; i < n->pos; i++) {
+			if (!test_bit(i, n->used))
+				continue;
 			data = ahash_data(n, i, set->dsize);
 			if (!mtype_data_equal(data, d, &multi))
 				continue;
@@ -871,7 +961,6 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	int i, ret = 0;
 	u32 key, multi = 0;
 
-	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 #ifdef IP_SET_HASH_WITH_NETS
 	/* If we test an IP address and not a network address,
@@ -886,8 +975,14 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #endif
 
 	key = HKEY(d, h->initval, t->htable_bits);
-	n = hbucket(t, key);
+	n = rcu_dereference_bh(hbucket(t, key));
+	if (n == NULL) {
+		ret = 0;
+		goto out;
+	}
 	for (i = 0; i < n->pos; i++) {
+		if (!test_bit(i, n->used))
+			continue;
 		data = ahash_data(n, i, set->dsize);
 		if (mtype_data_equal(data, d, &multi) &&
 		    !(SET_WITH_TIMEOUT(set) &&
@@ -897,7 +992,6 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		}
 	}
 out:
-	rcu_read_unlock_bh();
 	return ret;
 }
 
@@ -909,15 +1003,19 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	const struct htable *t;
 	struct nlattr *nested;
 	size_t memsize;
+	u8 htable_bits;
 
+	rcu_read_lock_bh();
 	t = rcu_dereference_bh_nfnl(h->table);
 	memsize = mtype_ahash_memsize(h, t, NLEN(set->family), set->dsize);
+	htable_bits = t->htable_bits;
+	rcu_read_unlock_bh();
 
 	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
 		goto nla_put_failure;
 	if (nla_put_net32(skb, IPSET_ATTR_HASHSIZE,
-			  htonl(jhash_size(t->htable_bits))) ||
+			  htonl(jhash_size(htable_bits))) ||
 	    nla_put_net32(skb, IPSET_ATTR_MAXELEM, htonl(h->maxelem)))
 		goto nla_put_failure;
 #ifdef IP_SET_HASH_WITH_NETMASK
@@ -947,26 +1045,32 @@ mtype_list(const struct ip_set *set,
 	   struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct htype *h = set->data;
-	const struct htable *t = rcu_dereference_bh_nfnl(h->table);
+	const struct htable *t;
 	struct nlattr *atd, *nested;
 	const struct hbucket *n;
 	const struct mtype_elem *e;
 	u32 first = cb->args[IPSET_CB_ARG0];
 	/* We assume that one hash bucket fills into one page */
 	void *incomplete;
-	int i;
+	int i, ret = 0;
 
 	atd = ipset_nest_start(skb, IPSET_ATTR_ADT);
 	if (!atd)
 		return -EMSGSIZE;
+
 	pr_debug("list hash set %s\n", set->name);
+	t = rcu_dereference_bh_nfnl(h->table);
 	for (; cb->args[IPSET_CB_ARG0] < jhash_size(t->htable_bits);
 	     cb->args[IPSET_CB_ARG0]++) {
 		incomplete = skb_tail_pointer(skb);
-		n = hbucket(t, cb->args[IPSET_CB_ARG0]);
+		n = rcu_dereference(hbucket(t, cb->args[IPSET_CB_ARG0]));
 		pr_debug("cb->arg bucket: %lu, t %p n %p\n",
 			 cb->args[IPSET_CB_ARG0], t, n);
+		if (n == NULL)
+			continue;
 		for (i = 0; i < n->pos; i++) {
+			if (!test_bit(i, n->used))
+				continue;
 			e = ahash_data(n, i, set->dsize);
 			if (SET_WITH_TIMEOUT(set) &&
 			    ip_set_timeout_expired(ext_timeout(e, set)))
@@ -977,7 +1081,8 @@ mtype_list(const struct ip_set *set,
 			if (!nested) {
 				if (cb->args[IPSET_CB_ARG0] == first) {
 					nla_nest_cancel(skb, atd);
-					return -EMSGSIZE;
+					ret = -EMSGSIZE;
+					goto out;
 				} else
 					goto nla_put_failure;
 			}
@@ -992,7 +1097,7 @@ mtype_list(const struct ip_set *set,
 	/* Set listing finished */
 	cb->args[IPSET_CB_ARG0] = 0;
 
-	return 0;
+	goto out;
 
 nla_put_failure:
 	nlmsg_trim(skb, incomplete);
@@ -1000,10 +1105,11 @@ nla_put_failure:
 		pr_warn("Can't list set %s: one bucket does not fit into a message. Please report it!\n",
 			set->name);
 		cb->args[IPSET_CB_ARG0] = 0;
-		return -EMSGSIZE;
-	}
-	ipset_nest_end(skb, atd);
-	return 0;
+		ret = -EMSGSIZE;
+	} else
+		ipset_nest_end(skb, atd);
+out:
+	return ret;
 }
 
 static int
@@ -1064,12 +1170,14 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 
 	if (unlikely(!ip_set_optattr_netorder(tb, IPSET_ATTR_HASHSIZE) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_MAXELEM) ||
-#ifdef IP_SET_HASH_WITH_MARKMASK
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_MARKMASK) ||
-#endif
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
+#ifdef IP_SET_HASH_WITH_MARKMASK
+	/* Separated condition in order to avoid directive in argument list */
+	if (unlikely(!ip_set_optattr_netorder(tb, IPSET_ATTR_MARKMASK)))
+		return -IPSET_ERR_PROTOCOL;
+#endif
 
 	if (tb[IPSET_ATTR_HASHSIZE]) {
 		hashsize = ip_set_get_h32(tb[IPSET_ATTR_HASHSIZE]);
@@ -1092,7 +1200,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	if (tb[IPSET_ATTR_MARKMASK]) {
-		markmask = ntohl(nla_get_u32(tb[IPSET_ATTR_MARKMASK]));
+		markmask = ntohl(nla_get_be32(tb[IPSET_ATTR_MARKMASK]));
 
 		if (markmask == 0)
 			return -IPSET_ERR_INVALID_MARKMASK;
-- 
1.8.5.1

