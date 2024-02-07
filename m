Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D862033F;
	Wed,  7 Feb 2024 23:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707349061; cv=none; b=h7yLFnLzWxJ9C/sh4wFIpSAcgWef+xKntXFvKehQWH8q4VVo+eYMfJc2y5VyiyBUx1j/33aXRA/vK4d0KIkygXOxhfp8LDQ9P+DdH5VfdXccql39NUoeEVIhd+ilj4GShIOBrqvYKbFK2O1m3rWu2TuoCw9d2IrB2R12oKLkvM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707349061; c=relaxed/simple;
	bh=cPeYWK4EosRjOppdC99VE/DsVaGgSBiEn8k33p4EeL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oD966r9OoYEEpF7SZ/ngZwemxglr9CI73wluzf2AOwt0dNgK9qIJq9KKLtH3YRj/EGXj+DU+lPpDABsWp4l/rtRNsfBPLTwauyPswJDDXNpIFWLzzTqzXt2b1UIJwPhtl6poKOyMj9j/ekwO46LQVSCd6b/8pppaNCsN5gNn7Pk=
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
Subject: [PATCH net 10/13] netfilter: nft_set_rbtree: skip end interval element from gc
Date: Thu,  8 Feb 2024 00:37:23 +0100
Message-Id: <20240207233726.331592-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240207233726.331592-1-pablo@netfilter.org>
References: <20240207233726.331592-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rbtree lazy gc on insert might collect an end interval element that has
been just added in this transactions, skip end interval elements that
are not yet active.

Fixes: f718863aca46 ("netfilter: nft_set_rbtree: fix overlap expiration walk")
Cc: stable@vger.kernel.org
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 5fd74f993988..9944fe479e53 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -234,7 +234,7 @@ static void nft_rbtree_gc_elem_remove(struct net *net, struct nft_set *set,
 
 static const struct nft_rbtree_elem *
 nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
-		   struct nft_rbtree_elem *rbe, u8 genmask)
+		   struct nft_rbtree_elem *rbe)
 {
 	struct nft_set *set = (struct nft_set *)__set;
 	struct rb_node *prev = rb_prev(&rbe->node);
@@ -253,7 +253,7 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 	while (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
 		if (nft_rbtree_interval_end(rbe_prev) &&
-		    nft_set_elem_active(&rbe_prev->ext, genmask))
+		    nft_set_elem_active(&rbe_prev->ext, NFT_GENMASK_ANY))
 			break;
 
 		prev = rb_prev(prev);
@@ -365,7 +365,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
 			const struct nft_rbtree_elem *removed_end;
 
-			removed_end = nft_rbtree_gc_elem(set, priv, rbe, genmask);
+			removed_end = nft_rbtree_gc_elem(set, priv, rbe);
 			if (IS_ERR(removed_end))
 				return PTR_ERR(removed_end);
 
-- 
2.30.2

