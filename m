From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 17/22] netfilter: ipset: Fix reported memory size for hash:* types
Date: Mon, 17 Oct 2016 14:51:34 +0200
Message-ID: <1476708699-32761-18-git-send-email-kadlec@blackhole.kfki.hu>
References: <1476708699-32761-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:38571 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755019AbcJQNAU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 09:00:20 -0400
In-Reply-To: <1476708699-32761-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The calculation of the full allocated memory did not take
into account the size of the base hash bucket structure at some
places.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index f4b30b6..295ad84 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -87,6 +87,8 @@ struct htable {
 };
 
 #define hbucket(h, i)		((h)->bucket[i])
+#define ext_size(n, dsize)	\
+	(sizeof(struct hbucket) + (n) * (dsize))
 
 #ifndef IPSET_NET_COUNT
 #define IPSET_NET_COUNT		1
@@ -521,7 +523,7 @@ struct htype {
 				d++;
 			}
 			tmp->pos = d;
-			set->ext_size -= AHASH_INIT_SIZE * dsize;
+			set->ext_size -= ext_size(AHASH_INIT_SIZE, dsize);
 			rcu_assign_pointer(hbucket(t, i), tmp);
 			kfree_rcu(n, rcu);
 		}
@@ -627,7 +629,7 @@ struct htype {
 					goto cleanup;
 				}
 				m->size = AHASH_INIT_SIZE;
-				extsize = sizeof(*m) + AHASH_INIT_SIZE * dsize;
+				extsize = ext_size(AHASH_INIT_SIZE, dsize);
 				RCU_INIT_POINTER(hbucket(t, key), m);
 			} else if (m->pos >= m->size) {
 				struct hbucket *ht;
@@ -647,7 +649,7 @@ struct htype {
 				memcpy(ht, m, sizeof(struct hbucket) +
 					      m->size * dsize);
 				ht->size = m->size + AHASH_INIT_SIZE;
-				extsize += AHASH_INIT_SIZE * dsize;
+				extsize += ext_size(AHASH_INIT_SIZE, dsize);
 				kfree(m);
 				m = ht;
 				RCU_INIT_POINTER(hbucket(t, key), ht);
@@ -729,7 +731,7 @@ struct htype {
 		if (!n)
 			return -ENOMEM;
 		n->size = AHASH_INIT_SIZE;
-		set->ext_size += sizeof(*n) + AHASH_INIT_SIZE * set->dsize;
+		set->ext_size += ext_size(AHASH_INIT_SIZE, set->dsize);
 		goto copy_elem;
 	}
 	for (i = 0; i < n->pos; i++) {
@@ -793,7 +795,7 @@ struct htype {
 		memcpy(n, old, sizeof(struct hbucket) +
 		       old->size * set->dsize);
 		n->size = old->size + AHASH_INIT_SIZE;
-		set->ext_size += AHASH_INIT_SIZE * set->dsize;
+		set->ext_size += ext_size(AHASH_INIT_SIZE, set->dsize);
 	}
 
 copy_elem:
@@ -885,7 +887,7 @@ struct htype {
 				k++;
 		}
 		if (n->pos == 0 && k == 0) {
-			set->ext_size -= sizeof(*n) + n->size * dsize;
+			set->ext_size -= ext_size(n->size, dsize);
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);
 		} else if (k >= AHASH_INIT_SIZE) {
@@ -904,7 +906,7 @@ struct htype {
 				k++;
 			}
 			tmp->pos = k;
-			set->ext_size -= AHASH_INIT_SIZE * dsize;
+			set->ext_size -= ext_size(AHASH_INIT_SIZE, dsize);
 			rcu_assign_pointer(hbucket(t, key), tmp);
 			kfree_rcu(n, rcu);
 		}
-- 
1.8.5.1

