Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A0F27D769
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2025 10:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744279505; cv=none; b=rfzTuw60NmslwmkHHMeKMm+Lj6yW+75/vX1nkuqKQLIyQxxDOGCBimGimo/MfDMiCpFTCdGL5VooesIDA1JpCLuw/QHoEm/ZSg1uLZr8twN9gXW46ofR+RSFBJUv26MLzwIb8Cxuw9Aw1ZTYhbB/cPrVypJQTccRcAHFOBuGVkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744279505; c=relaxed/simple;
	bh=qzr9uSi5eSdOLTpx/bwsFLX24vAMbsNYyHbT8VbUCE0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tzRkt+Gbl2hoCf4swy4w3H3xf6H7tTqHLpnvPZSD2XDGOQRX4ahY94QMzuTb+glrHgiLbD6buMwarLPT40h3FlDsqsN/bKPnfYTAZv47CDcTwX0SqN5YPXZ6cz6WHEJiVel552TmltN31IsqsX5kTxuLrdrgfxrNpmSG36uNhGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WDII11HU; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vrz/qPwt; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WDII11HU";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vrz/qPwt"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id AC9306068A; Thu, 10 Apr 2025 12:05:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744279500;
	bh=dgmYYosSQMFEw0xc2NO2xEj7X3ohNOD85Lg/tFb4HqY=;
	h=From:To:Cc:Subject:Date:From;
	b=WDII11HUMQ+172Hf3GEVwyYU7VkkviKO218bLO4ohbFq9IhyC1CpFF3SsYTVq8XME
	 EZp9gXhaZ23Iz9lAacdt4pEgU9v08a6Jb4HQJEKclDSoYHLB1qDaTMObe3FiyBIgZe
	 BA8szrUZN6dh0dDJnaVSMaVUJv6GntCbqiISRUOUTeWvVCzRfkxzKOZUhGaMI4g1dU
	 pzcSgSxrdeDpg/IwNhK7YGEnc/pXIokluUwZQLy9xZ9ZrsEK9wDlDiPhEwu31mV/VD
	 Tw2Z29R343wqMS8Qlsw3w0LORY47hUh8OLRm1VzdGDPKtSpnV9fpZmQTRlwsvgyVA7
	 2LUrD1VnM9X+Q==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 91C5260681;
	Thu, 10 Apr 2025 12:04:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744279499;
	bh=dgmYYosSQMFEw0xc2NO2xEj7X3ohNOD85Lg/tFb4HqY=;
	h=From:To:Cc:Subject:Date:From;
	b=vrz/qPwt207cP3q6vA+maTyTFxvUoca4ir0Q5zb3SQVI+RI0BcL8xFiLoGnFotkAl
	 5yhUuXrx0giRFDSWPGljjPAx7bzeZ0Mq/MH2M2fu/XgHpzxvqh8OpwFB0wKwdLeylB
	 VyNOeRW+VuA4EZmLpueE97qS5xYbl2w/aCknECbGCv6HZZ0ibrZsdkLempwgjf5sBA
	 Vqa9XmoVc3geZpnTPJY2TjxvjIFTW5QIAjxsZE263NNn01Sm2auoN9vG+iZB/meej7
	 GK+KSpc/rL/IBjMxKxfsrKZkzjDWCU9HiM8EFGJ79GrKCstJ8rWYCQg3oCDbW/0akW
	 Yq7713pM8v1HA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	sbrivio@redhat.com
Subject: [PATCH nf-next,v2 1/2] netfilter: nft_set_pipapo: prevent overflow in lookup table allocation
Date: Thu, 10 Apr 2025 12:04:55 +0200
Message-Id: <20250410100456.1029111-1-pablo@netfilter.org>
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

While at it, replace leftover allocation using the GFP_KERNEL to
GFP_KERNEL_ACCOUNT for consistency, in pipapo_resize().

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: detach chunk to ensure allocation below INT_MAX.

 net/netfilter/nft_set_pipapo.c | 48 +++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7be342b495f5..1b5c498468c5 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -683,6 +683,22 @@ static int pipapo_realloc_mt(struct nft_pipapo_field *f,
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
@@ -701,6 +717,7 @@ static int pipapo_resize(struct nft_pipapo_field *f,
 	long *new_lt = NULL, *new_p, *old_lt = f->lt, *old_p;
 	unsigned int new_bucket_size, copy;
 	int group, bucket, err;
+	size_t lt_size;
 
 	if (rules >= NFT_PIPAPO_RULE0_MAX)
 		return -ENOSPC;
@@ -719,10 +736,11 @@ static int pipapo_resize(struct nft_pipapo_field *f,
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
 
@@ -917,15 +935,17 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
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
@@ -936,7 +956,7 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 		return;
 	}
 
-	new_lt = kvzalloc(lt_size + NFT_PIPAPO_ALIGN_HEADROOM, GFP_KERNEL_ACCOUNT);
+	new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
 	if (!new_lt)
 		return;
 
@@ -1451,13 +1471,15 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 
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
 
-- 
2.30.2

