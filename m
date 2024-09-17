Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B129627442;
	Tue, 17 Sep 2024 20:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726604693; cv=none; b=l04+lz3fMfwj5ac+tDHe567qakU0zeLvcydG8KMrskshzy7c01Jy2lfgciH6mHU3LKIcQPWeD/PfHnqx+VdzTWfmMyWd9clvmlK7/b+xcwxPnAslr4UVrameiTyfBmYhp6M1G2b/j3rr1kD/lo/J3ZIMAMdyjYeMcoDxH2k2htw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726604693; c=relaxed/simple;
	bh=sAXL5REFErOAIq72y1hD/tmlcEw6FH8vBGdLH/Gb6m0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IrBjF0R3e4Rm0OrDV9RmTdH+DVR9EFoapVJKM9tOrr+RdLsxxV6BQDsnppZSYrDl3mJ6wKKOFVl5EsV72odJ6bqbU6mw1GiSOS8wfrIPAphcpE08YaDIARP7/wr8sdHK9IFHIxw7ZIujDSeVnR6z2BfsmYt38cq2icvzsjxz9S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.6 1/2] netfilter: nft_set_pipapo: walk over current view on netlink dump
Date: Tue, 17 Sep 2024 22:24:43 +0200
Message-Id: <20240917202444.171526-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240917202444.171526-1-pablo@netfilter.org>
References: <20240917202444.171526-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 29b359cf6d95fd60730533f7f10464e95bd17c73 upstream.

The generation mask can be updated while netlink dump is in progress.
The pipapo set backend walk iterator cannot rely on it to infer what
view of the datastructure is to be used. Add notation to specify if user
wants to read/update the set.

Based on patch from Florian Westphal.

Fixes: 2b84e215f874 ("netfilter: nft_set_pipapo: .walk does not deal with generations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 13 +++++++++++++
 net/netfilter/nf_tables_api.c     |  5 +++++
 net/netfilter/nft_set_pipapo.c    |  5 +++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 8af2543520b9..1b95c34a4e3d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -297,9 +297,22 @@ struct nft_set_elem {
 	void			*priv;
 };
 
+/**
+ * enum nft_iter_type - nftables set iterator type
+ *
+ * @NFT_ITER_READ: read-only iteration over set elements
+ * @NFT_ITER_UPDATE: iteration under mutex to update set element state
+ */
+enum nft_iter_type {
+	NFT_ITER_UNSPEC,
+	NFT_ITER_READ,
+	NFT_ITER_UPDATE,
+};
+
 struct nft_set;
 struct nft_set_iter {
 	u8		genmask;
+	enum nft_iter_type type:8;
 	unsigned int	count;
 	unsigned int	skip;
 	int		err;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fc99a5e91829..da5684e3fd08 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -628,6 +628,7 @@ static void nft_map_deactivate(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	struct nft_set_iter iter = {
 		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_mapelem_deactivate,
 	};
 
@@ -5392,6 +5393,7 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		}
 
 		iter.genmask	= nft_genmask_next(ctx->net);
+		iter.type	= NFT_ITER_UPDATE;
 		iter.skip 	= 0;
 		iter.count	= 0;
 		iter.err	= 0;
@@ -5467,6 +5469,7 @@ static void nft_map_activate(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	struct nft_set_iter iter = {
 		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_mapelem_activate,
 	};
 
@@ -5845,6 +5848,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	args.skb		= skb;
 	args.reset		= reset;
 	args.iter.genmask	= nft_genmask_cur(net);
+	args.iter.type		= NFT_ITER_READ;
 	args.iter.skip		= cb->args[0];
 	args.iter.count		= 0;
 	args.iter.err		= 0;
@@ -7246,6 +7250,7 @@ static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
 {
 	struct nft_set_iter iter = {
 		.genmask	= genmask,
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_setelem_flush,
 	};
 
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index e4dd73093048..90f129f1a136 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2037,13 +2037,14 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_set_iter *iter)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
-	struct net *net = read_pnet(&set->net);
 	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
 	int i, r;
 
+	WARN_ON_ONCE(iter->type == NFT_ITER_UNSPEC);
+
 	rcu_read_lock();
-	if (iter->genmask == nft_genmask_cur(net))
+	if (iter->type == NFT_ITER_READ)
 		m = rcu_dereference(priv->match);
 	else
 		m = priv->clone;
-- 
2.30.2

