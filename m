Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87643D6661;
	Thu, 22 Jan 2026 16:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769099404; cv=none; b=Ec9iyKES3QFJcm+qLxu+jnntw8ji/0zOOHsdxwK9auFaIjaLFoZ70SwResljEp4MXur/XFktGf5AUUEh1ckBckwSJipGot9FCR1dcXgaxtVZhOnXt/XLHRp7qwN7cUiNAyT/LRm4bvySbe3twklS7+oyiUwXTIiwgTg2hezuNqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769099404; c=relaxed/simple;
	bh=BihG0PSPj0qfxrrRywd0t1i4E6I4s5j8eO7wS+D5B24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/hAV3UO8gLrOucwnfKw9XIbxse/D6eANtT7ZVcoIW1hPhmgvDcR4ghLJknbOoRBaBM4Ng96BtnSjC1T5+kcFEm+FsvtUQwMiHJZlLj5eR9tgGw14sZ1m5WKaWvmeX8+3Vj9dEOPLYmLWRlr3x5kqqfTc5pZPPz+oqSzIl9SIGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2BAC56033F; Thu, 22 Jan 2026 17:29:55 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 4/4] netfilter: nft_set_rbtree: remove seqcount_rwlock_t
Date: Thu, 22 Jan 2026 17:29:35 +0100
Message-ID: <20260122162935.8581-5-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122162935.8581-1-fw@strlen.de>
References: <20260122162935.8581-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

After the conversion to binary search array, this is not required anymore.
Remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index de2cce96023e..7598c368c4e5 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -33,7 +33,6 @@ struct nft_rbtree {
 	rwlock_t		lock;
 	struct nft_array __rcu	*array;
 	struct nft_array	*array_next;
-	seqcount_rwlock_t	count;
 	unsigned long		last_gc;
 };
 
@@ -539,9 +538,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		cond_resched();
 
 		write_lock_bh(&priv->lock);
-		write_seqcount_begin(&priv->count);
 		err = __nft_rbtree_insert(net, set, rbe, elem_priv);
-		write_seqcount_end(&priv->count);
 		write_unlock_bh(&priv->lock);
 	} while (err == -EAGAIN);
 
@@ -551,9 +548,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 static void nft_rbtree_erase(struct nft_rbtree *priv, struct nft_rbtree_elem *rbe)
 {
 	write_lock_bh(&priv->lock);
-	write_seqcount_begin(&priv->count);
 	rb_erase(&rbe->node, &priv->root);
-	write_seqcount_end(&priv->count);
 	write_unlock_bh(&priv->lock);
 }
 
@@ -765,7 +760,6 @@ static int nft_rbtree_init(const struct nft_set *set,
 	BUILD_BUG_ON(offsetof(struct nft_rbtree_elem, priv) != 0);
 
 	rwlock_init(&priv->lock);
-	seqcount_rwlock_init(&priv->count, &priv->lock);
 	priv->root = RB_ROOT;
 
 	priv->array = NULL;
-- 
2.52.0

