From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 03/34] netfilter: ipset: Introduce RCU locking in bitmap:* types
Date: Sat,  2 May 2015 19:27:52 +0200
Message-ID: <1430587703-3387-4-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:36943 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbbEBR2F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:05 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There's nothing much required because the bitmap types use atomic
bit operations. However the logic of adding elements slightly changed:
first the MAC address updated (which is not atomic), then the element
activated (added).

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h   | 14 ++++++++++----
 net/netfilter/ipset/ip_set_bitmap_ip.c    |  3 ++-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 13 +++++++++++--
 net/netfilter/ipset/ip_set_bitmap_port.c  |  3 ++-
 4 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 6f024a8..6660f2a 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -144,10 +144,12 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	if (ret == IPSET_ADD_FAILED) {
 		if (SET_WITH_TIMEOUT(set) &&
-		    ip_set_timeout_expired(ext_timeout(x, set)))
+		    ip_set_timeout_expired(ext_timeout(x, set))) {
 			ret = 0;
-		else if (!(flags & IPSET_FLAG_EXIST))
+		} else if (!(flags & IPSET_FLAG_EXIST)) {
+			set_bit(e->id, map->members);
 			return -IPSET_ERR_EXIST;
+		}
 		/* Element is re-added, cleanup extensions */
 		ip_set_ext_destroy(set, x);
 	}
@@ -165,6 +167,10 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		ip_set_init_comment(ext_comment(x, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(x, set), ext);
+
+	/* Activate element */
+	set_bit(e->id, map->members);
+
 	return 0;
 }
 
@@ -260,7 +266,7 @@ mtype_gc(unsigned long ul_set)
 
 	/* We run parallel with other readers (test element)
 	 * but adding/deleting new entries is locked out */
-	read_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	for (id = 0; id < map->elements; id++)
 		if (mtype_gc_test(id, map, set->dsize)) {
 			x = get_ext(set, map, id);
@@ -269,7 +275,7 @@ mtype_gc(unsigned long ul_set)
 				ip_set_ext_destroy(set, x);
 			}
 		}
-	read_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 
 	map->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
 	add_timer(&map->gc);
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 55b083e..487513b 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -80,7 +80,7 @@ static inline int
 bitmap_ip_do_add(const struct bitmap_ip_adt_elem *e, struct bitmap_ip *map,
 		 u32 flags, size_t dsize)
 {
-	return !!test_and_set_bit(e->id, map->members);
+	return !!test_bit(e->id, map->members);
 }
 
 static inline int
@@ -377,6 +377,7 @@ bitmap_ip_init(void)
 static void __exit
 bitmap_ip_fini(void)
 {
+	rcu_barrier();
 	ip_set_type_unregister(&bitmap_ip_type);
 }
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 8610474..8f3f1cd 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -146,15 +146,23 @@ bitmap_ipmac_do_add(const struct bitmap_ipmac_adt_elem *e,
 	struct bitmap_ipmac_elem *elem;
 
 	elem = get_elem(map->extensions, e->id, dsize);
-	if (test_and_set_bit(e->id, map->members)) {
+	if (test_bit(e->id, map->members)) {
 		if (elem->filled == MAC_FILLED) {
-			if (e->ether && (flags & IPSET_FLAG_EXIST))
+			if (e->ether &&
+			    (flags & IPSET_FLAG_EXIST) &&
+			    !ether_addr_equal(e->ether, elem->ether)) {
+				/* memcpy isn't atomic */
+				clear_bit(e->id, map->members);
+				smp_mb__after_atomic();
 				memcpy(elem->ether, e->ether, ETH_ALEN);
+			}
 			return IPSET_ADD_FAILED;
 		} else if (!e->ether)
 			/* Already added without ethernet address */
 			return IPSET_ADD_FAILED;
 		/* Fill the MAC address and trigger the timer activation */
+		clear_bit(e->id, map->members);
+		smp_mb__after_atomic();
 		memcpy(elem->ether, e->ether, ETH_ALEN);
 		elem->filled = MAC_FILLED;
 		return IPSET_ADD_START_STORED_TIMEOUT;
@@ -414,6 +422,7 @@ bitmap_ipmac_init(void)
 static void __exit
 bitmap_ipmac_fini(void)
 {
+	rcu_barrier();
 	ip_set_type_unregister(&bitmap_ipmac_type);
 }
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 005dd36..e69619a 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -73,7 +73,7 @@ static inline int
 bitmap_port_do_add(const struct bitmap_port_adt_elem *e,
 		   struct bitmap_port *map, u32 flags, size_t dsize)
 {
-	return !!test_and_set_bit(e->id, map->members);
+	return !!test_bit(e->id, map->members);
 }
 
 static inline int
@@ -311,6 +311,7 @@ bitmap_port_init(void)
 static void __exit
 bitmap_port_fini(void)
 {
+	rcu_barrier();
 	ip_set_type_unregister(&bitmap_port_type);
 }
 
-- 
1.8.5.1

