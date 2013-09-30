From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 22/26] netfilter: ipset: Fix hash resizing with comments
Date: Mon, 30 Sep 2013 21:50:33 +0200
Message-ID: <1380570637-31235-23-git-send-email-kadlec@blackhole.kfki.hu>
References: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:60606 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377Ab3I3Tup (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:50:45 -0400
In-Reply-To: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The destroy function must take into account that resizing doesn't
create new extensions so those cannot be destroyed at resize.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 6efb655..1cffeb9 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -393,7 +393,7 @@ mtype_flush(struct ip_set *set)
 
 /* Destroy the hashtable part of the set */
 static void
-mtype_ahash_destroy(struct ip_set *set, struct htable *t)
+mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
 {
 	struct hbucket *n;
 	u32 i;
@@ -401,7 +401,7 @@ mtype_ahash_destroy(struct ip_set *set, struct htable *t)
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
 		n = hbucket(t, i);
 		if (n->size) {
-			if (set->extensions & IPSET_EXT_DESTROY)
+			if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
 				mtype_ext_cleanup(set, n);
 			/* FIXME: use slab cache */
 			kfree(n->value);
@@ -420,7 +420,7 @@ mtype_destroy(struct ip_set *set)
 	if (set->extensions & IPSET_EXT_TIMEOUT)
 		del_timer_sync(&h->gc);
 
-	mtype_ahash_destroy(set, rcu_dereference_bh_nfnl(h->table));
+	mtype_ahash_destroy(set, rcu_dereference_bh_nfnl(h->table), true);
 #ifdef IP_SET_HASH_WITH_RBTREE
 	rbtree_destroy(&h->rbtree);
 #endif
@@ -586,7 +586,7 @@ retry:
 				mtype_data_reset_flags(data, &flags);
 #endif
 				read_unlock_bh(&set->lock);
-				mtype_ahash_destroy(set, t);
+				mtype_ahash_destroy(set, t, false);
 				if (ret == -EAGAIN)
 					goto retry;
 				return ret;
@@ -607,7 +607,7 @@ retry:
 
 	pr_debug("set %s resized from %u (%p) to %u (%p)\n", set->name,
 		 orig->htable_bits, orig, t->htable_bits, t);
-	mtype_ahash_destroy(set, orig);
+	mtype_ahash_destroy(set, orig, false);
 
 	return 0;
 }
-- 
1.7.0.4

