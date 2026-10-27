Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793108056;
	b=YiNkCYpM+gfVnMsq6X6ttpBAjKycRd1+wln+nFlEuWDuwBKqpxsKLJAk7VXEOR6mHALl
	 NW40IbIo32qG5r6IUSZPT+uMBsvaaCQuNApr2yH+Uolyak8najzZM0wnc1zTcZ1RqZYte
	 7E67+zj/zQq/BdUTeDwX+wi1B5EwkW4mjkZ/oXybtSSvDPI+NXwYFdnZ9oJl1pqEhzUDu
	 Qbsfs8nBbU5xfRiZF2uAjys/6tWwfckbIqIRHxGg6fTiPRxWyye318H2F95+yt6IISgAY
	 SMQWVxM3NyvaqZPpOoaWCJSHXdjYi6RY213PSU6kTvbqEkUhhy0jd5f5gYTBzsb4fDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793108056;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=7PGuYcKa/L0BpTaDdMSvrXD8CeSkGDCEubIvzrOETKo=;
	b=zOqRgnOd9ILnFIvnyRQPjLM6qsqlGMaOggtlVp452pHlnPz77rW8FvLbjJiuMtfrPuDH
	 bgxglg9sysh2t6B67JDui7L7uUijWOhWiFNILUNBTLbdoeP3muDtp9mN2AY2fMTPZ3Z1I
	 rXTt+dMQl+wLnL86rtyjP8uGqWf77/Boa48d/zK8q4p90iVpQERQyYs1ZK8S6R7GGQKNi
	 dPObherPiSV/1T2BQ2JuumEzG9mUdUlOGLnX0/Dy9DcnxiLMspDy0CRLvNgZsbJfZwziE
	 AJKVKo/w98pxBhlr3EJNx6LoES9/vv+sqWRkDUDyA+fgzLrAPQGYFfkpqDz3dOkwFDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974D7606A31B
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2026 13:34:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 974D7606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 12D0260788; Tue, 27 Oct 2026 14:34:14 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v6 5/6] netfilter: ipset: re-add forceadd support
Date: Tue, 27 Oct 2026 14:33:30 +0100
Message-ID: <20261027133331.25979-6-fw@strlen.de>
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

The rhashtable conversion removed the SET_WITH_FORCEADD eviction logic.

Add mtype_remove_random() helper to lookup a random key slot.
If there is an element, try to evict it and allow add of the new element
just like before the rhashtable conversion.

LLM review claims failing constant-propagation will cause a call to the
h->params hashfn instead of the ip_set_hash_rnd_params one, so use a
random key instead of a fake "return get_random_u32()" hashfn as in
earlier versions.

Signed-off-by: Florian Westphal <fw@strlen.de>
- v6: v5 review complained that failing constant propagation can cause
--
 OOB access when the original params hashfn gets uses, so fill a random
 key instead and use the normal hashfn instead of overriding it.

 net/netfilter/ipset/ip_set_hash_gen.h | 82 +++++++++++++++++++++++++--
 1 file changed, 77 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 00dad2685022..b07757d528dd 100644
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
@@ -652,6 +658,70 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 		    (offsetof(struct mtype_rht_elem, elem) + set->dsize);
 }
 
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
+		.hashfn		= mtype_rht_hashfn,
+		.obj_hashfn	= mtype_rht_obj_hashfn,
+		.obj_cmpfn	= mtype_remove_cmpfn,
+		.key_len	= HKEY_DATALEN,
+	};
+	struct mtype_rht_elem *e = NULL;
+	struct htype *h = set->data;
+	bool removed = false;
+	u8 k[HKEY_DATALEN];
+
+	/* make sure k[] doesn't eat too much stack space */
+	BUILD_BUG_ON(sizeof(k) > 64);
+
+	/* LLM claims ip_set_hash_rnd_params must use the real
+	 * hashfn instead of a "get_random_u32" stub, because
+	 * rhashtable_lookup() might fail to constant-fold
+	 * ip_set_hash_rnd_params, in which case it would fall
+	 * back to h->params hashfn.
+	 */
+	get_random_bytes(k, sizeof(k));
+
+#ifdef IP_SET_HASH_WITH_MULTI
+	{
+		struct rhlist_head *list = rhltable_lookup(&h->rhlt, k,
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
@@ -726,11 +796,13 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		 * 'under limit' value, both increment.  Not worth the
 		 * effort to 'atomic_inc_return+decrement on error'.
 		 */
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

