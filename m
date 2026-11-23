Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442285;
	b=Qofy4CMEcrxf4RwvHop05X5K/ko/QydMhHvoJUlZtmxJC0LvXRslPSsjCN3i0HkUod3j
	 5rTQpSbpPfGf+0/XrcjkBikGfZEc/aImXgRHbc2XT86ix/saCwKrBBZ5+wrTKyNBVXYBY
	 jYjZS2OMbY6HsNEzKElnj6bCX2rH1VUFeQux5vcEGfZ5mh2VMo5UUbXoBQUbdM0P06L44
	 /9qCFJsWU1lKK/61KY6aisxvMl8XdgxbhMnTtIqaoIK2Ei5HsCn68pii3MC/VOFeXsxy+
	 GwRTmfwtoQbL6VhmFDQczx/Fy/tuZ65ROcrDN2Gh7r5brJInUbcTBCfa4HeVOPzGZSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442285;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=sEB+mS0CsXC+1zHmglTou5v2/VefIu20eB7qIyEpTAo=;
	b=MLEmNnYiv/LrB084BAW25ohLllj8wM/X+zsI9zT+e7KV/hFVxtHw32kVoAEUxIdBylSQ
	 PwTUd0MkXGJ5v240E9FOlrjc2vU1AmFNCAGDsyN5Tf1w8QWl68nkkAa/iyoWHicbUE7ug
	 3V9FL4++1KxKrwM4GXTuF58dAET/1+Yk3MQxKeh9E8takY4PmtHFIAX+sBCyloYkW0Gdv
	 7+y71Xm2D+LiujYjs9CNofrwFDVuDCkZy/FRcoRsctpjxBxIoBpDG0knHLGmgHOEpZNHK
	 uSAh3UrLSIgbPitwdOJu3feoJba5n2A9tXDKheakDp6dc1ydmCs0QAkRSD2VLNKZ4OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Vajg7qEj;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5833C60A2607;
	Mon, 23 Nov 2026 13:58:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5833C60A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Vajg7qEj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442282;
	bh=sEB+mS0CsXC+1zHmglTou5v2/VefIu20eB7qIyEpTAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vajg7qEjzXr6f4tb92z2s5iLZ5gKga5KZOzKc6swFBf05ejw7+OpljkUle0edMxal
	 OHPVbEPNvZn27d1WptVnssAImsWvLNXRgr7CsAvO4Z71MpOpRshNOWLjpNV+Y0QsrK
	 uF2n4rSVymilL6acWW7+IzYhdk4NK9nH2BqLmmfEKSULMt1bU+h3+79YK2R8OS95Zt
	 bYsNSLXnVsCQBhSHPuFIY0fo6FszMBzrRKwK4AZctK5acD0PMcRGLbSiOcQ7IyI8B/
	 raIWRRauNX0W2I6qZ3Avao4RkVLaifF22dfb22lAt84IUjaDTIIdmQ6Yhqdej6Sv9R
	 t5y3wnsccuETw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2F135602ED;
	Mon, 23 Nov 2026 14:58:02 +0100 (CET)
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
Subject: [PATCH net-next 15/15] netfilter: ipset: re-add forceadd support
Date: Mon, 23 Nov 2026 14:57:26 +0100
Message-ID: <20261123135726.3940688-16-pablo@netfilter.org>
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

The rhashtable conversion removed the SET_WITH_FORCEADD eviction logic.

Add mtype_remove_random() helper to look up a random key slot: a group
for IP_SET_HASH_WITH_MULTI sets, or a plain element otherwise. If there
is one, try to evict it and allow add of the new element just like
before the rhashtable conversion.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.47.3

