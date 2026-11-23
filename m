Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442273;
	b=A1YpirMuCEuZBzaiDfj+UiPIJyyQDrn6fR9FqsNytY0BPu67heLb1FMYkHx4e4F4y4Fn
	 W0cgBTKtsZfqYw0jY2897wrNczsZ7MKiAyGKRZgAGNjI4lgLP9BAhHk2g2aFxTk2RpTtn
	 E7mkXbOIXdIeZ/J3E+VdpJh7NH62pYiqEcBdd+ay+Dreym2J7w95wP4A9y9zxbVVRjKTM
	 2yIH4BIWYsiI5VL95XsYOoBU/dJrgin0ueNbO0Wt3d1N+mmW+0ox5BoCtfhMCjk7vzbQW
	 MZetJ2ef94wuOHWZVzKh0B35g9icJmFewIC7h3NyCT+Rd2Ye55JGYEDcb46uvl2aMPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442273;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=r+sreO9YfJdHFll/i/1FveVEec0p58FWmL7aIwSNSNM=;
	b=f5q6dl2s7vr55VoJmafAw4Nk7tSmChtYNgUhTadA4eJyNXWZ7XHATFmKddKadnZxfb0s
	 M/bNERuT6zO9C8dqk/p/vN6sH9L8lJxyLOhWumzbl9KqPxQxjGqnT0GWJ55eQAM7MmJQ1
	 kDG1/OqTWeFWIpL3qiyzRfeaXzT1brDjXgbx9j70pB0WnYpq7ezjnffRdRbZhjPEqL5my
	 eadEMPCk3Qfc3amtHyEuL2ZqVqG9yU1ty9lYHbb4TVzzT7p2GIDot28Py+5FntdIQxYmc
	 n1pEzK6LwMGO0PWKzH0+kJrLyBzv8nUVdNfDDqRNipfxQgeTTPqOqdgZbgJvcTzRw2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=IsYqO06d;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5C5606A331;
	Mon, 23 Nov 2026 13:57:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E5C5606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=IsYqO06d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442269;
	bh=r+sreO9YfJdHFll/i/1FveVEec0p58FWmL7aIwSNSNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsYqO06dsMrFBvew6irUyNVKs+otKqyeDiFwEeKnMfmFRkkfeV/lWCQliLZ9ekkVh
	 BF+5ncf2QAOA90YfaFYzjTybnQkAIkeWyO2Sthxv1buXFcOCEc6Aq288neuvIHq5V5
	 mqdf0Qq5dUiM1MVxHsxM3iX90Xwo3cLnawkLJktSTRKl/yDPgnDNKZoWeely505p5p
	 cF7DXlHR5St5/td+iX/B0jVRNcRVuFxjNTOvJALmXjnHkE7rcQ0UP0/0RGCwBr8YHc
	 onzkbbuG0azFLW/PONBQjTQtoXd0gDgOx2a6oM2JYh7ftdtqvL67xVn9h8JmbT7o+v
	 VvgR4xYYVl9sA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 87C0A602F7;
	Mon, 23 Nov 2026 14:57:48 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 11/15] netfilter: ipset: add rhashtable boilerplate stubs
Date: Mon, 23 Nov 2026 14:57:22 +0100
Message-ID: <20261123135726.3940688-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135726.3940688-1-pablo@netfilter.org>
References: <20261123135726.3940688-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Preparation patch.  Adds an rhashtable to the set and initialises
and destroys it.  No elements are ever added to this hashtable.

This change is supposed to be devoid of side effects and is
separate to reduce size of the conversion patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 114 ++++++++++++++++++++++++--
 1 file changed, 109 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 80ca523f304b..a3f6c0aa47f7 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -8,6 +8,7 @@
 #include <linux/rcupdate_wait.h>
 #include <linux/jhash.h>
 #include <linux/types.h>
+#include <linux/rhashtable.h>
 #include <linux/seqlock.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/ipset/ip_set.h>
@@ -217,9 +218,16 @@ static const union nf_inet_addr zeromask = {};
 
 #undef mtype_ahash_destroy
 #undef mtype_ext_cleanup
+#undef mtype_rht_elem
+#undef mtype_rht_hashfn
+#undef mtype_rht_obj_hashfn
+#undef mtype_rht_cmpfn
+#undef mtype_rht_params
+
 #undef mtype_add_cidr
 #undef mtype_del_cidr
 #undef mtype_del_cidr_all
+#undef mtype_flush_elem
 #undef mtype_ahash_memsize
 #undef mtype_flush
 #undef mtype_destroy
@@ -265,9 +273,17 @@ static const union nf_inet_addr zeromask = {};
 
 #define mtype_ahash_destroy	IPSET_TOKEN(MTYPE, _ahash_destroy)
 #define mtype_ext_cleanup	IPSET_TOKEN(MTYPE, _ext_cleanup)
+
+#define mtype_rht_elem		IPSET_TOKEN(MTYPE, _rht_elem)
+#define mtype_rht_hashfn	IPSET_TOKEN(MTYPE, _rht_hashfn)
+#define mtype_rht_obj_hashfn	IPSET_TOKEN(MTYPE, _rht_obj_hashfn)
+#define mtype_rht_cmpfn		IPSET_TOKEN(MTYPE, _rht_cmpfn)
+#define mtype_rht_params	IPSET_TOKEN(MTYPE, _rht_params)
+
 #define mtype_add_cidr		IPSET_TOKEN(MTYPE, _add_cidr)
 #define mtype_del_cidr		IPSET_TOKEN(MTYPE, _del_cidr)
 #define mtype_del_cidr_all	IPSET_TOKEN(MTYPE, _del_cidr_all)
+#define mtype_flush_elem	IPSET_TOKEN(MTYPE, _flush_elem)
 #define mtype_ahash_memsize	IPSET_TOKEN(MTYPE, _ahash_memsize)
 #define mtype_flush		IPSET_TOKEN(MTYPE, _flush)
 #define mtype_destroy		IPSET_TOKEN(MTYPE, _destroy)
@@ -300,6 +316,62 @@ static const union nf_inet_addr zeromask = {};
 
 #define htype			MTYPE
 
+/* Per-element rhashtable object.  Extensions follow the elem field inline;
+ * allocate as offsetof(struct mtype_rht_elem, elem) + set->dsize bytes.
+ */
+struct mtype_rht_elem {
+	struct rhash_head node;
+	struct rcu_head rcu;		/* deferred free after removal */
+
+	/* element data; must be last. extensions follow. */
+	struct mtype_elem elem __aligned(__alignof__(u64));
+};
+
+/* jhash of the lookup key */
+static u32 mtype_rht_hashfn(const void *data, u32 len, u32 seed)
+{
+	BUILD_BUG_ON(HKEY_DATALEN % sizeof(u32) != 0);
+	return jhash2((const u32 *)data, HKEY_DATALEN / sizeof(u32), seed);
+}
+
+/* jhash of an existing element object */
+static u32 mtype_rht_obj_hashfn(const void *obj, u32 len, u32 seed)
+{
+	const struct mtype_rht_elem *e = obj;
+#ifdef IP_SET_HASH_WITH_NETS
+	/* Reset transient flags (e.g. nomatch) before hashing so that the
+	 * object hash always equals the lookup-key hash computed by hashfn.
+	 */
+	struct mtype_elem tmp;
+	u8 flags = 0;
+
+	memcpy(&tmp, &e->elem, HKEY_DATALEN);
+	mtype_data_reset_flags(&tmp, &flags);
+	return jhash2((const u32 *)&tmp, HKEY_DATALEN / sizeof(u32), seed);
+#else
+	return jhash2((const u32 *)&e->elem, HKEY_DATALEN / sizeof(u32), seed);
+#endif
+}
+
+/* 0 = key matches object (equal), non-zero = not equal */
+static int mtype_rht_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
+{
+	const struct mtype_rht_elem *e = obj;
+	u32 multi = 0;
+
+	return !mtype_data_equal(&e->elem,
+				 (const struct mtype_elem *)arg->key, &multi);
+}
+
+static const struct rhashtable_params mtype_rht_params = {
+	.head_offset	= offsetof(struct mtype_rht_elem, node),
+	.key_offset	= offsetof(struct mtype_rht_elem, elem),
+	.hashfn		= mtype_rht_hashfn,
+	.obj_hashfn	= mtype_rht_obj_hashfn,
+	.obj_cmpfn	= mtype_rht_cmpfn,
+	.key_len	= HKEY_DATALEN,
+};
+
 #define HKEY(data, initval, htable_bits)			\
 ({								\
 	const u32 *__k = (const u32 *)data;			\
@@ -313,6 +385,7 @@ static const union nf_inet_addr zeromask = {};
 /* The generic hash structure */
 struct htype {
 	struct htable __rcu *table; /* the hash table */
+	struct rhashtable ht;	/* the hash table */
 	struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
 	struct htable_gc gc;	/* gc workqueue */
 	u32 maxelem;		/* max elements in the hash */
@@ -482,6 +555,19 @@ mtype_del_cidr_all(struct ip_set *set, struct htype *h, const struct mtype_elem
 #endif
 }
 
+/* Free one element: called by rhashtable_free_and_destroy */
+static void
+mtype_flush_elem(void *ptr, void *arg)
+{
+	struct mtype_rht_elem *e = ptr;
+	struct ip_set *set = arg;
+
+	rcu_read_lock();
+	ip_set_ext_destroy(set, &e->elem);
+	kfree_rcu(e, rcu);
+	rcu_read_unlock();
+}
+
 /* Calculate the actual memory size of the set data */
 static size_t
 mtype_ahash_memsize(const struct htype *h, const struct htable *t)
@@ -586,6 +672,8 @@ mtype_destroy(struct ip_set *set)
 	struct htable *t = (__force struct htable *)h->table;
 	struct list_head *l, *lt;
 
+	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
+
 	list_for_each_safe(l, lt, &t->ad) {
 		list_del(l);
 		kfree(l);
@@ -1652,6 +1740,7 @@ static int
 IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 			    struct nlattr *tb[], u32 flags)
 {
+	struct rhashtable_params params;
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	u32 markmask;
@@ -1668,6 +1757,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	size_t hsize;
 	struct htype *h;
 	struct htable *t;
+	int err;
 	u32 i;
 
 	pr_debug("Create set %s with family %s\n",
@@ -1749,15 +1839,27 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 
 #ifdef IP_SET_PROTO_UNDEF
 	hsize = sizeof(struct htype);
+	params = mtype_rht_params;
 #else
-	hsize = set->family == NFPROTO_IPV6 ?
-		sizeof(struct IPSET_TOKEN(HTYPE, 6)) :
-		sizeof(struct IPSET_TOKEN(HTYPE, 4));
+	if (set->family == NFPROTO_IPV6) {
+		hsize = sizeof(struct IPSET_TOKEN(HTYPE, 6));
+		params = IPSET_TOKEN(HTYPE, 6_rht_params);
+	} else {
+		hsize = sizeof(struct IPSET_TOKEN(HTYPE, 4));
+		params = IPSET_TOKEN(HTYPE, 4_rht_params);
+	}
 #endif
 	h = kzalloc(hsize, GFP_KERNEL);
 	if (!h)
 		return -ENOMEM;
 
+	/* maxsize: maximum bucket table size to expand to */
+	params.max_size = maxelem;
+
+	err = rhashtable_init(&h->ht, &params);
+	if (err)
+		goto free_h;
+
 	/* Compute htable_bits from the user input parameter hashsize.
 	 * Assume that hashsize == 2^htable_bits,
 	 * otherwise round up to the first 2^n value.
@@ -1765,10 +1867,10 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	hbits = fls(hashsize - 1);
 	hsize = htable_size(hbits);
 	if (hsize == 0)
-		goto free_h;
+		goto free_rht;
 	t = ip_set_alloc(hsize);
 	if (!t)
-		goto free_h;
+		goto free_rht;
 	t->hregion = ip_set_alloc(ahash_sizeof_regions(hbits));
 	if (!t->hregion)
 		goto free_t;
@@ -1855,6 +1957,8 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #endif
 free_t:
 	ip_set_free(t);
+free_rht:
+	rhashtable_destroy(&h->ht);
 free_h:
 	kfree(h);
 	return -ENOMEM;
-- 
2.47.3

