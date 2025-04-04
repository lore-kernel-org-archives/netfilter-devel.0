Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6FF1E9B06
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 13:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773615; cv=none; b=TEzwH9bn0RUGJS4aQ7jE+1T8+bSelBjwWleOAJhU9n3eaLj/YpvJrLt62/Om6planI/fZxonY8I4SrlXML+7NffilcFN93lGQ/KKGFK+lPYFYsd3LwyWtUKdrwLpjD8ICd61ry/UuUNlgbKLxi8vmcXTkbtAklH4XCju8DxgkTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773615; c=relaxed/simple;
	bh=RGb7+uoedjke0rODlXnhhGzreY5rVC4ObjYBcU2p7Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INffY0lR9rKZu2cSHLMjI0MCXu6DLJm9LnmRUaCwCoE4N4//67c+tr2n7tXObgOgZHYfvZsJ1dYDyh08K+1dghJoYlVMACL/XesdQfn8bTjZxvEgLyiIYQuTuxj0fTc1TZH/sh5dO6aheDMnMScj5BmNBtiHXBZ+RinN6dUxaws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u0hAp-00011I-Hh; Fri, 04 Apr 2025 15:33:31 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 1/3] nft_set_pipapo: add avx register usage tracking for NET_DEBUG builds
Date: Fri,  4 Apr 2025 15:32:24 +0200
Message-ID: <20250404133229.12395-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250404133229.12395-1-fw@strlen.de>
References: <20250404133229.12395-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add rudimentary register tracking for avx2 helpers.

A register can have following states:
- mem (contains packet data)
- and (was consumed, value folded into other register)
- tmp (holds result of folding operation)

mem and tmp are mutually exclusive.

Warn if
a) register store happens while register has 'mem' bit set
   but 'and' unset.
   This detects clobbering of a register with new
   packet data before the previous load has been processed.
b) register is read but wasn't written to before
   This detects operations happening on undefined register
   content, such as AND or GOTOs.
c) register is saved to memory, but it doesn't hold result
   of an AND operation.
   This detects erroneous stores to the memory scratch map.
d) register is used for goto, but it doesn't contain result
   of earlier AND operation.

This is disabled for NET_DEBUG=n builds.

v2: Improve kdoc (Stefano Brivio)
    Use u16 (Stefano Brivio)
    Reduce macro usage in favor of inline helpers
    warn if we store register to memory but its not holding
    result of AND operation

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: major changes as per Stefano

 Stores to memory or GOTOs now cause a splat unless the register
 result of AND operation.
 This triggers in 1 case but I think code is fine, I added
 nft_pipapo_avx2_force_tmp() helper and use it in the relevant spot.

 net/netfilter/nft_set_pipapo_avx2.c | 217 ++++++++++++++++++++++++++--
 1 file changed, 203 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index b8d3c3213efe..334d16096d00 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -26,6 +26,160 @@
 
 #define NFT_PIPAPO_LONGS_PER_M256	(XSAVE_YMM_SIZE / BITS_PER_LONG)
 
+/**
+ * struct nft_pipapo_debug_regmap - Bitmaps representing sets of YMM registers
+ *
+ * @mem: n-th bit set if YMM<n> contains packet data loaded from memory
+ * @and: n-th bit set if YMM<n> was folded (AND operation done)
+ * @tmp: n-th bit set if YMM<n> contains folded data (result of AND operation)
+ */
+struct nft_pipapo_debug_regmap {
+#ifdef CONFIG_DEBUG_NET
+	u16 mem;
+	u16 and;
+	u16 tmp;
+#endif
+};
+
+#ifdef CONFIG_DEBUG_NET
+/* YYM15 is used as an always-0-register, see nft_pipapo_avx2_prepare */
+#define NFT_PIPAPO_AVX2_DEBUG_MAP                                       \
+	struct nft_pipapo_debug_regmap __pipapo_debug_regmap = {        \
+		.tmp = BIT(15),                                         \
+	}
+
+#define NFT_PIPAPO_WARN(cond, reg, rmap, line, message)	({			\
+	const struct nft_pipapo_debug_regmap *rm__ = (rmap);			\
+	DEBUG_NET_WARN_ONCE((cond), "reg %d line %u %s, mem %04x, and %04x tmp %04x",\
+		  (reg), (line), (message), rm__->mem, rm__->and, rm__->tmp);	\
+})
+#else /* !CONFIG_DEBUG_NET */
+#define NFT_PIPAPO_AVX2_DEBUG_MAP                                       \
+	struct nft_pipapo_debug_regmap __pipapo_debug_regmap
+#endif
+
+/**
+ * nft_pipapo_avx2_load_packet() - Check and record packet data store
+ *
+ * @reg: Index of register being written to
+ * @r: Current bitmap of registers for debugging purposes
+ * @line: __LINE__ number filled via AVX2 macro
+ *
+ * Mark reg as holding packet data.
+ * Check reg is unused or had an AND operation performed on it.
+ */
+static inline void nft_pipapo_avx2_load_packet(unsigned int reg,
+					       struct nft_pipapo_debug_regmap *r,
+					       unsigned int line)
+{
+#ifdef CONFIG_DEBUG_NET
+	bool used = BIT(reg) & (r->mem | r->tmp);
+	bool anded = BIT(reg) & r->and;
+
+	r->and &= ~BIT(reg);
+	r->tmp &= ~BIT(reg);
+	r->mem |= BIT(reg);
+
+	if (used)
+		NFT_PIPAPO_WARN(!anded, reg, r, line, "busy");
+#endif
+}
+
+/**
+ * nft_pipapo_avx2_force_tmp() - Mark @reg as holding result of AND operation
+ * @reg: Index of register
+ * @r: Current bitmap of registers for debugging purposes
+ *
+ * Mark reg as holding temporary data, no checks are performed.
+ */
+static inline void nft_pipapo_avx2_force_tmp(unsigned int reg,
+					   struct nft_pipapo_debug_regmap *r)
+{
+#ifdef CONFIG_DEBUG_NET
+	r->tmp |= BIT(reg);
+	r->mem &= ~BIT(reg);
+#endif
+}
+
+/**
+ * nft_pipapo_avx2_load_tmp() - Check and record scratchmap restore
+ *
+ * @reg: Index of register being written to
+ * @r: Current bitmap of registers for debugging purposes
+ * @line: __LINE__ number filled via AVX2 macro
+ *
+ * Mark reg as holding temporary data.
+ * Check reg is unused or had an AND operation performed on it.
+ */
+static inline void nft_pipapo_avx2_load_tmp(unsigned int reg,
+					    struct nft_pipapo_debug_regmap *r,
+					    unsigned int line)
+{
+#ifdef CONFIG_DEBUG_NET
+	bool used = BIT(reg) & (r->mem | r->tmp);
+	bool anded = BIT(reg) & r->and;
+
+	r->and &= ~BIT(reg);
+
+	nft_pipapo_avx2_force_tmp(reg, r);
+
+	if (used)
+		NFT_PIPAPO_WARN(!anded, reg, r, line, "busy");
+#endif
+}
+
+/**
+ * nft_pipapo_avx2_debug_and() - Mark registers as being ANDed
+ *
+ * @a: Index of register being written to
+ * @b: Index of first register being ANDed
+ * @c: Index of second register being ANDed
+ * @r: Current bitmap of registers for debugging purposes
+ * @line: __LINE__ number filled via AVX2 macro
+ *
+ * Tags @reg2 and @reg3 as ANDed register
+ * Tags @reg1 as containing AND result
+ */
+static inline void nft_pipapo_avx2_debug_and(unsigned int a, unsigned int b,
+					     unsigned int c,
+					     struct nft_pipapo_debug_regmap *r,
+					     unsigned int line)
+{
+#ifdef CONFIG_DEBUG_NET
+	bool b_and = BIT(b) & r->and;
+	bool c_and = BIT(c) & r->and;
+	bool b_tmp = BIT(b) & r->tmp;
+	bool c_tmp = BIT(c) & r->tmp;
+	bool b_mem = BIT(b) & r->mem;
+	bool c_mem = BIT(c) & r->mem;
+
+	r->and |= BIT(b);
+	r->and |= BIT(c);
+
+	nft_pipapo_avx2_force_tmp(a, r);
+
+	NFT_PIPAPO_WARN((!b_mem && !b_and && !b_tmp), b, r, line, "unused");
+	NFT_PIPAPO_WARN((!c_mem && !c_and && !c_tmp), c, r, line, "unused");
+#endif
+}
+
+/**
+ * nft_pipapo_avx2_reg_tmp() - Check that @reg holds result of AND operation
+ * @reg: Index of register
+ * @r: Current bitmap of registers for debugging purposes
+ * @line: __LINE__ number filled via AVX2 macro
+ */
+static inline void nft_pipapo_avx2_reg_tmp(unsigned int reg,
+					   const struct nft_pipapo_debug_regmap *r,
+					   unsigned int line)
+{
+#ifdef CONFIG_DEBUG_NET
+	bool holds_and_result = BIT(reg) & r->tmp;
+
+        NFT_PIPAPO_WARN(!holds_and_result, reg, r, line, "unused");
+#endif
+}
+
 /* Load from memory into YMM register with non-temporal hint ("stream load"),
  * that is, don't fetch lines from memory into the cache. This avoids pushing
  * precious packet data out of the cache hierarchy, and is appropriate when:
@@ -36,36 +190,60 @@
  * - loading the result bitmap from the previous field, as it's never used
  *   again
  */
-#define NFT_PIPAPO_AVX2_LOAD(reg, loc)					\
-	asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc))
+#define __NFT_PIPAPO_AVX2_LOAD(reg, loc)				\
+	asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc));		\
+
+#define NFT_PIPAPO_AVX2_LOAD(reg, loc) do {				\
+	nft_pipapo_avx2_load_tmp(reg,					\
+				 &__pipapo_debug_regmap, __LINE__);	\
+	__NFT_PIPAPO_AVX2_LOAD(reg, loc);				\
+} while (0)
 
 /* Stream a single lookup table bucket into YMM register given lookup table,
  * group index, value of packet bits, bucket size.
  */
-#define NFT_PIPAPO_AVX2_BUCKET_LOAD4(reg, lt, group, v, bsize)		\
-	NFT_PIPAPO_AVX2_LOAD(reg,					\
-			     lt[((group) * NFT_PIPAPO_BUCKETS(4) +	\
-				 (v)) * (bsize)])
-#define NFT_PIPAPO_AVX2_BUCKET_LOAD8(reg, lt, group, v, bsize)		\
-	NFT_PIPAPO_AVX2_LOAD(reg,					\
-			     lt[((group) * NFT_PIPAPO_BUCKETS(8) +	\
-				 (v)) * (bsize)])
+#define NFT_PIPAPO_AVX2_BUCKET_LOAD4(reg, lt, group, v, bsize) do {	\
+	nft_pipapo_avx2_load_packet(reg,				\
+				    &__pipapo_debug_regmap, __LINE__);	\
+	__NFT_PIPAPO_AVX2_LOAD(reg,					\
+			       lt[((group) * NFT_PIPAPO_BUCKETS(4) +	\
+			       (v)) * (bsize)]);			\
+} while (0)
+
+#define NFT_PIPAPO_AVX2_BUCKET_LOAD8(reg, lt, group, v, bsize) do {	\
+	nft_pipapo_avx2_load_packet(reg,				\
+				    &__pipapo_debug_regmap, __LINE__);	\
+	__NFT_PIPAPO_AVX2_LOAD(reg,					\
+			       lt[((group) * NFT_PIPAPO_BUCKETS(8) +	\
+			       (v)) * (bsize)])				\
+} while (0)
 
 /* Bitwise AND: the staple operation of this algorithm */
 #define NFT_PIPAPO_AVX2_AND(dst, a, b)					\
-	asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst)
+do {									\
+	BUILD_BUG_ON(a == b);						\
+	asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst);	\
+	nft_pipapo_avx2_debug_and(dst, a, b,				\
+				  &__pipapo_debug_regmap, __LINE__);	\
+} while (0)
 
 /* Jump to label if @reg is zero */
 #define NFT_PIPAPO_AVX2_NOMATCH_GOTO(reg, label)			\
-	asm goto("vptest %%ymm" #reg ", %%ymm" #reg ";"	\
-			  "je %l[" #label "]" : : : : label)
+do {									\
+	nft_pipapo_avx2_reg_tmp(reg, &__pipapo_debug_regmap, __LINE__);	\
+	asm goto("vptest %%ymm" #reg ", %%ymm" #reg ";"			\
+			  "je %l[" #label "]" : : : : label);		\
+} while (0)
 
 /* Store 256 bits from YMM register into memory. Contrary to bucket load
  * operation, we don't bypass the cache here, as stored matching results
  * are always used shortly after.
  */
 #define NFT_PIPAPO_AVX2_STORE(loc, reg)					\
-	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (loc))
+do {									\
+	nft_pipapo_avx2_reg_tmp(reg, &__pipapo_debug_regmap, __LINE__);	\
+	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (loc));		\
+} while (0)
 
 /* Zero out a complete YMM register, @reg */
 #define NFT_PIPAPO_AVX2_ZERO(reg)					\
@@ -219,6 +397,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	u8 pg[2] = { pkt[0] >> 4, pkt[0] & 0xf };
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -282,6 +461,7 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	u8 pg[4] = { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf };
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -361,6 +541,7 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
 		   };
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -458,6 +639,7 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
 		    };
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -553,6 +735,7 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
 		    };
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -680,6 +863,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -687,6 +871,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
 
 		if (first) {
 			NFT_PIPAPO_AVX2_BUCKET_LOAD8(2, lt, 0, pkt[0], bsize);
+			nft_pipapo_avx2_force_tmp(2, &__pipapo_debug_regmap);
 		} else {
 			NFT_PIPAPO_AVX2_BUCKET_LOAD8(0, lt, 0, pkt[0], bsize);
 			NFT_PIPAPO_AVX2_LOAD(1, map[i_ul]);
@@ -738,6 +923,7 @@ static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -803,6 +989,7 @@ static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -879,6 +1066,7 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -965,6 +1153,7 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
-- 
2.49.0

