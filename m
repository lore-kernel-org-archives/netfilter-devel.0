Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0433822B5;
	Fri, 19 Jun 2026 11:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870114; cv=none; b=DibM36O9Iv+XO4Kv95X+Zc1ifMeW7dF3PVKfc1V34z0u6/xyJwUOgzTxPKljsAo0LrfP65Zg4Kwog7F4s4xsIaWxLNv+zKjNdXUDpUsJq2jrddb4mN8PaZe4IBEl8X5/6WERUmYcwFrE5wPRbLGXGPcyqxunwrotd064e0Ae9p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870114; c=relaxed/simple;
	bh=XvvirPHKhJ9uRANtfuw9OHcFnyv53jw7CRIxBRbywS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1N2uCQwnhuL+Qb2GjqoHudgWE4wQStXjf/IeaHIyQa8vpsr0NhEzCwfXrbks50CAZTXlKOtaH5IRzLmGcfbu86O5w/SwQDRsiCdjKyizovD1ZVxgK8YF8G3rwkQeJrk3EQgj0ZduoAWOeT0XuQQ1QASqu5owffBVAtIJryvqtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gh50Ek2I; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gh50Ek2I"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 93B24601A7;
	Fri, 19 Jun 2026 13:55:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781870112;
	bh=+p5qRgjjFHKmH5pJYZ9bSIzcvP0tEaHT0HqsMFAHGz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gh50Ek2I9Ni3tPVSc/jf+gItgJy1Tn4A0YqT+wQxrIVwq3vL6867BPu2dbcw8xdJZ
	 62PFz/T5czk6OH8EauOWM5luRRURbvMJdD3kys4eY/neDW4WbvxXZnjZ6KWPTd8a3t
	 5W7cRv2f9ucdBoYp9Ya0Dqt0qU+TZwiHW63vhUdoGDI7I2VfavqFV8qziG5zmUUtG8
	 1rghrhxBcLZwkMgyhFS1HdQBufqSW7oPO1T8PSBs4TErOTUUUJUU1Vj3Mv49TM1yN/
	 GYR/mAV9G28OosART4JKRKw1dcPwDodWvsZAtihqJN9EDuK17kFOHyD7OrvR90xHCR
	 HFsZ71Jm+hP6g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 11/16] netfilter: nft_meta_bridge: add validate callback for get operations
Date: Fri, 19 Jun 2026 13:54:46 +0200
Message-ID: <20260619115452.93949-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619115452.93949-1-pablo@netfilter.org>
References: <20260619115452.93949-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Blamed commit added NFT_META_BRI_IIFHWADDR to the set validate callback,
yet this is a get operation.

Add a get validate callback and move the NFT_META_BRI_IIFHWADDR key
there.

AFAICS this is harmless, NFT_META_BRI_IIFHWADDR can deal with a NULL
input device and the set handler ignores a NFT_META_BRI_IIFHWADDR
operation, but it allows to read 4 bytes off bridge skb->cb[].

Fixes: cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nft_meta.h       |  2 ++
 net/bridge/netfilter/nft_meta_bridge.c | 19 ++++++++++++++++++-
 net/netfilter/nft_meta.c               |  5 +++--
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index f74e63290603..6cf1d910bbf8 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -40,6 +40,8 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 void nft_meta_set_destroy(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr);
 
+int nft_meta_get_validate(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr);
 int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr);
 
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 219c40680260..3d95f68e0906 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -107,12 +107,30 @@ static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
 					NULL, NFT_DATA_VALUE, len);
 }
 
+static int nft_meta_bridge_get_validate(const struct nft_ctx *ctx,
+					const struct nft_expr *expr)
+{
+	struct nft_meta *priv = nft_expr_priv(expr);
+	unsigned int hooks;
+
+	switch (priv->key) {
+	case NFT_META_BRI_IIFHWADDR:
+		hooks = 1 << NF_BR_PRE_ROUTING;
+		break;
+	default:
+		return nft_meta_get_validate(ctx, expr);
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
+}
+
 static struct nft_expr_type nft_meta_bridge_type;
 static const struct nft_expr_ops nft_meta_bridge_get_ops = {
 	.type		= &nft_meta_bridge_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
 	.eval		= nft_meta_bridge_get_eval,
 	.init		= nft_meta_bridge_get_init,
+	.validate	= nft_meta_bridge_get_validate,
 	.dump		= nft_meta_get_dump,
 };
 
@@ -168,7 +186,6 @@ static int nft_meta_bridge_set_validate(const struct nft_ctx *ctx,
 
 	switch (priv->key) {
 	case NFT_META_BRI_BROUTE:
-	case NFT_META_BRI_IIFHWADDR:
 		hooks = 1 << NF_BR_PRE_ROUTING;
 		break;
 	default:
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 9b5821c64442..0a43e0787a68 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -635,8 +635,8 @@ static int nft_meta_get_validate_xfrm(const struct nft_ctx *ctx)
 #endif
 }
 
-static int nft_meta_get_validate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr)
+int nft_meta_get_validate(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -652,6 +652,7 @@ static int nft_meta_get_validate(const struct nft_ctx *ctx,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nft_meta_get_validate);
 
 int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr)
-- 
2.47.3

