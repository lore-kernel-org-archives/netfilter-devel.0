Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97413F6600
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 17:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767251; cv=none; b=S7HAVmkOM4aF8RchLLBeq4cnszz5ZuV67BcexIc/JlMRCFKNW+EIn30Ja/FPXPskGmOjszLJzlYJ9pc+w+neXbEOgYCBaATgJXEI/vloQZJodCEWuzJclEf2IheoZGHYpVIAiQNfo7VL3nODVnbEZJrDwDyxVwpdeBiGksvY2Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767251; c=relaxed/simple;
	bh=IRHH/oiii1VfvqemkNUz9+cXsGUe52pybSdsEJy+yPs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LaVa9L0Djagr3DP1PCjNfouxz5h9Wz6SKzxzF4bDU2mgJgE0vmmdZM29pJ/49vS7g9z1PPzQ9dRpsCmsfC58iccK7gdblgF5N+/IbrnnHe0j6rpe9CYDdEX1jw5Fxran2R9vVcrzkCFhXBLHL7GmlBWN8s1nLObKabqxjPOiQZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UvyNJLWD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UvyNJLWD"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AB9CD60284;
	Tue, 17 Mar 2026 18:07:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773767245;
	bh=BRHVcIlzvgyU1Z6zE/pt1eS5LnyhU8EdOrB9xKmT7xM=;
	h=From:To:Cc:Subject:Date:From;
	b=UvyNJLWDbDGUqjZw3hHLErwwi39TIHjC84B9renPPmx1ixBmIz8ofGWfwFCTAa1Ts
	 4KyniljSKUxZRMwkRw0HWZh1Q9IBEfJRIaQ+X70+PVPhmslOkT6DCv/qQz2UwFXP1H
	 teSo98oJWmowWcxZHPKngKhgZb13gZZceOxC47udEyvDt3db0idzVNQUJKqfa5Rltj
	 UO5TjNNJPFGLVWv7OnUzOHoEsKlod+SkRByZe2KLLUerSkCkNzvQm5WTg97DwbFf1o
	 UMG9/LQgF5DoF+PInDOUvUBbbiOc/PI6GWTBgg43l80CQXoxweluExV43fBd+NsymQ
	 ylgBnuoGy/pjg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	carges@cloudflare.com
Subject: [PATCH nf,v4] netfilter: nft_set_rbtree: revisit array resize logic
Date: Tue, 17 Mar 2026 18:07:21 +0100
Message-ID: <20260317170721.12396-1-pablo@netfilter.org>
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

The shrink logic is skipped by anonymous sets.

Use check_add_overflow() to calculate the new array size.

Add a WARN_ON_ONCE check to make sure elements fit into the new array
size.

Reported-by: Chris Arges <carges@cloudflare.com>
Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: use maybe_grow: goto tag instead of grow:
    Add note in commit description: "The shrink logic is skipped by anonymous sets."

 net/netfilter/nft_set_rbtree.c | 91 +++++++++++++++++++++++++++-------
 1 file changed, 72 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 4061c506be53..e4d2cf04efab 100644
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
+		goto maybe_grow;
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

