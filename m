From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 10/22] netfilter: ipset: Count non-static extension memory for userspace
Date: Mon, 17 Oct 2016 14:51:27 +0200
Message-ID: <1476708699-32761-11-git-send-email-kadlec@blackhole.kfki.hu>
References: <1476708699-32761-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:38572 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755017AbcJQNAU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 09:00:20 -0400
In-Reply-To: <1476708699-32761-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Non-static (i.e. comment) extension was not counted into the memory
size. A new internal counter is introduced for this. In the case of
the hash types the sizes of the arrays are counted there as well so
that we can avoid to scan the whole set when just the header data
is requested.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h         |  8 ++++++--
 include/linux/netfilter/ipset/ip_set_comment.h |  7 +++++--
 net/netfilter/ipset/ip_set_bitmap_gen.h        |  5 +++--
 net/netfilter/ipset/ip_set_core.c              |  2 +-
 net/netfilter/ipset/ip_set_hash_gen.h          | 26 ++++++++++++++------------
 net/netfilter/ipset/ip_set_list_set.c          |  5 +++--
 6 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 4671d74..8e42253 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -79,10 +79,12 @@ enum ip_set_ext_id {
 	IPSET_EXT_ID_MAX,
 };
 
+struct ip_set;
+
 /* Extension type */
 struct ip_set_ext_type {
 	/* Destroy extension private data (can be NULL) */
-	void (*destroy)(void *ext);
+	void (*destroy)(struct ip_set *set, void *ext);
 	enum ip_set_extension type;
 	enum ipset_cadt_flags flag;
 	/* Size and minimal alignment */
@@ -252,6 +254,8 @@ struct ip_set {
 	u32 timeout;
 	/* Number of elements (vs timeout) */
 	u32 elements;
+	/* Size of the dynamic extensions (vs timeout) */
+	size_t ext_size;
 	/* Element data size */
 	size_t dsize;
 	/* Offsets to extensions in elements */
@@ -268,7 +272,7 @@ struct ip_set {
 	 */
 	if (SET_WITH_COMMENT(set))
 		ip_set_extensions[IPSET_EXT_ID_COMMENT].destroy(
-			ext_comment(data, set));
+			set, ext_comment(data, set));
 }
 
 static inline int
diff --git a/include/linux/netfilter/ipset/ip_set_comment.h b/include/linux/netfilter/ipset/ip_set_comment.h
index 5444b1b..8e2bab1 100644
--- a/include/linux/netfilter/ipset/ip_set_comment.h
+++ b/include/linux/netfilter/ipset/ip_set_comment.h
@@ -20,13 +20,14 @@
  * The kadt functions don't use the comment extensions in any way.
  */
 static inline void
-ip_set_init_comment(struct ip_set_comment *comment,
+ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 		    const struct ip_set_ext *ext)
 {
 	struct ip_set_comment_rcu *c = rcu_dereference_protected(comment->c, 1);
 	size_t len = ext->comment ? strlen(ext->comment) : 0;
 
 	if (unlikely(c)) {
+		set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
 		kfree_rcu(c, rcu);
 		rcu_assign_pointer(comment->c, NULL);
 	}
@@ -38,6 +39,7 @@
 	if (unlikely(!c))
 		return;
 	strlcpy(c->str, ext->comment, len + 1);
+	set->ext_size += sizeof(*c) + strlen(c->str) + 1;
 	rcu_assign_pointer(comment->c, c);
 }
 
@@ -58,13 +60,14 @@
  * of the set data anymore.
  */
 static inline void
-ip_set_comment_free(struct ip_set_comment *comment)
+ip_set_comment_free(struct ip_set *set, struct ip_set_comment *comment)
 {
 	struct ip_set_comment_rcu *c;
 
 	c = rcu_dereference_protected(comment->c, 1);
 	if (unlikely(!c))
 		return;
+	set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
 	kfree_rcu(c, rcu);
 	rcu_assign_pointer(comment->c, NULL);
 }
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 13a7021..5a9fa61 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -84,6 +84,7 @@
 		mtype_ext_cleanup(set);
 	memset(map->members, 0, map->memsize);
 	set->elements = 0;
+	set->ext_size = 0;
 }
 
 /* Calculate the actual memory size of the set data */
@@ -101,7 +102,7 @@
 {
 	const struct mtype *map = set->data;
 	struct nlattr *nested;
-	size_t memsize = mtype_memsize(map, set->dsize);
+	size_t memsize = mtype_memsize(map, set->dsize) + set->ext_size;
 
 	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
@@ -175,7 +176,7 @@
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(x, set), ext);
 	if (SET_WITH_COMMENT(set))
-		ip_set_init_comment(ext_comment(x, set), ext);
+		ip_set_init_comment(set, ext_comment(x, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(x, set), ext);
 
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 3bca341..cd8961e 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -324,7 +324,7 @@ static inline struct ip_set_net *ip_set_pernet(struct net *net)
 }
 EXPORT_SYMBOL_GPL(ip_set_get_ipaddr6);
 
-typedef void (*destroyer)(void *);
+typedef void (*destroyer)(struct ip_set *, void *);
 /* ipset data extension types, in size order */
 
 const struct ip_set_ext_type ip_set_extensions[] = {
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 09465d1..37afa68 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -345,21 +345,13 @@ struct htype {
 /* Calculate the actual memory size of the set data */
 static size_t
 mtype_ahash_memsize(const struct htype *h, const struct htable *t,
-		    u8 nets_length, size_t dsize)
+		    u8 nets_length)
 {
-	u32 i;
-	struct hbucket *n;
 	size_t memsize = sizeof(*h) + sizeof(*t);
 
 #ifdef IP_SET_HASH_WITH_NETS
 	memsize += sizeof(struct net_prefixes) * nets_length;
 #endif
-	for (i = 0; i < jhash_size(t->htable_bits); i++) {
-		n = rcu_dereference_bh(hbucket(t, i));
-		if (!n)
-			continue;
-		memsize += sizeof(struct hbucket) + n->size * dsize;
-	}
 
 	return memsize;
 }
@@ -402,6 +394,7 @@ struct htype {
 	memset(h->nets, 0, sizeof(struct net_prefixes) * NLEN(set->family));
 #endif
 	set->elements = 0;
+	set->ext_size = 0;
 }
 
 /* Destroy the hashtable part of the set */
@@ -533,6 +526,7 @@ struct htype {
 				d++;
 			}
 			tmp->pos = d;
+			set->ext_size -= AHASH_INIT_SIZE * dsize;
 			rcu_assign_pointer(hbucket(t, i), tmp);
 			kfree_rcu(n, rcu);
 		}
@@ -564,7 +558,7 @@ struct htype {
 	struct htype *h = set->data;
 	struct htable *t, *orig;
 	u8 htable_bits;
-	size_t dsize = set->dsize;
+	size_t extsize, dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 flags;
 	struct mtype_elem *tmp;
@@ -607,6 +601,7 @@ struct htype {
 	/* There can't be another parallel resizing, but dumping is possible */
 	atomic_set(&orig->ref, 1);
 	atomic_inc(&orig->uref);
+	extsize = 0;
 	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
 		 set->name, orig->htable_bits, htable_bits, orig);
 	for (i = 0; i < jhash_size(orig->htable_bits); i++) {
@@ -637,6 +632,7 @@ struct htype {
 					goto cleanup;
 				}
 				m->size = AHASH_INIT_SIZE;
+				extsize = sizeof(*m) + AHASH_INIT_SIZE * dsize;
 				RCU_INIT_POINTER(hbucket(t, key), m);
 			} else if (m->pos >= m->size) {
 				struct hbucket *ht;
@@ -656,6 +652,7 @@ struct htype {
 				memcpy(ht, m, sizeof(struct hbucket) +
 					      m->size * dsize);
 				ht->size = m->size + AHASH_INIT_SIZE;
+				extsize += AHASH_INIT_SIZE * dsize;
 				kfree(m);
 				m = ht;
 				RCU_INIT_POINTER(hbucket(t, key), ht);
@@ -669,6 +666,7 @@ struct htype {
 		}
 	}
 	rcu_assign_pointer(h->table, t);
+	set->ext_size = extsize;
 
 	spin_unlock_bh(&set->lock);
 
@@ -742,6 +740,7 @@ struct htype {
 		if (!n)
 			return -ENOMEM;
 		n->size = AHASH_INIT_SIZE;
+		set->ext_size += sizeof(*n) + AHASH_INIT_SIZE * set->dsize;
 		goto copy_elem;
 	}
 	for (i = 0; i < n->pos; i++) {
@@ -805,6 +804,7 @@ struct htype {
 		memcpy(n, old, sizeof(struct hbucket) +
 		       old->size * set->dsize);
 		n->size = old->size + AHASH_INIT_SIZE;
+		set->ext_size += AHASH_INIT_SIZE * set->dsize;
 	}
 
 copy_elem:
@@ -825,7 +825,7 @@ struct htype {
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(data, set), ext);
 	if (SET_WITH_COMMENT(set))
-		ip_set_init_comment(ext_comment(data, set), ext);
+		ip_set_init_comment(set, ext_comment(data, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(data, set), ext);
 	/* Must come last for the case when timed out entry is reused */
@@ -897,6 +897,7 @@ struct htype {
 				k++;
 		}
 		if (n->pos == 0 && k == 0) {
+			set->ext_size -= sizeof(*n) + n->size * dsize;
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);
 		} else if (k >= AHASH_INIT_SIZE) {
@@ -915,6 +916,7 @@ struct htype {
 				k++;
 			}
 			tmp->pos = k;
+			set->ext_size -= AHASH_INIT_SIZE * dsize;
 			rcu_assign_pointer(hbucket(t, key), tmp);
 			kfree_rcu(n, rcu);
 		}
@@ -1063,7 +1065,7 @@ struct htype {
 
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh_nfnl(h->table, NFNL_SUBSYS_IPSET);
-	memsize = mtype_ahash_memsize(h, t, NLEN(set->family), set->dsize);
+	memsize = mtype_ahash_memsize(h, t, NLEN(set->family)) + set->ext_size;
 	htable_bits = t->htable_bits;
 	rcu_read_unlock_bh();
 
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index c455166..dede343 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -228,7 +228,7 @@ struct list_set {
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(e, set), ext);
 	if (SET_WITH_COMMENT(set))
-		ip_set_init_comment(ext_comment(e, set), ext);
+		ip_set_init_comment(set, ext_comment(e, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(e, set), ext);
 	/* Update timeout last */
@@ -422,6 +422,7 @@ struct list_set {
 	list_for_each_entry_safe(e, n, &map->members, list)
 		list_set_del(set, e);
 	set->elements = 0;
+	set->ext_size = 0;
 }
 
 static void
@@ -467,7 +468,7 @@ struct list_set {
 {
 	const struct list_set *map = set->data;
 	struct nlattr *nested;
-	size_t memsize = list_set_memsize(map, set->dsize);
+	size_t memsize = list_set_memsize(map, set->dsize) + set->ext_size;
 
 	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
-- 
1.8.5.1

