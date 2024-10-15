Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4821C07DE;
	Tue, 15 Oct 2024 12:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996943; cv=none; b=M4OkHaMw3l+9EeSiYQIA2rH5644yAjZIWvapnpsLWdiGWsyrX2w4OT1hxuZQTyN7s+G9d//UGi6PGs5fmbWMB5qxYhnTnO3rCWF7ydVr1qegMwxV6npUBFYsoBfuXpRlavmJgJGCyoymxzwbydKxP88pzyTSiidp1IZhapFbJgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996943; c=relaxed/simple;
	bh=1cEzU8oTbACOtQQlDZeHdqr5iIvjdMgkD/p+BkZXWb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqdFfdYXQ6KC3F2VqgqALnyhAlR27CHxRR35rNA71rPdlnNvrc6wM0MMEgxy3QjmdjjVgai2kTCruEbZu9gEb42xcON62D0LQqJzeyRY867aUOJxFMxVVn95nwgUkFAiSCRsUW9anLxoAJG7MQ9cELE+s8NhJVD2SuNgMdjen8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBLbz0pG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBLbz0pG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3721C4CEC6;
	Tue, 15 Oct 2024 12:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996943;
	bh=1cEzU8oTbACOtQQlDZeHdqr5iIvjdMgkD/p+BkZXWb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBLbz0pGH4qAJLXeyIPEqnkpefKRvdXUA82kDcENF4ULplgC6iFTbsX9yeOK/3F/h
	 xpsL8wwv/VRtZSVrTVXBoYG8vORT7/Dh7xZx5uLWCvSu5dB+y+wOTB6NmQI/Kpeyzn
	 pzmjYsBEV3+/Adtc8tRbeU3xsCoTZCgK33SZjc7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 045/518] netfilter: nft_set_pipapo: walk over current view on netlink dump
Date: Tue, 15 Oct 2024 14:39:09 +0200
Message-ID: <20241015123918.750351261@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 29b359cf6d95fd60730533f7f10464e95bd17c73 upstream.

The generation mask can be updated while netlink dump is in progress.
The pipapo set backend walk iterator cannot rely on it to infer what
view of the datastructure is to be used. Add notation to specify if user
wants to read/update the set.

Based on patch from Florian Westphal.

Fixes: 2b84e215f874 ("netfilter: nft_set_pipapo: .walk does not deal with generations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |   13 +++++++++++++
 net/netfilter/nf_tables_api.c     |    5 +++++
 net/netfilter/nft_set_pipapo.c    |    5 +++--
 3 files changed, 21 insertions(+), 2 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -262,9 +262,22 @@ struct nft_set_elem {
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
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -594,6 +594,7 @@ static void nft_map_deactivate(const str
 {
 	struct nft_set_iter iter = {
 		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_mapelem_deactivate,
 	};
 
@@ -4777,6 +4778,7 @@ int nf_tables_bind_set(const struct nft_
 		}
 
 		iter.genmask	= nft_genmask_next(ctx->net);
+		iter.type	= NFT_ITER_UPDATE;
 		iter.skip 	= 0;
 		iter.count	= 0;
 		iter.err	= 0;
@@ -4830,6 +4832,7 @@ static void nft_map_activate(const struc
 {
 	struct nft_set_iter iter = {
 		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_mapelem_activate,
 	};
 
@@ -5142,6 +5145,7 @@ static int nf_tables_dump_set(struct sk_
 	args.cb			= cb;
 	args.skb		= skb;
 	args.iter.genmask	= nft_genmask_cur(net);
+	args.iter.type		= NFT_ITER_READ;
 	args.iter.skip		= cb->args[0];
 	args.iter.count		= 0;
 	args.iter.err		= 0;
@@ -6065,6 +6069,7 @@ static int nf_tables_delsetelem(struct n
 	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL) {
 		struct nft_set_iter iter = {
 			.genmask	= genmask,
+			.type		= NFT_ITER_UPDATE,
 			.fn		= nft_flush_set,
 		};
 		set->ops->walk(&ctx, set, &iter);
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2026,13 +2026,14 @@ static void nft_pipapo_walk(const struct
 			    struct nft_set_iter *iter)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
-	struct net *net = read_pnet(&set->net);
 	struct nft_pipapo_match *m;
 	struct nft_pipapo_field *f;
 	int i, r;
 
+	WARN_ON_ONCE(iter->type == NFT_ITER_UNSPEC);
+
 	rcu_read_lock();
-	if (iter->genmask == nft_genmask_cur(net))
+	if (iter->type == NFT_ITER_READ)
 		m = rcu_dereference(priv->match);
 	else
 		m = priv->clone;


