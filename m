Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793108047;
	b=2P+6ooD92frbfzY8xyT62nlOFSuYUWteCHuLOIujrYqJKBotfG9VsaMKD1pS3gjrZRtv
	 ZHQkvYl+YcClIaXAmnXob0EPWq812rNpXyCDX2TicEZRXgTAqQLwG7s3De05BUo0Dt4Yg
	 nGa+pJGnH7zootIrZ7Q5c1JNEBIdf90E6eB2L4CG5PJxgp886AG8MlQOn1qG6N2UYBL7f
	 dHzTYZq31iojrU0Qnkkmi/peNhygi7MnMFH8j1fnWvx4udVDrpLr5te7pWqegYtUAYBPM
	 X302NY95U8kZwcImBA202DPzdqYoUdhcThX0Mif8niHBtAJKDoLCbspkcUA5l25U3wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793108047;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Wr16zuA8QUKD4HCjrehfqQLOof490/ZjOLA60jy0a6s=;
	b=S/vahc3H6y7BRxf7uDi3hqAXWkpxdEi13BYfaqHPKfQ8sMWJ9FncG6wtaI85BB1pXK4/
	 oa0iqE46Hps9l0QrkXL+Htv9rISwloNhinNvRNjrY7+5hiQu8aPfzW1/jVNvdqb7UzcPn
	 e14i03RLwbu0sbIUV1hSOtSwoQcNa/5EwjqJD+HBI6OwtdhpHqQiJrfySIWYQp8Yp9Yjx
	 uIY8AgR+xjt5CWK8pIISMIINwigAT8Dlo4Ehas6ZYwuqJ10QzBP7/vBZ+A9ou0QeyDB65
	 7g3aZLievu4EfiYH2nLZwn9rWTbV1I4sOf/46tBcym6hr9xIjZ+eav692OLAQgpYvRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0830E606A31A
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2026 13:34:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0830E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7288160788; Tue, 27 Oct 2026 14:34:05 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v6 3/6] netfilter: ipset: add rhltable boilerplate stubs
Date: Tue, 27 Oct 2026 14:33:28 +0100
Message-ID: <20261027133331.25979-4-fw@strlen.de>
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

Preparation patch.  ip_set_hash_netiface.c (IP_SET_HASH_WITH_MULTI)
may store distinct elements with the same hash key.  rhashtable doesn't
support this.  For these sets, switch to rhltable which stores identical
hlist heads.  We can then walk the list after lookup to find best match.

A dedicated ht.nelems replacement counter is added because rhashtable
nelems tracks unique keys, not the number of elements.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v6: add a rhl_count to htype struct to handle rhlist case, where
 rhastables own nelems counter only increments for each hash head, not
 each element.

 net/netfilter/ipset/ip_set_hash_gen.h      | 54 +++++++++++++++++++++-
 net/netfilter/ipset/ip_set_hash_netiface.c | 24 +++++++---
 2 files changed, 71 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index ec31c9ea83e2..8f242f20c81c 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -206,6 +206,7 @@ static const union nf_inet_addr zeromask = {};
 /* Family dependent templates */
 
 #undef ahash_data
+#undef mtype_key_equal
 #undef mtype_data_equal
 #undef mtype_do_data_match
 #undef mtype_data_set_flags
@@ -257,6 +258,9 @@ static const union nf_inet_addr zeromask = {};
 #undef htype
 #undef HKEY
 
+#ifdef IP_SET_HASH_WITH_MULTI
+#define mtype_key_equal	IPSET_TOKEN(MTYPE, _key_equal)
+#endif
 #define mtype_data_equal	IPSET_TOKEN(MTYPE, _data_equal)
 #ifdef IP_SET_HASH_WITH_NETS
 #define mtype_do_data_match	IPSET_TOKEN(MTYPE, _do_data_match)
@@ -320,7 +324,11 @@ static const union nf_inet_addr zeromask = {};
  * allocate as offsetof(struct mtype_rht_elem, elem) + set->dsize bytes.
  */
 struct mtype_rht_elem {
+#ifdef IP_SET_HASH_WITH_MULTI
+	struct rhlist_head node;
+#else
 	struct rhash_head node;
+#endif
 	struct rcu_head rcu;		/* deferred free after removal */
 
 	/* element data; must be last. extensions follow. */
@@ -357,10 +365,15 @@ static u32 mtype_rht_obj_hashfn(const void *obj, u32 len, u32 seed)
 static int mtype_rht_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
 {
 	const struct mtype_rht_elem *e = obj;
+#ifdef IP_SET_HASH_WITH_MULTI
+	return !mtype_key_equal(&e->elem,
+				(const struct mtype_elem *)arg->key);
+#else
 	u32 multi = 0;
 
 	return !mtype_data_equal(&e->elem,
-				 (const struct mtype_elem *)arg->key, &multi);
+				(const struct mtype_elem *)arg->key, &multi);
+#endif
 }
 
 static const struct rhashtable_params mtype_rht_params = {
@@ -385,7 +398,12 @@ static const struct rhashtable_params mtype_rht_params = {
 /* The generic hash structure */
 struct htype {
 	struct htable __rcu *table; /* the hash table */
+#ifdef IP_SET_HASH_WITH_MULTI
+	struct rhltable rhlt;	/* the hashlist table */
+	atomic_t rhl_count;	/* rhlist elem counter */
+#else
 	struct rhashtable ht;	/* the hash table */
+#endif
 	struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
 	struct htable_gc gc;	/* gc workqueue */
 	u32 maxelem;		/* max elements in the hash */
@@ -404,6 +422,26 @@ struct htype {
 	struct mtype_elem next; /* temporary storage for uadd */
 };
 
+#ifdef IP_SET_HASH_WITH_MULTI
+#define ipset_hash_nelems(h) atomic_read(&(h)->rhl_count)
+#define ipset_hash_walk_enter(h, iter)	rhltable_walk_enter(&(h)->rhlt, (iter))
+#define ipset_rhl_count_dec(h) atomic_dec(&(h)->rhl_count)
+#define ipset_rhl_count_inc(h) atomic_inc(&(h)->rhl_count)
+#define ipset_hash_remove(h, e)								\
+({											\
+	typeof(h) __h = (h);								\
+	int __retval = rhltable_remove(&(__h)->rhlt, &(e)->node, mtype_rht_params);	\
+	if (__retval == 0)								\
+		ipset_rhl_count_dec(__h);						\
+	__retval;									\
+})
+#else
+#define ipset_hash_nelems(h) atomic_read(&(h)->ht.nelems)
+#define ipset_hash_walk_enter(h, iter)	rhashtable_walk_enter(&(h)->ht, (iter))
+#define ipset_rhl_count_dec(__h) do { } while (0)
+#define ipset_hash_remove(h, e) rhashtable_remove_fast(&(h)->ht, &(e)->node, mtype_rht_params)
+#endif
+
 /* ADD|DEL entries saved during resize */
 struct mtype_resize_ad {
 	struct list_head list;
@@ -671,7 +709,12 @@ mtype_destroy(struct ip_set *set)
 	struct htable *t = (__force struct htable *)h->table;
 	struct list_head *l, *lt;
 
+#ifdef IP_SET_HASH_WITH_MULTI
+	rhltable_free_and_destroy(&h->rhlt, mtype_flush_elem, set);
+	DEBUG_NET_WARN_ON_ONCE(ipset_hash_nelems(h));
+#else
 	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
+#endif
 
 	list_for_each_safe(l, lt, &t->ad) {
 		list_del(l);
@@ -1855,7 +1898,12 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	/* maxsize: maximum bucket table size to expand to */
 	params.max_size = maxelem;
 
+#ifdef IP_SET_HASH_WITH_MULTI
+	atomic_set(&h->rhl_count, 0);
+	err = rhltable_init(&h->rhlt, &params);
+#else
 	err = rhashtable_init(&h->ht, &params);
+#endif
 	if (err)
 		goto free_h;
 
@@ -1957,7 +2005,11 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 free_t:
 	ip_set_free(t);
 free_rht:
+#ifdef IP_SET_HASH_WITH_MULTI
+	rhltable_destroy(&h->rhlt);
+#else
 	rhashtable_destroy(&h->ht);
+#endif
 free_h:
 	kfree(h);
 	return -ENOMEM;
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index b602cc43565d..edadd6307675 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -63,16 +63,22 @@ struct hash_netiface4_elem {
 };
 
 /* Common functions */
+static bool
+hash_netiface4_key_equal(const struct hash_netiface4_elem *ip1,
+			 const struct hash_netiface4_elem *ip2)
+{
+	return ip1->ip == ip2->ip &&
+	       ip1->cidr == ip2->cidr &&
+	       ip1->physdev == ip2->physdev;
+}
 
 static bool
 hash_netiface4_data_equal(const struct hash_netiface4_elem *ip1,
 			  const struct hash_netiface4_elem *ip2,
 			  u32 *multi)
 {
-	return ip1->ip == ip2->ip &&
-	       ip1->cidr == ip2->cidr &&
+	return hash_netiface4_key_equal(ip1, ip2) &&
 	       (++*multi) &&
-	       ip1->physdev == ip2->physdev &&
 	       (ip1->wildcard ?
 		strncmp(ip1->iface, ip2->iface, strlen(ip1->iface)) == 0 :
 		strcmp(ip1->iface, ip2->iface) == 0);
@@ -297,16 +303,22 @@ struct hash_netiface6_elem {
 };
 
 /* Common functions */
+static bool
+hash_netiface6_key_equal(const struct hash_netiface6_elem *ip1,
+			 const struct hash_netiface6_elem *ip2)
+{
+	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
+	       ip1->cidr == ip2->cidr &&
+	       ip1->physdev == ip2->physdev;
+}
 
 static bool
 hash_netiface6_data_equal(const struct hash_netiface6_elem *ip1,
 			  const struct hash_netiface6_elem *ip2,
 			  u32 *multi)
 {
-	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
-	       ip1->cidr == ip2->cidr &&
+	return hash_netiface6_key_equal(ip1, ip2) &&
 	       (++*multi) &&
-	       ip1->physdev == ip2->physdev &&
 	       (ip1->wildcard ?
 		strncmp(ip1->iface, ip2->iface, strlen(ip1->iface)) == 0 :
 		strcmp(ip1->iface, ip2->iface) == 0);
-- 
2.55.0

