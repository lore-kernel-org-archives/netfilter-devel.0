Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ADD2FD7C3
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jul 2026 13:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784035177; cv=none; b=Kg20RWLDZ+lkdC/poQaeI+bsveS2YuI06Mq9NeTIIyfY24nRl4pEclUWwMzUIil8G558VYAcI6nmn5QRfqoQpB5/LHJwaaVJxLbRAHqUWZMUvrAYlUxAq3L8ET89m7aN/MAQR/gZOTiAtH051/JepkjcrkkTw3iezfElQuBoTKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784035177; c=relaxed/simple;
	bh=8y+KYxTTkVVyBhtYhVTu8rKM1aQxsvH68HLskHesPCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLbENXpDjDPFs+cMn5dv0S9qaR/iFSFteTteB2337iC1QYb6yYPSEjbn9yvk+2N7WbYnCHxYolQ+aMxMfpEjoPQLPU2Pv5xLb7+LVa18ZSNt8KEUx1HRSnJsluyczBQRQxJrzPgBUtl1RqmpuvEFMi01dsLHwQg8Pbigu8WNdMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1813760847; Tue, 14 Jul 2026 15:19:32 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 12/12] netfilter: ipset: re-add forceadd support for rhashtable
Date: Tue, 14 Jul 2026 15:18:28 +0200
Message-ID: <20260714131828.10685-13-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714131828.10685-1-fw@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rhashtable conversion removed the SET_WITH_FORCEADD eviction logic.
Sets created with the forceadd flag got IPSET_ERR_HASH_FULL instead of
evicting an existing element to make room.

Add mtype_remove_random() helper that walks the rhashtable to pick an
element to evict, and call it from mtype_add() when the set is full and
forceadd is enabled.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 43 +++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 12d3bc5acc81..df73c1ebb3f0 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -116,6 +116,7 @@ static const union nf_inet_addr zeromask = {};
 #undef mtype_bucket_size
 #undef mtype_hash_size
 
+#undef mtype_remove_random
 #undef mtype_add
 #undef mtype_del
 #undef mtype_test_cidrs
@@ -165,6 +166,7 @@ static const union nf_inet_addr zeromask = {};
 #define mtype_bucket_size	IPSET_TOKEN(MTYPE, _bucket_size)
 #define mtype_hash_size		IPSET_TOKEN(MTYPE, _hash_size)
 
+#define mtype_remove_random	IPSET_TOKEN(MTYPE, _remove_random)
 #define mtype_add		IPSET_TOKEN(MTYPE, _add)
 #define mtype_del		IPSET_TOKEN(MTYPE, _del)
 #define mtype_test_cidrs	IPSET_TOKEN(MTYPE, _test_cidrs)
@@ -511,6 +513,33 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 		    (offsetof(struct mtype_rht_elem, elem) + set->dsize);
 }
 
+/* Evict one element from the set to make room for a new one (forceadd) */
+static void __maybe_unused
+mtype_remove_random(struct ip_set *set, struct htype *h)
+{
+	struct rhashtable_iter hti;
+	struct mtype_rht_elem *e;
+	bool removed = false;
+
+	rhashtable_walk_enter(&h->ht, &hti);
+	rhashtable_walk_start(&hti);
+	e = rhashtable_walk_next(&hti);
+	if (IS_ERR(e))
+		e = NULL;
+
+	if (e && !rhashtable_remove_fast(&h->ht, &e->node, mtype_rht_params))
+		removed = true;
+
+	rhashtable_walk_stop(&hti);
+	rhashtable_walk_exit(&hti);
+
+	if (removed) {
+		mtype_del_cidr_all(set, h, &e->elem);
+		ip_set_ext_destroy_slow(set, &e->elem);
+		kfree_rcu(e, rcu);
+	}
+}
+
 /* Add an element to a hash and update the internal counters when succeeded,
  * otherwise report the proper error code.
  */
@@ -573,11 +602,15 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	rcu_read_unlock();
 
 	if (atomic_read(&h->ht.nelems) >= h->maxelem) {
-		if (net_ratelimit())
-			pr_warn("Set %s is full, maxelem %u reached\n",
-				set->name, h->maxelem);
-		mtype_data_next(&h->next, d);
-		return -IPSET_ERR_HASH_FULL;
+		if (SET_WITH_FORCEADD(set)) {
+			mtype_remove_random(set, h);
+		} else {
+			if (net_ratelimit())
+				pr_warn("Set %s is full, maxelem %u reached\n",
+					set->name, h->maxelem);
+			mtype_data_next(&h->next, d);
+			return -IPSET_ERR_HASH_FULL;
+		}
 	}
 
 	e = kzalloc(offsetof(struct mtype_rht_elem, elem) + set->dsize,
-- 
2.54.0

