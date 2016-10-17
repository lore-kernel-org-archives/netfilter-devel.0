From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 11/22] netfilter: ipset: Simplify mtype_expire() for hash types
Date: Mon, 17 Oct 2016 14:51:28 +0200
Message-ID: <1476708699-32761-12-git-send-email-kadlec@blackhole.kfki.hu>
References: <1476708699-32761-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:55696 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755088AbcJQNAV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 09:00:21 -0400
In-Reply-To: <1476708699-32761-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove redundant parameters nets_length and dsize:
they could be get from other parameters.

Remove one leve of intendation by using continue while
iterating over elements in bucket.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 37afa68..79e158d 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -467,14 +467,15 @@ struct htype {
 
 /* Delete expired elements from the hashtable */
 static void
-mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
+mtype_expire(struct ip_set *set, struct htype *h)
 {
 	struct htable *t;
 	struct hbucket *n, *tmp;
 	struct mtype_elem *data;
 	u32 i, j, d;
+	size_t dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
-	u8 k;
+	u8 k, nets_length = NLEN(set->family);
 #endif
 
 	t = ipset_dereference_protected(h->table, set);
@@ -488,21 +489,20 @@ struct htype {
 				continue;
 			}
 			data = ahash_data(n, j, dsize);
-			if (ip_set_timeout_expired(ext_timeout(data, set))) {
-				pr_debug("expired %u/%u\n", i, j);
-				clear_bit(j, n->used);
-				smp_mb__after_atomic();
+			if (!ip_set_timeout_expired(ext_timeout(data, set)))
+				continue;
+			pr_debug("expired %u/%u\n", i, j);
+			clear_bit(j, n->used);
+			smp_mb__after_atomic();
 #ifdef IP_SET_HASH_WITH_NETS
-				for (k = 0; k < IPSET_NET_COUNT; k++)
-					mtype_del_cidr(h,
-						NCIDR_PUT(DCIDR_GET(data->cidr,
-								    k)),
-						nets_length, k);
+			for (k = 0; k < IPSET_NET_COUNT; k++)
+				mtype_del_cidr(h,
+					NCIDR_PUT(DCIDR_GET(data->cidr, k)),
+					nets_length, k);
 #endif
-				ip_set_ext_destroy(set, data);
-				set->elements--;
-				d++;
-			}
+			ip_set_ext_destroy(set, data);
+			set->elements--;
+			d++;
 		}
 		if (d >= AHASH_INIT_SIZE) {
 			if (d >= n->size) {
@@ -541,7 +541,7 @@ struct htype {
 
 	pr_debug("called\n");
 	spin_lock_bh(&set->lock);
-	mtype_expire(set, h, NLEN(set->family), set->dsize);
+	mtype_expire(set, h);
 	spin_unlock_bh(&set->lock);
 
 	h->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
@@ -717,7 +717,7 @@ struct htype {
 	if (set->elements >= h->maxelem) {
 		if (SET_WITH_TIMEOUT(set))
 			/* FIXME: when set is full, we slow down here */
-			mtype_expire(set, h, NLEN(set->family), set->dsize);
+			mtype_expire(set, h);
 		if (set->elements >= h->maxelem && SET_WITH_FORCEADD(set))
 			forceadd = true;
 	}
-- 
1.8.5.1

