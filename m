Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257DC1AC428
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2024 09:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713469; cv=none; b=qVW/zqAtEzYfi6esXNgRiguh4lE0WW6kRsvbtc++7EoynicDGRdLQEc9gceyCjiyxt2506kqGQiAoRJHokjuYkt59yBRIiAQcpSXfoOOtZ2Y3xdl74yshs4xri4mECGngL1ssAgg1sx/g8IYZcr+LSwDd1IvVG2KEMeLDuDMLOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713469; c=relaxed/simple;
	bh=MspoTOWAqQWgmHe/rKvVTtD8BVuZ6+t8ddAICGB2wrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPHXVoCfmX1R/8o/y3FLUCWetzxeRxUPkNszELOlgPhCalhLUnkUbAGNHd3hzDA2WxbjFNC4ZjL25f4UyFjRO01WczK3jeGZ/VsRYcB5GvDhrxQaZJe94RJHVtcxU8nMzf1kbfQvVtujEfBVmsRRA9XYz4vXPHMPteMmOG6DRDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t7tdK-0003cm-Ga; Mon, 04 Nov 2024 10:44:26 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 4/7] netfilter: nf_tables: avoid false-positive lockdep splats in set walker
Date: Mon,  4 Nov 2024 10:41:16 +0100
Message-ID: <20241104094126.16917-5-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241104094126.16917-1-fw@strlen.de>
References: <20241104094126.16917-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Its not possible to add or delete elements from hash and bitmap sets,
as long as caller is holding the transaction mutex, so its ok to iterate
the list outside of rcu read side critical section.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_bitmap.c | 10 ++++++----
 net/netfilter/nft_set_hash.c   |  3 ++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 1caa04619dc6..12390d2e994f 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -88,13 +88,15 @@ bool nft_bitmap_lookup(const struct net *net, const struct nft_set *set,
 }
 
 static struct nft_bitmap_elem *
-nft_bitmap_elem_find(const struct nft_set *set, struct nft_bitmap_elem *this,
+nft_bitmap_elem_find(const struct net *net,
+		     const struct nft_set *set, struct nft_bitmap_elem *this,
 		     u8 genmask)
 {
 	const struct nft_bitmap *priv = nft_set_priv(set);
 	struct nft_bitmap_elem *be;
 
-	list_for_each_entry_rcu(be, &priv->list, head) {
+	list_for_each_entry_rcu(be, &priv->list, head,
+				lockdep_is_held(&nft_pernet(net)->commit_mutex)) {
 		if (memcmp(nft_set_ext_key(&be->ext),
 			   nft_set_ext_key(&this->ext), set->klen) ||
 		    !nft_set_elem_active(&be->ext, genmask))
@@ -132,7 +134,7 @@ static int nft_bitmap_insert(const struct net *net, const struct nft_set *set,
 	u8 genmask = nft_genmask_next(net);
 	u32 idx, off;
 
-	be = nft_bitmap_elem_find(set, new, genmask);
+	be = nft_bitmap_elem_find(net, set, new, genmask);
 	if (be) {
 		*elem_priv = &be->priv;
 		return -EEXIST;
@@ -201,7 +203,7 @@ nft_bitmap_deactivate(const struct net *net, const struct nft_set *set,
 
 	nft_bitmap_location(set, elem->key.val.data, &idx, &off);
 
-	be = nft_bitmap_elem_find(set, this, genmask);
+	be = nft_bitmap_elem_find(net, set, this, genmask);
 	if (!be)
 		return NULL;
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index daa56dda737a..65bd291318f2 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -647,7 +647,8 @@ static void nft_hash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	int i;
 
 	for (i = 0; i < priv->buckets; i++) {
-		hlist_for_each_entry_rcu(he, &priv->table[i], node) {
+		hlist_for_each_entry_rcu(he, &priv->table[i], node,
+					 lockdep_is_held(&nft_pernet(ctx->net)->commit_mutex)) {
 			if (iter->count < iter->skip)
 				goto cont;
 
-- 
2.45.2

