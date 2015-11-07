From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 3/3] netfilter: ipset: Fix hash type expire: release empty hash bucket block
Date: Sat,  7 Nov 2015 13:42:25 +0100
Message-ID: <1446900145-14190-4-git-send-email-kadlec@blackhole.kfki.hu>
References: <1446900145-14190-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:44483 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbbKGMkt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Nov 2015 07:40:49 -0500
In-Reply-To: <1446900145-14190-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When all entries are expired/all slots are empty, release the bucket.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index fa4f637..e5336ab 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -476,7 +476,7 @@ static void
 mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 {
 	struct htable *t;
-	struct hbucket *n;
+	struct hbucket *n, *tmp;
 	struct mtype_elem *data;
 	u32 i, j, d;
 #ifdef IP_SET_HASH_WITH_NETS
@@ -511,9 +511,14 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 			}
 		}
 		if (d >= AHASH_INIT_SIZE) {
-			struct hbucket *tmp = kzalloc(sizeof(*tmp) +
-					(n->size - AHASH_INIT_SIZE) * dsize,
-					GFP_ATOMIC);
+			if (d >= n->size) {
+				rcu_assign_pointer(hbucket(t, i), NULL);
+				kfree_rcu(n, rcu);
+				continue;
+			}
+			tmp = kzalloc(sizeof(*tmp) +
+				      (n->size - AHASH_INIT_SIZE) * dsize,
+				      GFP_ATOMIC);
 			if (!tmp)
 				/* Still try to delete expired elements */
 				continue;
-- 
1.8.5.1

