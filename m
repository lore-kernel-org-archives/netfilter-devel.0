Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D062429D29E
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2026 11:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773661724; cv=none; b=LGl9FrLrKPTq0jsI3OOz9sqQ5NWPPftyTr2xWDguE01dl0kKY/o2oLoIgHzaHZ0rhe4V1QV/Ssk3R3BL0T3/OKqUON5nyyG7I/QYRlmWtmMuQj5UsOUQeoU2SImhlHgWb87wnyehx5phAMiOWxrW5AbgsvSKsiWBNE8OMQ9pbFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773661724; c=relaxed/simple;
	bh=L4ogvc0Q0cONQeD4Wx+dp5LbBVFKhicM068/xn00lgw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rhARCNSW0cZP9NPdS01ggx6U26wZgSdA1mtfkHJJY9IxfZrsBnKJsLPE9Du9K3kicVCripuxPtovmnKoOH9IvPMVxy1zELt2Fnaj29T2jr8MOb0dGZMg9ZkxtK4y/WBd4k/b9ruALu8T2Bk0HxGZK1cPrY2ThuSD/hI+MVrOKvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pkb0WXxL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pkb0WXxL"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 09E5E602A5;
	Mon, 16 Mar 2026 12:48:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773661719;
	bh=2glWxkbHOrCul3UIct407e+pqZvq2KvtJpGIGredMrI=;
	h=From:To:Cc:Subject:Date:From;
	b=pkb0WXxLV47enL+NDAhsQS7TVJIPMhRh/ZQr3xHsIVS12v7SKvy88ZlNhG4FW2KcS
	 KDAbs1hdZxs78nYDD8OfNMgLXWDA/42o3MC0ug5apBmF7yIs9dPMZZxrYQfzX+e9OL
	 4cRqiYEg9bJ1SvLgXKaU0dl8Zt2OCgXC99L2bUQ2yoEzX0z20chZTmCf21cZj+bqwq
	 FPmLuTPUfSK2JsAmrbCVQ/xN7kxOjYSpV3s+xMmjLsoPMnwATw5CIoXntSvzgmoWbT
	 XJ4kv0+VG/KZv5iSGvNvhjk/ddfp2ualuHOnF94bAaR7XAwk6mCXq2dOeb9xpQdSPj
	 7wHt363M+FMbQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: carges@cloudflare.com,
	fw@strlen.de
Subject: [PATCH nf,v2] netfilter: nft_set_rbtree: revisit array resize logic
Date: Mon, 16 Mar 2026 12:48:35 +0100
Message-ID: <20260316114835.3834812-1-pablo@netfilter.org>
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

Start by 1024 slots in the array (which takes 16 Kbytes initially on
x86_64), and expand it by x1.5.

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
v2: - increase/decrease by x1.5 factor per Florian
    - shrink array on flush
    - add bugtrap in case number of elements is less than array size
    - consolidate array (re)allocation
    - use check_overflow_add()
 
Hi, this is v2, slightly larger than previous version.

 net/netfilter/nft_set_rbtree.c | 72 +++++++++++++++++++++++++---------
 1 file changed, 53 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index bdcea649467f..c80f903e0546 100644
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
@@ -639,18 +637,61 @@ static u32 nft_array_elems(const struct nft_set *set)
 	return (nelems / 2) + 2;
 }
 
-static int nft_array_may_resize(const struct nft_set *set)
+#define NFT_ARRAY_INITIAL_SIZE	1024
+
+static int nft_array_may_resize(const struct nft_set *set, bool flush)
 {
-	u32 nelems = nft_array_elems(set), new_max_intervals;
+	u32 max_intervals, new_max_intervals, shrinked_max_intervals;
 	struct nft_rbtree *priv = nft_set_priv(set);
+	u32 nelems = nft_array_elems(set), delta;
 	struct nft_array *array;
 
-	if (!priv->array_next) {
-		if (priv->array)
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
+			new_max_intervals = NFT_ARRAY_INITIAL_SIZE;
+		}
+	}
+
+	if (flush) {
+		nelems = 0;
+		new_max_intervals = NFT_ARRAY_INITIAL_SIZE;
+		goto realloc_array;
+	}
+
+	if (check_add_overflow(new_max_intervals, new_max_intervals, &shrinked_max_intervals))
+		return -EOVERFLOW;
+
+	shrinked_max_intervals = DIV_ROUND_UP(shrinked_max_intervals, 3);
+	if (shrinked_max_intervals > NFT_ARRAY_INITIAL_SIZE &&
+	    nelems < shrinked_max_intervals) {
+		new_max_intervals = shrinked_max_intervals;
+		goto realloc_array;
+	}
 
+	if (nelems > new_max_intervals) {
+		delta = new_max_intervals >> 1;
+		if (check_add_overflow(new_max_intervals, delta, &new_max_intervals))
+			return -EOVERFLOW;
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
@@ -658,13 +699,6 @@ static int nft_array_may_resize(const struct nft_set *set)
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
 
@@ -680,7 +714,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 	nft_rbtree_maybe_reset_start_cookie(priv, tstamp);
 
-	if (nft_array_may_resize(set) < 0)
+	if (nft_array_may_resize(set, false) < 0)
 		return -ENOMEM;
 
 	do {
@@ -796,7 +830,7 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 	    nft_rbtree_interval_null(set, this))
 		priv->start_rbe_cookie = 0;
 
-	if (nft_array_may_resize(set) < 0)
+	if (nft_array_may_resize(set, false) < 0)
 		return NULL;
 
 	while (parent != NULL) {
@@ -867,7 +901,7 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 	switch (iter->type) {
 	case NFT_ITER_UPDATE_CLONE:
-		if (nft_array_may_resize(set) < 0) {
+		if (nft_array_may_resize(set, true) < 0) {
 			iter->err = -ENOMEM;
 			break;
 		}
-- 
2.47.3

