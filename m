Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AF35B1E8
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 12:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707222581; cv=none; b=A3VUvYV7XcBEq0cSytqNAJnKNhd6HMdwUZ/N9ugZ6wUSl7EO/2LChxIDryDmeFEuZ2Ql71f4t2I0tomRE2zr8vgDc4DUKzILSfIDCFvmZurZZPWoUkXg/ptdw1QRIAt5eUpqk+5h2yV71ntrVVvTPS7Tsj635qUiE8LSDVGGers=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707222581; c=relaxed/simple;
	bh=rwDBe8QfLAkUqD0rjmzowzTCPZ1rAFvxtSUiftvkPwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUPsDE1nd3kc7psUgpgvk2xjWiKYfzeOg5AgWnQBk8mD5PmoDTnxsoq9VNzmd9shwzaLTWgwXTIpz/duwJgHBnMsSnJ6MJM+AhGui5SjUHaAz/owz5/2xQ85PcQ/MPOmHy4MRSPxoc8NgRiewA1JI3SHIH4nD07lT7hmB3JQ4bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rXKZy-0002AQ-RB; Tue, 06 Feb 2024 13:29:34 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/3] netfilter: nft_set_pipapo: store index in scratch maps
Date: Tue,  6 Feb 2024 13:23:06 +0100
Message-ID: <20240206122531.21972-2-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206122531.21972-1-fw@strlen.de>
References: <20240206122531.21972-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pipapo needs a scratchpad area to keep state during matching.
This state can be large and thus cannot reside on stack.

Each set preallocates percpu areas for this.

On each match stage, one scratchpad half starts with all-zero and the other
is inited to all-ones.

At the end of each stage, the half that starts with all-ones is
always zero.  Before next field is tested, pointers to the two halves
are swapped, i.e.  resmap pointer turns into fill pointer and vice versa.

After the last field has been processed, pipapo stashes the
index toggle in a percpu variable, with assumption that next packet
will start with the all-zero half and sets all bits in the other to 1.

This isn't reliable.

There can be multiple sets and we can't be sure that the upper
and lower half of all set scratch map is always in sync (lookups
can be conditional), so one set might have swapped, but other might
not have been queried.

Thus we need to keep the index per-set-and-cpu, just like the
scratchpad.

Note that this bug fix is incomplete, there is a related issue.

avx2 and normal implementation might use slightly different areas of the
map array space due to the avx2 alignment requirements, so
m->scratch (generic/fallback implementation) and ->scratch_aligned
(avx) may partially overlap. scratch and scratch_aligned are not distinct
objects, the latter is just the aligned address of the former.

After this change, write to scratch_align->map_index may write to
scratch->map, so this issue becomes more prominent, we can set to 1
a bit in the supposedly-all-zero area of scratch->map[].

A followup patch will remove the scratch_aligned and makes generic and
avx code use the same (aligned) area.

Its done in a separate change to ease review.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c      | 34 +++++++++++++++--------------
 net/netfilter/nft_set_pipapo.h      | 14 ++++++++++--
 net/netfilter/nft_set_pipapo_avx2.c | 15 ++++++-------
 3 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index efd523496be4..a8aa915f3f0b 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -342,9 +342,6 @@
 #include "nft_set_pipapo_avx2.h"
 #include "nft_set_pipapo.h"
 
-/* Current working bitmap index, toggled between field matches */
-static DEFINE_PER_CPU(bool, nft_pipapo_scratch_index);
-
 /**
  * pipapo_refill() - For each set bit, set bits from selected mapping table item
  * @map:	Bitmap to be scanned for set bits
@@ -412,6 +409,7 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 		       const u32 *key, const struct nft_set_ext **ext)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
+	struct nft_pipapo_scratch *scratch;
 	unsigned long *res_map, *fill_map;
 	u8 genmask = nft_genmask_cur(net);
 	const u8 *rp = (const u8 *)key;
@@ -422,15 +420,17 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 
 	local_bh_disable();
 
-	map_index = raw_cpu_read(nft_pipapo_scratch_index);
-
 	m = rcu_dereference(priv->match);
 
 	if (unlikely(!m || !*raw_cpu_ptr(m->scratch)))
 		goto out;
 
-	res_map  = *raw_cpu_ptr(m->scratch) + (map_index ? m->bsize_max : 0);
-	fill_map = *raw_cpu_ptr(m->scratch) + (map_index ? 0 : m->bsize_max);
+	scratch = *raw_cpu_ptr(m->scratch);
+
+	map_index = scratch->map_index;
+
+	res_map  = scratch->map + (map_index ? m->bsize_max : 0);
+	fill_map = scratch->map + (map_index ? 0 : m->bsize_max);
 
 	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
 
@@ -460,7 +460,7 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 		b = pipapo_refill(res_map, f->bsize, f->rules, fill_map, f->mt,
 				  last);
 		if (b < 0) {
-			raw_cpu_write(nft_pipapo_scratch_index, map_index);
+			scratch->map_index = map_index;
 			local_bh_enable();
 
 			return false;
@@ -477,7 +477,7 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 			 * current inactive bitmap is clean and can be reused as
 			 * *next* bitmap (not initial) for the next packet.
 			 */
-			raw_cpu_write(nft_pipapo_scratch_index, map_index);
+			scratch->map_index = map_index;
 			local_bh_enable();
 
 			return true;
@@ -1121,12 +1121,12 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 	int i;
 
 	for_each_possible_cpu(i) {
-		unsigned long *scratch;
+		struct nft_pipapo_scratch *scratch;
 #ifdef NFT_PIPAPO_ALIGN
-		unsigned long *scratch_aligned;
+		void *scratch_aligned;
 #endif
-
-		scratch = kzalloc_node(bsize_max * sizeof(*scratch) * 2 +
+		scratch = kzalloc_node(struct_size(scratch, map,
+						   bsize_max * 2) +
 				       NFT_PIPAPO_ALIGN_HEADROOM,
 				       GFP_KERNEL, cpu_to_node(i));
 		if (!scratch) {
@@ -1145,7 +1145,9 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 		*per_cpu_ptr(clone->scratch, i) = scratch;
 
 #ifdef NFT_PIPAPO_ALIGN
-		scratch_aligned = NFT_PIPAPO_LT_ALIGN(scratch);
+		scratch_aligned = NFT_PIPAPO_LT_ALIGN(&scratch->map);
+		/* Need to align ->map start, not start of structure itself */
+		scratch_aligned -= offsetof(struct nft_pipapo_scratch, map);
 		*per_cpu_ptr(clone->scratch_aligned, i) = scratch_aligned;
 #endif
 	}
@@ -2132,7 +2134,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 	m->field_count = field_count;
 	m->bsize_max = 0;
 
-	m->scratch = alloc_percpu(unsigned long *);
+	m->scratch = alloc_percpu(struct nft_pipapo_scratch *);
 	if (!m->scratch) {
 		err = -ENOMEM;
 		goto out_scratch;
@@ -2141,7 +2143,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 		*per_cpu_ptr(m->scratch, i) = NULL;
 
 #ifdef NFT_PIPAPO_ALIGN
-	m->scratch_aligned = alloc_percpu(unsigned long *);
+	m->scratch_aligned = alloc_percpu(struct nft_pipapo_scratch *);
 	if (!m->scratch_aligned) {
 		err = -ENOMEM;
 		goto out_free;
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 1040223da5fa..144b186c4caf 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -130,6 +130,16 @@ struct nft_pipapo_field {
 	union nft_pipapo_map_bucket *mt;
 };
 
+/**
+ * struct nft_pipapo_scratch - percpu data used for lookup and matching
+ * @map_index	Current working bitmap index, toggled between field matches
+ * @map		store partial matching results during lookup
+ */
+struct nft_pipapo_scratch {
+	u8 map_index;
+	unsigned long map[];
+};
+
 /**
  * struct nft_pipapo_match - Data used for lookup and matching
  * @field_count		Amount of fields in set
@@ -142,9 +152,9 @@ struct nft_pipapo_field {
 struct nft_pipapo_match {
 	int field_count;
 #ifdef NFT_PIPAPO_ALIGN
-	unsigned long * __percpu *scratch_aligned;
+	struct nft_pipapo_scratch * __percpu *scratch_aligned;
 #endif
-	unsigned long * __percpu *scratch;
+	struct nft_pipapo_scratch * __percpu *scratch;
 	size_t bsize_max;
 	struct rcu_head rcu;
 	struct nft_pipapo_field f[] __counted_by(field_count);
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 52e0d026d30a..8cad7b2e759d 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -71,9 +71,6 @@
 #define NFT_PIPAPO_AVX2_ZERO(reg)					\
 	asm volatile("vpxor %ymm" #reg ", %ymm" #reg ", %ymm" #reg)
 
-/* Current working bitmap index, toggled between field matches */
-static DEFINE_PER_CPU(bool, nft_pipapo_avx2_scratch_index);
-
 /**
  * nft_pipapo_avx2_prepare() - Prepare before main algorithm body
  *
@@ -1120,11 +1117,12 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 			    const u32 *key, const struct nft_set_ext **ext)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
-	unsigned long *res, *fill, *scratch;
+	struct nft_pipapo_scratch *scratch;
 	u8 genmask = nft_genmask_cur(net);
 	const u8 *rp = (const u8 *)key;
 	struct nft_pipapo_match *m;
 	struct nft_pipapo_field *f;
+	unsigned long *res, *fill;
 	bool map_index;
 	int i, ret = 0;
 
@@ -1146,10 +1144,11 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 		kernel_fpu_end();
 		return false;
 	}
-	map_index = raw_cpu_read(nft_pipapo_avx2_scratch_index);
 
-	res  = scratch + (map_index ? m->bsize_max : 0);
-	fill = scratch + (map_index ? 0 : m->bsize_max);
+	map_index = scratch->map_index;
+
+	res = scratch->map + (map_index ? m->bsize_max : 0);
+	fill = scratch->map + (map_index ? 0 : m->bsize_max);
 
 	/* Starting map doesn't need to be set for this implementation */
 
@@ -1221,7 +1220,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 
 out:
 	if (i % 2)
-		raw_cpu_write(nft_pipapo_avx2_scratch_index, !map_index);
+		scratch->map_index = !map_index;
 	kernel_fpu_end();
 
 	return ret >= 0;
-- 
2.43.0

