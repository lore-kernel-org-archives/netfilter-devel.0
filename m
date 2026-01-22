Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83F9350A17;
	Thu, 22 Jan 2026 16:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769099398; cv=none; b=RJA7lSinzwyzzpSiHRme0FwboqnwoUcuQaGVCa1A64H0Z14yrLUcuZd4PMOjVg+hz4qAKqPxTOBYGZbbto7YzeJhkmj5hbffbmZnCMSgexNxzBSC4i9VkQAS1gtUzCNgM9nyVoXKLewBrrQJricNXbqtXOd46+kyBlWqivsG0dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769099398; c=relaxed/simple;
	bh=wACKi+B3HIHKnbPL01x0oEpYf6KBVA+5KE9lbwKaixI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IziwBdwNpw3FoxL53zb2dNMWmCDiiIIxwE0b+pUdjnoyp5VQpiHqYcAV4jKnIjmQo0u6SUGrBa6j4j2FiqHaQKNevfZH3SKSDrPUy/H98CCMn7x9NfxMolNVyt58pPyCAFjptUYDx5s6metpRT4chAmAVBoDNt6B1eOGS5375Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 17CD460863; Thu, 22 Jan 2026 17:29:51 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 3/4] netfilter: nft_set_rbtree: use binary search array in get command
Date: Thu, 22 Jan 2026 17:29:34 +0100
Message-ID: <20260122162935.8581-4-fw@strlen.de>
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

Rework .get interface to use the binary search array, this needs a specific
lookup function to match on end intervals (<=). Packet path lookup is slight
different because match is on lesser value, not equal (ie. <).

After this patch, seqcount can be removed in a follow up patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
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
2.52.0

