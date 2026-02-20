Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ACD1E22E9
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2026 14:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771596371; cv=none; b=OP3CzSXM6XtAyxh2tNxw+cITQICjFhQZH17Xj4P7dMrvdC7mh0LIxFaGiO5RhG9Sa4mGAZy/6sD043Jy5Q8CgDGm84UCizndXTwHVg/E58KvBp5/KC55LmHRP9721Bg7AWZ5dcJV6mg1FkkOi9otaC1tRrjlIPXjYMiNwWqnZ3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771596371; c=relaxed/simple;
	bh=cAreoWgHTw4tLyYkvGxHkPhS7ZsmGWj5PB0JKWDZkaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y01T/nPGHeWdsYLuDzZawxf+1GpGyPeDBZs5uYyRluWmcqX/wI100EuhIqLnjjDy23JQfeJ36/h3c7kUnIlYPF9wIqRQOgh8JiTv3X3oK3Rj85y5gK1OzUVIpojskQb67Th2ih08EUGre2IvU+zYLCN3cN7UiCJ3P7DFJeirMMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C0B3E6090A; Fri, 20 Feb 2026 15:06:08 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: nft_set_rbtree: don't disable bh when acquiring tree lock
Date: Fri, 20 Feb 2026 15:05:41 +0100
Message-ID: <20260220140553.21155-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260220140553.21155-1-fw@strlen.de>
References: <20260220140553.21155-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As of commit 7e43e0a1141d
("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
the lock is only taken from control plane, no need to disable BH anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 644d4b916705..ef567a948703 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -684,9 +684,9 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 		cond_resched();
 
-		write_lock_bh(&priv->lock);
+		write_lock(&priv->lock);
 		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp, last);
-		write_unlock_bh(&priv->lock);
+		write_unlock(&priv->lock);
 
 		if (nft_rbtree_interval_end(rbe))
 			priv->start_rbe_cookie = 0;
@@ -696,13 +696,6 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	return err;
 }
 
-static void nft_rbtree_erase(struct nft_rbtree *priv, struct nft_rbtree_elem *rbe)
-{
-	write_lock_bh(&priv->lock);
-	rb_erase(&rbe->node, &priv->root);
-	write_unlock_bh(&priv->lock);
-}
-
 static void nft_rbtree_remove(const struct net *net,
 			      const struct nft_set *set,
 			      struct nft_elem_priv *elem_priv)
@@ -710,7 +703,9 @@ static void nft_rbtree_remove(const struct net *net,
 	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem_priv);
 	struct nft_rbtree *priv = nft_set_priv(set);
 
-	nft_rbtree_erase(priv, rbe);
+	write_lock(&priv->lock);
+	rb_erase(&rbe->node, &priv->root);
+	write_unlock(&priv->lock);
 }
 
 static void nft_rbtree_activate(const struct net *net,
@@ -871,9 +866,9 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 		nft_rbtree_do_walk(ctx, set, iter);
 		break;
 	case NFT_ITER_READ:
-		read_lock_bh(&priv->lock);
+		read_lock(&priv->lock);
 		nft_rbtree_do_walk(ctx, set, iter);
-		read_unlock_bh(&priv->lock);
+		read_unlock(&priv->lock);
 		break;
 	default:
 		iter->err = -EINVAL;
@@ -909,14 +904,14 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
 		/* end element needs to be removed first, it has
 		 * no timeout extension.
 		 */
-		write_lock_bh(&priv->lock);
+		write_lock(&priv->lock);
 		if (rbe_end) {
 			nft_rbtree_gc_elem_move(net, set, priv, rbe_end);
 			rbe_end = NULL;
 		}
 
 		nft_rbtree_gc_elem_move(net, set, priv, rbe);
-		write_unlock_bh(&priv->lock);
+		write_unlock(&priv->lock);
 	}
 
 	priv->last_gc = jiffies;
-- 
2.52.0

