From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 08/10] netfilter: ipset: Introduce RCU in all set types instead of rwlock per set
Date: Mon, 24 Nov 2014 21:46:50 +0100
Message-ID: <1416862012-31139-9-git-send-email-kadlec@blackhole.kfki.hu>
References: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:49173 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaKXUqA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:46:00 -0500
In-Reply-To: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu>
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
 include/linux/netfilter/ipset/ip_set.h         |  82 +++-
 include/linux/netfilter/ipset/ip_set_timeout.h |  39 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h        |   8 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |   2 +-
 net/netfilter/ipset/ip_set_core.c              |  35 +-
 net/netfilter/ipset/ip_set_hash_gen.h          | 547 +++++++++++++++----------
 net/netfilter/ipset/ip_set_list_set.c          | 386 ++++++++---------
 7 files changed, 614 insertions(+), 485 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index f1606fa..418d360 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -113,10 +113,10 @@ struct ip_set_comment {
 };
 
 struct ip_set_skbinfo {
-	u32 skbmark;
-	u32 skbmarkmask;
-	u32 skbprio;
-	u16 skbqueue;
+	u32 __rcu skbmark;
+	u32 __rcu skbmarkmask;
+	u32 __rcu skbprio;
+	u16 __rcu skbqueue;
 };
 
 struct ip_set;
@@ -223,7 +223,7 @@ struct ip_set {
 	/* The name of the set */
 	char name[IPSET_MAXNAMELEN];
 	/* Lock protecting the set data */
-	rwlock_t lock;
+	spinlock_t lock;
 	/* References to the set */
 	u32 ref;
 	/* The core set type */
@@ -322,30 +322,72 @@ ip_set_update_counter(struct ip_set_counter *counter,
 	}
 }
 
+/* RCU-safe assign value */
+#define IP_SET_RCU_ASSIGN(ptr, value)	\
+do {					\
+	smp_wmb();			\
+	*(ptr) = value;			\
+} while (0)
+
+static inline void
+ip_set_rcu_assign_ulong(unsigned long *v, unsigned long value)
+{
+	IP_SET_RCU_ASSIGN(v, value);
+}
+
+static inline void
+ip_set_rcu_assign_u32(u32 *v, u32 value)
+{
+	IP_SET_RCU_ASSIGN(v, value);
+}
+
+static inline void
+ip_set_rcu_assign_u16(u16 *v, u16 value)
+{
+	IP_SET_RCU_ASSIGN(v, value);
+}
+
+static inline void
+ip_set_rcu_assign_u8(u8 *v, u8 value)
+{
+	IP_SET_RCU_ASSIGN(v, value);
+}
+
+#define ip_set_rcu_deref(t)		\
+	rcu_dereference_index_check(t,	\
+		rcu_read_lock_held() || rcu_read_lock_bh_held())
+
 static inline void
 ip_set_get_skbinfo(struct ip_set_skbinfo *skbinfo,
 		      const struct ip_set_ext *ext,
 		      struct ip_set_ext *mext, u32 flags)
 {
-		mext->skbmark = skbinfo->skbmark;
-		mext->skbmarkmask = skbinfo->skbmarkmask;
-		mext->skbprio = skbinfo->skbprio;
-		mext->skbqueue = skbinfo->skbqueue;
+		mext->skbmark = ip_set_rcu_deref(skbinfo->skbmark);
+		mext->skbmarkmask = ip_set_rcu_deref(skbinfo->skbmarkmask);
+		mext->skbprio = ip_set_rcu_deref(skbinfo->skbprio);
+		mext->skbqueue = ip_set_rcu_deref(skbinfo->skbqueue);
 }
 static inline bool
 ip_set_put_skbinfo(struct sk_buff *skb, struct ip_set_skbinfo *skbinfo)
 {
+	u32 skbmark, skbmarkmask, skbprio;
+	u16 skbqueue;
+
+	skbmark = ip_set_rcu_deref(skbinfo->skbmark);
+	skbmarkmask = ip_set_rcu_deref(skbinfo->skbmarkmask);
+	skbprio = ip_set_rcu_deref(skbinfo->skbprio);
+	skbqueue = ip_set_rcu_deref(skbinfo->skbqueue);
 	/* Send nonzero parameters only */
-	return ((skbinfo->skbmark || skbinfo->skbmarkmask) &&
+	return ((skbmark || skbmarkmask) &&
 		nla_put_net64(skb, IPSET_ATTR_SKBMARK,
-			      cpu_to_be64((u64)skbinfo->skbmark << 32 |
-					  skbinfo->skbmarkmask))) ||
-	       (skbinfo->skbprio &&
+			      cpu_to_be64((u64)skbmark << 32 |
+					  skbmarkmask))) ||
+	       (skbprio &&
 	        nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
-			      cpu_to_be32(skbinfo->skbprio))) ||
-	       (skbinfo->skbqueue &&
+			      cpu_to_be32(skbprio))) ||
+	       (skbqueue &&
 	        nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
-			     cpu_to_be16(skbinfo->skbqueue)));
+			     cpu_to_be16(skbqueue)));
 
 }
 
@@ -353,10 +395,10 @@ static inline void
 ip_set_init_skbinfo(struct ip_set_skbinfo *skbinfo,
 		    const struct ip_set_ext *ext)
 {
-	skbinfo->skbmark = ext->skbmark;
-	skbinfo->skbmarkmask = ext->skbmarkmask;
-	skbinfo->skbprio = ext->skbprio;
-	skbinfo->skbqueue = ext->skbqueue;
+	ip_set_rcu_assign_u32(&skbinfo->skbmark, ext->skbmark);
+	ip_set_rcu_assign_u32(&skbinfo->skbmarkmask, ext->skbmarkmask);
+	ip_set_rcu_assign_u32(&skbinfo->skbprio, ext->skbprio);
+	ip_set_rcu_assign_u16(&skbinfo->skbqueue, ext->skbqueue);
 }
 
 static inline bool
diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux/netfilter/ipset/ip_set_timeout.h
index 83c2f9e..9e30031 100644
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -40,38 +40,47 @@ ip_set_timeout_uget(struct nlattr *tb)
 }
 
 static inline bool
-ip_set_timeout_test(unsigned long timeout)
+__ip_set_timeout_expired(unsigned long t)
 {
-	return timeout == IPSET_ELEM_PERMANENT ||
-	       time_is_after_jiffies(timeout);
+	return t != IPSET_ELEM_PERMANENT && time_is_before_jiffies(t);
+}
+
+static inline bool
+ip_set_timeout_expired_rcu(unsigned long *timeout)
+{
+	unsigned long t = ip_set_rcu_deref(*timeout);
+
+	return __ip_set_timeout_expired(t);
 }
 
 static inline bool
 ip_set_timeout_expired(unsigned long *timeout)
 {
-	return *timeout != IPSET_ELEM_PERMANENT &&
-	       time_is_before_jiffies(*timeout);
+	return __ip_set_timeout_expired(*timeout);
 }
 
 static inline void
-ip_set_timeout_set(unsigned long *timeout, u32 t)
+ip_set_timeout_set(unsigned long *timeout, u32 value)
 {
-	if (!t) {
-		*timeout = IPSET_ELEM_PERMANENT;
-		return;
-	}
+	unsigned long t;
+
+	if (!value)
+		return ip_set_rcu_assign_ulong(timeout, IPSET_ELEM_PERMANENT);
 
-	*timeout = msecs_to_jiffies(t * 1000) + jiffies;
-	if (*timeout == IPSET_ELEM_PERMANENT)
+	t = msecs_to_jiffies(value * 1000) + jiffies;
+	if (t == IPSET_ELEM_PERMANENT)
 		/* Bingo! :-) */
-		(*timeout)--;
+		t--;
+	ip_set_rcu_assign_ulong(timeout, t);
 }
 
 static inline u32
 ip_set_timeout_get(unsigned long *timeout)
 {
-	return *timeout == IPSET_ELEM_PERMANENT ? 0 :
-		jiffies_to_msecs(*timeout - jiffies)/1000;
+	unsigned long t = ip_set_rcu_deref(*timeout);
+
+	return t == IPSET_ELEM_PERMANENT ? 0 :
+		jiffies_to_msecs(t - jiffies)/1000;
 }
 
 #endif	/* __KERNEL__ */
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 6f024a8..8d919cc 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -124,7 +124,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (ret <= 0)
 		return ret;
 	if (SET_WITH_TIMEOUT(set) &&
-	    ip_set_timeout_expired(ext_timeout(x, set)))
+	    ip_set_timeout_expired_rcu(ext_timeout(x, set)))
 		return 0;
 	if (SET_WITH_COUNTER(set))
 		ip_set_update_counter(ext_counter(x, set), ext, mext, flags);
@@ -216,7 +216,7 @@ mtype_list(const struct ip_set *set,
 #ifdef IP_SET_BITMAP_STORED_TIMEOUT
 		     mtype_is_filled((const struct mtype_elem *) x) &&
 #endif
-		     ip_set_timeout_expired(ext_timeout(x, set))))
+		     ip_set_timeout_expired_rcu(ext_timeout(x, set))))
 			continue;
 		nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
 		if (!nested) {
@@ -260,7 +260,7 @@ mtype_gc(unsigned long ul_set)
 
 	/* We run parallel with other readers (test element)
 	 * but adding/deleting new entries is locked out */
-	read_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	for (id = 0; id < map->elements; id++)
 		if (mtype_gc_test(id, map, set->dsize)) {
 			x = get_ext(set, map, id);
@@ -269,7 +269,7 @@ mtype_gc(unsigned long ul_set)
 				ip_set_ext_destroy(set, x);
 			}
 		}
-	read_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 
 	map->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
 	add_timer(&map->gc);
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 8610474..5e20c26 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -134,7 +134,7 @@ bitmap_ipmac_add_timeout(unsigned long *timeout,
 		if (e->ether)
 			ip_set_timeout_set(timeout, t);
 		else
-			*timeout = t;
+			ip_set_rcu_assign_ulong(timeout, t);
 	}
 	return 0;
 }
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 912e5a0..9fb2610 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -217,6 +217,7 @@ ip_set_type_register(struct ip_set_type *type)
 		 type->revision_min, type->revision_max);
 unlock:
 	ip_set_type_unlock();
+	synchronize_rcu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ip_set_type_register);
@@ -496,16 +497,16 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return 0;
 
-	read_lock_bh(&set->lock);
+	rcu_read_lock_bh();
 	ret = set->variant->kadt(set, skb, par, IPSET_TEST, opt);
-	read_unlock_bh(&set->lock);
+	rcu_read_unlock_bh();
 
 	if (ret == -EAGAIN) {
 		/* Type requests element to be completed */
 		pr_debug("element must be completed, ADD is triggered\n");
-		write_lock_bh(&set->lock);
+		spin_lock_bh(&set->lock);
 		set->variant->kadt(set, skb, par, IPSET_ADD, opt);
-		write_unlock_bh(&set->lock);
+		spin_unlock_bh(&set->lock);
 		ret = 1;
 	} else {
 		/* --return-nomatch: invert matched element */
@@ -535,9 +536,9 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return -IPSET_ERR_TYPE_MISMATCH;
 
-	write_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	ret = set->variant->kadt(set, skb, par, IPSET_ADD, opt);
-	write_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 
 	return ret;
 }
@@ -558,9 +559,9 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return -IPSET_ERR_TYPE_MISMATCH;
 
-	write_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	ret = set->variant->kadt(set, skb, par, IPSET_DEL, opt);
-	write_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 
 	return ret;
 }
@@ -845,7 +846,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 	set = kzalloc(sizeof(struct ip_set), GFP_KERNEL);
 	if (!set)
 		return -ENOMEM;
-	rwlock_init(&set->lock);
+	spin_lock_init(&set->lock);
 	strlcpy(set->name, name, IPSET_MAXNAMELEN);
 	set->family = family;
 	set->revision = revision;
@@ -1024,9 +1025,9 @@ ip_set_flush_set(struct ip_set *set)
 {
 	pr_debug("set: %s\n",  set->name);
 
-	write_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	set->variant->flush(set);
-	write_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 }
 
 static int
@@ -1327,9 +1328,9 @@ dump_last:
 				goto next_set;
 			/* Fall through and add elements */
 		default:
-			read_lock_bh(&set->lock);
+			rcu_read_lock_bh();
 			ret = set->variant->list(set, skb, cb);
-			read_unlock_bh(&set->lock);
+			rcu_read_unlock_bh();
 			if (!cb->args[IPSET_CB_ARG0])
 				/* Set is done, proceed with next one */
 				goto next_set;
@@ -1407,9 +1408,9 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 	bool eexist = flags & IPSET_FLAG_EXIST, retried = false;
 
 	do {
-		write_lock_bh(&set->lock);
+		spin_lock_bh(&set->lock);
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
-		write_unlock_bh(&set->lock);
+		spin_unlock_bh(&set->lock);
 		retried = true;
 	} while (ret == -EAGAIN &&
 		 set->variant->resize &&
@@ -1589,9 +1590,9 @@ ip_set_utest(struct sock *ctnl, struct sk_buff *skb,
 			     set->type->adt_policy))
 		return -IPSET_ERR_PROTOCOL;
 
-	read_lock_bh(&set->lock);
+	rcu_read_lock_bh();
 	ret = set->variant->uadt(set, tb, IPSET_TEST, NULL, 0, 0);
-	read_unlock_bh(&set->lock);
+	rcu_read_unlock_bh();
 	/* Userspace can't trigger element to be re-added */
 	if (ret == -EAGAIN)
 		ret = 1;
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 974ff38..f889d98 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -10,9 +10,10 @@
 
 #include <linux/rcupdate.h>
 #include <linux/jhash.h>
+#include <linux/types.h>
 #include <linux/netfilter/ipset/ip_set_timeout.h>
-#ifndef rcu_dereference_bh
-#define rcu_dereference_bh(p)	rcu_dereference(p)
+#ifndef rcu_dereference_bh_check
+#define rcu_dereference_bh_check(p, c)	rcu_dereference_bh(p)
 #endif
 
 #define rcu_dereference_bh_nfnl(p)	rcu_dereference_bh_check(p, 1)
@@ -20,9 +21,7 @@
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
@@ -36,6 +35,8 @@
 #define AHASH_INIT_SIZE			4
 /* Max number of elements to store in an array block */
 #define AHASH_MAX_SIZE			(3*AHASH_INIT_SIZE)
+/* Max muber of elements in the array block when tuned */
+#define AHASH_MAX_TUNED			64
 
 /* Max number of elements can be tuned */
 #ifdef IP_SET_HASH_WITH_MULTI
@@ -53,7 +54,7 @@ tune_ahash_max(u8 curr, u32 multi)
 	/* Currently, at listing one hash bucket must fit into a message.
 	 * Therefore we have a hard limit here.
 	 */
-	return n > curr && n <= 64 ? n : curr;
+	return n > curr && n <= AHASH_MAX_TUNED ? n : curr;
 }
 #define TUNE_AHASH_MAX(h, multi)	\
 	((h)->ahash_max = tune_ahash_max((h)->ahash_max, multi))
@@ -64,18 +65,21 @@ tune_ahash_max(u8 curr, u32 multi)
 
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
+	struct hbucket * __rcu bucket[0]; /* hashtable buckets */
 };
 
-#define hbucket(h, i)		(&((h)->bucket[i]))
+#define hbucket(h, i)		((h)->bucket[i])
 
 #ifndef IPSET_NET_COUNT
 #define IPSET_NET_COUNT		1
@@ -83,8 +87,8 @@ struct htable {
 
 /* Book-keeping of the prefixes added to the set */
 struct net_prefixes {
-	u32 nets[IPSET_NET_COUNT]; /* number of elements per cidr */
-	u8 cidr[IPSET_NET_COUNT];  /* the different cidr values in the set */
+	u32 nets[IPSET_NET_COUNT]; /* number of elements for this cidr */
+	u8 cidr[IPSET_NET_COUNT];  /* the cidr value */
 };
 
 /* Compute the hash table size */
@@ -97,11 +101,11 @@ htable_size(u8 hbits)
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
@@ -110,6 +114,7 @@ htable_bits(u32 hashsize)
 {
 	/* Assume that hashsize == 2^htable_bits */
 	u8 bits = fls(hashsize - 1);
+
 	if (jhash_size(bits) != hashsize)
 		/* Round up to the first 2^n value */
 		bits = fls(hashsize);
@@ -117,30 +122,6 @@ htable_bits(u32 hashsize)
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
@@ -280,9 +261,6 @@ struct htype {
 #ifdef IP_SET_HASH_WITH_NETMASK
 	u8 netmask;		/* netmask value for subnets to store */
 #endif
-#ifdef IP_SET_HASH_WITH_RBTREE
-	struct rb_root rbtree;
-#endif
 #ifdef IP_SET_HASH_WITH_NETS
 	struct net_prefixes nets[0]; /* book-keeping of prefixes */
 #endif
@@ -324,8 +302,8 @@ mtype_del_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
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
@@ -341,15 +319,18 @@ mtype_ahash_memsize(const struct htype *h, const struct htable *t,
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
@@ -364,7 +345,8 @@ mtype_ext_cleanup(struct ip_set *set, struct hbucket *n)
 	int i;
 
 	for (i = 0; i < n->pos; i++)
-		ip_set_ext_destroy(set, ahash_data(n, i, set->dsize));
+		if (test_bit(i, n->used))
+			ip_set_ext_destroy(set, ahash_data(n, i, set->dsize));
 }
 
 /* Flush a hash type of set: destroy all elements */
@@ -376,16 +358,16 @@ mtype_flush(struct ip_set *set)
 	struct hbucket *n;
 	u32 i;
 
-	t = rcu_dereference_bh_nfnl(h->table);
+	t = h->table;
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
 		n = hbucket(t, i);
-		if (n->size) {
-			if (set->extensions & IPSET_EXT_DESTROY)
-				mtype_ext_cleanup(set, n);
-			n->size = n->pos = 0;
-			/* FIXME: use slab cache */
-			kfree(n->value);
-		}
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
@@ -402,12 +384,12 @@ mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
 
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
 		n = hbucket(t, i);
-		if (n->size) {
-			if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
-				mtype_ext_cleanup(set, n);
-			/* FIXME: use slab cache */
-			kfree(n->value);
-		}
+		if (n == NULL)
+			continue;
+		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
+			mtype_ext_cleanup(set, n);
+		/* FIXME: use slab cache */
+		kfree(n);
 	}
 
 	ip_set_free(t);
@@ -422,10 +404,7 @@ mtype_destroy(struct ip_set *set)
 	if (set->extensions & IPSET_EXT_TIMEOUT)
 		del_timer_sync(&h->gc);
 
-	mtype_ahash_destroy(set, rcu_dereference_bh_nfnl(h->table), true);
-#ifdef IP_SET_HASH_WITH_RBTREE
-	rbtree_destroy(&h->rbtree);
-#endif
+	mtype_ahash_destroy(set, h->table, true);
 	kfree(h);
 
 	set->data = NULL;
@@ -470,17 +449,22 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
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
+	BUG_ON(!spin_is_locked(&set->lock));
+	t = h->table;
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
 		n = hbucket(t, i);
-		for (j = 0; j < n->pos; j++) {
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
@@ -490,29 +474,32 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
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
@@ -522,9 +509,9 @@ mtype_gc(unsigned long ul_set)
 	struct htype *h = set->data;
 
 	pr_debug("called\n");
-	write_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	mtype_expire(set, h, NLEN(set->family), set->dsize);
-	write_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 
 	h->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
 	add_timer(&h->gc);
@@ -537,75 +524,110 @@ static int
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
+	unsigned char _tmp[dsize];
+	struct mtype_elem *tmp = (struct mtype_elem *) &_tmp;
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
+	orig = h->table;
+	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
+		 set->name, orig->htable_bits, htable_bits, orig);
 	for (i = 0; i < jhash_size(orig->htable_bits); i++) {
 		n = hbucket(orig, i);
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
+			m = hbucket(t, key);
+			if (!m) {
+				m = kzalloc(sizeof(struct hbucket) +
+					    AHASH_INIT_SIZE * dsize,
+					    GFP_ATOMIC);
+				if (!m)
+					ret = -ENOMEM;
+				m->size = AHASH_INIT_SIZE;
+				hbucket(t, key) = m;
+			} else if (m->pos >= m->size) {
+				struct hbucket *tmp;
+
+				if (m->size >= AHASH_MAX(h))
+					ret = -EAGAIN;
+				else {
+					tmp = kzalloc(sizeof(struct hbucket) +
+						(m->size + AHASH_INIT_SIZE)
+						* dsize,
+						GFP_ATOMIC);
+					if (!tmp)
+						ret = -ENOMEM;
+				}
+				if (ret < 0) {
+					spin_unlock_bh(&set->lock);
+					mtype_ahash_destroy(set, t, false);
+					if (ret == -EAGAIN)
+						goto retry;
+					return ret;
+				}
+				memcpy(tmp, m, sizeof(struct hbucket) +
+					       m->size * dsize);
+				tmp->size = m->size + AHASH_INIT_SIZE;
+				kfree(m);
+				m = hbucket(t, key) = tmp;
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
@@ -615,6 +637,10 @@ retry:
 	mtype_ahash_destroy(set, orig, false);
 
 	return 0;
+
+out:
+	spin_unlock_bh(&set->lock);
+	return ret;
 }
 
 /* Add an element to a hash and update the internal counters when succeeded,
@@ -627,17 +653,49 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
+	t = h->table;
 	key = HKEY(value, h->initval, t->htable_bits);
 	n = hbucket(t, key);
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
@@ -645,85 +703,92 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
@@ -734,29 +799,31 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
+	t = h->table;
 	key = HKEY(value, h->initval, t->htable_bits);
 	n = hbucket(t, key);
-	for (i = 0; i < n->pos; i++) {
-		data = ahash_data(n, i, set->dsize);
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
@@ -764,25 +831,37 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
 
@@ -832,8 +911,12 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
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
@@ -871,7 +954,6 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	int i, ret = 0;
 	u32 key, multi = 0;
 
-	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 #ifdef IP_SET_HASH_WITH_NETS
 	/* If we test an IP address and not a network address,
@@ -886,8 +968,14 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
@@ -897,7 +985,6 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		}
 	}
 out:
-	rcu_read_unlock_bh();
 	return ret;
 }
 
@@ -909,15 +996,19 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
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
@@ -947,26 +1038,32 @@ mtype_list(const struct ip_set *set,
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
+		n = rcu_dereference_bh(hbucket(t, cb->args[IPSET_CB_ARG0]));
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
@@ -977,7 +1074,8 @@ mtype_list(const struct ip_set *set,
 			if (!nested) {
 				if (cb->args[IPSET_CB_ARG0] == first) {
 					nla_nest_cancel(skb, atd);
-					return -EMSGSIZE;
+					ret = -EMSGSIZE;
+					goto out;
 				} else
 					goto nla_put_failure;
 			}
@@ -992,7 +1090,7 @@ mtype_list(const struct ip_set *set,
 	/* Set listing finished */
 	cb->args[IPSET_CB_ARG0] = 0;
 
-	return 0;
+	goto out;
 
 nla_put_failure:
 	nlmsg_trim(skb, incomplete);
@@ -1000,10 +1098,11 @@ nla_put_failure:
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
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index f8f6828..323115a 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/ip.h>
+#include <linux/rculist.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
 
@@ -27,6 +28,8 @@ MODULE_ALIAS("ip_set_list:set");
 
 /* Member elements  */
 struct set_elem {
+	struct rcu_head rcu;
+	struct list_head list;
 	ip_set_id_t id;
 };
 
@@ -41,12 +44,9 @@ struct list_set {
 	u32 size;		/* size of set list array */
 	struct timer_list gc;	/* garbage collection */
 	struct net *net;	/* namespace */
-	struct set_elem members[0]; /* the set members */
+	struct list_head members; /* the set members */
 };
 
-#define list_set_elem(set, map, id)	\
-	(struct set_elem *)((void *)(map)->members + (id) * (set)->dsize)
-
 static int
 list_set_ktest(struct ip_set *set, const struct sk_buff *skb,
 	       const struct xt_action_param *par,
@@ -54,17 +54,14 @@ list_set_ktest(struct ip_set *set, const struct sk_buff *skb,
 {
 	struct list_set *map = set->data;
 	struct set_elem *e;
-	u32 i, cmdflags = opt->cmdflags;
+	u32 cmdflags = opt->cmdflags;
 	int ret;
 
 	/* Don't lookup sub-counters at all */
 	opt->cmdflags &= ~IPSET_FLAG_MATCH_COUNTERS;
 	if (opt->cmdflags & IPSET_FLAG_SKIP_SUBCOUNTER_UPDATE)
 		opt->cmdflags &= ~IPSET_FLAG_SKIP_COUNTER_UPDATE;
-	for (i = 0; i < map->size; i++) {
-		e = list_set_elem(set, map, i);
-		if (e->id == IPSET_INVALID_ID)
-			return 0;
+	list_for_each_entry_rcu(e, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -91,13 +88,9 @@ list_set_kadd(struct ip_set *set, const struct sk_buff *skb,
 {
 	struct list_set *map = set->data;
 	struct set_elem *e;
-	u32 i;
 	int ret;
 
-	for (i = 0; i < map->size; i++) {
-		e = list_set_elem(set, map, i);
-		if (e->id == IPSET_INVALID_ID)
-			return 0;
+	list_for_each_entry_rcu(e, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -115,13 +108,9 @@ list_set_kdel(struct ip_set *set, const struct sk_buff *skb,
 {
 	struct list_set *map = set->data;
 	struct set_elem *e;
-	u32 i;
 	int ret;
 
-	for (i = 0; i < map->size; i++) {
-		e = list_set_elem(set, map, i);
-		if (e->id == IPSET_INVALID_ID)
-			return 0;
+	list_for_each_entry_rcu(e, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -138,110 +127,65 @@ list_set_kadt(struct ip_set *set, const struct sk_buff *skb,
 	      enum ipset_adt adt, struct ip_set_adt_opt *opt)
 {
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+	int ret = -EINVAL;
 
+	rcu_read_lock();
 	switch (adt) {
 	case IPSET_TEST:
-		return list_set_ktest(set, skb, par, opt, &ext);
+		ret = list_set_ktest(set, skb, par, opt, &ext);
+		break;
 	case IPSET_ADD:
-		return list_set_kadd(set, skb, par, opt, &ext);
+		ret = list_set_kadd(set, skb, par, opt, &ext);
+		break;
 	case IPSET_DEL:
-		return list_set_kdel(set, skb, par, opt, &ext);
+		ret = list_set_kdel(set, skb, par, opt, &ext);
+		break;
 	default:
 		break;
 	}
-	return -EINVAL;
-}
+	rcu_read_unlock();
 
-static bool
-id_eq(const struct ip_set *set, u32 i, ip_set_id_t id)
-{
-	const struct list_set *map = set->data;
-	const struct set_elem *e;
-
-	if (i >= map->size)
-		return 0;
-
-	e = list_set_elem(set, map, i);
-	return !!(e->id == id &&
-		 !(SET_WITH_TIMEOUT(set) &&
-		   ip_set_timeout_expired(ext_timeout(e, set))));
+	return ret;
 }
 
-static int
-list_set_add(struct ip_set *set, u32 i, struct set_adt_elem *d,
-	     const struct ip_set_ext *ext)
-{
-	struct list_set *map = set->data;
-	struct set_elem *e = list_set_elem(set, map, i);
-
-	if (e->id != IPSET_INVALID_ID) {
-		if (i == map->size - 1) {
-			/* Last element replaced: e.g. add new,before,last */
-			ip_set_put_byindex(map->net, e->id);
-			ip_set_ext_destroy(set, e);
-		} else {
-			struct set_elem *x = list_set_elem(set, map,
-							   map->size - 1);
-
-			/* Last element pushed off */
-			if (x->id != IPSET_INVALID_ID) {
-				ip_set_put_byindex(map->net, x->id);
-				ip_set_ext_destroy(set, x);
-			}
-			memmove(list_set_elem(set, map, i + 1), e,
-				set->dsize * (map->size - (i + 1)));
-			/* Extensions must be initialized to zero */
-			memset(e, 0, set->dsize);
-		}
-	}
-
-	e->id = d->id;
-	if (SET_WITH_TIMEOUT(set))
-		ip_set_timeout_set(ext_timeout(e, set), ext->timeout);
-	if (SET_WITH_COUNTER(set))
-		ip_set_init_counter(ext_counter(e, set), ext);
-	if (SET_WITH_COMMENT(set))
-		ip_set_init_comment(ext_comment(e, set), ext);
-	if (SET_WITH_SKBINFO(set))
-		ip_set_init_skbinfo(ext_skbinfo(e, set), ext);
-	return 0;
-}
+/* Userspace interfaces: we are protected by the nfnl mutex */
 
-static int
-list_set_del(struct ip_set *set, u32 i)
+static void
+__list_set_del(struct ip_set *set, struct set_elem *e)
 {
 	struct list_set *map = set->data;
-	struct set_elem *e = list_set_elem(set, map, i);
 
 	ip_set_put_byindex(map->net, e->id);
+	/* We may call it, because we don't have a to be destroyed
+	 * extension which is used by the kernel.
+	 */
 	ip_set_ext_destroy(set, e);
+	kfree_rcu(e, rcu);
+}
 
-	if (i < map->size - 1)
-		memmove(e, list_set_elem(set, map, i + 1),
-			set->dsize * (map->size - (i + 1)));
+static inline void
+list_set_del(struct ip_set *set, struct set_elem *e)
+{
+	list_del_rcu(&e->list);
+	__list_set_del(set, e);
+}
 
-	/* Last element */
-	e = list_set_elem(set, map, map->size - 1);
-	e->id = IPSET_INVALID_ID;
-	return 0;
+static inline void
+list_set_replace(struct ip_set *set, struct set_elem *e, struct set_elem *old)
+{
+	list_replace_rcu(&old->list, &e->list);
+	__list_set_del(set, old);
 }
 
 static void
 set_cleanup_entries(struct ip_set *set)
 {
 	struct list_set *map = set->data;
-	struct set_elem *e;
-	u32 i = 0;
+	struct set_elem *e, *n;
 
-	while (i < map->size) {
-		e = list_set_elem(set, map, i);
-		if (e->id != IPSET_INVALID_ID &&
-		    ip_set_timeout_expired(ext_timeout(e, set)))
-			list_set_del(set, i);
-			/* Check element moved to position i in next loop */
-		else
-			i++;
-	}
+	list_for_each_entry_safe(e, n, &map->members, list)
+		if (ip_set_timeout_expired(ext_timeout(e, set)))
+			list_set_del(set, e);
 }
 
 static int
@@ -250,31 +194,45 @@ list_set_utest(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 {
 	struct list_set *map = set->data;
 	struct set_adt_elem *d = value;
-	struct set_elem *e;
-	u32 i;
+	struct set_elem *e, *next, *prev = NULL;
 	int ret;
 
-	for (i = 0; i < map->size; i++) {
-		e = list_set_elem(set, map, i);
-		if (e->id == IPSET_INVALID_ID)
-			return 0;
-		else if (SET_WITH_TIMEOUT(set) &&
-			 ip_set_timeout_expired(ext_timeout(e, set)))
+	list_for_each_entry(e, &map->members, list) {
+		if (SET_WITH_TIMEOUT(set) &&
+		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
-		else if (e->id != d->id)
+		else if (e->id != d->id) {
+			prev = e;
 			continue;
+		}
 
 		if (d->before == 0)
-			return 1;
-		else if (d->before > 0)
-			ret = id_eq(set, i + 1, d->refid);
-		else
-			ret = i > 0 && id_eq(set, i - 1, d->refid);
+			ret = 1;
+		else if (d->before > 0) {
+			next = list_next_entry(e, list);
+			ret = !list_is_last(&e->list, &map->members) &&
+			      next->id == d->refid;
+		} else
+			ret = prev != NULL && prev->id == d->refid;
 		return ret;
 	}
 	return 0;
 }
 
+static void
+list_set_init_extensions(struct ip_set *set, const struct ip_set_ext *ext,
+			 struct set_elem *e)
+{
+	if (SET_WITH_COUNTER(set))
+		ip_set_init_counter(ext_counter(e, set), ext);
+	if (SET_WITH_COMMENT(set))
+		ip_set_init_comment(ext_comment(e, set), ext);
+	if (SET_WITH_SKBINFO(set))
+		ip_set_init_skbinfo(ext_skbinfo(e, set), ext);
+	/* Update timeout last */
+	if (SET_WITH_TIMEOUT(set))
+		ip_set_timeout_set(ext_timeout(e, set), ext->timeout);
+}
 
 static int
 list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
@@ -282,60 +240,82 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 {
 	struct list_set *map = set->data;
 	struct set_adt_elem *d = value;
-	struct set_elem *e;
+	struct set_elem *e, *n, *prev, *next;
 	bool flag_exist = flags & IPSET_FLAG_EXIST;
-	u32 i, ret = 0;
 
 	if (SET_WITH_TIMEOUT(set))
 		set_cleanup_entries(set);
 
-	/* Check already added element */
-	for (i = 0; i < map->size; i++) {
-		e = list_set_elem(set, map, i);
-		if (e->id == IPSET_INVALID_ID)
-			goto insert;
-		else if (e->id != d->id)
+	/* Find where to add the new entry */
+	n = prev = next = NULL;
+	list_for_each_entry(e, &map->members, list) {
+		if (SET_WITH_TIMEOUT(set) &&
+		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
-
-		if ((d->before > 1 && !id_eq(set, i + 1, d->refid)) ||
-		    (d->before < 0 &&
-		     (i == 0 || !id_eq(set, i - 1, d->refid))))
-			/* Before/after doesn't match */
+		else if (d->id == e->id)
+			n = e;
+		else if (d->before == 0 || e->id != d->refid)
+			continue;
+		else if (d->before > 0)
+			next = e;
+		else
+			prev = e;
+	}
+	/* Re-add already existing element */
+	if (n) {
+		if ((d->before > 0 && !next) ||
+		    (d->before < 0 && !prev))
 			return -IPSET_ERR_REF_EXIST;
 		if (!flag_exist)
-			/* Can't re-add */
 			return -IPSET_ERR_EXIST;
 		/* Update extensions */
-		ip_set_ext_destroy(set, e);
+		ip_set_ext_destroy(set, n);
+		list_set_init_extensions(set, ext, n);
 
-		if (SET_WITH_TIMEOUT(set))
-			ip_set_timeout_set(ext_timeout(e, set), ext->timeout);
-		if (SET_WITH_COUNTER(set))
-			ip_set_init_counter(ext_counter(e, set), ext);
-		if (SET_WITH_COMMENT(set))
-			ip_set_init_comment(ext_comment(e, set), ext);
-		if (SET_WITH_SKBINFO(set))
-			ip_set_init_skbinfo(ext_skbinfo(e, set), ext);
 		/* Set is already added to the list */
 		ip_set_put_byindex(map->net, d->id);
 		return 0;
 	}
-insert:
-	ret = -IPSET_ERR_LIST_FULL;
-	for (i = 0; i < map->size && ret == -IPSET_ERR_LIST_FULL; i++) {
-		e = list_set_elem(set, map, i);
-		if (e->id == IPSET_INVALID_ID)
-			ret = d->before != 0 ? -IPSET_ERR_REF_EXIST
-				: list_set_add(set, i, d, ext);
-		else if (e->id != d->refid)
-			continue;
-		else if (d->before > 0)
-			ret = list_set_add(set, i, d, ext);
-		else if (i + 1 < map->size)
-			ret = list_set_add(set, i + 1, d, ext);
+	/* Add new entry */
+	if (d->before == 0) {
+		/* Append  */
+		n = list_empty(&map->members) ? NULL :
+		    list_last_entry(&map->members, struct set_elem, list);
+	} else if (d->before > 0) {
+		/* Insert after next element */
+		if (!list_is_last(&next->list, &map->members))
+			n = list_next_entry(next, list);
+	} else {
+		/* Insert before prev element */
+		if (prev->list.prev != &map->members)
+			n = list_prev_entry(prev, list);
 	}
-
-	return ret;
+	/* Can we replace a timed out entry? */
+	if (n != NULL &&
+	    !(SET_WITH_TIMEOUT(set) &&
+	      ip_set_timeout_expired(ext_timeout(n, set))))
+		n =  NULL;
+
+	e = kzalloc(set->dsize, GFP_KERNEL);
+	if (!e)
+		return -ENOMEM;
+	e->id = d->id;
+	INIT_LIST_HEAD(&e->list);
+	list_set_init_extensions(set, ext, e);
+	if (n)
+		list_set_replace(set, e, n);
+	else if (next)
+		list_add_tail_rcu(&e->list, &next->list);
+	else if (prev)
+		list_add_rcu(&e->list, &prev->list);
+	else
+		list_add_tail_rcu(&e->list, &map->members);
+	spin_unlock_bh(&set->lock);
+
+	synchronize_rcu_bh();
+
+	spin_lock_bh(&set->lock);
+	return 0;
 }
 
 static int
@@ -344,32 +324,30 @@ list_set_udel(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 {
 	struct list_set *map = set->data;
 	struct set_adt_elem *d = value;
-	struct set_elem *e;
-	u32 i;
-
-	for (i = 0; i < map->size; i++) {
-		e = list_set_elem(set, map, i);
-		if (e->id == IPSET_INVALID_ID)
-			return d->before != 0 ? -IPSET_ERR_REF_EXIST
-					      : -IPSET_ERR_EXIST;
-		else if (SET_WITH_TIMEOUT(set) &&
-			 ip_set_timeout_expired(ext_timeout(e, set)))
+	struct set_elem *e, *next, *prev = NULL;
+
+	list_for_each_entry(e, &map->members, list) {
+		if (SET_WITH_TIMEOUT(set) &&
+		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
-		else if (e->id != d->id)
+		else if (e->id != d->id) {
+			prev = e;
 			continue;
+		}
 
-		if (d->before == 0)
-			return list_set_del(set, i);
-		else if (d->before > 0) {
-			if (!id_eq(set, i + 1, d->refid))
+		if (d->before > 0) {
+			next = list_next_entry(e, list);
+			if (list_is_last(&e->list, &map->members) ||
+			    next->id != d->refid)
 				return -IPSET_ERR_REF_EXIST;
-			return list_set_del(set, i);
-		} else if (i == 0 || !id_eq(set, i - 1, d->refid))
-			return -IPSET_ERR_REF_EXIST;
-		else
-			return list_set_del(set, i);
+		} else if (d->before < 0) {
+			if (prev == NULL || prev->id != d->refid)
+				return -IPSET_ERR_REF_EXIST;
+		}
+		list_set_del(set, e);
+		return 0;
 	}
-	return -IPSET_ERR_EXIST;
+	return d->before != 0 ? -IPSET_ERR_REF_EXIST : -IPSET_ERR_EXIST;
 }
 
 static int
@@ -410,6 +388,7 @@ list_set_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 f = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		e.before = f & IPSET_FLAG_BEFORE;
 	}
 
@@ -447,27 +426,26 @@ static void
 list_set_flush(struct ip_set *set)
 {
 	struct list_set *map = set->data;
-	struct set_elem *e;
-	u32 i;
-
-	for (i = 0; i < map->size; i++) {
-		e = list_set_elem(set, map, i);
-		if (e->id != IPSET_INVALID_ID) {
-			ip_set_put_byindex(map->net, e->id);
-			ip_set_ext_destroy(set, e);
-			e->id = IPSET_INVALID_ID;
-		}
-	}
+	struct set_elem *e, *n;
+
+	list_for_each_entry_safe(e, n, &map->members, list)
+		list_set_del(set, e);
 }
 
 static void
 list_set_destroy(struct ip_set *set)
 {
 	struct list_set *map = set->data;
+	struct set_elem *e, *n;
 
 	if (SET_WITH_TIMEOUT(set))
 		del_timer_sync(&map->gc);
-	list_set_flush(set);
+	list_for_each_entry_safe(e, n, &map->members, list) {
+		list_del(&e->list);
+		ip_set_put_byindex(map->net, e->id);
+		ip_set_ext_destroy(set, e);
+		kfree(e);
+	}
 	kfree(map);
 
 	set->data = NULL;
@@ -478,6 +456,11 @@ list_set_head(struct ip_set *set, struct sk_buff *skb)
 {
 	const struct list_set *map = set->data;
 	struct nlattr *nested;
+	struct set_elem *e;
+	u32 n = 0;
+
+	list_for_each_entry(e, &map->members, list)
+		n++;
 
 	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
@@ -485,7 +468,7 @@ list_set_head(struct ip_set *set, struct sk_buff *skb)
 	if (nla_put_net32(skb, IPSET_ATTR_SIZE, htonl(map->size)) ||
 	    nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref - 1)) ||
 	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE,
-			  htonl(sizeof(*map) + map->size * set->dsize)))
+			  htonl(sizeof(*map) + n * set->dsize)))
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
@@ -502,18 +485,20 @@ list_set_list(const struct ip_set *set,
 {
 	const struct list_set *map = set->data;
 	struct nlattr *atd, *nested;
-	u32 i, first = cb->args[IPSET_CB_ARG0];
-	const struct set_elem *e;
+	u32 i = 0, first = cb->args[IPSET_CB_ARG0];
+	struct set_elem *e;
 
 	atd = ipset_nest_start(skb, IPSET_ATTR_ADT);
 	if (!atd)
 		return -EMSGSIZE;
-	for (; cb->args[IPSET_CB_ARG0] < map->size;
-	     cb->args[IPSET_CB_ARG0]++) {
-		i = cb->args[IPSET_CB_ARG0];
-		e = list_set_elem(set, map, i);
-		if (e->id == IPSET_INVALID_ID)
-			goto finish;
+	list_for_each_entry(e, &map->members, list) {
+		if (i == first)
+			break;
+		i++;
+	}
+
+	list_for_each_entry_from(e, &map->members, list) {
+		i++;
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -532,7 +517,7 @@ list_set_list(const struct ip_set *set,
 			goto nla_put_failure;
 		ipset_nest_end(skb, nested);
 	}
-finish:
+
 	ipset_nest_end(skb, atd);
 	/* Set listing finished */
 	cb->args[IPSET_CB_ARG0] = 0;
@@ -544,6 +529,7 @@ nla_put_failure:
 		cb->args[IPSET_CB_ARG0] = 0;
 		return -EMSGSIZE;
 	}
+	cb->args[IPSET_CB_ARG0] = i - 1;
 	ipset_nest_end(skb, atd);
 	return 0;
 }
@@ -580,9 +566,9 @@ list_set_gc(unsigned long ul_set)
 	struct ip_set *set = (struct ip_set *) ul_set;
 	struct list_set *map = set->data;
 
-	write_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	set_cleanup_entries(set);
-	write_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 
 	map->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
 	add_timer(&map->gc);
@@ -606,24 +592,16 @@ static bool
 init_list_set(struct net *net, struct ip_set *set, u32 size)
 {
 	struct list_set *map;
-	struct set_elem *e;
-	u32 i;
 
-	map = kzalloc(sizeof(*map) +
-		      min_t(u32, size, IP_SET_LIST_MAX_SIZE) * set->dsize,
-		      GFP_KERNEL);
+	map = kzalloc(sizeof(*map), GFP_KERNEL);
 	if (!map)
 		return false;
 
 	map->size = size;
 	map->net = net;
+	INIT_LIST_HEAD(&map->members);
 	set->data = map;
 
-	for (i = 0; i < size; i++) {
-		e = list_set_elem(set, map, i);
-		e->id = IPSET_INVALID_ID;
-	}
-
 	return true;
 }
 
-- 
1.8.5.1

