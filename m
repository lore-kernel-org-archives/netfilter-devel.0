Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F2D33C53F;
	Mon, 25 May 2026 18:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779733815; cv=none; b=pIjBNGQTKUlXa79xgkMBK1LmldjF+xlrAVifGAD78ZZ5HzlWeiAkyiwpzzDNMxG0A6Kvv2l6V4iireD+6AFl20sTosWnx8QTmNabUUaLXlqYbgpb5bSV2FONYLZoa7Ms3muTMefHSaeEKbms5FNbV+uX3mf4wrmTI/k9YXHI/Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779733815; c=relaxed/simple;
	bh=uZukQQjCRqfRvaWuXuJLlPp/ijxp0R1pQMofQARSVeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9+lX6MKtNvAaXzsOOxxE99l4DDdknZ9vxAFKIvlpGj32sYeYx7b6tWvZDj9sLGAu1/7VFFi1GrvhnQifkNkeWOv5vrRCkkAllQoPxBUt3jOeyhioR/QPKmyA/059JdnLv8Z68sXaQ3udwyp6yYapJCz6H5no90P3ruXfKE6/ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3842560826; Mon, 25 May 2026 20:30:11 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 10/11] netfilter: nft_set_pipapo_avx2: restore performance optimization
Date: Mon, 25 May 2026 20:29:23 +0200
Message-ID: <20260525182924.28456-11-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260525182924.28456-1-fw@strlen.de>
References: <20260525182924.28456-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The avx2 lookup routines get the next map index to process passes as a
function argument, but this isn't obvious because it's hidden in the
lookup macro.

Additionally, a recent LLM review pointed out following "bug":
 -------------------------------------------------------------
 >               b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 >               if (last)
 > -                     return b;
 > +                     ret = b;
 >
 >               if (unlikely(ret == -1))
 >                       ret = b / XSAVE_YMM_SIZE;

 Does this change introduce a logic error when last=true and no match is
 found? [..]

 Should this be changed to an else-if structure instead?
 -------------------------------------------------------------

LLM sees a control-flow change, but there is none:

All call sites invoke nft_pipapo_avx2_refill() only when at least one
bit in the map is set, i.e. nft_pipapo_avx2_refill() never returns -1.

Add a runtime debug check that fires if we'd return -1 as additional
documentation and also make the suggested change, code might be easier
to understand this way.

In commit 17a20e09f086 ("netfilter: nft_set: remove one argument from
lookup and update functions") I incorrectly moved the "ret" scope into
the loop.

This has no effect on the correctness, but it can (depending on map sizes)
cause a redundant repeat of an earlier processing step.

Restore the intended 'pass map index' instead of always-0.  Note that I
did not see any change in performance numbers, but Stefano correctly
points out that the existing perf test likely lack a sparse intermediate
bitmap (between fields) with a lot of leading zeroes.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 35 ++++++++++++-----------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index dad265807b8b..b3f105520a85 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -144,6 +144,7 @@ static void nft_pipapo_avx2_fill(unsigned long *data, int start, int len)
  * This is an alternative implementation of pipapo_refill() suitable for usage
  * with AVX2 lookup routines: we know there are four words to be scanned, at
  * a given offset inside the map, for each matching iteration.
+ * The caller must ensure at least one bit in the four words is set.
  *
  * This function doesn't actually use any AVX2 instruction.
  *
@@ -179,6 +180,7 @@ static int nft_pipapo_avx2_refill(int offset, unsigned long *map,
 	NFT_PIPAPO_AVX2_REFILL_ONE_WORD(3);
 #undef NFT_PIPAPO_AVX2_REFILL_ONE_WORD
 
+	DEBUG_NET_WARN_ON_ONCE(ret < 0);
 	return ret;
 }
 
@@ -243,8 +245,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
 			ret = b;
-
-		if (unlikely(ret == -1))
+		else if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
 
 		continue;
@@ -320,8 +321,7 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
 			ret = b;
-
-		if (unlikely(ret == -1))
+		else if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
 
 		continue;
@@ -415,8 +415,7 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
 			ret = b;
-
-		if (unlikely(ret == -1))
+		else if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
 
 		continue;
@@ -506,8 +505,7 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
 			ret = b;
-
-		if (unlikely(ret == -1))
+		else if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
 
 		continue;
@@ -642,8 +640,7 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
 			ret = b;
-
-		if (unlikely(ret == -1))
+		else if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
 
 		continue;
@@ -700,8 +697,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
 			ret = b;
-
-		if (unlikely(ret == -1))
+		else if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
 
 		continue;
@@ -765,8 +761,7 @@ static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
 			ret = b;
-
-		if (unlikely(ret == -1))
+		else if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
 
 		continue;
@@ -840,8 +835,7 @@ static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
 			ret = b;
-
-		if (unlikely(ret == -1))
+		else if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
 
 		continue;
@@ -926,8 +920,7 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
 			ret = b;
-
-		if (unlikely(ret == -1))
+		else if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
 
 		continue;
@@ -1020,8 +1013,7 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
 			ret = b;
-
-		if (unlikely(ret == -1))
+		else if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
 
 		continue;
@@ -1143,6 +1135,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 	const struct nft_pipapo_field *f;
 	unsigned long *res, *fill, *map;
 	bool map_index;
+	int ret = 0;
 	int i;
 
 	scratch = *raw_cpu_ptr(m->scratch);
@@ -1167,8 +1160,8 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 
 	nft_pipapo_for_each_field(f, i, m) {
 		bool last = i == m->field_count - 1, first = !i;
-		int ret = 0;
 
+		/* NB: previous round @ret is passed to avx2 lookup fn */
 #define NFT_SET_PIPAPO_AVX2_LOOKUP(b, n)				\
 		(ret = nft_pipapo_avx2_lookup_##b##b_##n(res, fill, f,	\
 							 ret, data,	\
-- 
2.53.0

