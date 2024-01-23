Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1819D5FEE1
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2024 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706026429; cv=none; b=XAcCsuxnHjvhP03cyk/Jfhoo4X3GY0w+0a12kPjXPr0e8RBIZtKS43ZLYouqvC+4aLoLd4DdG7Tv9ckw9xTEs/xNTRk0njUVvPH3Z2p3usICM/PXo6VoKdhaFrpzzOP3MOjiM+ttQZfiyj023ZOu2oJOGpqbieQZp1dLWM9V7VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706026429; c=relaxed/simple;
	bh=0YaB38ZuYh+h2sJPJ1y7UmH47LXvNTGEwuJFI2M9thg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=KlvfaI9yO5H5JaTzbjEOkwWnQUAnQFeJP7B+K+ZaAfy9Lmd4lYith5HK3RCfwQKK+iBv0RbGGS7bCpiKLgipnhV5nR0Vj4+oISrH1WFB9NvDwI0yTlKZu2eWcDe17DzdmJ2zFyUjXIEelcZRZkmqxdNlkVyN3ub0EwEPFRhccjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: validate NFPROTO_{IPV4,IPV6,INET} family
Date: Tue, 23 Jan 2024 17:13:33 +0100
Message-Id: <20240123161333.39189-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several expressions explicitly refer to NF_INET_* hook definitions
from expr->ops->validate, however, family is not validated.

Bail out with EOPNOTSUPP in case they are used from unsupported
families.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This is v1:

NF_INET_* and NF_NETDEV_* hook definitions overlap, and .validate refers to
hooks only in several expressions, not families.

- synproxy refers to NFPROTO_BRIDGE from eval path, however, .validate does
  not refer to bridge hooks.
- rt and socket might be already used from the ingress hooks, another
  possibility would be to update .validate to refer to these hooks explicitly.
- nft_compat's xt_target_check() and xt_match_check() calls already validate
  the family, but better reject this unfront.

compile tested only.

 net/netfilter/nft_compat.c       | 10 ++++++++++
 net/netfilter/nft_flow_offload.c |  5 +++++
 net/netfilter/nft_nat.c          |  5 +++++
 net/netfilter/nft_rt.c           |  5 +++++
 net/netfilter/nft_socket.c       |  5 +++++
 net/netfilter/nft_synproxy.c     |  5 +++++
 net/netfilter/nft_tproxy.c       |  5 +++++
 7 files changed, 40 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 5284cd2ad532..61f5498b73ef 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -350,6 +350,11 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 	unsigned int hook_mask = 0;
 	int ret;
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_BRIDGE)
+		return -EOPNOTSUPP;
+
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
@@ -595,6 +600,11 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 	unsigned int hook_mask = 0;
 	int ret;
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_BRIDGE)
+		return -EOPNOTSUPP;
+
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index ab3362c483b4..397351fa4d5f 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -384,6 +384,11 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
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
index 583885ce7232..808f5802c270 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -143,6 +143,11 @@ static int nft_nat_validate(const struct nft_ctx *ctx,
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
index 35a2c28caa60..24d977138572 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -166,6 +166,11 @@ static int nft_rt_validate(const struct nft_ctx *ctx, const struct nft_expr *exp
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
index 9ed85be79452..f30163e2ca62 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -242,6 +242,11 @@ static int nft_socket_validate(const struct nft_ctx *ctx,
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
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 13da882669a4..ebdb81eaafb0 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -253,6 +253,11 @@ static int nft_synproxy_validate(const struct nft_ctx *ctx,
 				 const struct nft_expr *expr,
 				 const struct nft_data **data)
 {
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	return nft_chain_validate_hooks(ctx->chain, (1 << NF_INET_LOCAL_IN) |
 						    (1 << NF_INET_FORWARD));
 }
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index ae15cd693f0e..71412adb73d4 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -316,6 +316,11 @@ static int nft_tproxy_validate(const struct nft_ctx *ctx,
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

