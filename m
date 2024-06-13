Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A986AFAE;
	Thu, 13 Jun 2024 11:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279145; cv=none; b=iN7MGFX6ECx1bju+LobV5Ye3LgMBLpgU5mNYxmYqzdsPZiDjPLU2PrMC3/4LxMqyCYf/jfyFogt1wKY/y6nDqasXll1xkAY6QRbpkLyGejyNOmE8Nmfa2cAhgLh030jMeVyISuf1seBsmmzA1V8GgoSql4nJy1NtF0BVYPUlYbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279145; c=relaxed/simple;
	bh=5BXeDsl+GZs+nLhawJu81Pn7rfzlBdUApm67O716qrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ei4Gd1OptSQaWsbsLsgnBYB/rj8MMxV6xjO5vjg6m7ol0rujQnimXV4D1WbgNU3mwayk2/kLT9w/1VGL5DV7j4l71hBfQi83PGhEmxImVqfaWGeW3++UeUApbwi8CtPlRcOzLOKlLDO/NwBHJS82wN6uukJKvnJN6Byqmmo9NJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=paR5GgXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="paR5GgXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5A1C32786;
	Thu, 13 Jun 2024 11:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279145;
	bh=5BXeDsl+GZs+nLhawJu81Pn7rfzlBdUApm67O716qrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=paR5GgXMRYPgl6sCbO4JKs9wa4ROjeUtGDEc/txAkuTE1fvd8vBd6urwiY73REsGn
	 Smbp/DY8LTg2TkzIrYmh7cR4VrLtvpH1ZvXdLllqaqzq8zbngAZVkKKmgeqBEsdibP
	 WKQVKLOUuLetd08Z7isLWSbjctnmKRuBor+r0tyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 191/213] netfilter: nf_tables: validate NFPROTO_* family
Date: Thu, 13 Jun 2024 13:33:59 +0200
Message-ID: <20240613113235.344610498@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d0009effa8862c20a13af4cb7475d9771b905693 ]

Several expressions explicitly refer to NF_INET_* hook definitions
from expr->ops->validate, however, family is not validated.

Bail out with EOPNOTSUPP in case they are used from unsupported
families.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Fixes: 2fa841938c64 ("netfilter: nf_tables: introduce routing expression")
Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Fixes: 6c47260250fc ("netfilter: nf_tables: add xfrm expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_compat.c       |   12 ++++++++++++
 net/netfilter/nft_flow_offload.c |    5 +++++
 net/netfilter/nft_nat.c          |    5 +++++
 net/netfilter/nft_rt.c           |    5 +++++
 net/netfilter/nft_socket.c       |    5 +++++
 net/netfilter/nft_tproxy.c       |    5 +++++
 6 files changed, 37 insertions(+)

--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -319,6 +319,12 @@ static int nft_target_validate(const str
 	unsigned int hook_mask = 0;
 	int ret;
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_BRIDGE &&
+	    ctx->family != NFPROTO_ARP)
+		return -EOPNOTSUPP;
+
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
@@ -560,6 +566,12 @@ static int nft_match_validate(const stru
 	unsigned int hook_mask = 0;
 	int ret;
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_BRIDGE &&
+	    ctx->family != NFPROTO_ARP)
+		return -EOPNOTSUPP;
+
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -145,6 +145,11 @@ static int nft_flow_offload_validate(con
 {
 	unsigned int hook_mask = (1 << NF_INET_FORWARD);
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	return nft_chain_validate_hooks(ctx->chain, hook_mask);
 }
 
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -94,6 +94,11 @@ static int nft_nat_validate(const struct
 	struct nft_nat *priv = nft_expr_priv(expr);
 	int err;
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	err = nft_chain_validate_dependency(ctx->chain, NFT_CHAIN_T_NAT);
 	if (err < 0)
 		return err;
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -159,6 +159,11 @@ static int nft_rt_validate(const struct
 	const struct nft_rt *priv = nft_expr_priv(expr);
 	unsigned int hooks;
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	switch (priv->key) {
 	case NFT_RT_NEXTHOP4:
 	case NFT_RT_NEXTHOP6:
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -139,6 +139,11 @@ static int nft_socket_validate(const str
 			       const struct nft_expr *expr,
 			       const struct nft_data **data)
 {
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	return nft_chain_validate_hooks(ctx->chain,
 					(1 << NF_INET_PRE_ROUTING) |
 					(1 << NF_INET_LOCAL_IN) |
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -293,6 +293,11 @@ static int nft_tproxy_validate(const str
 			       const struct nft_expr *expr,
 			       const struct nft_data **data)
 {
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	return nft_chain_validate_hooks(ctx->chain, 1 << NF_INET_PRE_ROUTING);
 }
 


