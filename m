Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794494333;
	b=c9me1xc35gq4wMBR9kFN2aiRdZL3VkPulyJ/bLT2zlELK9ODVbC1V9c6tvX1LckmbXvt
	 EHvMYJK47JdULKz3vHYsMKesPYNecreKLEjgy1hNIZFtoTpHFJLMtiltPbClpYuCqRwYb
	 nHHLBpvc2qs3H+C69ETxBi/TRP40mWxDULp304G1ZyO113butNFiNr1zFgFZxAPtL+QRn
	 QdUfwfeMNt+RWf2jo38MrPOJyvaKT8F/GcgjcNfP+V7tIoBpsyoUDah/JOEq2YDnVHTLu
	 on6mA2JdXXOxYHimgne8ayP1JPUan/NMmfmgUbMow1x9ht5UHnDeXLO+h5BpQcqyaKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794494333;
	h=DMARC-Filter:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=FoQJIB8aCaCACdzSkM1XOT51GDp9jEieJ3TxnoCSL5I=;
	b=lrQOLSggehGuo/fg7UR7R+MEc6yzxdU8TpfGmqsD7coyIGMQR9HTdv3/yoLdwp1KKNpJ
	 /nZY0vI1MWL9/nnNES39IxKywEXCX/aKTKA+dduBpY0tbIw9eeurMecPi4OyAmrvkzOwA
	 vcIYnnIPVy5Q35UOZpQiZkb8ETkfZauNNMwypZb6o48XYltdi2zxLGrd7Or5zdQ/Y0wL3
	 UENbVo9/VLGn8dOuL2R0uG6qlrwcJJUbB3SPXuIJBcQJtwZaW8ki4Pls8t4cSx5ifR6VJ
	 TcmhN7KSbBrw/JSRUwFmNaHA7xNxJ41Uk1inQxq2pHDEREI2kPIpTzoIgN+5QyVz3Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2904606A321
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 14:38:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2904606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DBD226028B; Thu, 12 Nov 2026 15:38:50 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v10 6/6] netfilter: ipset: re-add forceadd support
Date: Thu, 12 Nov 2026 15:38:18 +0100
Message-ID: <20261112143818.30638-7-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261112143818.30638-1-fw@strlen.de>
References: <20261112143818.30638-1-fw@strlen.de>
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

Add mtype_remove_random() helper to look up a random key slot: a group
for IP_SET_HASH_WITH_MULTI sets, or a plain element otherwise. If there
is one, try to evict it and allow add of the new element just like
before the rhashtable conversion.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 93 ++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 39ef51c44df8..eab1e2bd85ff 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -165,6 +165,8 @@ static const union nf_inet_addr zeromask = {};
 #undef mtype_kadt
 #undef mtype_uadt
 
+#undef mtype_remove_random
+#undef mtype_remove_cmpfn
 #undef mtype_new_elem
 #undef mtype_add_replace_old
 #undef mtype_add
@@ -235,6 +237,8 @@ static const union nf_inet_addr zeromask = {};
 #define mtype_kadt		IPSET_TOKEN(MTYPE, _kadt)
 #define mtype_uadt		IPSET_TOKEN(MTYPE, _uadt)
 
+#define mtype_remove_random	IPSET_TOKEN(MTYPE, _remove_random)
+#define mtype_remove_cmpfn	IPSET_TOKEN(MTYPE, _remove_cmpfn)
 #define mtype_new_elem		IPSET_TOKEN(MTYPE, _new_elem)
 #define mtype_add_replace_old	IPSET_TOKEN(MTYPE, _add_replace_old)
 #define mtype_add		IPSET_TOKEN(MTYPE, _add)
@@ -950,6 +954,93 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 #endif
 }
 
+static int mtype_remove_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
+{
+	return 0; /* always match */
+}
+
+/**
+ * mtype_remove_random() - Remove a random element from the set (forceadd)
+ * @set: Pointer to the ip_set
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
+	u32 k[HKEY_DATALEN / sizeof(u32)];
+	struct htype *h = set->data;
+
+	/* make sure k[] doesn't eat too much stack space */
+	BUILD_BUG_ON(sizeof(k) > 64);
+
+	/* The real hashfn is needed instead of a "get_random_u32" stub,
+	 * because rhashtable_lookup() might fail to constant-fold the
+	 * params below, in which case it would fall back to h->params
+	 * hashfn.
+	 */
+	get_random_bytes(k, sizeof(k));
+
+#ifdef IP_SET_HASH_WITH_MULTI
+	{
+		static const struct rhashtable_params ip_set_hash_grp_rnd_params = {
+			.head_offset	= offsetof(struct mtype_group, node),
+			.key_offset	= offsetof(struct mtype_group, key),
+			.hashfn		= mtype_rht_hashfn,
+			.obj_hashfn	= mtype_group_obj_hashfn,
+			.obj_cmpfn	= mtype_remove_cmpfn,
+			.key_len	= HKEY_DATALEN,
+		};
+		struct mtype_group *grp;
+		struct mtype_rht_elem *e;
+
+		grp = rhashtable_lookup(&h->ht, k, ip_set_hash_grp_rnd_params);
+		if (!grp)
+			return false;
+
+		/* mtype_add() can call us while already holding this exact
+		 * group's lock (maxelem reached while inserting into it);
+		 * trylock to avoid self-deadlock. Best-effort: no linear
+		 * scan, 'return false' is fine either way.
+		 */
+		if (!spin_trylock_bh(&grp->lock))
+			return false;
+		e = hlist_entry_safe(grp->iface_list.first,
+				     struct mtype_rht_elem, node);
+		if (!e) {
+			spin_unlock_bh(&grp->lock);
+			return false;
+		}
+		mtype_group_remove_elem(set, h, grp, e);
+		mtype_group_unlock(h, grp);
+		return true;
+	}
+#else
+	{
+		static const struct rhashtable_params ip_set_hash_rnd_params = {
+			.head_offset	= offsetof(struct mtype_rht_elem, node),
+			.key_offset	= offsetof(struct mtype_rht_elem, elem),
+			.hashfn		= mtype_rht_hashfn,
+			.obj_hashfn	= mtype_rht_obj_hashfn,
+			.obj_cmpfn	= mtype_remove_cmpfn,
+			.key_len	= HKEY_DATALEN,
+		};
+		struct mtype_rht_elem *e;
+
+		e = rhashtable_lookup(&h->ht, &k, ip_set_hash_rnd_params);
+		if (!e || rhashtable_remove_fast(&h->ht, &e->node, mtype_rht_params))
+			return false;
+
+		ipset_hash_elem_destroy_free(set, e);
+		return true;
+	}
+#endif
+}
+
 /**
  * mtype_new_elem() - allocate and initialize a replacement/new element
  * @set: Pointer to the ip_set
@@ -993,7 +1084,7 @@ mtype_new_elem(struct ip_set *set, struct htype *h, const struct mtype_elem *d,
 		 * its pretty much pointless, userspace can just retry once
 		 * gc has fired, resp. decrease the gc interval.
 		 */
-		if (1) {
+		if (!SET_WITH_FORCEADD(set) || !mtype_remove_random(set)) {
 			if (net_ratelimit())
 				pr_warn("Set %s is full, maxelem %u reached\n",
 					set->name, h->maxelem);
-- 
2.56.1

