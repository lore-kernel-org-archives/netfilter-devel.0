Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594AE352015
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2026 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787930629; cv=none; b=tV9hObqL+18d7Hd8eBS/+MqXtmnyes/9zzowDNGLGHKwgqfJkB4+9XdFq42bBN/UCB9H53ZsMHL6A6CbPl1ihJFJhGSVFfy1N6q0lNhBQ4049Q4BrY0iH89sSFRm1sh2JGd6zKwUEJJ0rBnZl+GMiWl2R0ARtWZl6xqB41WAGBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787930629; c=relaxed/simple;
	bh=rX4dsCLrpzf7YPLNhDU0EijnIAPhej9VZBrs9SWuopg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGrP/bBQhZG23gVPoz2cp9GBrnd4Lge8mOb/01VLQHK75y2jorLvJx2PpCt6NHLHgEP24zz1z7UeV2huEUAS0OpoUf860jc8YyW4xK+aENFQQg+Vfil8dW7JJoVMGQROmVmxsUsN4ruYe9HFjqMEZVXlwp3mFHvyOKykmvI8PXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 473BA60795; Fri, 28 Aug 2026 17:23:46 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v3 2/5] netfilter: ipset: add rhltable boilerplate stubs
Date: Fri, 28 Aug 2026 17:22:53 +0200
Message-ID: <20260828152256.8759-3-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260828152256.8759-1-fw@strlen.de>
References: <20260828152256.8759-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Preparation patch.  ip_set_hash_netiface.c (IP_SET_HASH_WITH_MULTI)
may store distinct elements with the same hash key.  rhashtable doesn't
support this.  For these sets, switch to rhltable which stores identical
hlist heads.  We can then walk the list after lookup to find best match.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: no changes.
 net/netfilter/ipset/ip_set_hash_gen.h      | 41 +++++++++++++++++++++-
 net/netfilter/ipset/ip_set_hash_netiface.c | 24 +++++++++----
 2 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 800655abbcb3..220fc9e79c76 100644
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
@@ -385,7 +398,11 @@ static const struct rhashtable_params mtype_rht_params = {
 /* The generic hash structure */
 struct htype {
 	struct htable __rcu *table; /* the hash table */
+#ifdef IP_SET_HASH_WITH_MULTI
+	struct rhltable rhlt;	/* the hashlist table */
+#else
 	struct rhashtable ht;	/* the hash table */
+#endif
 	struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
 	struct htable_gc gc;	/* gc workqueue */
 	u32 maxelem;		/* max elements in the hash */
@@ -404,6 +421,16 @@ struct htype {
 	struct mtype_elem next; /* temporary storage for uadd */
 };
 
+#ifdef IP_SET_HASH_WITH_MULTI
+#define ipset_hash_nelems(h) atomic_read(&(h)->rhlt.ht.nelems)
+#define ipset_hash_walk_enter(h, iter)	rhltable_walk_enter(&(h)->rhlt, (iter))
+#define ipset_hash_remove(h, e) rhltable_remove(&(h)->rhlt, &(e)->node, mtype_rht_params)
+#else
+#define ipset_hash_nelems(h) atomic_read(&(h)->ht.nelems)
+#define ipset_hash_walk_enter(h, iter)	rhashtable_walk_enter(&(h)->ht, (iter))
+#define ipset_hash_remove(h, e) rhashtable_remove_fast(&(h)->ht, &(e)->node, mtype_rht_params)
+#endif
+
 /* ADD|DEL entries saved during resize */
 struct mtype_resize_ad {
 	struct list_head list;
@@ -669,7 +696,11 @@ mtype_destroy(struct ip_set *set)
 	struct htable *t = (__force struct htable *)h->table;
 	struct list_head *l, *lt;
 
+#ifdef IP_SET_HASH_WITH_MULTI
+	rhltable_free_and_destroy(&h->rhlt, mtype_flush_elem, set);
+#else
 	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
+#endif
 
 	list_for_each_safe(l, lt, &t->ad) {
 		list_del(l);
@@ -1853,7 +1884,11 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	/* maxsize: maximum bucket table size to expand to */
 	params.max_size = maxelem;
 
+#ifdef IP_SET_HASH_WITH_MULTI
+	err = rhltable_init(&h->rhlt, &params);
+#else
 	err = rhashtable_init(&h->ht, &params);
+#endif
 	if (err)
 		goto free_h;
 
@@ -1955,7 +1990,11 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 free_t:
 	ip_set_free(t);
 free_rht:
+#ifdef IP_SET_HASH_WITH_MULTI
+	rhltable_free_and_destroy(&h->rhlt, mtype_flush_elem, set);
+#else
 	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
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
2.54.0

