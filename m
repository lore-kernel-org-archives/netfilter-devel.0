Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B4F20E30D;
	Wed,  6 Nov 2024 23:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730936806; cv=none; b=VB84k2heV3pbLY0EI+nf/NDogN7bfH16S83FWlEcZIHXakpzGdnCftxp+8QnizLtU8O5F8xgz2e6D0jFx71fHye4xVm3g5gSef360Za14aB/EfLWsui0N2O6JNFwMrfNyzW9G7Wlp//nfiixdwnPLFA7QrELv0tt7V57qAHFNfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730936806; c=relaxed/simple;
	bh=Adf3aOJNC5r2hXJPMgaZyBMBI/EGeLcoAk4ycfDdvw4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EeLxMxx1q2JFLlvy6vHcfJ5/ivFrfJ4dxZtLdbPICFrLiuxTYG329cNhQ2q9hksVpI9HVt7EoiDdStDUV3WjC3mNj6rZ8tweFNnFY+FvQPdcEV94Vo9JMZBEZolEkbPl7cgYCindNjwYjGIjw5ByKivt41okgDxb0iowCMZ8EtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 08/11] netfilter: nf_tables: avoid false-positive lockdep splats in set walker
Date: Thu,  7 Nov 2024 00:46:22 +0100
Message-Id: <20241106234625.168468-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241106234625.168468-1-pablo@netfilter.org>
References: <20241106234625.168468-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Its not possible to add or delete elements from hash and bitmap sets,
as long as caller is holding the transaction mutex, so its ok to iterate
the list outside of rcu read side critical section.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

