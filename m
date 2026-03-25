Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5853793DB;
	Wed, 25 Mar 2026 22:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477597; cv=none; b=d9ZgSKNfn/h7c+VHN2mHu9ngKXdFibWFGDzA0aWv2uYwdShw3U79TT0pWBC/5231NazP/GDlzRauYhusl1xbAj2gf/qaiEPngnMGW7nB/4H6Maaeeei7/MgaA9ELDjq7jBWW4rvLEUBjWf5YJLL2MBuGQMRjtvEvaJXfHzOlIsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477597; c=relaxed/simple;
	bh=bSSQeRLAt8ztWJBujreX42RmbME573EsxO32BJwsp4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rxdr5y0MLDiUK0yStENAKx2UkFmf086vV6UlV+je4zPcJTQRdyXRtW8NbKd094VuK0Xo4bgTMHUJ0RewMhs/a2ogwR6BT6IWZyu6qXp3NswoLqdi5ySR3XCf05+BWClQgXwuqh8aAxxEDOMOO5Snvw3pMC77DPFGFdT0AizttWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ErY5CTQ0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ErY5CTQ0"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2CEDB60251;
	Wed, 25 Mar 2026 23:26:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774477592;
	bh=WNxZdluDIh5L9aujGAa+6rLbauRkSSIt5jI038ei7zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErY5CTQ0Yd0OL0gUlChua7RuLEE+yaL9Rep20S599vrSRAw7osBpb1iUzqqwPZyUb
	 mYjAWkk5edpxhPqQJ0gM76fkcL7/R3H7CnSFNvBcQ6lGI0vlKs/I/ObhUv0/zJ561P
	 nBh1hfofgUGNoOQfbJxBSUxKEX5DaQqe9vJYyrSwxpxCOBQfYIJUnvpISrnYEpcYbd
	 /BmNQ/l305qkTdHIpL3eKl4x7bysLDzwxH2cCP4Tf9q+oadJrFQ1GsWdfIz+wazf4z
	 80aO4uKy5/5tc9jD/i2j5xF80GAx/K0OZv8ng3euav3rx+CClBs+E7m9P4KoO7q1Vz
	 mIovu/w9NauVw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 07/14] netfilter: nft_set_rbtree: revisit array resize logic
Date: Wed, 25 Mar 2026 23:26:08 +0100
Message-ID: <20260325222615.637793-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325222615.637793-1-pablo@netfilter.org>
References: <20260325222615.637793-1-pablo@netfilter.org>
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

The shrink logic is skipped by anonymous sets.

Use check_add_overflow() to calculate the new array size.

Add a WARN_ON_ONCE check to make sure elements fit into the new array
size.

Reported-by: Chris Arges <carges@cloudflare.com>
Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 92 +++++++++++++++++++++++++++-------
 1 file changed, 75 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index fe8bd497d74a..737c339decd0 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -572,14 +572,12 @@ static struct nft_array *nft_array_alloc(u32 max_intervals)
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
@@ -595,27 +593,87 @@ static u32 nft_array_elems(const struct nft_set *set)
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
-		array = nft_array_alloc(nelems + NFT_ARRAY_EXTRA_SIZE);
-		if (!array)
-			return -ENOMEM;
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
+			new_max_intervals = priv->array->max_intervals;
+		} else {
+			max_intervals = 0;
+			new_max_intervals = initial_intervals;
+		}
+	}
 
-		priv->array_next = array;
+	if (nft_set_is_anonymous(set))
+		goto maybe_grow;
+
+	if (flush) {
+		/* Set flush just started, nelems still report elements.*/
+		nelems = 0;
+		new_max_intervals = NFT_ARRAY_INITIAL_SIZE;
+		goto realloc_array;
 	}
 
-	if (nelems < priv->array_next->max_intervals)
-		return 0;
+	if (check_add_overflow(new_max_intervals, new_max_intervals,
+			       &shrinked_max_intervals))
+		return -EOVERFLOW;
+
+	shrinked_max_intervals = DIV_ROUND_UP(shrinked_max_intervals, 3);
 
-	new_max_intervals = priv->array_next->max_intervals + NFT_ARRAY_EXTRA_SIZE;
-	if (nft_array_intervals_alloc(priv->array_next, new_max_intervals) < 0)
+	if (shrinked_max_intervals > NFT_ARRAY_INITIAL_SIZE &&
+	    nelems < shrinked_max_intervals) {
+		new_max_intervals = shrinked_max_intervals;
+		goto realloc_array;
+	}
+maybe_grow:
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
 		return -ENOMEM;
 
+	if (priv->array_next) {
+		if (max_intervals == new_max_intervals)
+			return 0;
+
+		if (nft_array_intervals_alloc(priv->array_next, new_max_intervals) < 0)
+			return -ENOMEM;
+	} else {
+		array = nft_array_alloc(new_max_intervals);
+		if (!array)
+			return -ENOMEM;
+
+		priv->array_next = array;
+	}
+
 	return 0;
 }
 
@@ -630,7 +688,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 	nft_rbtree_maybe_reset_start_cookie(priv, tstamp);
 
-	if (nft_array_may_resize(set) < 0)
+	if (nft_array_may_resize(set, false) < 0)
 		return -ENOMEM;
 
 	do {
@@ -741,7 +799,7 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 	    nft_rbtree_interval_null(set, this))
 		priv->start_rbe_cookie = 0;
 
-	if (nft_array_may_resize(set) < 0)
+	if (nft_array_may_resize(set, false) < 0)
 		return NULL;
 
 	while (parent != NULL) {
@@ -811,7 +869,7 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 	switch (iter->type) {
 	case NFT_ITER_UPDATE_CLONE:
-		if (nft_array_may_resize(set) < 0) {
+		if (nft_array_may_resize(set, true) < 0) {
 			iter->err = -ENOMEM;
 			break;
 		}
-- 
2.47.3

