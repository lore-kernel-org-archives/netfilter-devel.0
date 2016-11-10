From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 10/22] netfilter: ipset: Add element count to all set types header
Date: Thu, 10 Nov 2016 13:57:44 +0100
Message-ID: <1478782676-9770-11-git-send-email-kadlec@blackhole.kfki.hu>
References: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:49011 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932961AbcKJM6I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:08 -0500
In-Reply-To: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is better to list the set elements for all set types, thus the
header information is uniform. Element counts are therefore added
to the bitmap and list types.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h        |  2 ++
 include/linux/netfilter/ipset/ip_set_bitmap.h |  2 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h       | 10 +++++++++-
 net/netfilter/ipset/ip_set_hash_gen.h         | 21 ++++++++++-----------
 net/netfilter/ipset/ip_set_list_set.c         |  6 +++++-
 5 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 7a218eb..4671d74 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -250,6 +250,8 @@ struct ip_set {
 	u8 flags;
 	/* Default timeout value, if enabled */
 	u32 timeout;
+	/* Number of elements (vs timeout) */
+	u32 elements;
 	/* Element data size */
 	size_t dsize;
 	/* Offsets to extensions in elements */
diff --git a/include/linux/netfilter/ipset/ip_set_bitmap.h b/include/linux/netfilter/ipset/ip_set_bitmap.h
index 5e4662a..366d6c0 100644
--- a/include/linux/netfilter/ipset/ip_set_bitmap.h
+++ b/include/linux/netfilter/ipset/ip_set_bitmap.h
@@ -6,8 +6,8 @@
 #define IPSET_BITMAP_MAX_RANGE	0x0000FFFF
 
 enum {
+	IPSET_ADD_STORE_PLAIN_TIMEOUT = -1,
 	IPSET_ADD_FAILED = 1,
-	IPSET_ADD_STORE_PLAIN_TIMEOUT,
 	IPSET_ADD_START_STORED_TIMEOUT,
 };
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 4f07b90..1810d1c 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -83,6 +83,7 @@
 	if (set->extensions & IPSET_EXT_DESTROY)
 		mtype_ext_cleanup(set);
 	memset(map->members, 0, map->memsize);
+	set->elements = 0;
 }
 
 /* Calculate the actual memory size of the set data */
@@ -105,7 +106,8 @@
 		goto nla_put_failure;
 	if (mtype_do_head(skb, map) ||
 	    nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref)) ||
-	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)))
+	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
+	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(set->elements)))
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
@@ -149,6 +151,7 @@
 	if (ret == IPSET_ADD_FAILED) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(x, set))) {
+			set->elements--;
 			ret = 0;
 		} else if (!(flags & IPSET_FLAG_EXIST)) {
 			set_bit(e->id, map->members);
@@ -157,6 +160,8 @@
 		/* Element is re-added, cleanup extensions */
 		ip_set_ext_destroy(set, x);
 	}
+	if (ret > 0)
+		set->elements--;
 
 	if (SET_WITH_TIMEOUT(set))
 #ifdef IP_SET_BITMAP_STORED_TIMEOUT
@@ -174,6 +179,7 @@
 
 	/* Activate element */
 	set_bit(e->id, map->members);
+	set->elements++;
 
 	return 0;
 }
@@ -190,6 +196,7 @@
 		return -IPSET_ERR_EXIST;
 
 	ip_set_ext_destroy(set, x);
+	set->elements--;
 	if (SET_WITH_TIMEOUT(set) &&
 	    ip_set_timeout_expired(ext_timeout(x, set)))
 		return -IPSET_ERR_EXIST;
@@ -285,6 +292,7 @@
 			if (ip_set_timeout_expired(ext_timeout(x, set))) {
 				clear_bit(id, map->members);
 				ip_set_ext_destroy(set, x);
+				set->elements--;
 			}
 		}
 	spin_unlock_bh(&set->lock);
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index f5acfb9..6e967f1 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -275,7 +275,6 @@ struct net_prefixes {
 struct htype {
 	struct htable __rcu *table; /* the hash table */
 	u32 maxelem;		/* max elements in the hash */
-	u32 elements;		/* current element (vs timeout) */
 	u32 initval;		/* random jhash init value */
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	u32 markmask;		/* markmask value for mark mask to store */
@@ -400,7 +399,7 @@ struct htype {
 #ifdef IP_SET_HASH_WITH_NETS
 	memset(h->nets, 0, sizeof(struct net_prefixes) * NLEN(set->family));
 #endif
-	h->elements = 0;
+	set->elements = 0;
 }
 
 /* Destroy the hashtable part of the set */
@@ -506,7 +505,7 @@ struct htype {
 						nets_length, k);
 #endif
 				ip_set_ext_destroy(set, data);
-				h->elements--;
+				set->elements--;
 				d++;
 			}
 		}
@@ -715,11 +714,11 @@ struct htype {
 	bool deleted = false, forceadd = false, reuse = false;
 	u32 key, multi = 0;
 
-	if (h->elements >= h->maxelem) {
+	if (set->elements >= h->maxelem) {
 		if (SET_WITH_TIMEOUT(set))
 			/* FIXME: when set is full, we slow down here */
 			mtype_expire(set, h, NLEN(set->family), set->dsize);
-		if (h->elements >= h->maxelem && SET_WITH_FORCEADD(set))
+		if (set->elements >= h->maxelem && SET_WITH_FORCEADD(set))
 			forceadd = true;
 	}
 
@@ -732,7 +731,7 @@ struct htype {
 				pr_warn("Set %s is full, maxelem %u reached\n",
 					set->name, h->maxelem);
 			return -IPSET_ERR_HASH_FULL;
-		} else if (h->elements >= h->maxelem) {
+		} else if (set->elements >= h->maxelem) {
 			goto set_full;
 		}
 		old = NULL;
@@ -781,11 +780,11 @@ struct htype {
 					NLEN(set->family), i);
 #endif
 			ip_set_ext_destroy(set, data);
-			h->elements--;
+			set->elements--;
 		}
 		goto copy_data;
 	}
-	if (h->elements >= h->maxelem)
+	if (set->elements >= h->maxelem)
 		goto set_full;
 	/* Create a new slot */
 	if (n->pos >= n->size) {
@@ -810,7 +809,7 @@ struct htype {
 	j = n->pos++;
 	data = ahash_data(n, j, set->dsize);
 copy_data:
-	h->elements++;
+	set->elements++;
 #ifdef IP_SET_HASH_WITH_NETS
 	for (i = 0; i < IPSET_NET_COUNT; i++)
 		mtype_add_cidr(h, NCIDR_PUT(DCIDR_GET(d->cidr, i)),
@@ -883,7 +882,7 @@ struct htype {
 		smp_mb__after_atomic();
 		if (i + 1 == n->pos)
 			n->pos--;
-		h->elements--;
+		set->elements--;
 #ifdef IP_SET_HASH_WITH_NETS
 		for (j = 0; j < IPSET_NET_COUNT; j++)
 			mtype_del_cidr(h, NCIDR_PUT(DCIDR_GET(d->cidr, j)),
@@ -1084,7 +1083,7 @@ struct htype {
 #endif
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref)) ||
 	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
-	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(h->elements)))
+	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(set->elements)))
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 462b0b1..c455166 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -166,6 +166,7 @@ struct list_set {
 static inline void
 list_set_del(struct ip_set *set, struct set_elem *e)
 {
+	set->elements--;
 	list_del_rcu(&e->list);
 	call_rcu(&e->rcu, __list_set_del_rcu);
 }
@@ -309,6 +310,7 @@ struct list_set {
 		list_add_rcu(&e->list, &prev->list);
 	else
 		list_add_tail_rcu(&e->list, &map->members);
+	set->elements++;
 
 	return 0;
 }
@@ -419,6 +421,7 @@ struct list_set {
 
 	list_for_each_entry_safe(e, n, &map->members, list)
 		list_set_del(set, e);
+	set->elements = 0;
 }
 
 static void
@@ -471,7 +474,8 @@ struct list_set {
 		goto nla_put_failure;
 	if (nla_put_net32(skb, IPSET_ATTR_SIZE, htonl(map->size)) ||
 	    nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref)) ||
-	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)))
+	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
+	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(set->elements)))
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
-- 
1.8.5.1

