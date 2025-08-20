Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF86A309DB5;
	Wed, 20 Aug 2025 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701279; cv=none; b=iPSSpAzY8FPMqI6kWb5NCSq7eqjBqpFVkXMAtM7FZ56WRuEaWDSsKC2187KFUAArX3ZMbNlyEtP8O/h8sXSy9VE76llFoTzzO0X2SGdUMvrsZ5BbOEkAF9Y7VbqZ36vW/soF2H+QaKWN0g+iFOzOVwJu/bd6ofiXVEM9BvGFyUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701279; c=relaxed/simple;
	bh=NnDXyZQZlzNEvEQDjUzEBQMzommh/cqXJJjeQMEm0/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPgxe0Uode6rkWIeTucFMenn3kEcSJHOv8OCFcTKsMOK4oVdtOuil0BLI5JJ3Lkh3yaUoRSu8kihY1soZLTOAJ/02ed4/5OhngHBNiupj+jm5ZCGmDS2UufwAQNvZ1Jr6Lu2jhU889mIz1+t5U+nwdjqllRdRfXzmMClrualSsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CF24C602F8; Wed, 20 Aug 2025 16:47:55 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH net-next 3/6] netfilter: nft_set_pipapo_avx2: split lookup function in two parts
Date: Wed, 20 Aug 2025 16:47:35 +0200
Message-ID: <20250820144738.24250-4-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250820144738.24250-1-fw@strlen.de>
References: <20250820144738.24250-1-fw@strlen.de>
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

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 126 +++++++++++++++++-----------
 1 file changed, 77 insertions(+), 49 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index fc734a8545b4..994a2ad2d9b1 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1133,56 +1133,35 @@ static inline void pipapo_resmap_init_avx2(const struct nft_pipapo_match *m, uns
 }
 
 /**
- * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
- * @net:	Network namespace
- * @set:	nftables API set representation
- * @key:	nftables API element representation containing key data
+ * pipapo_get_avx2() - Lookup function for AVX2 implementation
+ * @m:		Storage containing the set elements
+ * @data:	Key data to be matched against existing elements
+ * @genmask:	If set, check that element is active in given genmask
+ * @tstamp:	Timestamp to check for expired elements
  *
  * For more details, see DOC: Theory of Operation in nft_set_pipapo.c.
  *
  * This implementation exploits the repetitive characteristic of the algorithm
  * to provide a fast, vectorised version using the AVX2 SIMD instruction set.
  *
- * Return: true on match, false otherwise.
+ * The caller must check that the FPU is usable.
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
-	/* Note that we don't need a valid MXCSR state for any of the
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
 
@@ -1191,6 +1170,12 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 
 	pipapo_resmap_init_avx2(m, res);
 
+	/* Note that we don't need a valid MXCSR state for any of the
+	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
+	 * instruction.
+	 */
+	kernel_fpu_begin_mask(0);
+
 	nft_pipapo_avx2_prepare();
 
 next_match:
@@ -1200,7 +1185,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 
 #define NFT_SET_PIPAPO_AVX2_LOOKUP(b, n)				\
 		(ret = nft_pipapo_avx2_lookup_##b##b_##n(res, fill, f,	\
-							 ret, rp,	\
+							 ret, data,	\
 							 first, last))
 
 		if (likely(f->bb == 8)) {
@@ -1216,7 +1201,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 				NFT_SET_PIPAPO_AVX2_LOOKUP(8, 16);
 			} else {
 				ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
-								  ret, rp,
+								  ret, data,
 								  first, last);
 			}
 		} else {
@@ -1232,7 +1217,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 				NFT_SET_PIPAPO_AVX2_LOOKUP(4, 32);
 			} else {
 				ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
-								  ret, rp,
+								  ret, data,
 								  first, last);
 			}
 		}
@@ -1240,29 +1225,72 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 
 #undef NFT_SET_PIPAPO_AVX2_LOOKUP
 
-		if (ret < 0)
-			goto out;
+		if (ret < 0) {
+			scratch->map_index = map_index;
+			kernel_fpu_end();
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
+			kernel_fpu_end();
+			return e;
 		}
 
+		map_index = !map_index;
 		swap(res, fill);
-		rp += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
+		data += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
 
-out:
-	if (i % 2)
-		scratch->map_index = !map_index;
 	kernel_fpu_end();
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
+ * the AVX2 routines if the fpu is usable or fall back to the generic
+ * implementation of the algorithm otherwise.
+ *
+ * Return: nftables API extension pointer or NULL if no match.
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
+	}
+
+	m = rcu_dereference(priv->match);
+
+	e = pipapo_get_avx2(m, rp, genmask, get_jiffies_64());
 	local_bh_enable();
 
-	return ext;
+	return e ? &e->ext : NULL;
 }
-- 
2.49.1

