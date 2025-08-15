Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFC126F44D
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 14:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755268647; cv=none; b=YWXo7NEsWcZWmtRBnhBtM+x2RkhGh7HGKnWCMYEk8AC3Gh0kqI2VO5I2MvzGIPB/g4TeXkHP471vOB9yJ0Bdmu7BmRSI7YWFs9mbq48jz/IqpaYYVLecgc6zZqBtB+YkwZqxB2rztnciVYGZCDS+531sTNhZqZ+L5CvZK8ABKm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755268647; c=relaxed/simple;
	bh=TCUD8TjbJtrrTxqLxWdvKeK9PE1+a4lgIY0ejEBcGsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DG85ml3B5mBwEWSPVNxfT7yeVcTOGM0agQR83CRaFGRcD31KvLRQKS1o8T9aLZxDIt63OUH/h3YwkF0rxlzKsnW28ncbRRh4RlPpUCZaShrecL+QQ0bl9/0c/WC2pqZzIG7fsSPxjdxoZIPK66drbrA4RjdJs2wNeKHBSpMx9CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1ACF1605CE; Fri, 15 Aug 2025 16:37:22 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/2] netfilter: nft_set_pipapo_avx2: split lookup function in two parts
Date: Fri, 15 Aug 2025 16:36:57 +0200
Message-ID: <20250815143702.17272-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250815143702.17272-1-fw@strlen.de>
References: <20250815143702.17272-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split the main avx2 lookup function into a helper.

This is a preparation patch: followup change will use the new helper
from the insertion path if possible.  This greatly improves insertion
performance when avx2 is supported.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 127 +++++++++++++++++-----------
 1 file changed, 76 insertions(+), 51 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 2f090e253caf..d512877cc211 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1133,58 +1133,35 @@ static inline void pipapo_resmap_init_avx2(const struct nft_pipapo_match *m, uns
 }
 
 /**
- * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
- * @net:	Network namespace
- * @set:	nftables API set representation
- * @key:	nftables API element representation containing key data
+ * pipapo_get_avx2() - Lookup function for AVX2 implementation
+ * @m:		storage containing the set elements
+ * @data:	Key data to be matched against existing elements
+ * @genmask:	If set, check that element is active in given genmask
+ * @tstamp:	timestamp to check for expired elements
  *
  * For more details, see DOC: Theory of Operation in nft_set_pipapo.c.
  *
  * This implementation exploits the repetitive characteristic of the algorithm
  * to provide a fast, vectorised version using the AVX2 SIMD instruction set.
  *
- * Return: true on match, false otherwise.
+ * The caller MUST check that the fpu is usable.
+ * This function must be called with BH disabled.
+ *
+ * Return: pointer to &struct nft_pipapo_elem on match, NULL otherwise.
  */
-const struct nft_set_ext *
-nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
-		       const u32 *key)
+static struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
+					       const u8 *data, u8 genmask,
+					       u64 tstamp)
 {
-	struct nft_pipapo *priv = nft_set_priv(set);
-	const struct nft_set_ext *ext = NULL;
 	struct nft_pipapo_scratch *scratch;
-	u8 genmask = nft_genmask_cur(net);
-	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
-	const u8 *rp = (const u8 *)key;
 	unsigned long *res, *fill;
 	bool map_index;
 	int i;
 
-	local_bh_disable();
-
-	if (unlikely(!irq_fpu_usable())) {
-		ext = nft_pipapo_lookup(net, set, key);
-
-		local_bh_enable();
-		return ext;
-	}
-
-	m = rcu_dereference(priv->match);
-
-	/* This also protects access to all data related to scratch maps.
-	 *
-	 * Note that we don't need a valid MXCSR state for any of the
-	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
-	 * instruction.
-	 */
-	kernel_fpu_begin_mask(0);
-
 	scratch = *raw_cpu_ptr(m->scratch);
-	if (unlikely(!scratch)) {
-		kernel_fpu_end();
-		local_bh_enable();
+	if (unlikely(!scratch))
 		return NULL;
-	}
 
 	map_index = scratch->map_index;
 
@@ -1202,7 +1179,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 
 #define NFT_SET_PIPAPO_AVX2_LOOKUP(b, n)				\
 		(ret = nft_pipapo_avx2_lookup_##b##b_##n(res, fill, f,	\
-							 ret, rp,	\
+							 ret, data,	\
 							 first, last))
 
 		if (likely(f->bb == 8)) {
@@ -1218,7 +1195,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 				NFT_SET_PIPAPO_AVX2_LOOKUP(8, 16);
 			} else {
 				ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
-								  ret, rp,
+								  ret, data,
 								  first, last);
 			}
 		} else {
@@ -1234,7 +1211,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 				NFT_SET_PIPAPO_AVX2_LOOKUP(4, 32);
 			} else {
 				ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
-								  ret, rp,
+								  ret, data,
 								  first, last);
 			}
 		}
@@ -1242,29 +1219,77 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 
 #undef NFT_SET_PIPAPO_AVX2_LOOKUP
 
-		if (ret < 0)
-			goto out;
+		if (ret < 0) {
+			scratch->map_index = map_index;
+			return NULL;
+		}
 
 		if (last) {
-			const struct nft_set_ext *e = &f->mt[ret].e->ext;
+			struct nft_pipapo_elem *e;
 
-			if (unlikely(nft_set_elem_expired(e) ||
-				     !nft_set_elem_active(e, genmask)))
+			e = f->mt[ret].e;
+			if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
+				     !nft_set_elem_active(&e->ext, genmask)))
 				goto next_match;
 
-			ext = e;
-			goto out;
+			scratch->map_index = map_index;
+			return e;
 		}
 
+		map_index = !map_index;
 		swap(res, fill);
-		rp += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
+		data += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
+	}
+
+	return NULL;
+}
+
+/**
+ * nft_pipapo_avx2_lookup() - Dataplane frontend for AVX2 implementation
+ * @net:	Network namespace
+ * @set:	nftables API set representation
+ * @key:	nftables API element representation containing key data
+ *
+ * This function is called from the data path.  It will search for
+ * an element matching the given key in the current active copy using
+ * the avx2 routines if the fpu is usable or fall back to the generic
+ * implementation of the algorithm otherwise.
+ *
+ * Return: ntables API extension pointer or NULL if no match.
+ */
+const struct nft_set_ext *
+nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key)
+{
+	struct nft_pipapo *priv = nft_set_priv(set);
+	u8 genmask = nft_genmask_cur(net);
+	const struct nft_pipapo_match *m;
+	const u8 *rp = (const u8 *)key;
+	const struct nft_pipapo_elem *e;
+
+	local_bh_disable();
+
+	if (unlikely(!irq_fpu_usable())) {
+		const struct nft_set_ext *ext;
+
+		ext = nft_pipapo_lookup(net, set, key);
+
+		local_bh_enable();
+		return ext;
 	}
 
-out:
-	if (i % 2)
-		scratch->map_index = !map_index;
+	m = rcu_dereference(priv->match);
+
+	/* This also protects access to all data related to scratch maps.
+	 *
+	 * Note that we don't need a valid MXCSR state for any of the
+	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
+	 * instruction.
+	 */
+	kernel_fpu_begin_mask(0);
+	e = pipapo_get_avx2(m, rp, genmask, get_jiffies_64());
 	kernel_fpu_end();
 	local_bh_enable();
 
-	return ext;
+	return e ? &e->ext : NULL;
 }
-- 
2.49.1

