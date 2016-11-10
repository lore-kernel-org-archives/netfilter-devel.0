From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 19/22] netfilter: ipset: Fix reported memory size for hash:* types
Date: Thu, 10 Nov 2016 13:57:53 +0100
Message-ID: <1478782676-9770-20-git-send-email-kadlec@blackhole.kfki.hu>
References: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36193 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933023AbcKJM6C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:02 -0500
In-Reply-To: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
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
index 1c9b84e..88b70fc 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -85,6 +85,8 @@ struct htable {
 };
 
 #define hbucket(h, i)		((h)->bucket[i])
+#define ext_size(n, dsize)	\
+	(sizeof(struct hbucket) + (n) * (dsize))
 
 #ifndef IPSET_NET_COUNT
 #define IPSET_NET_COUNT		1
@@ -519,7 +521,7 @@ struct htype {
 				d++;
 			}
 			tmp->pos = d;
-			set->ext_size -= AHASH_INIT_SIZE * dsize;
+			set->ext_size -= ext_size(AHASH_INIT_SIZE, dsize);
 			rcu_assign_pointer(hbucket(t, i), tmp);
 			kfree_rcu(n, rcu);
 		}
@@ -625,7 +627,7 @@ struct htype {
 					goto cleanup;
 				}
 				m->size = AHASH_INIT_SIZE;
-				extsize = sizeof(*m) + AHASH_INIT_SIZE * dsize;
+				extsize = ext_size(AHASH_INIT_SIZE, dsize);
 				RCU_INIT_POINTER(hbucket(t, key), m);
 			} else if (m->pos >= m->size) {
 				struct hbucket *ht;
@@ -645,7 +647,7 @@ struct htype {
 				memcpy(ht, m, sizeof(struct hbucket) +
 					      m->size * dsize);
 				ht->size = m->size + AHASH_INIT_SIZE;
-				extsize += AHASH_INIT_SIZE * dsize;
+				extsize += ext_size(AHASH_INIT_SIZE, dsize);
 				kfree(m);
 				m = ht;
 				RCU_INIT_POINTER(hbucket(t, key), ht);
@@ -727,7 +729,7 @@ struct htype {
 		if (!n)
 			return -ENOMEM;
 		n->size = AHASH_INIT_SIZE;
-		set->ext_size += sizeof(*n) + AHASH_INIT_SIZE * set->dsize;
+		set->ext_size += ext_size(AHASH_INIT_SIZE, set->dsize);
 		goto copy_elem;
 	}
 	for (i = 0; i < n->pos; i++) {
@@ -791,7 +793,7 @@ struct htype {
 		memcpy(n, old, sizeof(struct hbucket) +
 		       old->size * set->dsize);
 		n->size = old->size + AHASH_INIT_SIZE;
-		set->ext_size += AHASH_INIT_SIZE * set->dsize;
+		set->ext_size += ext_size(AHASH_INIT_SIZE, set->dsize);
 	}
 
 copy_elem:
@@ -883,7 +885,7 @@ struct htype {
 				k++;
 		}
 		if (n->pos == 0 && k == 0) {
-			set->ext_size -= sizeof(*n) + n->size * dsize;
+			set->ext_size -= ext_size(n->size, dsize);
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);
 		} else if (k >= AHASH_INIT_SIZE) {
@@ -902,7 +904,7 @@ struct htype {
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

