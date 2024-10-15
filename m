Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8A61EF0BA;
	Tue, 15 Oct 2024 11:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992423; cv=none; b=B0TyeMr1d8eqgYbqYBCbY2p2XKNrPGAJR0t27KJSbvBQv4PDJcFeoiTnqa9f+Gy7kJZrpqdtW7e2xCqiUKP2vHt6SlmBcRaOXb7RbnCTJOa1r2LJg1w++WtgrKdTpSWIEhmT9SG82YEdDqUiBsgB66fCzvhIzuF9r678qc4rI3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992423; c=relaxed/simple;
	bh=kddfD/BmLiDTAcngKgHqN0E7JTN4f2KGFRtcEf5cVxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FL6Ay7vLjNyBy05Qx6ktawy1rhlVA/nZhGj1J6bp9Iq99PIHzyi5aeGvSNks3OaK8lqbx5zmrYnwI38/c6hOx/iDYgfpRaSTTzyyuE2G/MKF6vYjh2SB07ho99n1cdmatAze+WPRizD47SC9TPpdfAahGDQ08C8+vxWAQW0Mu7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfT78Dzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfT78Dzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11112C4CEC6;
	Tue, 15 Oct 2024 11:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992423;
	bh=kddfD/BmLiDTAcngKgHqN0E7JTN4f2KGFRtcEf5cVxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfT78Dzlq1PMngXE3flHiiYGqRjYBKfHb6REdwNQGFbq+0A8zYhZKzUaqMjyAqtcC
	 NECwgDDUclabuDlIKG90agpOw5qphIu8BOs0GDEzQ3XvvO5B46jizAFMDETNNTbNXT
	 dRomleWvoqG30pyAHJvzqX4MBQ5k4YMpqgE7TZTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 081/691] netfilter: nft_set_pipapo: walk over current view on netlink dump
Date: Tue, 15 Oct 2024 13:20:29 +0200
Message-ID: <20241015112443.571253697@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -283,9 +283,22 @@ struct nft_set_elem {
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
 
@@ -5073,6 +5074,7 @@ int nf_tables_bind_set(const struct nft_
 		}
 
 		iter.genmask	= nft_genmask_next(ctx->net);
+		iter.type	= NFT_ITER_UPDATE;
 		iter.skip 	= 0;
 		iter.count	= 0;
 		iter.err	= 0;
@@ -5148,6 +5150,7 @@ static void nft_map_activate(const struc
 {
 	struct nft_set_iter iter = {
 		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_mapelem_activate,
 	};
 
@@ -5504,6 +5507,7 @@ static int nf_tables_dump_set(struct sk_
 	args.cb			= cb;
 	args.skb		= skb;
 	args.iter.genmask	= nft_genmask_cur(net);
+	args.iter.type		= NFT_ITER_READ;
 	args.iter.skip		= cb->args[0];
 	args.iter.count		= 0;
 	args.iter.err		= 0;
@@ -6833,6 +6837,7 @@ static int nft_set_flush(struct nft_ctx
 {
 	struct nft_set_iter iter = {
 		.genmask	= genmask,
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_setelem_flush,
 	};
 
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2042,13 +2042,14 @@ static void nft_pipapo_walk(const struct
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


