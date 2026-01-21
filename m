Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD602222D8
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Jan 2026 00:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768954149; cv=none; b=q54crs3KkJUM+2ni0yZisY8/yZ1tm46y5r3J+eb5eGsfvovn95C979Szr+oGQSjPw1ryc9o31P9LbJXZ4azjGVzOeLGeegIN3rwq38C5aKTmWIBga7dV2zuPpZ+Q9W24CEB52UId/FNHfOKIaHQNc0I8IFdJHGjsWRDCC6sxqWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768954149; c=relaxed/simple;
	bh=ttnKMSX0Kt3QHrKxZk35l6TK3PTu/Lo5TEUcGbBQXWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrsXOQjV71U8E/JRDkeMExeXg5TSK7QUB5dfp7l6luwktduu5qnG0faC7k7+vNxHVcuOMe3oLMSBqjOBjYSseFTl23KAVq4MgdXCIRVeJMnF8rxB9p9kXvcCYtophSVTCJx7YkmF2yZ1GFVrP76LWT0kpC6QQwg9vVzRayZtU18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ifFKPkKD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ifFKPkKD"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AE756605AA;
	Wed, 21 Jan 2026 01:08:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1768954137;
	bh=NAKK+mkhZ/zfaetU5W25ZsbKFwGxGVV+idVbUZxGT9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifFKPkKDmsfnszMrGRqVm5qG6w7Pc1+XLJiaNrlsAZoKD9mPBlQWWK5tvkHjEJqIY
	 OBf7Py6WBh0BnqJo2Kvs0dAyfbdRnyIjvB5AbV+oH098BVtP1dPgiL2AwsJR8ICg83
	 I8kRUsIF9rSV32AQsXtJQc5oLiyD0q4ZT+2ISe/rSCsaA03WYumSCU3ZrAsctPO2EQ
	 W0yM1P/PbUj8Hz9J1vEVAeywpUYxOLO56bJ1DriMTSHaUiYpv1HpT2sSmtfDDC7/mb
	 1te6PWk4dAuxD9EifnmqER0UsoN/ScSgXmU3EHahpTMP6jSeBLBZaEQ/U8zB95J2b6
	 BIphwDikrAj2Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v2 4/4] netfilter: nft_set_rbtree: remove seqcount_rwlock_t
Date: Wed, 21 Jan 2026 01:08:47 +0100
Message-ID: <20260121000847.294125-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121000847.294125-1-pablo@netfilter.org>
References: <20260121000847.294125-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After the conversion to binary search array, this is not required anymore.
Remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series

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
2.47.3

