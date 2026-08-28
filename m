Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644DB353A6A
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2026 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787930637; cv=none; b=kaCdUc2iLWGRHj9pAx+e6QgU6BwpfF6J0r5jW2A8Mc/l7qK3VV12wRZ601PVwBshsCes98KOO1m5ZXnkRliIZbCN9GzsPzr4ddCLPybmJeo/GaSwEXMHoiEaF0CnTEBaOFNpy7XSV7FGIkj0jX8zhVBJGTZ1z11I1IjDzAqzSBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787930637; c=relaxed/simple;
	bh=VXI0qp+toB8cAFLoeuIifcQOeYFcIyOMY5LC9m16Gpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tqbro1ycj2Hm6kILLdRS9Z61G/LjPCrm/SeKP2bvDpqnDkb+vdk6qjwod3hbe2MjdBIoCQ4Pdk45jwOHeNkOaGSJ5v11CrvYCZRuWd1nrVE9HIH/GKThIffmvuUR4A/KPAbUgIULNmi0Tr6r4t5oN+mHMZSvFAno09RKjzGvCks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D0EA0607D4; Fri, 28 Aug 2026 17:23:54 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v3 4/5] netfilter: ipset: re-add forceadd support
Date: Fri, 28 Aug 2026 17:22:55 +0200
Message-ID: <20260828152256.8759-5-fw@strlen.de>
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

The rhashtable conversion removed the SET_WITH_FORCEADD eviction logic.

Add mtype_remove_random() helper to lookup a random key slot.
If there is an element, try to evict it and allow add of the new element
just like before the rhashtable conversion.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: reword kdoc to say that can only be best-effort and cannot
 guarantee insertion. Quote ipset man page verbatim.
 LLM review consistently harps on mtype_remove_random being bad.
 Its not, its actually more likely to remove an entry than the old
 region code used pre-rhashtable.  And even if we would actually
 do a linear scan, we can't guarantee insertion given other CPU
 might be doing and insert as well: forceadd never 'guarantees'
 insertion will work, even ipset man page says so.

 net/netfilter/ipset/ip_set_hash_gen.h | 78 +++++++++++++++++++++++++--
 1 file changed, 73 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index bce83006e2a2..e156ea725f3c 100644
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
@@ -664,6 +670,66 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
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
+mtype_remove_random(struct ip_set *set, struct htype *h)
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
+	if (removed) {
+		mtype_del_cidr_all(set, h, &e->elem);
+		ip_set_ext_destroy(set, &e->elem);
+		kfree_rcu(e, rcu);
+	}
+
+	return removed;
+}
+
 /* Add an element to a hash and update the internal counters when succeeded,
  * otherwise report the proper error code.
  */
@@ -733,11 +799,13 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 
 	if (!old && ipset_hash_nelems(h) >= h->maxelem) {
-		if (net_ratelimit())
-			pr_warn("Set %s is full, maxelem %u reached\n",
-				set->name, h->maxelem);
-		ret = -IPSET_ERR_HASH_FULL;
-		goto out_rcu_unlock;
+		if (!SET_WITH_FORCEADD(set) || !mtype_remove_random(set, h)) {
+			if (net_ratelimit())
+				pr_warn("Set %s is full, maxelem %u reached\n",
+					set->name, h->maxelem);
+			ret = -IPSET_ERR_HASH_FULL;
+			goto out_rcu_unlock;
+		}
 	}
 
 	e = kzalloc(offsetof(struct mtype_rht_elem, elem) + set->dsize,
-- 
2.54.0

