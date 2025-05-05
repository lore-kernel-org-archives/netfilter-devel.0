Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A84A30C1EB;
	Mon,  5 May 2025 23:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746488533; cv=none; b=E3pNJ89M9+NRebEwv0g21iBoY28Ry4oAhp4wa53F8OzVVBX45sr5+v8mlxPHumb/24AcgFbwTr/+ArCZcdu1XcJmbdPO9diDLcp5/86DDB6ozWx83EJktrICog09jROVB2f1cpjZNk/Lng16NcFZqn5KHYB+rFZkwdC9CCz42wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746488533; c=relaxed/simple;
	bh=EFTRLRjwpBgNLtTNjIEWrilqYxjqnsGKjQ+o+P8hHtE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PGeXg+tt2SHn5jcoWGSliHgGCswYZHXgVioFyiGe3WzfxI7llf38xXYPg6cfoCFIKrCOWhTsSNBoSXdR6YjblLGid9qkDQeX8ywscjXMs++ZaZ+ParAEftZBToYg9iI7ItxDariX6FuTE4utGMQM2HLp/KvPampALMzxPWbi4h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Pg2O77xA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SnRAT2rA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Pg2O77xA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SnRAT2rA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CEE2A6065D; Tue,  6 May 2025 01:42:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488528;
	bh=LlI6nAsm5pW1gJVJCXsytPjMeoNq4AGK7ipClh+oORs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pg2O77xAflYii3Q++PZbXvwRP+75YUuXzBeskpBiW0k6tsx+FWbd9t4W/Tef8sIpR
	 +/+TKhL7Ei+0mlYKadAn66EgSwWZtwlG3LyYbua7q17aXaE+SlGzOSIibBnmSYTpB4
	 wtOdZZTsXkLfHkJWSzjXmITBXnqpKDP0/LNsPbrxaIBK57Pgn+OEmzUaS+qFNKKiMW
	 9RPBUab1GnfydTdIC+ZjR/7tiDLxuQGgiddmoTBzc4UrSyzhfBdbP2wm+8etSOxtv4
	 fK+8CwYmsxJHL0GkSiemD1rGNs6TRUqMHJsy4Ef8YuH+cPxylFjiof8iJ4dSywJRpw
	 eDxJzD5vylHZg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B360660655;
	Tue,  6 May 2025 01:41:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488520;
	bh=LlI6nAsm5pW1gJVJCXsytPjMeoNq4AGK7ipClh+oORs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnRAT2rAM3lkshAxsIV4qqrgqKVKfiJSXEry9ajWMMUvIA4/V7YR5mx/4VqftuVO2
	 dGJaJceZtZqJUPhYo7bXjPWLlSIyppMMwmFZ/N6xSj6OY6JLkNGEPIoLQ4u+6ocHNb
	 XX830jQBnqh7wDA9AoGw9GCf42wGDNBc+gzCoeDiIR6zYd+ujBxp9jNvvUhhZToh5U
	 ZvRcKDlWUArgT7y6Gi+Y2XoU+YlRyGJYeTfv3QrUGTnmkCFIG180WNu9tWhSIcpNHd
	 18oxwQ6aiqoRMqzPtwmmmf3Ewq6HmACwYugRQ9992pyNKTvpKnFTF7ENz9dEli01Ft
	 YcOrGVo1BynnQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH nf-next 5/7] netfilter: nft_set_pipapo: prevent overflow in lookup table allocation
Date: Tue,  6 May 2025 01:41:49 +0200
Message-Id: <20250505234151.228057-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250505234151.228057-1-pablo@netfilter.org>
References: <20250505234151.228057-1-pablo@netfilter.org>
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
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 58 ++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7be342b495f5..0529e4ef7520 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -683,6 +683,30 @@ static int pipapo_realloc_mt(struct nft_pipapo_field *f,
 	return 0;
 }
 
+
+/**
+ * lt_calculate_size() - Get storage size for lookup table with overflow check
+ * @groups:	Amount of bit groups
+ * @bb:		Number of bits grouped together in lookup table buckets
+ * @bsize:	Size of each bucket in lookup table, in longs
+ *
+ * Return: allocation size including alignment overhead, negative on overflow
+ */
+static ssize_t lt_calculate_size(unsigned int groups, unsigned int bb,
+				 unsigned int bsize)
+{
+	ssize_t ret = groups * NFT_PIPAPO_BUCKETS(bb) * sizeof(long);
+
+	if (check_mul_overflow(ret, bsize, &ret))
+		return -1;
+	if (check_add_overflow(ret, NFT_PIPAPO_ALIGN_HEADROOM, &ret))
+		return -1;
+	if (ret > INT_MAX)
+		return -1;
+
+	return ret;
+}
+
 /**
  * pipapo_resize() - Resize lookup or mapping table, or both
  * @f:		Field containing lookup and mapping tables
@@ -701,6 +725,7 @@ static int pipapo_resize(struct nft_pipapo_field *f,
 	long *new_lt = NULL, *new_p, *old_lt = f->lt, *old_p;
 	unsigned int new_bucket_size, copy;
 	int group, bucket, err;
+	ssize_t lt_size;
 
 	if (rules >= NFT_PIPAPO_RULE0_MAX)
 		return -ENOSPC;
@@ -719,10 +744,11 @@ static int pipapo_resize(struct nft_pipapo_field *f,
 	else
 		copy = new_bucket_size;
 
-	new_lt = kvzalloc(f->groups * NFT_PIPAPO_BUCKETS(f->bb) *
-			  new_bucket_size * sizeof(*new_lt) +
-			  NFT_PIPAPO_ALIGN_HEADROOM,
-			  GFP_KERNEL);
+	lt_size = lt_calculate_size(f->groups, f->bb, new_bucket_size);
+	if (lt_size < 0)
+		return -ENOMEM;
+
+	new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
 	if (!new_lt)
 		return -ENOMEM;
 
@@ -907,7 +933,7 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 {
 	unsigned int groups, bb;
 	unsigned long *new_lt;
-	size_t lt_size;
+	ssize_t lt_size;
 
 	lt_size = f->groups * NFT_PIPAPO_BUCKETS(f->bb) * f->bsize *
 		  sizeof(*f->lt);
@@ -917,15 +943,17 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 		groups = f->groups * 2;
 		bb = NFT_PIPAPO_GROUP_BITS_LARGE_SET;
 
-		lt_size = groups * NFT_PIPAPO_BUCKETS(bb) * f->bsize *
-			  sizeof(*f->lt);
+		lt_size = lt_calculate_size(groups, bb, f->bsize);
+		if (lt_size < 0)
+			return;
 	} else if (f->bb == NFT_PIPAPO_GROUP_BITS_LARGE_SET &&
 		   lt_size < NFT_PIPAPO_LT_SIZE_LOW) {
 		groups = f->groups / 2;
 		bb = NFT_PIPAPO_GROUP_BITS_SMALL_SET;
 
-		lt_size = groups * NFT_PIPAPO_BUCKETS(bb) * f->bsize *
-			  sizeof(*f->lt);
+		lt_size = lt_calculate_size(groups, bb, f->bsize);
+		if (lt_size < 0)
+			return;
 
 		/* Don't increase group width if the resulting lookup table size
 		 * would exceed the upper size threshold for a "small" set.
@@ -936,7 +964,7 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 		return;
 	}
 
-	new_lt = kvzalloc(lt_size + NFT_PIPAPO_ALIGN_HEADROOM, GFP_KERNEL_ACCOUNT);
+	new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
 	if (!new_lt)
 		return;
 
@@ -1451,13 +1479,15 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 
 	for (i = 0; i < old->field_count; i++) {
 		unsigned long *new_lt;
+		ssize_t lt_size;
 
 		memcpy(dst, src, offsetof(struct nft_pipapo_field, lt));
 
-		new_lt = kvzalloc(src->groups * NFT_PIPAPO_BUCKETS(src->bb) *
-				  src->bsize * sizeof(*dst->lt) +
-				  NFT_PIPAPO_ALIGN_HEADROOM,
-				  GFP_KERNEL_ACCOUNT);
+		lt_size = lt_calculate_size(src->groups, src->bb, src->bsize);
+		if (lt_size < 0)
+			goto out_lt;
+
+		new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
 		if (!new_lt)
 			goto out_lt;
 
-- 
2.30.2

