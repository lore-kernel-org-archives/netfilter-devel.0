Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E8326A0C8
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2025 09:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744278154; cv=none; b=p9wI6a2D/zx9fBX3yxYoHHI48YjQ4SGTb+IJiMxDFUdiqZ78csq41Pb9lnULcm4PkIVdqdCT57GfWCNLWDT5/Cu7n8+8JSHENecJ4ZH5ZwX6m/aZ6Hc8IfGyqRTfHGjU48QVczrJTBpd+kDeXhRhrJeWgJCz/l4MkusR9c/plsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744278154; c=relaxed/simple;
	bh=8Oi8QpBMvVteWVJ1mFi2luH7eRg81XzblFGd15nGR+8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LUz7Tq834OgXkrPHnCiTczQ9Aur57Y905T9cycKdtWz0axYfmGll8nOwaziMZCIgxJ0p0CYcgESKrkDTbJMvLFeJlOQC1K11iU8BKL8atrB9zhwnXR0VFbbVSQIN5Lc7GQevKVeVZgth6IoF0xBFGqa6EwOuVe17mUezAmRqsHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=quYPNf9a; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LFas4/4z; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="quYPNf9a";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LFas4/4z"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D70AE6069B; Thu, 10 Apr 2025 11:42:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744278140;
	bh=7yE4m9kvDfkOTqYSuNA59afo9UQ75O99xPSB6dH6xeI=;
	h=From:To:Cc:Subject:Date:From;
	b=quYPNf9a6qw7EBiLGpn1MrPfmO6vlj9rdBek4+iyfuxE+Fp9EH5Mi9LffhgjpkD0U
	 DNivPhKPiNQcofy7ebZhY6x7PgoFlYR8+rSH4NYUrq9fIXLMwCffXD3gi/AIje7WGp
	 tpQLuaCSpzB+tpl1f4HSkUhzPHEnAW35RRfe9JTnkfAYkR0FtqVLyCIpdXDmu7NK35
	 Nflzz9utMcmvhdDoFQiFPw3R+kCgKt7Had9kYySdi+3SN5a6IxF7lhSJocIWgOiUiB
	 UgVZDib8Abnkfuv0Im83O4cNnDRF/qzCD7kjd23lRmtXkr8lwPixT9cTwR9Ar6fK3c
	 hI3/IEcW6AWFg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9EA0160630;
	Thu, 10 Apr 2025 11:42:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744278139;
	bh=7yE4m9kvDfkOTqYSuNA59afo9UQ75O99xPSB6dH6xeI=;
	h=From:To:Cc:Subject:Date:From;
	b=LFas4/4z65H/ZHohq8wZYVBGiAbhA5N3so+1kjn1/WmaK3bdQhMIFHW7Qzp7nHugi
	 6OIS8nGlT8i0FWfRWQ4MTiSgOJ+GvmdysZlcZStk9Xdi66QcT9OivpfIzIrISmJq+l
	 RGmRmHFIZGQmL0Y2VKyqW60t+8DEO+oVTFYYRmeT4JfSAe3Qck5FGO2vRkWAYni7Cy
	 jZvCc2oq4L73f+/027OvU/fKUxULvOsv+uUgv7jr7W1kTw7viI2J7m7dvYaiBXBsDQ
	 /IVj9Ev8h4f2g2lrvA24mf/UM9jmojHizEluVwsbAXTWw3dEjetFp6/g4HggoqkGOQ
	 1JzvXY4JO17uw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	sbrivio@redhat.com
Subject: [PATCH nf-next] netfilter: nft_set_pipapo: prevent overflow in allocations
Date: Thu, 10 Apr 2025 11:42:15 +0200
Message-Id: <20250410094215.1027962-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When calculating the lookup table size, ensure the following
multiplication does not overflow:

- desc->field_len[] maximum value is U8_MAX multiplied by
  NFT_PIPAPO_GROUPS_PER_BYTE(f) that can be 2, worst case.
- NFT_PIPAPO_BUCKETS(f->bb) is 2^8, worst case.
- sizeof(unsigned long), from sizeof(*f->lt), lt in
  struct nft_pipapo_field.

Then, use check_mul_overflow() to multiply by bucket size and then use
check_add_overflow() to the alignment for avx2 (if needed). Finally, add
lt_size_check_overflow() helper and use it to consolidate this.

Check for overflows when calculating the size of the map bucket too in
struct nft_pipapo_field.

While at it, replace leftover allocation using the GFP_KERNEL to
GFP_KERNEL_ACCOUNT for consistency, in pipapo_resize().

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I can route this through nf.git if preferred.

 net/netfilter/nft_set_pipapo.c | 54 ++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7be342b495f5..ffb8c3623a93 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -663,6 +663,9 @@ static int pipapo_realloc_mt(struct nft_pipapo_field *f,
 	    check_add_overflow(rules, extra, &rules_alloc))
 		return -EOVERFLOW;
 
+	if (rules_alloc > (INT_MAX / sizeof(*new_mt)))
+		return -ENOMEM;
+
 	new_mt = kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL_ACCOUNT);
 	if (!new_mt)
 		return -ENOMEM;
@@ -683,6 +686,22 @@ static int pipapo_realloc_mt(struct nft_pipapo_field *f,
 	return 0;
 }
 
+static bool lt_size_check_overflow(unsigned int groups, unsigned int bb,
+				   unsigned int bsize, size_t size,
+				   size_t *lt_size)
+{
+	*lt_size = groups * NFT_PIPAPO_BUCKETS(bb) * size;
+
+	if (check_mul_overflow(*lt_size, bsize, lt_size))
+		return true;
+	if (check_add_overflow(*lt_size, NFT_PIPAPO_ALIGN_HEADROOM, lt_size))
+		return true;
+	if (*lt_size > INT_MAX)
+		return true;
+
+	return false;
+}
+
 /**
  * pipapo_resize() - Resize lookup or mapping table, or both
  * @f:		Field containing lookup and mapping tables
@@ -701,6 +720,7 @@ static int pipapo_resize(struct nft_pipapo_field *f,
 	long *new_lt = NULL, *new_p, *old_lt = f->lt, *old_p;
 	unsigned int new_bucket_size, copy;
 	int group, bucket, err;
+	size_t lt_size;
 
 	if (rules >= NFT_PIPAPO_RULE0_MAX)
 		return -ENOSPC;
@@ -719,10 +739,11 @@ static int pipapo_resize(struct nft_pipapo_field *f,
 	else
 		copy = new_bucket_size;
 
-	new_lt = kvzalloc(f->groups * NFT_PIPAPO_BUCKETS(f->bb) *
-			  new_bucket_size * sizeof(*new_lt) +
-			  NFT_PIPAPO_ALIGN_HEADROOM,
-			  GFP_KERNEL);
+	if (lt_size_check_overflow(f->groups, f->bb, new_bucket_size,
+				   sizeof(*new_lt), &lt_size))
+		return -ENOMEM;
+
+	new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
 	if (!new_lt)
 		return -ENOMEM;
 
@@ -917,15 +938,17 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 		groups = f->groups * 2;
 		bb = NFT_PIPAPO_GROUP_BITS_LARGE_SET;
 
-		lt_size = groups * NFT_PIPAPO_BUCKETS(bb) * f->bsize *
-			  sizeof(*f->lt);
+		if (lt_size_check_overflow(groups, bb, f->bsize,
+					   sizeof(*f->lt), &lt_size))
+			return;
 	} else if (f->bb == NFT_PIPAPO_GROUP_BITS_LARGE_SET &&
 		   lt_size < NFT_PIPAPO_LT_SIZE_LOW) {
 		groups = f->groups / 2;
 		bb = NFT_PIPAPO_GROUP_BITS_SMALL_SET;
 
-		lt_size = groups * NFT_PIPAPO_BUCKETS(bb) * f->bsize *
-			  sizeof(*f->lt);
+		if (lt_size_check_overflow(groups, bb, f->bsize,
+					   sizeof(*f->lt), &lt_size))
+			return;
 
 		/* Don't increase group width if the resulting lookup table size
 		 * would exceed the upper size threshold for a "small" set.
@@ -936,7 +959,7 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 		return;
 	}
 
-	new_lt = kvzalloc(lt_size + NFT_PIPAPO_ALIGN_HEADROOM, GFP_KERNEL_ACCOUNT);
+	new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
 	if (!new_lt)
 		return;
 
@@ -1451,13 +1474,15 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 
 	for (i = 0; i < old->field_count; i++) {
 		unsigned long *new_lt;
+		size_t lt_size;
 
 		memcpy(dst, src, offsetof(struct nft_pipapo_field, lt));
 
-		new_lt = kvzalloc(src->groups * NFT_PIPAPO_BUCKETS(src->bb) *
-				  src->bsize * sizeof(*dst->lt) +
-				  NFT_PIPAPO_ALIGN_HEADROOM,
-				  GFP_KERNEL_ACCOUNT);
+		if (lt_size_check_overflow(src->groups, src->bb, src->bsize,
+					   sizeof(*dst->lt), &lt_size))
+			goto out_lt;
+
+		new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
 		if (!new_lt)
 			goto out_lt;
 
@@ -1469,6 +1494,9 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
 		if (src->rules > 0) {
+			if (src->rules_alloc > (INT_MAX / sizeof(*src->mt)))
+				goto out_mt;
+
 			dst->mt = kvmalloc_array(src->rules_alloc,
 						 sizeof(*src->mt),
 						 GFP_KERNEL_ACCOUNT);
-- 
2.30.2

