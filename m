Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F079C3F54CE
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 17:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767085; cv=none; b=H0t4J5QC2ZygVgos6DE+Zrzv+FtxCuaiDLyZYUdpvwO04BSpJg4ovQ5yPoe66ENfjt6sBYzQ/qcQvcgaaOYXyqctLzSUg23seJV/c2iT6toJ3jywqsZo7Th9m9XdrNIbU1f7b1OjkI+X/T0zjhuxPDwz+k6IqXKyq8mnVyyDIQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767085; c=relaxed/simple;
	bh=EupWQMAU438nBjGmtRMmYsucW133DCxqE6xIMZ47ux4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mMat6PbaIx35XxRgq/nDrtCYd65S8EeVtM2AHGUNE0iYMCxrfmCoB4XPsFJsPPWXycVuLBeuJZ39YIVUwUOofUC4x1xixeuV2+6190MNBN/D4hqW+qDcsy8+HWMT2BTWbhMQUSKKPKNi7IYn1kTOOVHcQ6bbAdbm871SQHxRGCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kIy419hO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kIy419hO"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6467D600B5;
	Tue, 17 Mar 2026 18:04:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773767080;
	bh=SltrDfELMM+bnxh4me1v8Dn2w8H5ZbSITq6oK2YUVNQ=;
	h=From:To:Cc:Subject:Date:From;
	b=kIy419hO4LBFMJQeZQx6hOletlw7cMbSvQSvKYS0tzISxaAeWDSSaWPkKwyfQpk0p
	 WJk1Xuf8+SOqazzYmeCgIpFSvEkw3JxrrZP+mfAtxseSNqMisqPHSt+nzvJ6jA7ZDN
	 5d1pxjUBrxQ+KH4PxqVyVqUJUn7VEezKMD+UUjgQbDO9sYt3+UDENxOPEYhuYts5TP
	 j7zSLi+j1XLnRzHnhqxxoMDFSlK3/ZvYCQuSueSrgHK/W/XBM4YVqjO+2xcBm7rSmA
	 HZTNMuFCr0coVNgVSK010xkoep4Tyi/GkpvK555lSAp0KdofefIsgNXmBpLPRi9Jqt
	 TGugCG8kT5FJA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	carges@cloudflare.com
Subject: [PATCH nf,v3] netfilter: nft_set_rbtree: revisit array resize logic
Date: Tue, 17 Mar 2026 18:04:16 +0100
Message-ID: <20260317170416.12082-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Chris Arges reports high memory consumption with thousands of
containers, this patch revisits the array allocation logic.

For anonymous sets, start by 16 slots (which takes 256 bytes on x86_64).
Expand it by x2 until threshold of 512 slots is reached, over that
threshold, expand it by x1.5.

For non-anonymous set, start by 1024 slots in the array (which takes 16
Kbytes initially on x86_64). Expand it by x1.5.

Use set->ndeact to subtract deactivated elements when calculating the
number of the slots in the array, otherwise the array size array gets
increased artifically. Add special case shrink logic to deal with flush
set too.

Use check_add_overflow() to calculate the new array size.

Add a WARN_ON_ONCE check to make sure elements fit into the new array
size.

Reported-by: Chris Arges <carges@cloudflare.com>
Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: add logic for anonymous sets per Florian.

 net/netfilter/nft_set_rbtree.c | 91 +++++++++++++++++++++++++++-------
 1 file changed, 72 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 4061c506be53..bb101e05e49b 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -616,14 +616,12 @@ static struct nft_array *nft_array_alloc(u32 max_intervals)
 	return array;
 }
 
-#define NFT_ARRAY_EXTRA_SIZE	10240
-
 /* Similar to nft_rbtree_{u,k}size to hide details to userspace, but consider
  * packed representation coming from userspace for anonymous sets too.
  */
 static u32 nft_array_elems(const struct nft_set *set)
 {
-	u32 nelems = atomic_read(&set->nelems);
+	u32 nelems = atomic_read(&set->nelems) - set->ndeact;
 
 	/* Adjacent intervals are represented with a single start element in
 	 * anonymous sets, use the current element counter as is.
@@ -639,18 +637,80 @@ static u32 nft_array_elems(const struct nft_set *set)
 	return (nelems / 2) + 2;
 }
 
-static int nft_array_may_resize(const struct nft_set *set)
+#define NFT_ARRAY_INITIAL_SIZE		1024
+#define NFT_ARRAY_INITIAL_ANON_SIZE	16
+#define NFT_ARRAY_INITIAL_ANON_THRESH	(8192U / sizeof(struct nft_array_interval))
+
+static int nft_array_may_resize(const struct nft_set *set, bool flush)
 {
-	u32 nelems = nft_array_elems(set), new_max_intervals;
+	u32 initial_intervals, max_intervals, new_max_intervals, delta;
+	u32 shrinked_max_intervals, nelems = nft_array_elems(set);
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_array *array;
 
-	if (!priv->array_next) {
-		if (priv->array)
+	if (nft_set_is_anonymous(set))
+		initial_intervals = NFT_ARRAY_INITIAL_ANON_SIZE;
+	else
+		initial_intervals = NFT_ARRAY_INITIAL_SIZE;
+
+	if (priv->array_next) {
+		max_intervals = priv->array_next->max_intervals;
+		new_max_intervals = priv->array_next->max_intervals;
+	} else {
+		if (priv->array) {
+			max_intervals = priv->array->max_intervals;
 			new_max_intervals = priv->array->max_intervals;
-		else
-			new_max_intervals = NFT_ARRAY_EXTRA_SIZE;
+		} else {
+			max_intervals = 0;
+			new_max_intervals = initial_intervals;
+		}
+	}
+
+	if (nft_set_is_anonymous(set))
+		goto grow;
+
+	if (flush) {
+		/* Set flush just started, nelems still report elements.*/
+		nelems = 0;
+		new_max_intervals = NFT_ARRAY_INITIAL_SIZE;
+		goto realloc_array;
+	}
+
+	if (check_add_overflow(new_max_intervals, new_max_intervals,
+			       &shrinked_max_intervals))
+		return -EOVERFLOW;
+
+	shrinked_max_intervals = DIV_ROUND_UP(shrinked_max_intervals, 3);
 
+	if (shrinked_max_intervals > NFT_ARRAY_INITIAL_SIZE &&
+	    nelems < shrinked_max_intervals) {
+		new_max_intervals = shrinked_max_intervals;
+		goto realloc_array;
+	}
+grow:
+	if (nelems > new_max_intervals) {
+		if (nft_set_is_anonymous(set) &&
+		    new_max_intervals < NFT_ARRAY_INITIAL_ANON_THRESH) {
+			new_max_intervals <<= 1;
+		} else {
+			delta = new_max_intervals >> 1;
+			if (check_add_overflow(new_max_intervals, delta,
+					       &new_max_intervals))
+				return -EOVERFLOW;
+		}
+	}
+
+realloc_array:
+	if (WARN_ON_ONCE(nelems > new_max_intervals))
+		return -ENOMEM;
+
+	if (priv->array_next) {
+		if (max_intervals == new_max_intervals)
+			return 0;
+
+		if (nft_array_intervals_alloc(priv->array_next, new_max_intervals) < 0)
+			return -ENOMEM;
+	} else {
 		array = nft_array_alloc(new_max_intervals);
 		if (!array)
 			return -ENOMEM;
@@ -658,13 +718,6 @@ static int nft_array_may_resize(const struct nft_set *set)
 		priv->array_next = array;
 	}
 
-	if (nelems < priv->array_next->max_intervals)
-		return 0;
-
-	new_max_intervals = priv->array_next->max_intervals + NFT_ARRAY_EXTRA_SIZE;
-	if (nft_array_intervals_alloc(priv->array_next, new_max_intervals) < 0)
-		return -ENOMEM;
-
 	return 0;
 }
 
@@ -680,7 +733,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 	nft_rbtree_maybe_reset_start_cookie(priv, tstamp);
 
-	if (nft_array_may_resize(set) < 0)
+	if (nft_array_may_resize(set, false) < 0)
 		return -ENOMEM;
 
 	do {
@@ -791,7 +844,7 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 	    nft_rbtree_interval_null(set, this))
 		priv->start_rbe_cookie = 0;
 
-	if (nft_array_may_resize(set) < 0)
+	if (nft_array_may_resize(set, false) < 0)
 		return NULL;
 
 	while (parent != NULL) {
@@ -862,7 +915,7 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 	switch (iter->type) {
 	case NFT_ITER_UPDATE_CLONE:
-		if (nft_array_may_resize(set) < 0) {
+		if (nft_array_may_resize(set, true) < 0) {
 			iter->err = -ENOMEM;
 			break;
 		}
-- 
2.47.3

