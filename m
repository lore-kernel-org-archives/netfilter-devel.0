Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793108043;
	b=yP0JEAc+9sIfyFRQVNvYSDrNsEM6Ite+uxVQU8oWqFs8EYePv7kHG9FthQUD+E6rGQLI
	 pgT4Ap3DtqlUj5URUqZMzl8SrbyKN/ne2+5ahwZet900+AQyDaTxR908Qa45aI625hTeX
	 a0AHBvVovZceXzip5uYEl1Fvceo5wb2UkN0f+qDhwe6RNLAJxuQz5/mYM4OHAnrM7V2SI
	 Y8RGFUC0IjDmCPU28kL7yBhzoLng+uwJZaGVfSmr+heyb54JeuTzR28j6c8gPcJQ5o+z3
	 DJMgTha2sYzRMnY9LlP4YYial0trLycN43eZbIkQbXlXsx8WTvKZPFG2dc6RDeJXwgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793108043;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=o+NvXF6/U9jWKi/t68ZwmMvTzXX78iwbiiLXDfgFFY8=;
	b=XU738iRV3Lb1RCG+ikRnNt/q2gB3ooJ/sZAAWePxTk+WUacGj1MnjQSwzF+RwDVzE5yW
	 8eOHS9cn9GHK8H2CD4RuSyUfoQmZ8n5ktMJ4fPF3CVCauJP2LWqAr8InSsPHxm3TcYCQ5
	 KOtKm10VjkEwPuNqFHXtdkR5oYUbcPM9v8nDnbfQF4gGFzgVSu8DWr4eQvjMOCM8EMVJN
	 4ohEAAXhMafvAOAWCaDwqLiPUQIcxwpmgxlEkm/8jhIndNj1lshrzyzCjaHp/HJ/JL9w3
	 ofmCFClEaBU0mvcdv78sab8MBdzmgzPkDFIorEMbZ8AK9/zSWGW/cMM/snni7dxN37w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3254606A322
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2026 13:34:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3254606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 312BA60E2D; Tue, 27 Oct 2026 14:34:01 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v6 2/6] netfilter: ipset: add rhashtable boilerplate stubs
Date: Tue, 27 Oct 2026 14:33:27 +0100
Message-ID: <20261027133331.25979-3-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261027133331.25979-1-fw@strlen.de>
References: <20261027133331.25979-1-fw@strlen.de>
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

Preparation patch.  Adds an rhashtable to the set and initialises
and destroys it.  No elements are ever added to this hashtable.

This change is supposed to be devoid of side effects and is
separate to reduce size of the conversion patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes.
 net/netfilter/ipset/ip_set_hash_gen.h | 113 ++++++++++++++++++++++++--
 1 file changed, 108 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 80ca523f304b..ec31c9ea83e2 100644
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
@@ -482,6 +555,18 @@ mtype_del_cidr_all(struct ip_set *set, struct htype *h, const struct mtype_elem
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
 /* Calculate the actual memory size of the set data */
 static size_t
 mtype_ahash_memsize(const struct htype *h, const struct htable *t)
@@ -586,6 +671,8 @@ mtype_destroy(struct ip_set *set)
 	struct htable *t = (__force struct htable *)h->table;
 	struct list_head *l, *lt;
 
+	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
+
 	list_for_each_safe(l, lt, &t->ad) {
 		list_del(l);
 		kfree(l);
@@ -1652,6 +1739,7 @@ static int
 IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 			    struct nlattr *tb[], u32 flags)
 {
+	struct rhashtable_params params;
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	u32 markmask;
@@ -1668,6 +1756,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	size_t hsize;
 	struct htype *h;
 	struct htable *t;
+	int err;
 	u32 i;
 
 	pr_debug("Create set %s with family %s\n",
@@ -1749,15 +1838,27 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 
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
@@ -1765,10 +1866,10 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
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
@@ -1855,6 +1956,8 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #endif
 free_t:
 	ip_set_free(t);
+free_rht:
+	rhashtable_destroy(&h->ht);
 free_h:
 	kfree(h);
 	return -ENOMEM;
-- 
2.55.0

