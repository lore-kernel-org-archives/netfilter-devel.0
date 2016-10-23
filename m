From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 12/22] netfilter: ipset: Make NLEN compile time constant for hash types
Date: Sun, 23 Oct 2016 22:37:45 +0200
Message-ID: <1477255075-15255-13-git-send-email-kadlec@blackhole.kfki.hu>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:52291 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756758AbcJWUiD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Oct 2016 16:38:03 -0400
In-Reply-To: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hash types define HOST_MASK before inclusion of ip_set_hash_gen.h
and the only place where NLEN needed to be calculated at runtime
is *_create() method.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 51 ++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 79e158d..ab5b57c 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -152,20 +152,18 @@ struct net_prefixes {
 #define INIT_CIDR(cidr, host_mask)	\
 	DCIDR_PUT(((cidr) ? NCIDR_GET(cidr) : host_mask))
 
-#define SET_HOST_MASK(family)	(family == AF_INET ? 32 : 128)
-
 #ifdef IP_SET_HASH_WITH_NET0
-/* cidr from 0 to SET_HOST_MASK() value and c = cidr + 1 */
-#define NLEN(family)		(SET_HOST_MASK(family) + 1)
+/* cidr from 0 to HOST_MASK value and c = cidr + 1 */
+#define NLEN			(HOST_MASK + 1)
 #define CIDR_POS(c)		((c) - 1)
 #else
-/* cidr from 1 to SET_HOST_MASK() value and c = cidr + 1 */
-#define NLEN(family)		SET_HOST_MASK(family)
+/* cidr from 1 to HOST_MASK value and c = cidr + 1 */
+#define NLEN			HOST_MASK
 #define CIDR_POS(c)		((c) - 2)
 #endif
 
 #else
-#define NLEN(family)		0
+#define NLEN			0
 #endif /* IP_SET_HASH_WITH_NETS */
 
 #endif /* _IP_SET_HASH_GEN_H */
@@ -300,12 +298,12 @@ struct htype {
  * sized networks. cidr == real cidr + 1 to support /0.
  */
 static void
-mtype_add_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
+mtype_add_cidr(struct htype *h, u8 cidr, u8 n)
 {
 	int i, j;
 
 	/* Add in increasing prefix order, so larger cidr first */
-	for (i = 0, j = -1; i < nets_length && h->nets[i].cidr[n]; i++) {
+	for (i = 0, j = -1; i < NLEN && h->nets[i].cidr[n]; i++) {
 		if (j != -1) {
 			continue;
 		} else if (h->nets[i].cidr[n] < cidr) {
@@ -324,11 +322,11 @@ struct htype {
 }
 
 static void
-mtype_del_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
+mtype_del_cidr(struct htype *h, u8 cidr, u8 n)
 {
-	u8 i, j, net_end = nets_length - 1;
+	u8 i, j, net_end = NLEN - 1;
 
-	for (i = 0; i < nets_length; i++) {
+	for (i = 0; i < NLEN; i++) {
 		if (h->nets[i].cidr[n] != cidr)
 			continue;
 		h->nets[CIDR_POS(cidr)].nets[n]--;
@@ -344,13 +342,12 @@ struct htype {
 
 /* Calculate the actual memory size of the set data */
 static size_t
-mtype_ahash_memsize(const struct htype *h, const struct htable *t,
-		    u8 nets_length)
+mtype_ahash_memsize(const struct htype *h, const struct htable *t)
 {
 	size_t memsize = sizeof(*h) + sizeof(*t);
 
 #ifdef IP_SET_HASH_WITH_NETS
-	memsize += sizeof(struct net_prefixes) * nets_length;
+	memsize += sizeof(struct net_prefixes) * NLEN;
 #endif
 
 	return memsize;
@@ -391,7 +388,7 @@ struct htype {
 		kfree_rcu(n, rcu);
 	}
 #ifdef IP_SET_HASH_WITH_NETS
-	memset(h->nets, 0, sizeof(struct net_prefixes) * NLEN(set->family));
+	memset(h->nets, 0, sizeof(struct net_prefixes) * NLEN);
 #endif
 	set->elements = 0;
 	set->ext_size = 0;
@@ -475,7 +472,7 @@ struct htype {
 	u32 i, j, d;
 	size_t dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
-	u8 k, nets_length = NLEN(set->family);
+	u8 k;
 #endif
 
 	t = ipset_dereference_protected(h->table, set);
@@ -498,7 +495,7 @@ struct htype {
 			for (k = 0; k < IPSET_NET_COUNT; k++)
 				mtype_del_cidr(h,
 					NCIDR_PUT(DCIDR_GET(data->cidr, k)),
-					nets_length, k);
+					k);
 #endif
 			ip_set_ext_destroy(set, data);
 			set->elements--;
@@ -778,7 +775,7 @@ struct htype {
 			for (i = 0; i < IPSET_NET_COUNT; i++)
 				mtype_del_cidr(h,
 					NCIDR_PUT(DCIDR_GET(data->cidr, i)),
-					NLEN(set->family), i);
+					i);
 #endif
 			ip_set_ext_destroy(set, data);
 			set->elements--;
@@ -814,8 +811,7 @@ struct htype {
 	set->elements++;
 #ifdef IP_SET_HASH_WITH_NETS
 	for (i = 0; i < IPSET_NET_COUNT; i++)
-		mtype_add_cidr(h, NCIDR_PUT(DCIDR_GET(d->cidr, i)),
-			       NLEN(set->family), i);
+		mtype_add_cidr(h, NCIDR_PUT(DCIDR_GET(d->cidr, i)), i);
 #endif
 	memcpy(data, d, sizeof(struct mtype_elem));
 overwrite_extensions:
@@ -888,7 +884,7 @@ struct htype {
 #ifdef IP_SET_HASH_WITH_NETS
 		for (j = 0; j < IPSET_NET_COUNT; j++)
 			mtype_del_cidr(h, NCIDR_PUT(DCIDR_GET(d->cidr, j)),
-				       NLEN(set->family), j);
+				       j);
 #endif
 		ip_set_ext_destroy(set, data);
 
@@ -960,14 +956,13 @@ struct htype {
 	int i, j = 0;
 #endif
 	u32 key, multi = 0;
-	u8 nets_length = NLEN(set->family);
 
 	pr_debug("test by nets\n");
-	for (; j < nets_length && h->nets[j].cidr[0] && !multi; j++) {
+	for (; j < NLEN && h->nets[j].cidr[0] && !multi; j++) {
 #if IPSET_NET_COUNT == 2
 		mtype_data_reset_elem(d, &orig);
 		mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]), false);
-		for (k = 0; k < nets_length && h->nets[k].cidr[1] && !multi;
+		for (k = 0; k < NLEN && h->nets[k].cidr[1] && !multi;
 		     k++) {
 			mtype_data_netmask(d, NCIDR_GET(h->nets[k].cidr[1]),
 					   true);
@@ -1024,7 +1019,7 @@ struct htype {
 	 * try all possible network sizes
 	 */
 	for (i = 0; i < IPSET_NET_COUNT; i++)
-		if (DCIDR_GET(d->cidr, i) != SET_HOST_MASK(set->family))
+		if (DCIDR_GET(d->cidr, i) != HOST_MASK)
 			break;
 	if (i == IPSET_NET_COUNT) {
 		ret = mtype_test_cidrs(set, d, ext, mext, flags);
@@ -1065,7 +1060,7 @@ struct htype {
 
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh_nfnl(h->table, NFNL_SUBSYS_IPSET);
-	memsize = mtype_ahash_memsize(h, t, NLEN(set->family)) + set->ext_size;
+	memsize = mtype_ahash_memsize(h, t) + set->ext_size;
 	htable_bits = t->htable_bits;
 	rcu_read_unlock_bh();
 
@@ -1297,7 +1292,7 @@ struct htype {
 
 	hsize = sizeof(*h);
 #ifdef IP_SET_HASH_WITH_NETS
-	hsize += sizeof(struct net_prefixes) * NLEN(set->family);
+	hsize += sizeof(struct net_prefixes) * NLEN;
 #endif
 	h = kzalloc(hsize, GFP_KERNEL);
 	if (!h)
-- 
1.8.5.1

