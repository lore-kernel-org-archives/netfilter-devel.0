From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 13/34] netfilter: ipset: Fix cidr handling for hash:*net* types
Date: Sat,  2 May 2015 19:28:02 +0200
Message-ID: <1430587703-3387-14-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:36963 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbbEBR2G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:06 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit "Simplify cidr handling for hash:*net* types" broke the cidr
handling for the hash:*net* types when the sets were used by the SET
target: entries with invalid cidr values were added to the sets.
Reported by Jonathan Johnson.

Testsuite entry is added to verify the fix.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h       |  2 --
 net/netfilter/ipset/ip_set_hash_gen.h        | 43 +++++++++++++++++-----------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  4 +--
 net/netfilter/ipset/ip_set_hash_net.c        |  4 +--
 net/netfilter/ipset/ip_set_hash_netiface.c   |  4 +--
 net/netfilter/ipset/ip_set_hash_netnet.c     |  8 +++---
 net/netfilter/ipset/ip_set_hash_netport.c    |  4 +--
 net/netfilter/ipset/ip_set_hash_netportnet.c |  8 +++---
 8 files changed, 42 insertions(+), 35 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 77789e5..acd7525 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -568,8 +568,6 @@ ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
 	{ .bytes = ULLONG_MAX, .packets = ULLONG_MAX,	\
 	  .timeout = (set)->timeout }
 
-#define IP_SET_INIT_CIDR(a, b) ((a) ? (a) : (b))
-
 #define IPSET_CONCAT(a, b)		a##b
 #define IPSET_TOKEN(a, b)		IPSET_CONCAT(a, b)
 
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 69f2b25..cab8857 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -133,17 +133,21 @@ htable_bits(u32 hashsize)
 #endif
 
 /* cidr + 1 is stored in net_prefixes to support /0 */
-#define SCIDR(cidr, i)		(__CIDR(cidr, i) + 1)
+#define NCIDR_PUT(cidr)		((cidr) + 1)
+#define NCIDR_GET(cidr)		((cidr) - 1)
 
 #ifdef IP_SET_HASH_WITH_NETS_PACKED
 /* When cidr is packed with nomatch, cidr - 1 is stored in the data entry */
-#define GCIDR(cidr, i)		(__CIDR(cidr, i) + 1)
-#define NCIDR(cidr)		(cidr)
+#define DCIDR_PUT(cidr)		((cidr) - 1)
+#define DCIDR_GET(cidr, i)	(__CIDR(cidr, i) + 1)
 #else
-#define GCIDR(cidr, i)		(__CIDR(cidr, i))
-#define NCIDR(cidr)		(cidr - 1)
+#define DCIDR_PUT(cidr)		(cidr)
+#define DCIDR_GET(cidr, i)	__CIDR(cidr, i)
 #endif
 
+#define INIT_CIDR(cidr, host_mask)	\
+	DCIDR_PUT(((cidr) ? NCIDR_GET(cidr) : host_mask))
+
 #define SET_HOST_MASK(family)	(family == AF_INET ? 32 : 128)
 
 #ifdef IP_SET_HASH_WITH_NET0
@@ -274,7 +278,8 @@ struct htype {
 
 #ifdef IP_SET_HASH_WITH_NETS
 /* Network cidr size book keeping when the hash stores different
- * sized networks */
+ * sized networks. cidr == real cidr + 1 to support /0.
+ */
 static void
 mtype_add_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
 {
@@ -475,8 +480,10 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 				pr_debug("expired %u/%u\n", i, j);
 #ifdef IP_SET_HASH_WITH_NETS
 				for (k = 0; k < IPSET_NET_COUNT; k++)
-					mtype_del_cidr(h, SCIDR(data->cidr, k),
-						       nets_length, k);
+					mtype_del_cidr(h,
+						NCIDR_PUT(DCIDR_GET(data->cidr,
+								    k)),
+						nets_length, k);
 #endif
 				ip_set_ext_destroy(set, data);
 				clear_bit(j, n->used);
@@ -739,8 +746,9 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (!deleted) {
 #ifdef IP_SET_HASH_WITH_NETS
 			for (i = 0; i < IPSET_NET_COUNT; i++)
-				mtype_del_cidr(h, SCIDR(data->cidr, i),
-					       NLEN(set->family), i);
+				mtype_del_cidr(h,
+					NCIDR_PUT(DCIDR_GET(data->cidr, i)),
+					NLEN(set->family), i);
 #endif
 			ip_set_ext_destroy(set, data);
 			h->elements--;
@@ -775,7 +783,7 @@ copy_data:
 	h->elements++;
 #ifdef IP_SET_HASH_WITH_NETS
 	for (i = 0; i < IPSET_NET_COUNT; i++)
-		mtype_add_cidr(h, SCIDR(d->cidr, i),
+		mtype_add_cidr(h, NCIDR_PUT(DCIDR_GET(d->cidr, i)),
 			       NLEN(set->family), i);
 #endif
 	memcpy(data, d, sizeof(struct mtype_elem));
@@ -846,8 +854,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		h->elements--;
 #ifdef IP_SET_HASH_WITH_NETS
 		for (j = 0; j < IPSET_NET_COUNT; j++)
-			mtype_del_cidr(h, SCIDR(d->cidr, j), NLEN(set->family),
-				       j);
+			mtype_del_cidr(h, NCIDR_PUT(DCIDR_GET(d->cidr, j)),
+				       NLEN(set->family), j);
 #endif
 		ip_set_ext_destroy(set, data);
 
@@ -922,12 +930,13 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 	for (; j < nets_length && h->nets[j].cidr[0] && !multi; j++) {
 #if IPSET_NET_COUNT == 2
 		mtype_data_reset_elem(d, &orig);
-		mtype_data_netmask(d, NCIDR(h->nets[j].cidr[0]), false);
+		mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]), false);
 		for (k = 0; k < nets_length && h->nets[k].cidr[1] && !multi;
 		     k++) {
-			mtype_data_netmask(d, NCIDR(h->nets[k].cidr[1]), true);
+			mtype_data_netmask(d, NCIDR_GET(h->nets[k].cidr[1]),
+					   true);
 #else
-		mtype_data_netmask(d, NCIDR(h->nets[j].cidr[0]));
+		mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]));
 #endif
 		key = HKEY(d, h->initval, t->htable_bits);
 		n =  rcu_dereference_bh(hbucket(t, key));
@@ -978,7 +987,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	/* If we test an IP address and not a network address,
 	 * try all possible network sizes */
 	for (i = 0; i < IPSET_NET_COUNT; i++)
-		if (GCIDR(d->cidr, i) != SET_HOST_MASK(set->family))
+		if (DCIDR_GET(d->cidr, i) != SET_HOST_MASK(set->family))
 			break;
 	if (i == IPSET_NET_COUNT) {
 		ret = mtype_test_cidrs(set, d, ext, mext, flags);
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 291c03f..89e3ec3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -142,7 +142,7 @@ hash_ipportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_ipportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet4_elem e = {
-		.cidr = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK) - 1,
+		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
@@ -398,7 +398,7 @@ hash_ipportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_ipportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet6_elem e = {
-		.cidr = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK) - 1,
+		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index f6dcbfb..8e88005 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -121,7 +121,7 @@ hash_net4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_net *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net4_elem e = {
-		.cidr = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
@@ -294,7 +294,7 @@ hash_net6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_net *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net6_elem e = {
-		.cidr = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index e039c6b..3c5ee94 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -160,7 +160,7 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netiface *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface4_elem e = {
-		.cidr = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
 		.elem = 1,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
@@ -377,7 +377,7 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netiface *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface6_elem e = {
-		.cidr = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
 		.elem = 1,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 5f91538..4e41086 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -142,8 +142,8 @@ hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	e.cidr[0] = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] = IP_SET_INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	e.cidr[0] = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
+	e.cidr[1] = INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
 
@@ -373,8 +373,8 @@ hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	e.cidr[0] = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] = IP_SET_INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	e.cidr[0] = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
+	e.cidr[1] = INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(u8)*8)) | HOST_MASK;
 
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 0c915e8..5c00026 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -137,7 +137,7 @@ hash_netport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_netport *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem e = {
-		.cidr = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK) - 1,
+		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
@@ -357,7 +357,7 @@ hash_netport6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_netport *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport6_elem e = {
-		.cidr = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK) - 1,
+		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 14b3d38..9c3558a 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -153,8 +153,8 @@ hash_netportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	e.cidr[0] = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] = IP_SET_INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	e.cidr[0] = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
+	e.cidr[1] = INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
 
@@ -430,8 +430,8 @@ hash_netportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netportnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	e.cidr[0] = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] = IP_SET_INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	e.cidr[0] = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
+	e.cidr[1] = INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
 
-- 
1.8.5.1

