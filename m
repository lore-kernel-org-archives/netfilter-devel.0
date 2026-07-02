Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D22D224D6
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jul 2026 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783000037; cv=none; b=bkM6Wo9oDEMpLjJqkZjapc+A7kaspBtGVOgGCJG/dwn3e/IpYOF3K2PjCYs60X2RMsdb18qeC0bYQLFo3PfjW2UlY4+xm5CjjpP+YMNWD9HYEOrLJ0+EoP07K2eFDHgXcvUIzmkfS9sFLwpqM2msrm4hlgFhYOUzKm1d7M1b34M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783000037; c=relaxed/simple;
	bh=6VIU8yniXFXgP3XCpAzFwrDtF5UvuHqgRsB68fFsQUI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p6gxyeJhwFvXEg0QFUuw5hnvonUEKoBzF4KYvJHIBF4JLYFEKs6XbGslqM1CGq8znLz7/Lz8idoy1JIFYQWcyTHWajPjqvVu3FrOTpT7gfUhEdedI2uJmuFhRV1EY/BruPlh2nq+1iTtPZlg/CcIrAmch7hqDmOsL+zid+lzm44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=BPsKlNBS; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="BPsKlNBS"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4grdV33pG3z7s7wR;
	Thu, 02 Jul 2026 15:47:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1783000025; x=1784814426; bh=kFWsg///Nf
	gL0tXe+mWHKcUgB7p29rrlABtcm2ExiF0=; b=BPsKlNBSySgUNBal8G6C1UlXMz
	IPX9S5+moXFN6ZzQ2Wsaydgq7ejShDAa1QCcitguHsQQTBZM3iqLEQ87pYWUpd1X
	43myBlmhWPas84ZJCjONaoG2iTcX+IN6v+JMW3MLDDQIu+a6DwjQXf0Y4k9RPT5v
	/q9jHCrVxw4Vw8nzc=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id wLFYDzPjuXFo; Thu,  2 Jul 2026 15:47:05 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4grdTy0H2Sz7s7wT;
	Thu, 02 Jul 2026 15:47:02 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 8C2301408FA; Thu,  2 Jul 2026 15:47:01 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/5] netfilter: ipset: rework cidr bookkeeping
Date: Thu,  2 Jul 2026 15:47:01 +0200
Message-Id: <20260702134701.207721-6-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260702134701.207721-1-kadlec@netfilter.org>
References: <20260702134701.207721-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

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
---
 net/netfilter/ipset/ip_set_hash_gen.h        | 228 ++++++++++++-------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   4 +-
 net/netfilter/ipset/ip_set_hash_net.c        |   4 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |   4 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |  12 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |   4 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |  12 +-
 7 files changed, 175 insertions(+), 93 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 8231317b0f1f..2b473acad50c 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -99,9 +99,16 @@ struct htable {
 #endif
=20
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
=20
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
 /* When cidr is packed with nomatch, cidr - 1 is stored in the data entr=
y */
 #define DCIDR_PUT(cidr)		((cidr) - 1)
@@ -141,21 +143,9 @@ htable_size(u8 hbits)
 #define DCIDR_GET(cidr, i)	__CIDR(cidr, i)
 #endif
=20
-#define INIT_CIDR(cidr, host_mask)	\
-	DCIDR_PUT(((cidr) ? NCIDR_GET(cidr) : host_mask))
-
-#ifdef IP_SET_HASH_WITH_NET0
-/* cidr from 0 to HOST_MASK value and c =3D cidr + 1 */
-#define NLEN			(HOST_MASK + 1)
-#define CIDR_POS(c)		((c) - 1)
-#else
-/* cidr from 1 to HOST_MASK value and c =3D cidr + 1 */
-#define NLEN			HOST_MASK
-#define CIDR_POS(c)		((c) - 2)
-#endif
+#define INIT_CIDR(n, host_mask)	\
+	DCIDR_PUT((n)->len ? (n)->nets[0].cidr : host_mask)
=20
-#else
-#define NLEN			0
 #endif /* IP_SET_HASH_WITH_NETS */
=20
 #define SET_ELEM_EXPIRED(set, d)	\
@@ -292,6 +282,7 @@ static const union nf_inet_addr zeromask =3D {};
 /* The generic hash structure */
 struct htype {
 	struct htable __rcu *table; /* the hash table */
+	struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
 	struct htable_gc gc;	/* gc workqueue */
 	u32 maxelem;		/* max elements in the hash */
 	u32 initval;		/* random jhash init value */
@@ -302,9 +293,6 @@ struct htype {
 #if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMAS=
K)
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
  * sized networks. cidr =3D=3D real cidr + 1 to support /0.
  */
-static void
+static int
 mtype_add_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 {
-	int i, j;
+	struct net_prefixes *nets, *tmp;
+	int i, j, found, len =3D 0, ret =3D 0;
=20
 	spin_lock_bh(&set->lock);
+	nets =3D __ipset_dereference(h->rnets[n]);
 	/* Add in increasing prefix order, so larger cidr first */
-	for (i =3D 0, j =3D -1; i < NLEN && h->nets[i].cidr[n]; i++) {
-		if (j !=3D -1) {
+	for (i =3D 0, found =3D -1; i < nets->len; i++) {
+		if (nets->nets[i].count)
+			len++;
+		if (found !=3D -1) {
 			continue;
-		} else if (h->nets[i].cidr[n] < cidr) {
-			j =3D i;
-		} else if (h->nets[i].cidr[n] =3D=3D cidr) {
-			h->nets[CIDR_POS(cidr)].nets[n]++;
+		} else if (nets->nets[i].cidr < cidr) {
+			found =3D i;
+		} else if (nets->nets[i].cidr =3D=3D cidr) {
+			nets->nets[i].count++;
 			goto unlock;
 		}
 	}
-	if (j !=3D -1) {
-		for (; i > j; i--)
-			h->nets[i].cidr[n] =3D h->nets[i - 1].cidr[n];
+	len++;
+	tmp =3D kzalloc(sizeof(struct net_prefixes) +
+		      len * sizeof(struct net_prefix), GFP_ATOMIC);
+	if (!tmp)
+		return -ENOMEM;
+	tmp->len =3D len;
+	for (i =3D 0, j =3D 0; i < nets->len; i++) {
+		if (!nets->nets[i].count)
+			continue;
+		if (i =3D=3D found) {
+			tmp->nets[j].cidr =3D cidr;
+			tmp->nets[j++].count =3D 1;
+		}
+		tmp->nets[j].cidr =3D nets->nets[i].cidr;
+		tmp->nets[j++].count =3D nets->nets[i].count;
+	}
+	if (found =3D=3D -1) {
+		tmp->nets[j].cidr =3D cidr;
+		tmp->nets[j].count =3D 1;
 	}
-	h->nets[i].cidr[n] =3D cidr;
-	h->nets[CIDR_POS(cidr)].nets[n] =3D 1;
+	rcu_assign_pointer(h->rnets[n], tmp);
+	kfree_rcu(nets, rcu);
 unlock:
 	spin_unlock_bh(&set->lock);
+	return ret;
 }
=20
 static void
 mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 {
-	u8 i, j, net_end =3D NLEN - 1;
+	struct net_prefixes *nets, *tmp;
+	u8 i, j, found, len =3D 0;
=20
 	spin_lock_bh(&set->lock);
-	for (i =3D 0; i < NLEN; i++) {
-		if (h->nets[i].cidr[n] !=3D cidr)
-			continue;
-		h->nets[CIDR_POS(cidr)].nets[n]--;
-		if (h->nets[CIDR_POS(cidr)].nets[n] > 0)
-			goto unlock;
-		for (j =3D i; j < net_end && h->nets[j].cidr[n]; j++)
-			h->nets[j].cidr[n] =3D h->nets[j + 1].cidr[n];
-		h->nets[j].cidr[n] =3D 0;
+	nets =3D __ipset_dereference(h->rnets[n]);
+	for (i =3D 0, found =3D -1; i < nets->len; i++) {
+		if (nets->nets[i].count)
+			len++;
+		if (nets->nets[i].cidr =3D=3D cidr)
+			found =3D i;
+	}
+	if (unlikely(found =3D=3D -1))
+		return;
+	nets->nets[found].count--;
+	if (nets->nets[found].count)
 		goto unlock;
+	len--;
+	tmp =3D kzalloc(sizeof(struct net_prefixes) +
+		      len * sizeof(struct net_prefix), GFP_ATOMIC);
+	if (!tmp)
+		/* Leave a hole */
+		return;
+	tmp->len =3D len;
+	for (i =3D 0, j =3D 0; i < nets->len; i++) {
+		if (!nets->nets[i].count || i =3D=3D found)
+			continue;
+		tmp->nets[j].cidr =3D nets->nets[i].cidr;
+		tmp->nets[j++].count =3D nets->nets[i].count;
 	}
+	rcu_assign_pointer(h->rnets[n], tmp);
+	kfree_rcu(nets, rcu);
 unlock:
 	spin_unlock_bh(&set->lock);
 }
@@ -402,6 +428,9 @@ static void
 mtype_flush(struct ip_set *set)
 {
 	struct htype *h =3D set->data;
+#ifdef IP_SET_HASH_WITH_NETS
+	struct net_prefixes *nets, *tmp;
+#endif
 	struct htable *t;
 	struct hbucket *n;
 	u32 r, i;
@@ -425,7 +454,17 @@ mtype_flush(struct ip_set *set)
 		spin_unlock_bh(&t->hregion[r].lock);
 	}
 #ifdef IP_SET_HASH_WITH_NETS
-	memset(h->nets, 0, sizeof(h->nets));
+	for (i =3D 0; i < IPSET_NET_COUNT; i++) {
+		nets =3D ipset_dereference_nfnl(h->rnets[i]);
+		tmp =3D kzalloc(sizeof(struct net_prefixes), GFP_ATOMIC);
+		if (!tmp) {
+			for (i =3D 0; i < nets->len; i++)
+				nets->nets[i].count =3D 0;
+		} else {
+			rcu_assign_pointer(h->rnets[i], tmp);
+			kfree_rcu(nets, rcu);
+		}
+	}
 #endif
 }
=20
@@ -433,6 +472,9 @@ mtype_flush(struct ip_set *set)
 static void
 mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destr=
oy)
 {
+#ifdef IP_SET_HASH_WITH_NETS
+	struct htype *h =3D set->data;
+#endif
 	struct hbucket *n;
 	u32 i;
=20
@@ -446,6 +488,11 @@ mtype_ahash_destroy(struct ip_set *set, struct htabl=
e *t, bool ext_destroy)
 		kfree(n);
 	}
=20
+#ifdef IP_SET_HASH_WITH_NETS
+	if (ext_destroy)
+		for (i =3D 0; i < IPSET_NET_COUNT; i++)
+			kfree(h->rnets[i]);
+#endif
 	ip_set_free(t->hregion);
 	ip_set_free(t);
 }
@@ -519,8 +566,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, stru=
ct htable *t, u32 r)
 #ifdef IP_SET_HASH_WITH_NETS
 			for (k =3D 0; k < IPSET_NET_COUNT; k++)
 				mtype_del_cidr(set, h,
-					NCIDR_PUT(DCIDR_GET(data->cidr, k)),
-					k);
+					DCIDR_GET(data->cidr, k), k);
 #endif
 			t->hregion[r].elements--;
 			ip_set_ext_destroy(set, data);
@@ -950,8 +996,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 #ifdef IP_SET_HASH_WITH_NETS
 			for (i =3D 0; i < IPSET_NET_COUNT; i++)
 				mtype_del_cidr(set, h,
-					NCIDR_PUT(DCIDR_GET(data->cidr, i)),
-					i);
+					DCIDR_GET(data->cidr, i), i);
 #endif
 			ip_set_ext_destroy(set, data);
 			t->hregion[r].elements--;
@@ -996,7 +1041,7 @@ mtype_add(struct ip_set *set, void *value, const str=
uct ip_set_ext *ext,
 	t->hregion[r].elements++;
 #ifdef IP_SET_HASH_WITH_NETS
 	for (i =3D 0; i < IPSET_NET_COUNT; i++)
-		mtype_add_cidr(set, h, NCIDR_PUT(DCIDR_GET(d->cidr, i)), i);
+		mtype_add_cidr(set, h, DCIDR_GET(d->cidr, i), i);
 #endif
 	memcpy(data, d, sizeof(struct mtype_elem));
 overwrite_extensions:
@@ -1110,7 +1155,7 @@ mtype_del(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 #ifdef IP_SET_HASH_WITH_NETS
 		for (j =3D 0; j < IPSET_NET_COUNT; j++)
 			mtype_del_cidr(set, h,
-				       NCIDR_PUT(DCIDR_GET(d->cidr, j)), j);
+				DCIDR_GET(d->cidr, j), j);
 #endif
 		ip_set_ext_destroy(set, data);
=20
@@ -1193,28 +1238,37 @@ mtype_test_cidrs(struct ip_set *set, struct mtype=
_elem *d,
 {
 	struct htype *h =3D set->data;
 	struct htable *t =3D rcu_dereference_bh(h->table);
+	struct net_prefixes *nets0;
 	struct hbucket *n;
 	struct mtype_elem *data;
 #if IPSET_NET_COUNT =3D=3D 2
+	struct net_prefixes *nets1;
 	struct mtype_elem orig =3D *d;
-	int ret, i, j =3D 0, k;
+	int ret, i, j, k;
 #else
-	int ret, i, j =3D 0;
+	int ret, i, j;
 #endif
 	u32 key, multi =3D 0;
 	u8 pos;
=20
 	pr_debug("test by nets\n");
-	for (; j < NLEN && h->nets[j].cidr[0] && !multi; j++) {
+	rcu_read_lock_bh();
+	nets0 =3D rcu_dereference_bh(h->rnets[0]);
+#if IPSET_NET_COUNT =3D=3D 2
+	nets1 =3D rcu_dereference_bh(h->rnets[1]);
+#endif
+	for (j =3D 0; j < nets0->len && !multi; j++) {
+		if (!nets0->nets[j].count)
+			continue;
 #if IPSET_NET_COUNT =3D=3D 2
 		mtype_data_reset_elem(d, &orig);
-		mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]), false);
-		for (k =3D 0; k < NLEN && h->nets[k].cidr[1] && !multi;
-		     k++) {
-			mtype_data_netmask(d, NCIDR_GET(h->nets[k].cidr[1]),
-					   true);
+		mtype_data_netmask(d, nets0->nets[j].cidr, false);
+		for (k =3D 0; k < nets1->len && !multi; k++) {
+			if (!nets1->nets[k].count)
+				continue;
+			mtype_data_netmask(d, nets1->nets[k].cidr, true);
 #else
-		mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]));
+		mtype_data_netmask(d, nets0->nets[j].cidr);
 #endif
 		key =3D HKEY(d, h->initval, t->htable_bits);
 		n =3D rcu_dereference_bh(hbucket(t, key));
@@ -1229,7 +1283,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_e=
lem *d,
 				continue;
 			ret =3D mtype_data_match(data, ext, mext, set, flags);
 			if (ret !=3D 0)
-				return ret;
+				goto unlock;
 #ifdef IP_SET_HASH_WITH_MULTI
 			/* No match, reset multiple match flag */
 			multi =3D 0;
@@ -1239,7 +1293,10 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_=
elem *d,
 		}
 #endif
 	}
-	return 0;
+	ret =3D 0;
+unlock:
+	rcu_read_unlock_bh();
+	return ret;
 }
 #endif
=20
@@ -1504,6 +1561,9 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct=
 ip_set *set,
 	int ret __attribute__((unused)) =3D 0;
 	u8 netmask =3D set->family =3D=3D NFPROTO_IPV4 ? 32 : 128;
 	union nf_inet_addr bitmask =3D onesmask;
+#endif
+#ifdef IP_SET_HASH_WITH_NETS
+	struct net_prefixes *nets;
 #endif
 	size_t hsize;
 	struct htype *h;
@@ -1604,21 +1664,25 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, stru=
ct ip_set *set,
 	 */
 	hbits =3D fls(hashsize - 1);
 	hsize =3D htable_size(hbits);
-	if (hsize =3D=3D 0) {
-		kfree(h);
-		return -ENOMEM;
-	}
+	if (hsize =3D=3D 0)
+		goto free_h;
 	t =3D ip_set_alloc(hsize);
-	if (!t) {
-		kfree(h);
-		return -ENOMEM;
-	}
+	if (!t)
+		goto free_h;
 	t->hregion =3D ip_set_alloc(ahash_sizeof_regions(hbits));
-	if (!t->hregion) {
-		ip_set_free(t);
-		kfree(h);
-		return -ENOMEM;
+	if (!t->hregion)
+		goto free_t;
+#ifdef IP_SET_HASH_WITH_NETS
+	for (i =3D 0; i < IPSET_NET_COUNT; i++) {
+		nets =3D kzalloc(sizeof(struct net_prefixes), GFP_KERNEL);
+		if (!nets) {
+			if (i !=3D 0)
+				kfree(h->rnets[0]);
+			goto free_hregion;
+		}
+		RCU_INIT_POINTER(h->rnets[i], nets);
 	}
+#endif
 	h->gc.set =3D set;
 	spin_lock_init(&h->gc.lock);
 	for (i =3D 0; i < ahash_numof_locks(hbits); i++)
@@ -1682,6 +1746,16 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struc=
t ip_set *set,
 		 t->htable_bits, h->maxelem, set->data, t);
=20
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
=20
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/=
ipset/ip_set_hash_ipportnet.c
index 2d6652d43199..195853a25b06 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -138,7 +138,7 @@ hash_ipportnet4_kadt(struct ip_set *set, const struct=
 sk_buff *skb,
 	const struct hash_ipportnet4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_ipportnet4_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(h->rnets[0], HOST_MASK),
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
@@ -398,7 +398,7 @@ hash_ipportnet6_kadt(struct ip_set *set, const struct=
 sk_buff *skb,
 	const struct hash_ipportnet6 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_ipportnet6_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(h->rnets[0], HOST_MASK),
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/=
ip_set_hash_net.c
index ce0a9ce5a91f..092f3c9281b8 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -117,7 +117,7 @@ hash_net4_kadt(struct ip_set *set, const struct sk_bu=
ff *skb,
 	const struct hash_net4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_net4_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(h->rnets[0], HOST_MASK),
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
@@ -291,7 +291,7 @@ hash_net6_kadt(struct ip_set *set, const struct sk_bu=
ff *skb,
 	const struct hash_net6 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_net6_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(h->rnets[0], HOST_MASK),
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/i=
pset/ip_set_hash_netiface.c
index 30a655e5c4fd..b44b95f766b7 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -161,7 +161,7 @@ hash_netiface4_kadt(struct ip_set *set, const struct =
sk_buff *skb,
 	struct hash_netiface4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netiface4_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(h->rnets[0], HOST_MASK),
 		.elem =3D 1,
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
@@ -382,7 +382,7 @@ hash_netiface6_kadt(struct ip_set *set, const struct =
sk_buff *skb,
 	struct hash_netiface6 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netiface6_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(h->rnets[0], HOST_MASK),
 		.elem =3D 1,
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ips=
et/ip_set_hash_netnet.c
index 8fbe649c9dd3..f7c8a1cc30fc 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -149,8 +149,10 @@ hash_netnet4_kadt(struct ip_set *set, const struct s=
k_buff *skb,
 	struct hash_netnet4_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
-	e.cidr[0] =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] =3D INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	rcu_read_lock_bh();
+	e.cidr[0] =3D INIT_CIDR(h->rnets[0], HOST_MASK);
+	e.cidr[1] =3D INIT_CIDR(h->rnets[1], HOST_MASK);
+	rcu_read_unlock_bh();
 	if (adt =3D=3D IPSET_TEST)
 		e.ccmp =3D (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
=20
@@ -388,8 +390,10 @@ hash_netnet6_kadt(struct ip_set *set, const struct s=
k_buff *skb,
 	struct hash_netnet6_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
-	e.cidr[0] =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] =3D INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	rcu_read_lock_bh();
+	e.cidr[0] =3D INIT_CIDR(h->rnets[0], HOST_MASK);
+	e.cidr[1] =3D INIT_CIDR(h->rnets[1], HOST_MASK);
+	rcu_read_unlock_bh();
 	if (adt =3D=3D IPSET_TEST)
 		e.ccmp =3D (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
=20
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ip=
set/ip_set_hash_netport.c
index d1a0628df4ef..5de4b511de76 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -133,7 +133,7 @@ hash_netport4_kadt(struct ip_set *set, const struct s=
k_buff *skb,
 	const struct hash_netport4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netport4_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(h->rnets[0], HOST_MASK),
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
@@ -353,7 +353,7 @@ hash_netport6_kadt(struct ip_set *set, const struct s=
k_buff *skb,
 	const struct hash_netport6 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netport6_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(h->rnets[0], HOST_MASK),
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter=
/ipset/ip_set_hash_netportnet.c
index bf4f91b78e1d..6291532be7a5 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -157,8 +157,10 @@ hash_netportnet4_kadt(struct ip_set *set, const stru=
ct sk_buff *skb,
 	struct hash_netportnet4_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
-	e.cidr[0] =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] =3D INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	rcu_read_lock_bh();
+	e.cidr[0] =3D INIT_CIDR(h->rnets[0], HOST_MASK);
+	e.cidr[1] =3D INIT_CIDR(h->rnets[1], HOST_MASK);
+	rcu_read_unlock_bh();
 	if (adt =3D=3D IPSET_TEST)
 		e.ccmp =3D (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
=20
@@ -452,8 +454,10 @@ hash_netportnet6_kadt(struct ip_set *set, const stru=
ct sk_buff *skb,
 	struct hash_netportnet6_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
-	e.cidr[0] =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] =3D INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	rcu_read_lock_bh();
+	e.cidr[0] =3D INIT_CIDR(h->rnets[0], HOST_MASK);
+	e.cidr[1] =3D INIT_CIDR(h->rnets[1], HOST_MASK);
+	rcu_read_unlock_bh();
 	if (adt =3D=3D IPSET_TEST)
 		e.ccmp =3D (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
=20
--=20
2.39.5

