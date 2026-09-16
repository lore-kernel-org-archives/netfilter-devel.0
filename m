Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430AF37F8AF
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 12:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563148; cv=none; b=PGg05Cqq46yPuN30o1RXwSQTRSXWHrmTlixJoHZOkbDgD/pnv1ahVjna4bdRw9ZWpIDvasQ3wljs0i12AXEPAvzJ7OfEBCoioEHv+4hY8/HKow6SHZvTSornGWqErVz3KQjZAg4SM6DSPKn0gmB4at6KpguwBhmyOdyeB613NCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563148; c=relaxed/simple;
	bh=EuOl7a/I+gZrXCUk4HOg4gMvSgrY5+/RdcS6pibSe10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBs5za3KOl9xOcdElCKWhxxfk3aeL8h8+KZDJenzM4JHXn8BKoh93A37QzB4magDqPLi+qR2rxV8M0+wW0nSUT2sJqywj+yr+FkBmLxHPwVrOTf+prd+137lLSFzbcxOb5DvaQWD/+uKQ4Lh7GK+45jhfxrEFwJdDQP4aKcxpQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3D2F06067F; Wed, 16 Sep 2026 14:52:24 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v5 5/6] netfilter: ipset: re-add forceadd support
Date: Wed, 16 Sep 2026 14:51:50 +0200
Message-ID: <20260916125151.28062-6-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916125151.28062-1-fw@strlen.de>
References: <20260916125151.28062-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rhashtable conversion removed the SET_WITH_FORCEADD eviction logic.

Add mtype_remove_random() helper to lookup a random key slot.
If there is an element, try to evict it and allow add of the new element
just like before the rhashtable conversion.

Assisted-by: LLM
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 76 +++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 7cc2b515e71c..ad190b2f8632 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -154,6 +154,9 @@ static const union nf_inet_addr zeromask = {};
 #undef mtype_kadt
 #undef mtype_uadt
 
+#undef mtype_remove_random
+#undef mtype_remove_key
+#undef mtype_remove_cmpfn
 #undef mtype_add
 #undef mtype_do_set_exts
 #undef mtype_del
@@ -205,6 +208,9 @@ static const union nf_inet_addr zeromask = {};
 #define mtype_kadt		IPSET_TOKEN(MTYPE, _kadt)
 #define mtype_uadt		IPSET_TOKEN(MTYPE, _uadt)
 
+#define mtype_remove_random	IPSET_TOKEN(MTYPE, _remove_random)
+#define mtype_remove_key	IPSET_TOKEN(MTYPE, _remove_key)
+#define mtype_remove_cmpfn	IPSET_TOKEN(MTYPE, _remove_cmpfn)
 #define mtype_add		IPSET_TOKEN(MTYPE, _add)
 #define mtype_del		IPSET_TOKEN(MTYPE, _del)
 #define mtype_test_cidrs	IPSET_TOKEN(MTYPE, _test_cidrs)
@@ -637,6 +643,64 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 		    (offsetof(struct mtype_rht_elem, elem) + set->dsize);
 }
 
+static u32 mtype_remove_key(const void *data, u32 len, u32 seed)
+{
+	return get_random_u32();
+}
+
+static int mtype_remove_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
+{
+	return 0; /* always match */
+}
+
+/**
+ * mtype_remove_random() - Remove a random element from the set (forceadd)
+ * @set: Pointer to the ip_set
+ * @h: Pointer to the htype
+ *
+ * When sets created with forceadd option become full the next addition
+ * to the set may succeed and evict a random entry from the set.
+ * Best-effort: no linear scan; 'return false' is fine.
+ *
+ * Return: true if an element was evicted, false otherwise.
+ */
+static bool
+mtype_remove_random(struct ip_set *set)
+{
+	static const struct rhashtable_params ip_set_hash_rnd_params = {
+		.head_offset	= offsetof(struct mtype_rht_elem, node),
+		.key_offset	= offsetof(struct mtype_rht_elem, elem),
+		.hashfn		= mtype_remove_key,
+		.obj_hashfn	= mtype_rht_obj_hashfn,
+		.obj_cmpfn	= mtype_remove_cmpfn,
+		.key_len	= sizeof(u32),
+	};
+	struct mtype_rht_elem *e = NULL;
+	struct htype *h = set->data;
+	bool removed = false;
+	static const u32 k;
+
+#ifdef IP_SET_HASH_WITH_MULTI
+	{
+		struct rhlist_head *list = rhltable_lookup(&h->rhlt, &k,
+							   ip_set_hash_rnd_params);
+		if (!list)
+			return false;
+
+		e = container_of(list, typeof(*e), node);
+	}
+#else
+	e = rhashtable_lookup(&h->ht, &k, ip_set_hash_rnd_params);
+#endif
+	if (e && !ipset_hash_remove(h, e))
+		removed = true;
+
+	if (removed)
+		ipset_hash_elem_destroy_free(set, e);
+
+	return removed;
+}
+
 /* Add an element to a hash and update the internal counters when succeeded,
  * otherwise report the proper error code.
  */
@@ -706,11 +770,13 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 
 	if (!old && ipset_hash_nelems(h) >= h->maxelem) {
-		if (net_ratelimit())
-			pr_warn("Set %s is full, maxelem %u reached\n",
-				set->name, h->maxelem);
-		ret = -IPSET_ERR_HASH_FULL;
-		goto out_rcu_unlock;
+		if (!SET_WITH_FORCEADD(set) || !mtype_remove_random(set)) {
+			if (net_ratelimit())
+				pr_warn("Set %s is full, maxelem %u reached\n",
+					set->name, h->maxelem);
+			ret = -IPSET_ERR_HASH_FULL;
+			goto out_rcu_unlock;
+		}
 	}
 
 	e = kzalloc(offsetof(struct mtype_rht_elem, elem) + set->dsize,
-- 
2.55.0

