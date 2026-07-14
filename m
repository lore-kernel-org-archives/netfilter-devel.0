Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C763288C0E
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jul 2026 13:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784035132; cv=none; b=c7ZIzuddpGO1LbiXhNnCUHczXLM/5bpfuGR/TUP4rCvxTkEAeZXlUa20/GkGndOSTUg6A6dtBCMGypQA6XoZwuPk1bawqBFvNVWNPY9JGUgc9Gk+DeedW0Zam3wq5YTk3VfwqR/iiU9Q75QBi4ke7is2DWPTmvu2BdX+nosuT2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784035132; c=relaxed/simple;
	bh=a8AZW3eLMvJ7Axp6rhvJpoOpTuaPC06vBUl+NsDaxxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDretuEJ0UfkkctuKRwuP8PAnupa7kQgozm3AkXzkTox3o8HsLh3d0QbhcIlzJF0XkxT8Mtezv/IPfY6ctLbArVkiuCl4gaSpnVnGLut+VN9320BlasKtLQ7j+6gNtOeWGz8pCXMfo/WaaP4E6evDsw6jiPmiCNNMgUtkxAkvSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 18F7A60503; Tue, 14 Jul 2026 15:18:45 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 01/12] netfilter: ipset: rework cidr bookkeeping
Date: Tue, 14 Jul 2026 15:18:17 +0200
Message-ID: <20260714131828.10685-2-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714131828.10685-1-fw@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

According to sashiko, the current bookkeeping of cidr values
are unsafe on weakly-ordered architectures. Replace the
in-place updating with an RCU based method: create the new
bookeeping structure, update and replace the old one with
the new. Downside that we need to allocate memory when deleting
a cidr entry - in case of memory pressure fall back to leave
holes which possibility is taken into account at evaluation time.

Thanks to Pablo (Pablo Neira Ayuso <pablo@netfilter.org>) and
Cyntia (Cynthia <cynthia@kosmx.dev>) for helping me in debugging
which resulted the patch "netfilter: ipset: allocate the proper
memory for the generic hash structure" on which this very patch
depends.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h        | 230 ++++++++++++-------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   4 +-
 net/netfilter/ipset/ip_set_hash_net.c        |   4 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |   4 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |  12 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |   4 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |  12 +-
 7 files changed, 177 insertions(+), 93 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 8231317b0f1f..a6b282ad8c48 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -99,9 +99,16 @@ struct htable {
 #endif
 
 /* Book-keeping of the prefixes added to the set */
+struct net_prefix {
+	u8 cidr;			/* the cidr value */
+	u32 count;			/* number of elements of this cidr */
+};
+
 struct net_prefixes {
-	u32 nets[IPSET_NET_COUNT]; /* number of elements for this cidr */
-	u8 cidr[IPSET_NET_COUNT];  /* the cidr value */
+	struct rcu_head rcu;
+	u8 len;
+	struct net_prefix nets[]
+		__aligned(__alignof__(u64));
 };
 
 /* Compute the hash table size */
@@ -127,11 +134,6 @@ htable_size(u8 hbits)
 #else
 #define __CIDR(cidr, i)		(cidr)
 #endif
-
-/* cidr + 1 is stored in net_prefixes to support /0 */
-#define NCIDR_PUT(cidr)		((cidr) + 1)
-#define NCIDR_GET(cidr)		((cidr) - 1)
-
 #ifdef IP_SET_HASH_WITH_NETS_PACKED
 /* When cidr is packed with nomatch, cidr - 1 is stored in the data entry */
 #define DCIDR_PUT(cidr)		((cidr) - 1)
@@ -141,21 +143,9 @@ htable_size(u8 hbits)
 #define DCIDR_GET(cidr, i)	__CIDR(cidr, i)
 #endif
 
-#define INIT_CIDR(cidr, host_mask)	\
-	DCIDR_PUT(((cidr) ? NCIDR_GET(cidr) : host_mask))
-
-#ifdef IP_SET_HASH_WITH_NET0
-/* cidr from 0 to HOST_MASK value and c = cidr + 1 */
-#define NLEN			(HOST_MASK + 1)
-#define CIDR_POS(c)		((c) - 1)
-#else
-/* cidr from 1 to HOST_MASK value and c = cidr + 1 */
-#define NLEN			HOST_MASK
-#define CIDR_POS(c)		((c) - 2)
-#endif
+#define INIT_CIDR(n, host_mask)	\
+	DCIDR_PUT((n)->len ? (n)->nets[0].cidr : host_mask)
 
-#else
-#define NLEN			0
 #endif /* IP_SET_HASH_WITH_NETS */
 
 #define SET_ELEM_EXPIRED(set, d)	\
@@ -292,6 +282,7 @@ static const union nf_inet_addr zeromask = {};
 /* The generic hash structure */
 struct htype {
 	struct htable __rcu *table; /* the hash table */
+	struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
 	struct htable_gc gc;	/* gc workqueue */
 	u32 maxelem;		/* max elements in the hash */
 	u32 initval;		/* random jhash init value */
@@ -302,9 +293,6 @@ struct htype {
 #if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
 	u8 netmask;		/* netmask value for subnets to store */
 	union nf_inet_addr bitmask;	/* stores bitmask */
-#endif
-#ifdef IP_SET_HASH_WITH_NETS
-	struct net_prefixes nets[NLEN]; /* book-keeping of prefixes */
 #endif
 	/* Because 'next' is IPv4/IPv6 dependent, no elements of this
 	 * structure and referred in create() may come after 'next'.
@@ -326,50 +314,88 @@ struct mtype_resize_ad {
 /* Network cidr size book keeping when the hash stores different
  * sized networks. cidr == real cidr + 1 to support /0.
  */
-static void
+static int
 mtype_add_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 {
-	int i, j;
+	struct net_prefixes *nets, *tmp;
+	int i, j, found, len = 0, ret = 0;
 
 	spin_lock_bh(&set->lock);
+	nets = __ipset_dereference(h->rnets[n]);
 	/* Add in increasing prefix order, so larger cidr first */
-	for (i = 0, j = -1; i < NLEN && h->nets[i].cidr[n]; i++) {
-		if (j != -1) {
+	for (i = 0, found = -1; i < nets->len; i++) {
+		if (nets->nets[i].count)
+			len++;
+		if (found != -1) {
 			continue;
-		} else if (h->nets[i].cidr[n] < cidr) {
-			j = i;
-		} else if (h->nets[i].cidr[n] == cidr) {
-			h->nets[CIDR_POS(cidr)].nets[n]++;
+		} else if (nets->nets[i].cidr < cidr) {
+			found = i;
+		} else if (nets->nets[i].cidr == cidr) {
+			nets->nets[i].count++;
 			goto unlock;
 		}
 	}
-	if (j != -1) {
-		for (; i > j; i--)
-			h->nets[i].cidr[n] = h->nets[i - 1].cidr[n];
+	len++;
+	tmp = kzalloc(sizeof(struct net_prefixes) +
+		      len * sizeof(struct net_prefix), GFP_ATOMIC);
+	if (!tmp)
+		return -ENOMEM;
+	tmp->len = len;
+	for (i = 0, j = 0; i < nets->len; i++) {
+		if (!nets->nets[i].count)
+			continue;
+		if (i == found) {
+			tmp->nets[j].cidr = cidr;
+			tmp->nets[j++].count = 1;
+		}
+		tmp->nets[j].cidr = nets->nets[i].cidr;
+		tmp->nets[j++].count = nets->nets[i].count;
+	}
+	if (found == -1) {
+		tmp->nets[j].cidr = cidr;
+		tmp->nets[j].count = 1;
 	}
-	h->nets[i].cidr[n] = cidr;
-	h->nets[CIDR_POS(cidr)].nets[n] = 1;
+	rcu_assign_pointer(h->rnets[n], tmp);
+	kfree_rcu(nets, rcu);
 unlock:
 	spin_unlock_bh(&set->lock);
+	return ret;
 }
 
 static void
 mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 {
-	u8 i, j, net_end = NLEN - 1;
+	struct net_prefixes *nets, *tmp;
+	u8 i, j, found, len = 0;
 
 	spin_lock_bh(&set->lock);
-	for (i = 0; i < NLEN; i++) {
-		if (h->nets[i].cidr[n] != cidr)
-			continue;
-		h->nets[CIDR_POS(cidr)].nets[n]--;
-		if (h->nets[CIDR_POS(cidr)].nets[n] > 0)
-			goto unlock;
-		for (j = i; j < net_end && h->nets[j].cidr[n]; j++)
-			h->nets[j].cidr[n] = h->nets[j + 1].cidr[n];
-		h->nets[j].cidr[n] = 0;
+	nets = __ipset_dereference(h->rnets[n]);
+	for (i = 0, found = -1; i < nets->len; i++) {
+		if (nets->nets[i].count)
+			len++;
+		if (nets->nets[i].cidr == cidr)
+			found = i;
+	}
+	if (unlikely(found == -1))
+		return;
+	nets->nets[found].count--;
+	if (nets->nets[found].count)
 		goto unlock;
+	len--;
+	tmp = kzalloc(sizeof(struct net_prefixes) +
+		      len * sizeof(struct net_prefix), GFP_ATOMIC);
+	if (!tmp)
+		/* Leave a hole */
+		return;
+	tmp->len = len;
+	for (i = 0, j = 0; i < nets->len; i++) {
+		if (!nets->nets[i].count || i == found)
+			continue;
+		tmp->nets[j].cidr = nets->nets[i].cidr;
+		tmp->nets[j++].count = nets->nets[i].count;
 	}
+	rcu_assign_pointer(h->rnets[n], tmp);
+	kfree_rcu(nets, rcu);
 unlock:
 	spin_unlock_bh(&set->lock);
 }
@@ -402,6 +428,9 @@ static void
 mtype_flush(struct ip_set *set)
 {
 	struct htype *h = set->data;
+#ifdef IP_SET_HASH_WITH_NETS
+	struct net_prefixes *nets, *tmp;
+#endif
 	struct htable *t;
 	struct hbucket *n;
 	u32 r, i;
@@ -425,7 +454,19 @@ mtype_flush(struct ip_set *set)
 		spin_unlock_bh(&t->hregion[r].lock);
 	}
 #ifdef IP_SET_HASH_WITH_NETS
-	memset(h->nets, 0, sizeof(h->nets));
+	for (i = 0; i < IPSET_NET_COUNT; i++) {
+		nets = ipset_dereference_nfnl(h->rnets[i]);
+		tmp = kzalloc(sizeof(struct net_prefixes), GFP_ATOMIC);
+		if (!tmp) {
+			u8 j;
+
+			for (j = 0; j < nets->len; j++)
+				nets->nets[j].count = 0;
+		} else {
+			rcu_assign_pointer(h->rnets[i], tmp);
+			kfree_rcu(nets, rcu);
+		}
+	}
 #endif
 }
 
@@ -433,6 +474,9 @@ mtype_flush(struct ip_set *set)
 static void
 mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
 {
+#ifdef IP_SET_HASH_WITH_NETS
+	struct htype *h = set->data;
+#endif
 	struct hbucket *n;
 	u32 i;
 
@@ -446,6 +490,11 @@ mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
 		kfree(n);
 	}
 
+#ifdef IP_SET_HASH_WITH_NETS
+	if (ext_destroy)
+		for (i = 0; i < IPSET_NET_COUNT; i++)
+			kfree(h->rnets[i]);
+#endif
 	ip_set_free(t->hregion);
 	ip_set_free(t);
 }
@@ -519,8 +568,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 #ifdef IP_SET_HASH_WITH_NETS
 			for (k = 0; k < IPSET_NET_COUNT; k++)
 				mtype_del_cidr(set, h,
-					NCIDR_PUT(DCIDR_GET(data->cidr, k)),
-					k);
+					DCIDR_GET(data->cidr, k), k);
 #endif
 			t->hregion[r].elements--;
 			ip_set_ext_destroy(set, data);
@@ -950,8 +998,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #ifdef IP_SET_HASH_WITH_NETS
 			for (i = 0; i < IPSET_NET_COUNT; i++)
 				mtype_del_cidr(set, h,
-					NCIDR_PUT(DCIDR_GET(data->cidr, i)),
-					i);
+					DCIDR_GET(data->cidr, i), i);
 #endif
 			ip_set_ext_destroy(set, data);
 			t->hregion[r].elements--;
@@ -996,7 +1043,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	t->hregion[r].elements++;
 #ifdef IP_SET_HASH_WITH_NETS
 	for (i = 0; i < IPSET_NET_COUNT; i++)
-		mtype_add_cidr(set, h, NCIDR_PUT(DCIDR_GET(d->cidr, i)), i);
+		mtype_add_cidr(set, h, DCIDR_GET(d->cidr, i), i);
 #endif
 	memcpy(data, d, sizeof(struct mtype_elem));
 overwrite_extensions:
@@ -1110,7 +1157,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #ifdef IP_SET_HASH_WITH_NETS
 		for (j = 0; j < IPSET_NET_COUNT; j++)
 			mtype_del_cidr(set, h,
-				       NCIDR_PUT(DCIDR_GET(d->cidr, j)), j);
+				DCIDR_GET(d->cidr, j), j);
 #endif
 		ip_set_ext_destroy(set, data);
 
@@ -1193,28 +1240,37 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 {
 	struct htype *h = set->data;
 	struct htable *t = rcu_dereference_bh(h->table);
+	struct net_prefixes *nets0;
 	struct hbucket *n;
 	struct mtype_elem *data;
 #if IPSET_NET_COUNT == 2
+	struct net_prefixes *nets1;
 	struct mtype_elem orig = *d;
-	int ret, i, j = 0, k;
+	int ret, i, j, k;
 #else
-	int ret, i, j = 0;
+	int ret, i, j;
 #endif
 	u32 key, multi = 0;
 	u8 pos;
 
 	pr_debug("test by nets\n");
-	for (; j < NLEN && h->nets[j].cidr[0] && !multi; j++) {
+	rcu_read_lock_bh();
+	nets0 = rcu_dereference_bh(h->rnets[0]);
+#if IPSET_NET_COUNT == 2
+	nets1 = rcu_dereference_bh(h->rnets[1]);
+#endif
+	for (j = 0; j < nets0->len && !multi; j++) {
+		if (!nets0->nets[j].count)
+			continue;
 #if IPSET_NET_COUNT == 2
 		mtype_data_reset_elem(d, &orig);
-		mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]), false);
-		for (k = 0; k < NLEN && h->nets[k].cidr[1] && !multi;
-		     k++) {
-			mtype_data_netmask(d, NCIDR_GET(h->nets[k].cidr[1]),
-					   true);
+		mtype_data_netmask(d, nets0->nets[j].cidr, false);
+		for (k = 0; k < nets1->len && !multi; k++) {
+			if (!nets1->nets[k].count)
+				continue;
+			mtype_data_netmask(d, nets1->nets[k].cidr, true);
 #else
-		mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]));
+		mtype_data_netmask(d, nets0->nets[j].cidr);
 #endif
 		key = HKEY(d, h->initval, t->htable_bits);
 		n = rcu_dereference_bh(hbucket(t, key));
@@ -1229,7 +1285,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 				continue;
 			ret = mtype_data_match(data, ext, mext, set, flags);
 			if (ret != 0)
-				return ret;
+				goto unlock;
 #ifdef IP_SET_HASH_WITH_MULTI
 			/* No match, reset multiple match flag */
 			multi = 0;
@@ -1239,7 +1295,10 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 		}
 #endif
 	}
-	return 0;
+	ret = 0;
+unlock:
+	rcu_read_unlock_bh();
+	return ret;
 }
 #endif
 
@@ -1504,6 +1563,9 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	int ret __attribute__((unused)) = 0;
 	u8 netmask = set->family == NFPROTO_IPV4 ? 32 : 128;
 	union nf_inet_addr bitmask = onesmask;
+#endif
+#ifdef IP_SET_HASH_WITH_NETS
+	struct net_prefixes *nets;
 #endif
 	size_t hsize;
 	struct htype *h;
@@ -1604,21 +1666,25 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	 */
 	hbits = fls(hashsize - 1);
 	hsize = htable_size(hbits);
-	if (hsize == 0) {
-		kfree(h);
-		return -ENOMEM;
-	}
+	if (hsize == 0)
+		goto free_h;
 	t = ip_set_alloc(hsize);
-	if (!t) {
-		kfree(h);
-		return -ENOMEM;
-	}
+	if (!t)
+		goto free_h;
 	t->hregion = ip_set_alloc(ahash_sizeof_regions(hbits));
-	if (!t->hregion) {
-		ip_set_free(t);
-		kfree(h);
-		return -ENOMEM;
+	if (!t->hregion)
+		goto free_t;
+#ifdef IP_SET_HASH_WITH_NETS
+	for (i = 0; i < IPSET_NET_COUNT; i++) {
+		nets = kzalloc(sizeof(struct net_prefixes), GFP_KERNEL);
+		if (!nets) {
+			while (i > 0)
+				kfree(h->rnets[--i]);
+			goto free_hregion;
+		}
+		RCU_INIT_POINTER(h->rnets[i], nets);
 	}
+#endif
 	h->gc.set = set;
 	spin_lock_init(&h->gc.lock);
 	for (i = 0; i < ahash_numof_locks(hbits); i++)
@@ -1682,6 +1748,16 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 		 t->htable_bits, h->maxelem, set->data, t);
 
 	return 0;
+
+#ifdef IP_SET_HASH_WITH_NETS
+free_hregion:
+	ip_set_free(t->hregion);
+#endif
+free_t:
+	ip_set_free(t);
+free_h:
+	kfree(h);
+	return -ENOMEM;
 }
 #endif /* IP_SET_EMIT_CREATE */
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 2d6652d43199..195853a25b06 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -138,7 +138,7 @@ hash_ipportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_ipportnet4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet4_elem e = {
-		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr = INIT_CIDR(h->rnets[0], HOST_MASK),
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
@@ -398,7 +398,7 @@ hash_ipportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_ipportnet6 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet6_elem e = {
-		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr = INIT_CIDR(h->rnets[0], HOST_MASK),
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index ce0a9ce5a91f..092f3c9281b8 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -117,7 +117,7 @@ hash_net4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_net4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net4_elem e = {
-		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr = INIT_CIDR(h->rnets[0], HOST_MASK),
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
@@ -291,7 +291,7 @@ hash_net6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_net6 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net6_elem e = {
-		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr = INIT_CIDR(h->rnets[0], HOST_MASK),
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 30a655e5c4fd..b44b95f766b7 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -161,7 +161,7 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netiface4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface4_elem e = {
-		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr = INIT_CIDR(h->rnets[0], HOST_MASK),
 		.elem = 1,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
@@ -382,7 +382,7 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netiface6 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface6_elem e = {
-		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr = INIT_CIDR(h->rnets[0], HOST_MASK),
 		.elem = 1,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 8fbe649c9dd3..f7c8a1cc30fc 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -149,8 +149,10 @@ hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	e.cidr[0] = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] = INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	rcu_read_lock_bh();
+	e.cidr[0] = INIT_CIDR(h->rnets[0], HOST_MASK);
+	e.cidr[1] = INIT_CIDR(h->rnets[1], HOST_MASK);
+	rcu_read_unlock_bh();
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
 
@@ -388,8 +390,10 @@ hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	e.cidr[0] = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] = INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	rcu_read_lock_bh();
+	e.cidr[0] = INIT_CIDR(h->rnets[0], HOST_MASK);
+	e.cidr[1] = INIT_CIDR(h->rnets[1], HOST_MASK);
+	rcu_read_unlock_bh();
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
 
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index d1a0628df4ef..5de4b511de76 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -133,7 +133,7 @@ hash_netport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_netport4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem e = {
-		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr = INIT_CIDR(h->rnets[0], HOST_MASK),
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
@@ -353,7 +353,7 @@ hash_netport6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_netport6 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport6_elem e = {
-		.cidr = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr = INIT_CIDR(h->rnets[0], HOST_MASK),
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index bf4f91b78e1d..6291532be7a5 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -157,8 +157,10 @@ hash_netportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	e.cidr[0] = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] = INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	rcu_read_lock_bh();
+	e.cidr[0] = INIT_CIDR(h->rnets[0], HOST_MASK);
+	e.cidr[1] = INIT_CIDR(h->rnets[1], HOST_MASK);
+	rcu_read_unlock_bh();
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
 
@@ -452,8 +454,10 @@ hash_netportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netportnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	e.cidr[0] = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] = INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	rcu_read_lock_bh();
+	e.cidr[0] = INIT_CIDR(h->rnets[0], HOST_MASK);
+	e.cidr[1] = INIT_CIDR(h->rnets[1], HOST_MASK);
+	rcu_read_unlock_bh();
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
 
-- 
2.54.0

