Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE0A2E62B3
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 06:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743747736; cv=none; b=Y5vleTTliKHlUIoXUhIV9ERq3L6yyW9BaTZb+smRu9Inq6HvX6kB7vpPT86SBNTP4q024CE9Ns/Ki7JwvBMTD/ch7oXEcdxOCzmtcrTfIg7XXohuhmJ4eMg3/WSa7ydZ3+Uf2AtQqH6pe8YBz+ddRhx3RO4QwpDjTGDp2TM4KCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743747736; c=relaxed/simple;
	bh=9AOI8hlzeqf2DX2XAkuUq+i62lsfu7TlYm08h4ev1+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tb7H690TtSOzjICiPdqXDZBEbmyt5sm1WCAM8q7Yy+TqBanuEVFYlJ4ZJETjkcKBG5b3AVkAcY64L5FKVywSSkUEf3e6p43f2HHqz2PCI8oew6ZGgmavgODYtuiE5jCOz0k4YXFcwdkjA3XgOdKTVBl6mkKe/vo2EkPb1vCX1ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u0aRP-0005ub-RR; Fri, 04 Apr 2025 08:22:11 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sontu21@gmail.com,
	sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/3] nft_set_pipapo: add avx register usage tracking for NET_DEBUG builds
Date: Fri,  4 Apr 2025 08:20:52 +0200
Message-ID: <20250404062105.4285-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250404062105.4285-1-fw@strlen.de>
References: <20250404062105.4285-1-fw@strlen.de>
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

Warn if
a) register store happens while register has 'mem' bit set
   but 'and' unset
b) register is examined but wasn't written to
c) register is folded into another register but wasn't written to

This is off unless NET_DEBUG=y is set.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 136 +++++++++++++++++++++++++++-
 1 file changed, 131 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index b8d3c3213efe..8ce7154b678a 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -26,6 +26,109 @@
 
 #define NFT_PIPAPO_LONGS_PER_M256	(XSAVE_YMM_SIZE / BITS_PER_LONG)
 
+#if defined(CONFIG_DEBUG_NET)
+struct nft_pipapo_debug_regmap {
+	unsigned long mem;			/* register store: reg := mem (packet data) */
+	unsigned long and;			/* register used as and operator */
+	unsigned long tmp;			/* register used as and destination */
+};
+
+/* yym15 is used as an always-0-register, see nft_pipapo_avx2_prepare */
+#define	NFT_PIPAPO_AVX2_DEBUG_MAP	struct nft_pipapo_debug_regmap __pipapo_debug_regmap = { .mem = 1 << 15 }
+
+#define NFT_PIPAPO_WARN(cond, reg, message)						\
+	DEBUG_NET_WARN_ONCE((cond), "reg %d %s, mem %08lx, and %08lx tmp %08lx",	\
+		  (reg), (message), __pipapo_debug_regmap.mem, __pipapo_debug_regmap.and, __pipapo_debug_regmap.tmp)
+
+/**
+ * nft_pipapo_avx2_debug_load() - record a store to reg
+ *
+ * @reg: the register being written to
+ *
+ * Return: true if splat needs to be triggered
+ */
+static inline bool nft_pipapo_avx2_debug_load(unsigned int reg,
+					      struct nft_pipapo_debug_regmap *r)
+{
+	bool anded, used, tmp;
+
+	anded = test_bit(reg, &r->and);
+	used = test_bit(reg, &r->mem);
+	tmp = test_bit(reg, &r->tmp);
+
+	anded = test_and_clear_bit(reg, &r->and);
+	tmp = test_and_clear_bit(reg, &r->tmp);
+	used = test_and_set_bit(reg, &r->mem);
+
+	if (!used) /* Not used -> ok, no warning needs to be emitted. */
+		return false;
+
+	/* Register is clobbered, Warning needs to be emitted if it wasn't AND'ed */
+	return !anded;
+}
+
+/**
+ * nft_pipapo_avx2_debug_and() - mark registers as being ANDed
+ *
+ * @reg1: the register being written to
+ * @reg2: the first register being anded
+ * @reg3: the second register being anded
+ *
+ * Tags @reg2 and @reg3 as ANDed register
+ * Tags @reg1 as containing AND result
+ *
+ * Return: true if splat needs to be triggered
+ */
+static inline bool nft_pipapo_avx2_debug_and(unsigned int reg1, unsigned int reg2,
+					     unsigned int reg3,
+					     struct nft_pipapo_debug_regmap *r)
+{
+	bool r2_and = test_and_set_bit(reg2, &r->and);
+	bool r3_and = test_and_set_bit(reg3, &r->and);
+	bool r2_tmp = test_and_set_bit(reg2, &r->tmp);
+	bool r3_tmp = test_and_set_bit(reg3, &r->tmp);
+	bool r2_mem = test_bit(reg2, &r->mem);
+	bool r3_mem = test_bit(reg3, &r->mem);
+
+	clear_bit(reg1, &r->mem);
+	set_bit(reg1, &r->tmp);
+
+	return (!r2_mem && !r2_and && !r2_tmp) || (!r3_mem && !r3_and && !r3_tmp);
+}
+
+/* saw a load, ok if register hasn't been used (mem bit not set)
+ * or if the register was anded to another register (mem_and is set).
+ */
+#define	NFT_PIPAPO_AVX2_SAW_LOAD(reg)	({	\
+	unsigned int r__ = (reg);		\
+	NFT_PIPAPO_WARN(nft_pipapo_avx2_debug_load(r__, &__pipapo_debug_regmap), r__, "busy");\
+})
+
+static inline bool nft_pipapo_avx2_debug_usable(unsigned int reg,
+						const struct nft_pipapo_debug_regmap *r)
+{
+	unsigned long u = r->mem | r->and | r->tmp;
+
+	return !test_bit(reg, &u);
+}
+
+#define NFT_PIPAPO_AVX2_USABLE(reg) ({			\
+	unsigned int r__ = (reg);			\
+	NFT_PIPAPO_WARN(nft_pipapo_avx2_debug_usable(r__, &__pipapo_debug_regmap), r__, "undef");\
+})
+
+#define NFT_PIPAPO_AVX2_AND_DEBUG(dst, a, b) ({		\
+	unsigned int r__ = (dst);			\
+	NFT_PIPAPO_WARN(nft_pipapo_avx2_debug_and(r__, (a), (b), &__pipapo_debug_regmap), r__, "invalid sreg");\
+})
+
+#else
+#define	NFT_PIPAPO_AVX2_SAW_LOAD(reg)		BUILD_BUG_ON_INVALID(reg)
+#define	NFT_PIPAPO_AVX2_USABLE(reg)		BUILD_BUG_ON_INVALID(reg)
+#define NFT_PIPAPO_AVX2_AND_DEBUG(dst, a, b)	BUILD_BUG_ON_INVALID((dst) | (a) | (b))
+#define	NFT_PIPAPO_AVX2_DEBUG_MAP		do { } while (0)
+#endif
+
 /* Load from memory into YMM register with non-temporal hint ("stream load"),
  * that is, don't fetch lines from memory into the cache. This avoids pushing
  * precious packet data out of the cache hierarchy, and is appropriate when:
@@ -37,7 +140,10 @@
  *   again
  */
 #define NFT_PIPAPO_AVX2_LOAD(reg, loc)					\
-	asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc))
+do {									\
+	asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc));		\
+	NFT_PIPAPO_AVX2_SAW_LOAD(reg);					\
+} while (0)
 
 /* Stream a single lookup table bucket into YMM register given lookup table,
  * group index, value of packet bits, bucket size.
@@ -53,19 +159,29 @@
 
 /* Bitwise AND: the staple operation of this algorithm */
 #define NFT_PIPAPO_AVX2_AND(dst, a, b)					\
-	asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst)
+do {									\
+	BUILD_BUG_ON(a == b);						\
+	asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst);	\
+	NFT_PIPAPO_AVX2_AND_DEBUG(dst, a, b);				\
+} while (0)
 
 /* Jump to label if @reg is zero */
 #define NFT_PIPAPO_AVX2_NOMATCH_GOTO(reg, label)			\
-	asm goto("vptest %%ymm" #reg ", %%ymm" #reg ";"	\
-			  "je %l[" #label "]" : : : : label)
+do {									\
+	NFT_PIPAPO_AVX2_USABLE(reg);					\
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
+	NFT_PIPAPO_AVX2_USABLE(reg);					\
+	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (loc));		\
+} while (0)
 
 /* Zero out a complete YMM register, @reg */
 #define NFT_PIPAPO_AVX2_ZERO(reg)					\
@@ -219,6 +335,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	u8 pg[2] = { pkt[0] >> 4, pkt[0] & 0xf };
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -282,6 +399,7 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	u8 pg[4] = { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf };
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -361,6 +479,7 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
 		   };
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -458,6 +577,7 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
 		    };
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -553,6 +673,7 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
 		    };
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -680,6 +801,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -738,6 +860,7 @@ static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -803,6 +926,7 @@ static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -879,6 +1003,7 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
@@ -965,6 +1090,7 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
+	NFT_PIPAPO_AVX2_DEBUG_MAP;
 
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
-- 
2.49.0

