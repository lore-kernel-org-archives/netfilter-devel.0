Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8682BEFEF
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 13:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664557; cv=none; b=Nfv1WuPB4ZHO55g3LOK7a67kLTrsDOKv0ftSSliuG59YRKGMzf8ydwPAQnaf/ejOGAx43BnNO44H03XmtJkJLYMq8TdnScftaOwdXlX+ZpAaOFI8bLl+vYrqcAflY/8fIp7gfAgzEFz99vtz8uISN29l+j4Cvzo0RPx55jhiHTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664557; c=relaxed/simple;
	bh=PMshHXOPDJ3yf2jVmNtLUPMtF7w9XNy8rX8Pr63zz2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsT1f/Nkq7lQCekBhmcOpgBu/oCHTNTY0c4tODj4S9+A47C2ShY9GFcpNzPp0IqVxmt+zr0H0t7XLgzk3qHpFqlsK+xATgg2PrS7iqxQs0fdfM6jKVHBNPtJTTGfoVdhNfGz9OPNltTnTp6Ij8Yto5uODLLqK6vI6d93aaFS+8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 481D16045E; Tue, 25 Aug 2026 15:29:14 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 4/5] netfilter: ipset: re-add forceadd support
Date: Tue, 25 Aug 2026 15:28:42 +0200
Message-ID: <20260825132843.1692-5-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825132843.1692-1-fw@strlen.de>
References: <20260825132843.1692-1-fw@strlen.de>
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
 v2: no changes. v1 sashiko claim
 'Does this single random probe cause the forceadd logic to fail
 frequently?' is wrong.

 net/netfilter/ipset/ip_set_hash_gen.h | 77 +++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index a734bafe229a..1bb803be3dcb 100644
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
@@ -654,6 +660,65 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
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
+ * This is best-effort: no expensive linear scan is done, 'return false'
+ * is acceptable outcome.
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
@@ -723,11 +788,13 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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

