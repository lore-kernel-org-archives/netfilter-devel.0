Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108E41779BD;
	Fri, 27 Sep 2024 12:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439981; cv=none; b=scLDVboRNMQEsCTOgsuLc6Lc6LYMai0DOIi5wDZdGdG75cCI/gVPtuxE1mK+bDUJLAwZb6qHPXzWvzCxF9sl2o0tTwUbEiPm4S0gFa+EKj99A3A8m5/u8G2lMuO0yOsIjnkqQ+JhxNG5ayMSnakFpjlCZPobXC3zwENCnlAU2CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439981; c=relaxed/simple;
	bh=9Q+M9RQlsApJxGY1uSiuDckMtHUi7XSUUYMMeFVQqUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJXYiPSm10j8owak0gEmvJ4/b5pCOzz5WsdW919DjOpCCjvQ405BABd7uIK2Awnte1WRi5xM0SHUmOqFirJVbW6vHW+h11ZL0ZPIwabTtL3+E8WY95bftykrvvqJ9Yy9savq3dECAcFJtRIPRzdlFN0V0SHANYQtkubFDPPTVaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8H4OnV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8H4OnV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECA2C4CEC4;
	Fri, 27 Sep 2024 12:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439980;
	bh=9Q+M9RQlsApJxGY1uSiuDckMtHUi7XSUUYMMeFVQqUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8H4OnV7y30ami5lpmZtMat2lLhGzmEAiXzxdrtCDAz1uay9P5V+IMSju5kEWMARN
	 cVM9LOKn6gnNHprJK+6861z2D4mzwZyD0hvODY3W2rtRGas1/eiDOnDsX7uuLUPBQq
	 wJp31dpth+Do1meUMw6pjJOaoXZ/VqFRkwBBj4Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 45/54] netfilter: nft_set_pipapo: walk over current view on netlink dump
Date: Fri, 27 Sep 2024 14:23:37 +0200
Message-ID: <20240927121721.624073906@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -628,6 +628,7 @@ static void nft_map_deactivate(const str
 {
 	struct nft_set_iter iter = {
 		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_mapelem_deactivate,
 	};
 
@@ -5392,6 +5393,7 @@ int nf_tables_bind_set(const struct nft_
 		}
 
 		iter.genmask	= nft_genmask_next(ctx->net);
+		iter.type	= NFT_ITER_UPDATE;
 		iter.skip 	= 0;
 		iter.count	= 0;
 		iter.err	= 0;
@@ -5467,6 +5469,7 @@ static void nft_map_activate(const struc
 {
 	struct nft_set_iter iter = {
 		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_mapelem_activate,
 	};
 
@@ -5845,6 +5848,7 @@ static int nf_tables_dump_set(struct sk_
 	args.skb		= skb;
 	args.reset		= reset;
 	args.iter.genmask	= nft_genmask_cur(net);
+	args.iter.type		= NFT_ITER_READ;
 	args.iter.skip		= cb->args[0];
 	args.iter.count		= 0;
 	args.iter.err		= 0;
@@ -7246,6 +7250,7 @@ static int nft_set_flush(struct nft_ctx
 {
 	struct nft_set_iter iter = {
 		.genmask	= genmask,
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_setelem_flush,
 	};
 
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2037,13 +2037,14 @@ static void nft_pipapo_walk(const struct
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


