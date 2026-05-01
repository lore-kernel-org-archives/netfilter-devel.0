Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE443A16BE;
	Fri,  1 May 2026 12:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777638175; cv=none; b=NOqMrV2YTDtHh1m+h+Q5dTN0oEH9Jk2cwcyQqRvaShTnjxw+NlZVPls1kNADHfNOUSerBhbX7HkkABpPEowMcqJJtpWRocJTWmXE2HZbFdxoM17XBBC64AhjnJPfJCi0HpHRpGuxcUfez0A2QM05V9LIJb+9rgQLkncIBsfiJMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777638175; c=relaxed/simple;
	bh=VyKpaAA2RBDckXTxULVi0QivEocpX0HE9L2VwvwaSqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCQgzb9F7j/VpM3woPsSaKLEfOYLSjetVLQ9PMX8i/x43Xc5qYTSMxcjOqZRzWfg/90HjHoG5+vyzk9QTskCVdUzDdkZXJWdx5sZIGby8bgK9rrvC2I0imNT+goLH6etp42gpJ91NgllBiFCBmfBcy7Es0CDk/DURibbFrVlCxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cMALdZFB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cMALdZFB"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B71F2600B9;
	Fri,  1 May 2026 14:22:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777638169;
	bh=8VOGzSuOdaTqtVdfry2eeLh+IQQSH9RU5psBadMOzPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMALdZFBvrYUvCwSQMjGDqgvCnhgL8P64yH4GZlEmXlrCkGF5gL0gG2U+TCyt9Z4A
	 n0GCc9UZKeU2oHlUrjjO7QW305M1SEvbTxgUVP0+Q+DCsPoWUeZnUFMKLz0Z4RZSz5
	 IysjAe54GW2j4PqXzb6M4LwRKVWvhLB83tHCnlDTiS0Vh9srFv6CTE1N+jYINaf0+T
	 cEMWMM50e22gC7TUuZ/Swf4KfhipmzMOa+9gJQ8aHddukECm0KGigk9wvAErNLtV0T
	 WIcBBsENf9ANkQ0IAvB3Dw8bfbmGpwRhxoJ87KxDfl4PlT78m/PPPl8bHaN+Kz9b7B
	 05BJwaELi9GNw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 05/14] netfilter: nft_compat: run xt_check_hooks_{match,target}() from .validate
Date: Fri,  1 May 2026 14:22:28 +0200
Message-ID: <20260501122237.296262-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501122237.296262-1-pablo@netfilter.org>
References: <20260501122237.296262-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several matches and one target check that the hook is correct from
checkentry(), however, the basechain is only available from
nft_table_validate().

This patch uses xt_check_hooks_{match,target}() from the nft_compat
expression .validate path.

This patch sets the table in the nft_ctx struct in nft_table_validate()
which is required by this patch.

Based on patch from Florian Westphal.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |  1 +
 net/netfilter/nft_compat.c    | 45 +++++++++++++++++++++++++++--------
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d20ce5c36d31..38e33c66c618 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4205,6 +4205,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 	struct nft_chain *chain;
 	struct nft_ctx ctx = {
 		.net	= net,
+		.table	= (struct nft_table *)table,
 		.family	= table->family,
 	};
 	int err = 0;
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index decc725a33c2..0caa9304d2d0 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -261,10 +261,10 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			return ret;
 	}
 
-	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
-
 	nft_compat_wait_for_destructors(ctx->net);
 
+	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
+
 	ret = xt_check_target(&par, size, proto, inv);
 	if (ret < 0) {
 		if (ret == -ENOENT) {
@@ -353,8 +353,6 @@ static int nft_target_dump(struct sk_buff *skb,
 static int nft_target_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
-	struct xt_target *target = expr->ops->data;
-	unsigned int hook_mask = 0;
 	int ret;
 
 	if (ctx->family != NFPROTO_IPV4 &&
@@ -377,11 +375,21 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
 		const struct nf_hook_ops *ops = &basechain->ops;
+		unsigned int hook_mask = 1 << ops->hooknum;
+		struct xt_target *target = expr->ops->data;
+		void *info = nft_expr_priv(expr);
+		struct xt_tgchk_param par;
+		union nft_entry e = {};
 
-		hook_mask = 1 << ops->hooknum;
 		if (target->hooks && !(hook_mask & target->hooks))
 			return -EINVAL;
 
+		nft_target_set_tgchk_param(&par, ctx, target, info, &e, 0, false);
+
+		ret = xt_check_hooks_target(&par);
+		if (ret < 0)
+			return ret;
+
 		ret = nft_compat_chain_validate_dependency(ctx, target->table);
 		if (ret < 0)
 			return ret;
@@ -515,10 +523,10 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			return ret;
 	}
 
-	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
-
 	nft_compat_wait_for_destructors(ctx->net);
 
+	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
+
 	return xt_check_match(&par, size, proto, inv);
 }
 
@@ -614,8 +622,6 @@ static int nft_match_large_dump(struct sk_buff *skb,
 static int nft_match_validate(const struct nft_ctx *ctx,
 			      const struct nft_expr *expr)
 {
-	struct xt_match *match = expr->ops->data;
-	unsigned int hook_mask = 0;
 	int ret;
 
 	if (ctx->family != NFPROTO_IPV4 &&
@@ -638,11 +644,30 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
 		const struct nf_hook_ops *ops = &basechain->ops;
+		unsigned int hook_mask = 1 << ops->hooknum;
+		struct xt_match *match = expr->ops->data;
+		size_t size = XT_ALIGN(match->matchsize);
+		struct xt_mtchk_param par;
+		union nft_entry e = {};
+		void *info;
 
-		hook_mask = 1 << ops->hooknum;
 		if (match->hooks && !(hook_mask & match->hooks))
 			return -EINVAL;
 
+		if (NFT_EXPR_SIZE(size) > NFT_MATCH_LARGE_THRESH) {
+			struct nft_xt_match_priv *priv = nft_expr_priv(expr);
+
+			info = priv->info;
+		} else {
+			info = nft_expr_priv(expr);
+		}
+
+		nft_match_set_mtchk_param(&par, ctx, match, info, &e, 0, false);
+
+		ret = xt_check_hooks_match(&par);
+		if (ret < 0)
+			return ret;
+
 		ret = nft_compat_chain_validate_dependency(ctx, match->table);
 		if (ret < 0)
 			return ret;
-- 
2.47.3

