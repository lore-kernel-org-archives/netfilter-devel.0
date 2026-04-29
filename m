Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F3F30EF82
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 21:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777499766; cv=none; b=iqtW3duxGTNE0Ebfmr5W3EFwV/o6nbD8YA2kjuAzkVGjsk39w1pqQInhRR0wfEahJF8I6P8FE2b6X7kuHb7NEjdPPKamGT6CKUrjxPVLZFjB9Wipp3f10vvuI8GJ6nU0NezWY0/1LpZj4OSM26yzAj1wqK2Gl84hdpP5BHnwvtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777499766; c=relaxed/simple;
	bh=NXNMq9a1h0uiWbLB6twUoelkk7F0N9igbRmF5BshdjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjkDL0jXXsbWLAucjoWLr2gH74OnBU80BDVt+nrb5TgC+SPozMmAahfKuH36qGspHmqPYaaB94XRupXoe881y8Io1spstN/CJ0DiZToV6T42aVttGovltk4tTibISNQRLbT+skpYqnXLoLGX28/xnuh7Bcddd2jzJlZHWKc6znA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Fgt7Nqfy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Fgt7Nqfy"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4301660269;
	Wed, 29 Apr 2026 23:56:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777499762;
	bh=q+GQShBvMegxncMKMJWLwdqQu5Fq1P5ySPqngl58UsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fgt7NqfydZTAxJVOfJd/srAZ5yPh/ob0nD7t+6bWSjLNPG5ap4uJr5FxAShjO7G3i
	 N7uX4oLkLQwEzAUVQNqepJG9TJF0LqY8bnT/5KO5MUafmW6VFtf5U7yy471HgM6oWJ
	 vRKTF2D+nZGSlK8RlPTaKh6nWdwWXBMXt9ioyEACxzhbliQabtGCmr9nBfNl8pbUdg
	 bBvcS3rOQ2wAD9a772IcXVsBg8xwFXnVfbvbZWVNqqUlxyqY6nQXrmHOfpFj9ZOn7Y
	 8F/VLrrqkKKT9PFIAG8WH6vTg+9w8Sc7y5ZBvQ22rKlu0rewknjQz8wYxl1cnkh6KF
	 h6+x9eK1jobIg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v3 2/2] netfilter: nft_compat: run xt_check_hooks_{match,target}() from .validate
Date: Wed, 29 Apr 2026 23:55:57 +0200
Message-ID: <20260429215557.167114-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429215557.167114-1-pablo@netfilter.org>
References: <20260429215557.167114-1-pablo@netfilter.org>
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
v3: - remove redundant initialization of hook_mask in match
    - remove redundant check for hook_mask in match
    - adjust commit description to refer to check_hooks from .validate

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

