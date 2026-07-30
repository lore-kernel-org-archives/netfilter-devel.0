Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03873876A7
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 18:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785436773; cv=none; b=hZUBlz+fWZf8ToT65mywKh5wojRoheS/HO1wSivbN8z+Zio6vx5ApbNIwtlg2/EFf+Hdtbal3ujdg4ddfdGdhK0/x1A2NtaTIGu6dFXGsDGHvXoJKjmcaoSyPZ9KahUTMe1k1K08mKmWWWnddiv2lTfEiPQlShzW0ko6yI/QbCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785436773; c=relaxed/simple;
	bh=TWgPMAMQisszVsmUK5HDs2xs7DxV8kIJwyiZcJel16s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ey6vvLqXQGL9BusuJPFiRNEd5eRWSUrlPQVuWpk/oAeiJdxOmM41OLV27gOIYZHC+sPuADx3bQfzyrxDiYYZGVdedZxAk3DrYoyLY3JAAAjSJF2GREUdUOWQMd7n0zJ09RS8m7lvhoU3okDnQMvbedPTFlhUMk9/e243XNABI+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0C389605E7; Thu, 30 Jul 2026 20:39:16 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 4/5] netfilter: ipset: add and use mtype_del_cidr_all helper
Date: Thu, 30 Jul 2026 20:38:52 +0200
Message-ID: <20260730183853.21868-5-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260730183853.21868-1-fw@strlen.de>
References: <20260730183853.21868-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reduces size of upcoming rhashtable conversion.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 34 +++++++++++++--------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index ef586b486f51..f00c82acd7f0 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -195,6 +195,7 @@ static const union nf_inet_addr zeromask = {};
 #undef mtype_ext_cleanup
 #undef mtype_add_cidr
 #undef mtype_del_cidr
+#undef mtype_del_cidr_all
 #undef mtype_ahash_memsize
 #undef mtype_flush
 #undef mtype_destroy
@@ -242,6 +243,7 @@ static const union nf_inet_addr zeromask = {};
 #define mtype_ext_cleanup	IPSET_TOKEN(MTYPE, _ext_cleanup)
 #define mtype_add_cidr		IPSET_TOKEN(MTYPE, _add_cidr)
 #define mtype_del_cidr		IPSET_TOKEN(MTYPE, _del_cidr)
+#define mtype_del_cidr_all	IPSET_TOKEN(MTYPE, _del_cidr_all)
 #define mtype_ahash_memsize	IPSET_TOKEN(MTYPE, _ahash_memsize)
 #define mtype_flush		IPSET_TOKEN(MTYPE, _flush)
 #define mtype_destroy		IPSET_TOKEN(MTYPE, _destroy)
@@ -410,6 +412,17 @@ mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 }
 #endif
 
+static void
+mtype_del_cidr_all(struct ip_set *set, struct htype *h, const struct mtype_elem *data)
+{
+#ifdef IP_SET_HASH_WITH_NETS
+	int k;
+
+	for (k = 0; k < IPSET_NET_COUNT; k++)
+		mtype_del_cidr(set, h, DCIDR_GET(data->cidr, k), k);
+#endif
+}
+
 /* Calculate the actual memory size of the set data */
 static size_t
 mtype_ahash_memsize(const struct htype *h, const struct htable *t)
@@ -551,9 +564,6 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 	struct mtype_elem *data;
 	u32 i, j, d;
 	size_t dsize = set->dsize;
-#ifdef IP_SET_HASH_WITH_NETS
-	u8 k;
-#endif
 	u8 pos, htable_bits = t->htable_bits;
 
 	spin_lock_bh(&t->hregion[r].lock);
@@ -574,11 +584,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 			pr_debug("expired %u/%u\n", i, j);
 			clear_bit(j, n->used);
 			smp_mb__after_atomic();
-#ifdef IP_SET_HASH_WITH_NETS
-			for (k = 0; k < IPSET_NET_COUNT; k++)
-				mtype_del_cidr(set, h,
-					DCIDR_GET(data->cidr, k), k);
-#endif
+			mtype_del_cidr_all(set, h, data);
 			t->hregion[r].elements--;
 			ip_set_ext_destroy(set, data);
 			d++;
@@ -1004,11 +1010,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			j = 0;
 		data = ahash_data(n, j, set->dsize);
 		if (!deleted) {
-#ifdef IP_SET_HASH_WITH_NETS
-			for (i = 0; i < IPSET_NET_COUNT; i++)
-				mtype_del_cidr(set, h,
-					DCIDR_GET(data->cidr, i), i);
-#endif
+			mtype_del_cidr_all(set, h, data);
 			ip_set_ext_destroy(set, data);
 			t->hregion[r].elements--;
 		}
@@ -1163,11 +1165,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (i + 1 == pos)
 			smp_store_release(&n->pos, --pos);
 		t->hregion[r].elements--;
-#ifdef IP_SET_HASH_WITH_NETS
-		for (j = 0; j < IPSET_NET_COUNT; j++)
-			mtype_del_cidr(set, h,
-				DCIDR_GET(d->cidr, j), j);
-#endif
+		mtype_del_cidr_all(set, h, d);
 		ip_set_ext_destroy(set, data);
 
 		if (t->resizing && ext && ext->target) {
-- 
2.54.0

