Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE36BE6F;
	Thu, 13 Jun 2024 01:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240561; cv=none; b=NhXTGLiVZeHJfKrO+Fbfm7L0lqV/J0YudqCdBXZf9E/nIk86GoKsJUTxht6rWimXmbGlKWdW6F7p+A3qt3X+56nIUKg0JUDntQ51yJE/9iCAl8MyWZLDDZ1esH75ZHR0xeYjkm4cJCMwnQUUCskx8kzialv6kerUqMwoBpZ7XHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240561; c=relaxed/simple;
	bh=C8krvC5ubs++errOOo9Co9buRCIf79uKPqL58P1GF1w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B8UNBHvdu+6vJgx5e+Cu1AG0KpVYcAIxzqd86Z1AOfTz/MqKqBhfpDrKCdPVfkIhKTtDS3/Tg3Ws5EwKhkkFDI1h7r2gt77/1RsPBPmwcsvXfgmVP7zI2el1uqvvV8xwbaGCqGBMGddhZMgrpGLkgY26gY7ZRW4315LLvR2M7pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 33/40] netfilter: nf_tables: validate NFPROTO_* family
Date: Thu, 13 Jun 2024 03:02:02 +0200
Message-Id: <20240613010209.104423-34-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 net/netfilter/nft_compat.c       | 12 ++++++++++++
 net/netfilter/nft_flow_offload.c |  5 +++++
 net/netfilter/nft_nat.c          |  5 +++++
 net/netfilter/nft_rt.c           |  5 +++++
 net/netfilter/nft_socket.c       |  5 +++++
 net/netfilter/nft_tproxy.c       |  5 +++++
 6 files changed, 37 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 763ba07a58ab..6b66518ef3f7 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -319,6 +319,12 @@ static int nft_target_validate(const struct nft_ctx *ctx,
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
@@ -560,6 +566,12 @@ static int nft_match_validate(const struct nft_ctx *ctx,
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
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index ec35a41c7262..c9b7841abc08 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -145,6 +145,11 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
 {
 	unsigned int hook_mask = (1 << NF_INET_FORWARD);
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	return nft_chain_validate_hooks(ctx->chain, hook_mask);
 }
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index aa6149cc8c87..e3fba4f63967 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -94,6 +94,11 @@ static int nft_nat_validate(const struct nft_ctx *ctx,
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
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index edce109ef4b0..149f9a112fe3 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -159,6 +159,11 @@ static int nft_rt_validate(const struct nft_ctx *ctx, const struct nft_expr *exp
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
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 7e4f7063f481..c7b78e4ef459 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -139,6 +139,11 @@ static int nft_socket_validate(const struct nft_ctx *ctx,
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
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index db780b5985ab..d9604a316600 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -293,6 +293,11 @@ static int nft_tproxy_validate(const struct nft_ctx *ctx,
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
 
-- 
2.30.2

