Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1888630507B;
	Tue,  2 Sep 2025 13:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820174; cv=none; b=aU33DFfDl8rkAWysHTVqmCdV4GlYJ4k+C4NYNACI3nJb8/Sxbwto+S8M9mqkVl0o4IKSe82UUgdk4UCD6V9Ulo0S46vmUUzGIrZ4unYitl4D4qQsHB5apzH7fkuuHYg4ghI+bEb1G//UJP57gA5OnX4SdBb0YAikbh3X/5FeQhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820174; c=relaxed/simple;
	bh=NYiUV2s2HPmhx0oNKpe1UVnTAXA516vHuspNYekUCYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+77jTuYAh5tdb0JEsDZa8bUhwmVppxZpuBfSccfb+8I4be43Arh6IYXfA5+w/BDpEWB57k8oT4jphdhQYi1IgkaPyPV9hC5l7lx6rP3jUeiGZwmInupelprkIyJjjfHoNgN4B2X3g0IA6tE7pSRmPauhJ0GQ9CdD5SKmBUtxRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 72BE060298; Tue,  2 Sep 2025 15:36:11 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 4/7] netfilter: nf_tables: all transaction allocations can now sleep
Date: Tue,  2 Sep 2025 15:35:46 +0200
Message-ID: <20250902133549.15945-5-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250902133549.15945-1-fw@strlen.de>
References: <20250902133549.15945-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that nft_setelem_flush is not called with rcu read lock held or
disabled softinterrupts anymore this can now use GFP_KERNEL too.

This is the last atomic allocation of transaction elements, so remove
all gfp_t arguments and the wrapper function.

This makes attempts to delete large sets much more reliable, before
this was prone to transient memory allocation failures.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 47 ++++++++++++++---------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 58c5425d61c2..54519b3d2868 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -151,12 +151,12 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	bitmap_zero(ctx->reg_inited, NFT_REG32_NUM);
 }
 
-static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
-					     int msg_type, u32 size, gfp_t gfp)
+static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
+					 int msg_type, u32 size)
 {
 	struct nft_trans *trans;
 
-	trans = kzalloc(size, gfp);
+	trans = kzalloc(size, GFP_KERNEL);
 	if (trans == NULL)
 		return NULL;
 
@@ -172,12 +172,6 @@ static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
 	return trans;
 }
 
-static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
-					 int msg_type, u32 size)
-{
-	return nft_trans_alloc_gfp(ctx, msg_type, size, GFP_KERNEL);
-}
-
 static struct nft_trans_binding *nft_trans_get_binding(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
@@ -442,8 +436,7 @@ static bool nft_trans_collapse_set_elem_allowed(const struct nft_trans_elem *a,
 
 static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
 					struct nft_trans_elem *tail,
-					struct nft_trans_elem *trans,
-					gfp_t gfp)
+					struct nft_trans_elem *trans)
 {
 	unsigned int nelems, old_nelems = tail->nelems;
 	struct nft_trans_elem *new_trans;
@@ -466,9 +459,11 @@ static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
 	/* krealloc might free tail which invalidates list pointers */
 	list_del_init(&tail->nft_trans.list);
 
-	new_trans = krealloc(tail, struct_size(tail, elems, nelems), gfp);
+	new_trans = krealloc(tail, struct_size(tail, elems, nelems),
+			     GFP_KERNEL);
 	if (!new_trans) {
-		list_add_tail(&tail->nft_trans.list, &nft_net->commit_list);
+		list_add_tail(&tail->nft_trans.list,
+			      &nft_net->commit_list);
 		return false;
 	}
 
@@ -484,7 +479,7 @@ static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
 }
 
 static bool nft_trans_try_collapse(struct nftables_pernet *nft_net,
-				   struct nft_trans *trans, gfp_t gfp)
+				   struct nft_trans *trans)
 {
 	struct nft_trans *tail;
 
@@ -501,7 +496,7 @@ static bool nft_trans_try_collapse(struct nftables_pernet *nft_net,
 	case NFT_MSG_DELSETELEM:
 		return nft_trans_collapse_set_elem(nft_net,
 						   nft_trans_container_elem(tail),
-						   nft_trans_container_elem(trans), gfp);
+						   nft_trans_container_elem(trans));
 	}
 
 	return false;
@@ -537,17 +532,14 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 	}
 }
 
-static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *trans,
-					   gfp_t gfp)
+static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *trans)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 
 	WARN_ON_ONCE(trans->msg_type != NFT_MSG_NEWSETELEM &&
 		     trans->msg_type != NFT_MSG_DELSETELEM);
 
-	might_alloc(gfp);
-
-	if (nft_trans_try_collapse(nft_net, trans, gfp)) {
+	if (nft_trans_try_collapse(nft_net, trans)) {
 		kfree(trans);
 		return;
 	}
@@ -7549,7 +7541,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 						}
 
 						ue->priv = elem_priv;
-						nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+						nft_trans_commit_list_add_elem(ctx->net, trans);
 						goto err_elem_free;
 					}
 				}
@@ -7573,7 +7565,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+	nft_trans_commit_list_add_elem(ctx->net, trans);
 	return 0;
 
 err_set_full:
@@ -7839,7 +7831,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	nft_setelem_data_deactivate(ctx->net, set, elem.priv);
 
 	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+	nft_trans_commit_list_add_elem(ctx->net, trans);
 	return 0;
 
 fail_ops:
@@ -7864,9 +7856,8 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	if (!nft_set_elem_active(ext, iter->genmask))
 		return 0;
 
-	trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSETELEM,
-				    struct_size_t(struct nft_trans_elem, elems, 1),
-				    GFP_ATOMIC);
+	trans = nft_trans_alloc(ctx, NFT_MSG_DELSETELEM,
+				struct_size_t(struct nft_trans_elem, elems, 1));
 	if (!trans)
 		return -ENOMEM;
 
@@ -7877,7 +7868,7 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	nft_trans_elem_set(trans) = set;
 	nft_trans_container_elem(trans)->nelems = 1;
 	nft_trans_container_elem(trans)->elems[0].priv = elem_priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_ATOMIC);
+	nft_trans_commit_list_add_elem(ctx->net, trans);
 
 	return 0;
 }
@@ -7894,7 +7885,7 @@ static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_container_elem(trans)->elems[0].priv = elem_priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+	nft_trans_commit_list_add_elem(ctx->net, trans);
 
 	return 0;
 }
-- 
2.49.1

