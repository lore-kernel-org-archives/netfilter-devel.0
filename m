Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5AD311C12;
	Wed, 20 Aug 2025 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701287; cv=none; b=omWC9jxlvxv4vk4hhJO+Vtukc+DnHra74kGGdexR/+Gt1gMFZshVSNAB3wHii6R1AijJUSgbJOMiOkLEJ3BSKwLsjL1Zh+gLSf71dXmgVruDgVTToINS1fU1oVesFAOkU6pbPgOBF10XeAv5abDWKXW+8iG9ca2QTRvmSyqXGSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701287; c=relaxed/simple;
	bh=Tfa4ajUqWEo/qlkPhmGHygx2w2HpXBdINsWYSk0rER8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2B7jD6LsbmllyvjLrB8VUFhlwQy1UePceMiy0cE1rkFt3oc8ygtlLQiv6fsaDPjcH9RuAgCMVdhMuGt+cvd7tl+e0bUAu2jNy6P81h8SdfO33QZRtID9g8it5C/hop0Vtg0YjRCNibZjWHsdjDQv2or6ZALNC75+ttDup0z45A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 86B2F603CA; Wed, 20 Aug 2025 16:48:04 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 5/6] netfilter: nft_set_pipapo: Store real pointer, adjust later.
Date: Wed, 20 Aug 2025 16:47:37 +0200
Message-ID: <20250820144738.24250-6-fw@strlen.de>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The struct nft_pipapo_scratch is allocated, then aligned to the required
alignment and difference (in bytes) is then saved in align_off. The
aligned pointer is used later.
While this works, it gets complicated with all the extra checks if
all member before map are larger than the required alignment.

Instead of saving the aligned pointer, just save the returned pointer
and align the map pointer in nft_pipapo_lookup() before using it. The
alignment later on shouldn't be that expensive. With this change, the
align_off can be removed and the pointer can be passed to kfree() as is.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c      | 40 ++++++-----------------------
 net/netfilter/nft_set_pipapo.h      |  6 ++---
 net/netfilter/nft_set_pipapo_avx2.c |  8 +++---
 3 files changed, 14 insertions(+), 40 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7ed9c5f0e233..96b7539f5506 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -418,8 +418,8 @@ static struct nft_pipapo_elem *pipapo_get_slow(const struct nft_pipapo_match *m,
 					       const u8 *data, u8 genmask,
 					       u64 tstamp)
 {
+	unsigned long *res_map, *fill_map, *map;
 	struct nft_pipapo_scratch *scratch;
-	unsigned long *res_map, *fill_map;
 	const struct nft_pipapo_field *f;
 	bool map_index;
 	int i;
@@ -432,8 +432,9 @@ static struct nft_pipapo_elem *pipapo_get_slow(const struct nft_pipapo_match *m,
 
 	map_index = scratch->map_index;
 
-	res_map  = scratch->map + (map_index ? m->bsize_max : 0);
-	fill_map = scratch->map + (map_index ? 0 : m->bsize_max);
+	map = NFT_PIPAPO_LT_ALIGN(&scratch->__map[0]);
+	res_map  = map + (map_index ? m->bsize_max : 0);
+	fill_map = map + (map_index ? 0 : m->bsize_max);
 
 	pipapo_resmap_init(m, res_map);
 
@@ -1171,22 +1172,17 @@ static void pipapo_map(struct nft_pipapo_match *m,
 }
 
 /**
- * pipapo_free_scratch() - Free per-CPU map at original (not aligned) address
+ * pipapo_free_scratch() - Free per-CPU map at original address
  * @m:		Matching data
  * @cpu:	CPU number
  */
 static void pipapo_free_scratch(const struct nft_pipapo_match *m, unsigned int cpu)
 {
 	struct nft_pipapo_scratch *s;
-	void *mem;
 
 	s = *per_cpu_ptr(m->scratch, cpu);
-	if (!s)
-		return;
 
-	mem = s;
-	mem -= s->align_off;
-	kvfree(mem);
+	kvfree(s);
 }
 
 /**
@@ -1203,11 +1199,8 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 
 	for_each_possible_cpu(i) {
 		struct nft_pipapo_scratch *scratch;
-#ifdef NFT_PIPAPO_ALIGN
-		void *scratch_aligned;
-		u32 align_off;
-#endif
-		scratch = kvzalloc_node(struct_size(scratch, map, bsize_max * 2) +
+
+		scratch = kvzalloc_node(struct_size(scratch, __map, bsize_max * 2) +
 					NFT_PIPAPO_ALIGN_HEADROOM,
 					GFP_KERNEL_ACCOUNT, cpu_to_node(i));
 		if (!scratch) {
@@ -1222,23 +1215,6 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 		}
 
 		pipapo_free_scratch(clone, i);
-
-#ifdef NFT_PIPAPO_ALIGN
-		/* Align &scratch->map (not the struct itself): the extra
-		 * %NFT_PIPAPO_ALIGN_HEADROOM bytes passed to kzalloc_node()
-		 * above guarantee we can waste up to those bytes in order
-		 * to align the map field regardless of its offset within
-		 * the struct.
-		 */
-		BUILD_BUG_ON(offsetof(struct nft_pipapo_scratch, map) > NFT_PIPAPO_ALIGN_HEADROOM);
-
-		scratch_aligned = NFT_PIPAPO_LT_ALIGN(&scratch->map);
-		scratch_aligned -= offsetof(struct nft_pipapo_scratch, map);
-		align_off = scratch_aligned - (void *)scratch;
-
-		scratch = scratch_aligned;
-		scratch->align_off = align_off;
-#endif
 		*per_cpu_ptr(clone->scratch, i) = scratch;
 	}
 
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 4a2ff85ce1c4..e10cdbaa65d8 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -125,13 +125,11 @@ struct nft_pipapo_field {
 /**
  * struct nft_pipapo_scratch - percpu data used for lookup and matching
  * @map_index:	Current working bitmap index, toggled between field matches
- * @align_off:	Offset to get the originally allocated address
- * @map:	store partial matching results during lookup
+ * @__map:	store partial matching results during lookup
  */
 struct nft_pipapo_scratch {
 	u8 map_index;
-	u32 align_off;
-	unsigned long map[];
+	unsigned long __map[];
 };
 
 /**
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 028c11724b42..f0d8c796d731 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1155,7 +1155,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 {
 	struct nft_pipapo_scratch *scratch;
 	const struct nft_pipapo_field *f;
-	unsigned long *res, *fill;
+	unsigned long *res, *fill, *map;
 	bool map_index;
 	int i;
 
@@ -1164,9 +1164,9 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 		return NULL;
 
 	map_index = scratch->map_index;
-
-	res  = scratch->map + (map_index ? m->bsize_max : 0);
-	fill = scratch->map + (map_index ? 0 : m->bsize_max);
+	map = NFT_PIPAPO_LT_ALIGN(&scratch->__map[0]);
+	res  = map + (map_index ? m->bsize_max : 0);
+	fill = map + (map_index ? 0 : m->bsize_max);
 
 	pipapo_resmap_init_avx2(m, res);
 
-- 
2.49.1

