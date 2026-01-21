Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C786217F33
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Jan 2026 00:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768954146; cv=none; b=SqCcNlOSvvG7lcxSu4KoDtZz95t2xlFC2w3EXJoYltCHJ2bG9hkXxFFJcEDxz5NCcySoudxYlfen955KDq65HUljcwNO3UOzVQO+8JM+gu3VNwvEZ3rnklbuyuJfG7Vpx2MYQSxLIe/QQOKmfFEsfESHasPvmxIbmXVcek2jncs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768954146; c=relaxed/simple;
	bh=Ul3qX7ldStmRvdZ0BqSLLQExK6uQE/lDIj+2KEiSDns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUvhn/RA1ASTj+O5f+BAZAXiUDX95IIJiHRu5PTIp2P4LyUadAf2IQKgAf9PwzICwB3HVWF0IxQ7wciJBlRuWZ/rgwICJW76mImbSlxNRFCWnYzoZv2PEKFtMMBme4n4wNh5OMuaon7bEvgBbLj6i+MsZcbfEt8XLn9gqHcUdI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jMJ705JA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jMJ705JA"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B85F7602B3;
	Wed, 21 Jan 2026 01:08:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1768954136;
	bh=hOueSR37mI09d7hkxvvwrT5ZGOZX1zpwPekjtyXNSEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMJ705JAJiNbyacjxzv4Q2FQqeQ+e/VUWqhw5HquazIM1t6ulfQ2nn8FtssW8OU/C
	 vK5raotmmBU1Fm/L/EGFlkIVQHV6/khaE0djplVra1LQbUyvz8SA1cMTclSvY/TWQF
	 m6zY6MKArZYDXQFQE/vXLL0gvMLZaGtqfbgGDld6OEe3+R3sLn+k/6ZWb3R4gIzCe1
	 0xX+t7VGk+FkhwmNVF+3CKoVWAjJ+Eh9Ced5mnUh/EpRo7v8vQQoUOuWbsBwFnx6xb
	 6UKpPr1M9D/7g9YCNlOgsizLU/rJLNUnafekyId3QYFAX8wfYWw4WGw74rplmWxEfK
	 OQ04Y5pIJS4GQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v2 3/4] netfilter: nft_set_rbtree: use binary search array in get command
Date: Wed, 21 Jan 2026 01:08:46 +0100
Message-ID: <20260121000847.294125-4-pablo@netfilter.org>
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

Rework .get interface to use the binary search array, this needs a specific
lookup function to match on end intervals (<=). Packet path lookup is slight
different because match is on lesser value, not equal (ie. <).

After this patch, seqcount can be removed in a follow up patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 net/netfilter/nft_set_rbtree.c | 154 ++++++++++++++-------------------
 1 file changed, 64 insertions(+), 90 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 821808e8da06..de2cce96023e 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -62,96 +62,6 @@ static int nft_rbtree_cmp(const struct nft_set *set,
 		      set->klen);
 }
 
-static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
-			     const u32 *key, struct nft_rbtree_elem **elem,
-			     unsigned int seq, unsigned int flags, u8 genmask)
-{
-	struct nft_rbtree_elem *rbe, *interval = NULL;
-	struct nft_rbtree *priv = nft_set_priv(set);
-	const struct rb_node *parent;
-	const void *this;
-	int d;
-
-	parent = rcu_dereference_raw(priv->root.rb_node);
-	while (parent != NULL) {
-		if (read_seqcount_retry(&priv->count, seq))
-			return false;
-
-		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
-
-		this = nft_set_ext_key(&rbe->ext);
-		d = memcmp(this, key, set->klen);
-		if (d < 0) {
-			parent = rcu_dereference_raw(parent->rb_left);
-			if (!(flags & NFT_SET_ELEM_INTERVAL_END))
-				interval = rbe;
-		} else if (d > 0) {
-			parent = rcu_dereference_raw(parent->rb_right);
-			if (flags & NFT_SET_ELEM_INTERVAL_END)
-				interval = rbe;
-		} else {
-			if (!nft_set_elem_active(&rbe->ext, genmask)) {
-				parent = rcu_dereference_raw(parent->rb_left);
-				continue;
-			}
-
-			if (nft_set_elem_expired(&rbe->ext))
-				return false;
-
-			if (!nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) ||
-			    (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END) ==
-			    (flags & NFT_SET_ELEM_INTERVAL_END)) {
-				*elem = rbe;
-				return true;
-			}
-
-			if (nft_rbtree_interval_end(rbe))
-				interval = NULL;
-
-			parent = rcu_dereference_raw(parent->rb_left);
-		}
-	}
-
-	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
-	    nft_set_elem_active(&interval->ext, genmask) &&
-	    !nft_set_elem_expired(&interval->ext) &&
-	    ((!nft_rbtree_interval_end(interval) &&
-	      !(flags & NFT_SET_ELEM_INTERVAL_END)) ||
-	     (nft_rbtree_interval_end(interval) &&
-	      (flags & NFT_SET_ELEM_INTERVAL_END)))) {
-		*elem = interval;
-		return true;
-	}
-
-	return false;
-}
-
-static struct nft_elem_priv *
-nft_rbtree_get(const struct net *net, const struct nft_set *set,
-	       const struct nft_set_elem *elem, unsigned int flags)
-{
-	struct nft_rbtree *priv = nft_set_priv(set);
-	unsigned int seq = read_seqcount_begin(&priv->count);
-	struct nft_rbtree_elem *rbe = ERR_PTR(-ENOENT);
-	const u32 *key = (const u32 *)&elem->key.val;
-	u8 genmask = nft_genmask_cur(net);
-	bool ret;
-
-	ret = __nft_rbtree_get(net, set, key, &rbe, seq, flags, genmask);
-	if (ret || !read_seqcount_retry(&priv->count, seq))
-		return &rbe->priv;
-
-	read_lock_bh(&priv->lock);
-	seq = read_seqcount_begin(&priv->count);
-	ret = __nft_rbtree_get(net, set, key, &rbe, seq, flags, genmask);
-	read_unlock_bh(&priv->lock);
-
-	if (!ret)
-		return ERR_PTR(-ENOENT);
-
-	return &rbe->priv;
-}
-
 struct nft_array_lookup_ctx {
 	const u32	*key;
 	u32		klen;
@@ -206,6 +116,70 @@ nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
 	return interval->from;
 }
 
+struct nft_array_get_ctx {
+	const u32	*key;
+	unsigned int	flags;
+	u32		klen;
+};
+
+static int nft_array_get_cmp(const void *pkey, const void *entry)
+{
+	const struct nft_array_interval *interval = entry;
+	const struct nft_array_get_ctx *ctx = pkey;
+	int a, b;
+
+	if (!interval->from)
+		return 1;
+
+	a = memcmp(ctx->key, nft_set_ext_key(interval->from), ctx->klen);
+	if (!interval->to)
+		b = -1;
+	else
+		b = memcmp(ctx->key, nft_set_ext_key(interval->to), ctx->klen);
+
+	if (a >= 0) {
+		if (ctx->flags & NFT_SET_ELEM_INTERVAL_END && b <= 0)
+			return 0;
+		else if (b < 0)
+			return 0;
+	}
+
+	if (a < 0)
+		return -1;
+
+	return 1;
+}
+
+static struct nft_elem_priv *
+nft_rbtree_get(const struct net *net, const struct nft_set *set,
+	       const struct nft_set_elem *elem, unsigned int flags)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_array *array = rcu_dereference(priv->array);
+	const struct nft_array_interval *interval;
+	struct nft_array_get_ctx ctx = {
+		.key	= (const u32 *)&elem->key.val,
+		.flags	= flags,
+		.klen	= set->klen,
+	};
+	struct nft_rbtree_elem *rbe;
+
+	if (!array)
+		return ERR_PTR(-ENOENT);
+
+	interval = bsearch(&ctx, array->intervals, array->num_intervals,
+			   sizeof(struct nft_array_interval), nft_array_get_cmp);
+	if (!interval || nft_set_elem_expired(interval->from))
+		return ERR_PTR(-ENOENT);
+
+	if (flags & NFT_SET_ELEM_INTERVAL_END)
+		rbe = container_of(interval->to, struct nft_rbtree_elem, ext);
+	else
+		rbe = container_of(interval->from, struct nft_rbtree_elem, ext);
+
+	return &rbe->priv;
+}
+
 static void nft_rbtree_gc_elem_remove(struct net *net, struct nft_set *set,
 				      struct nft_rbtree *priv,
 				      struct nft_rbtree_elem *rbe)
-- 
2.47.3

