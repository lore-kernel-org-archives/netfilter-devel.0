Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DEB41202;
	Wed, 21 Feb 2024 11:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708515021; cv=none; b=iWLx01aRjCNmhyS3JCHg/V4PsfH9pzp5siOo2p/VgRkj5Kfc5g7uQGMps2/tigDI+q7SmOx2UfNBmjI6VeHxeGAfhk+fV3Ia+gVCRiW+K2EDm7aORDCp0RSko/1IZ6VM4j5jDI4pWm0tdsgc3DVnN73zK2LJNx03ic6x3qUvo9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708515021; c=relaxed/simple;
	bh=LarP9MGSMLbFNJl0sNwhAGff0a44u5IlhATlpUiv7Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThV6snuywrIo6/ZLfQ9WdhZEWO9iZuLRKHsYdrLu7DklSqXdMBqmiqS431IwJ1OFgpHCsQDUA1Qw8nfcz4bxE/JsYWVhEKrjjXBTRIvqnW9TVBrUK9w7QCpVU4dDTDNJmKviK2Rk023BECQY0QMyY+GNqIUXDhLXbOdHV65h13w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rckne-0003ty-E4; Wed, 21 Feb 2024 12:30:06 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH net-next 08/12] netfilter: nft_set_pipapo: shrink data structures
Date: Wed, 21 Feb 2024 12:26:10 +0100
Message-ID: <20240221112637.5396-9-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240221112637.5396-1-fw@strlen.de>
References: <20240221112637.5396-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The set uses a mix of 'int', 'unsigned int', and size_t.

The rule count limit is NFT_PIPAPO_RULE0_MAX, which cannot
exceed INT_MAX (a few helpers use 'int' as return type).

Add a compile-time assertion for this.

Replace size_t usage in structs with unsigned int or u8 where
the stored values are smaller.

Replace signed-int arguments for lengths with 'unsigned int'
where possible.

Last, remove lt_aligned member: its set but never read.

struct nft_pipapo_match 40 bytes -> 32 bytes
struct nft_pipapo_field 56 bytes -> 32 bytes

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 62 ++++++++++++++++++++++------------
 net/netfilter/nft_set_pipapo.h | 29 ++++++----------
 2 files changed, 51 insertions(+), 40 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 625c06b8bc39..b63278b2017a 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -359,11 +359,13 @@
  *
  * Return: -1 on no match, bit position on 'match_only', 0 otherwise.
  */
-int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
+int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
+		  unsigned long *dst,
 		  const union nft_pipapo_map_bucket *mt, bool match_only)
 {
 	unsigned long bitset;
-	int k, ret = -1;
+	unsigned int k;
+	int ret = -1;
 
 	for (k = 0; k < len; k++) {
 		bitset = map[k];
@@ -631,13 +633,17 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
  *
  * Return: 0 on success, -ENOMEM on allocation failure.
  */
-static int pipapo_resize(struct nft_pipapo_field *f, int old_rules, int rules)
+static int pipapo_resize(struct nft_pipapo_field *f,
+			 unsigned int old_rules, unsigned int rules)
 {
 	long *new_lt = NULL, *new_p, *old_lt = f->lt, *old_p;
 	union nft_pipapo_map_bucket *new_mt, *old_mt = f->mt;
-	size_t new_bucket_size, copy;
+	unsigned int new_bucket_size, copy;
 	int group, bucket;
 
+	if (rules >= NFT_PIPAPO_RULE0_MAX)
+		return -ENOSPC;
+
 	new_bucket_size = DIV_ROUND_UP(rules, BITS_PER_LONG);
 #ifdef NFT_PIPAPO_ALIGN
 	new_bucket_size = roundup(new_bucket_size,
@@ -690,7 +696,7 @@ static int pipapo_resize(struct nft_pipapo_field *f, int old_rules, int rules)
 
 	if (new_lt) {
 		f->bsize = new_bucket_size;
-		NFT_PIPAPO_LT_ASSIGN(f, new_lt);
+		f->lt = new_lt;
 		kvfree(old_lt);
 	}
 
@@ -847,8 +853,8 @@ static void pipapo_lt_8b_to_4b(int old_groups, int bsize,
  */
 static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 {
+	unsigned int groups, bb;
 	unsigned long *new_lt;
-	int groups, bb;
 	size_t lt_size;
 
 	lt_size = f->groups * NFT_PIPAPO_BUCKETS(f->bb) * f->bsize *
@@ -898,7 +904,7 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 	f->groups = groups;
 	f->bb = bb;
 	kvfree(f->lt);
-	NFT_PIPAPO_LT_ASSIGN(f, new_lt);
+	f->lt = new_lt;
 }
 
 /**
@@ -915,7 +921,7 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 static int pipapo_insert(struct nft_pipapo_field *f, const uint8_t *k,
 			 int mask_bits)
 {
-	int rule = f->rules, group, ret, bit_offset = 0;
+	unsigned int rule = f->rules, group, ret, bit_offset = 0;
 
 	ret = pipapo_resize(f, f->rules, f->rules + 1);
 	if (ret)
@@ -1255,8 +1261,14 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	/* Validate */
 	start_p = start;
 	end_p = end;
+
+	/* some helpers return -1, or 0 >= for valid rule pos,
+	 * so we cannot support more than INT_MAX rules at this time.
+	 */
+	BUILD_BUG_ON(NFT_PIPAPO_RULE0_MAX > INT_MAX);
+
 	nft_pipapo_for_each_field(f, i, m) {
-		if (f->rules >= (unsigned long)NFT_PIPAPO_RULE0_MAX)
+		if (f->rules >= NFT_PIPAPO_RULE0_MAX)
 			return -ENOSPC;
 
 		if (memcmp(start_p, end_p,
@@ -1362,7 +1374,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		if (!new_lt)
 			goto out_lt;
 
-		NFT_PIPAPO_LT_ASSIGN(dst, new_lt);
+		dst->lt = new_lt;
 
 		memcpy(NFT_PIPAPO_LT_ALIGN(new_lt),
 		       NFT_PIPAPO_LT_ALIGN(src->lt),
@@ -1433,10 +1445,10 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
  *
  * Return: Number of rules that originated from the same entry as @first.
  */
-static int pipapo_rules_same_key(struct nft_pipapo_field *f, int first)
+static unsigned int pipapo_rules_same_key(struct nft_pipapo_field *f, unsigned int first)
 {
 	struct nft_pipapo_elem *e = NULL; /* Keep gcc happy */
-	int r;
+	unsigned int r;
 
 	for (r = first; r < f->rules; r++) {
 		if (r != first && e != f->mt[r].e)
@@ -1489,8 +1501,9 @@ static int pipapo_rules_same_key(struct nft_pipapo_field *f, int first)
  *                        0      1      2
  *  element pointers:  0x42   0x42   0x44
  */
-static void pipapo_unmap(union nft_pipapo_map_bucket *mt, int rules,
-			 int start, int n, int to_offset, bool is_last)
+static void pipapo_unmap(union nft_pipapo_map_bucket *mt, unsigned int rules,
+			 unsigned int start, unsigned int n,
+			 unsigned int to_offset, bool is_last)
 {
 	int i;
 
@@ -1596,8 +1609,8 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct net *net = read_pnet(&set->net);
+	unsigned int rules_f0, first_rule = 0;
 	u64 tstamp = nft_net_tstamp(net);
-	int rules_f0, first_rule = 0;
 	struct nft_pipapo_elem *e;
 	struct nft_trans_gc *gc;
 
@@ -1608,7 +1621,7 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
 		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 		const struct nft_pipapo_field *f;
-		int i, start, rules_fx;
+		unsigned int i, start, rules_fx;
 
 		start = first_rule;
 		rules_fx = rules_f0;
@@ -1986,7 +1999,7 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m = priv->clone;
-	int rules_f0, first_rule = 0;
+	unsigned int rules_f0, first_rule = 0;
 	struct nft_pipapo_elem *e;
 	const u8 *data;
 
@@ -2051,7 +2064,7 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	struct net *net = read_pnet(&set->net);
 	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
-	int i, r;
+	unsigned int i, r;
 
 	rcu_read_lock();
 	if (iter->genmask == nft_genmask_cur(net))
@@ -2155,6 +2168,9 @@ static int nft_pipapo_init(const struct nft_set *set,
 
 	field_count = desc->field_count ? : 1;
 
+	BUILD_BUG_ON(NFT_PIPAPO_MAX_FIELDS > 255);
+	BUILD_BUG_ON(NFT_PIPAPO_MAX_FIELDS != NFT_REG32_COUNT);
+
 	if (field_count > NFT_PIPAPO_MAX_FIELDS)
 		return -EINVAL;
 
@@ -2176,7 +2192,11 @@ static int nft_pipapo_init(const struct nft_set *set,
 	rcu_head_init(&m->rcu);
 
 	nft_pipapo_for_each_field(f, i, m) {
-		int len = desc->field_len[i] ? : set->klen;
+		unsigned int len = desc->field_len[i] ? : set->klen;
+
+		/* f->groups is u8 */
+		BUILD_BUG_ON((NFT_PIPAPO_MAX_BYTES *
+			      BITS_PER_BYTE / NFT_PIPAPO_GROUP_BITS_LARGE_SET) >= 256);
 
 		f->bb = NFT_PIPAPO_GROUP_BITS_INIT;
 		f->groups = len * NFT_PIPAPO_GROUPS_PER_BYTE(f);
@@ -2185,7 +2205,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 
 		f->bsize = 0;
 		f->rules = 0;
-		NFT_PIPAPO_LT_ASSIGN(f, NULL);
+		f->lt = NULL;
 		f->mt = NULL;
 	}
 
@@ -2221,7 +2241,7 @@ static void nft_set_pipapo_match_destroy(const struct nft_ctx *ctx,
 					 struct nft_pipapo_match *m)
 {
 	struct nft_pipapo_field *f;
-	int i, r;
+	unsigned int i, r;
 
 	for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
 		;
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 42464e7c24ac..ca64f7505e71 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -70,15 +70,9 @@
 #define NFT_PIPAPO_ALIGN_HEADROOM					\
 	(NFT_PIPAPO_ALIGN - ARCH_KMALLOC_MINALIGN)
 #define NFT_PIPAPO_LT_ALIGN(lt)		(PTR_ALIGN((lt), NFT_PIPAPO_ALIGN))
-#define NFT_PIPAPO_LT_ASSIGN(field, x)					\
-	do {								\
-		(field)->lt_aligned = NFT_PIPAPO_LT_ALIGN(x);		\
-		(field)->lt = (x);					\
-	} while (0)
 #else
 #define NFT_PIPAPO_ALIGN_HEADROOM	0
 #define NFT_PIPAPO_LT_ALIGN(lt)		(lt)
-#define NFT_PIPAPO_LT_ASSIGN(field, x)	((field)->lt = (x))
 #endif /* NFT_PIPAPO_ALIGN */
 
 #define nft_pipapo_for_each_field(field, index, match)		\
@@ -110,22 +104,18 @@ union nft_pipapo_map_bucket {
 
 /**
  * struct nft_pipapo_field - Lookup, mapping tables and related data for a field
- * @groups:	Amount of bit groups
  * @rules:	Number of inserted rules
  * @bsize:	Size of each bucket in lookup table, in longs
+ * @groups:	Amount of bit groups
  * @bb:		Number of bits grouped together in lookup table buckets
  * @lt:		Lookup table: 'groups' rows of buckets
- * @lt_aligned:	Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
  * @mt:		Mapping table: one bucket per rule
  */
 struct nft_pipapo_field {
-	int groups;
-	unsigned long rules;
-	size_t bsize;
-	int bb;
-#ifdef NFT_PIPAPO_ALIGN
-	unsigned long *lt_aligned;
-#endif
+	unsigned int rules;
+	unsigned int bsize;
+	u8 groups;
+	u8 bb;
 	unsigned long *lt;
 	union nft_pipapo_map_bucket *mt;
 };
@@ -145,15 +135,15 @@ struct nft_pipapo_scratch {
 /**
  * struct nft_pipapo_match - Data used for lookup and matching
  * @field_count:	Amount of fields in set
- * @scratch:		Preallocated per-CPU maps for partial matching results
  * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
+ * @scratch:		Preallocated per-CPU maps for partial matching results
  * @rcu:		Matching data is swapped on commits
  * @f:			Fields, with lookup and mapping tables
  */
 struct nft_pipapo_match {
-	int field_count;
+	u8 field_count;
+	unsigned int bsize_max;
 	struct nft_pipapo_scratch * __percpu *scratch;
-	size_t bsize_max;
 	struct rcu_head rcu;
 	struct nft_pipapo_field f[] __counted_by(field_count);
 };
@@ -186,7 +176,8 @@ struct nft_pipapo_elem {
 	struct nft_set_ext	ext;
 };
 
-int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
+int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
+		  unsigned long *dst,
 		  const union nft_pipapo_map_bucket *mt, bool match_only);
 
 /**
-- 
2.43.0

