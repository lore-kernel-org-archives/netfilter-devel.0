Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDB92F9998
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 22:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777414254; cv=none; b=ckirvsvsdAhpxYK2NVuokm8zL3Hy/bJ/tFN+kJD7yb6KTJGIwaYwDHWcv2+xg2VbiND0+4CB2bQJ1dmDqPMTBSevn1pWgMNXLw+oedlGT33LD2N6crrH2KKzJ22Dyup6hqnXRHqufKB5XkODSFeQfOa48gs+yZWtWMdMgxjy4yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777414254; c=relaxed/simple;
	bh=1DOv+hF/ml+LuMMqUVgBwdezXXekibkRwn04pAl6A/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGr1pFHheLV5ODUbJiqtrWUG63vrC6+K3a7tpchTQEe6ukM9XfnFVlsLq1QoEUBILee70pyAGlbvZO4CRNV2nwHeqDmjBizHGzGTiPN4YRQrg1pU1LRR8ScYwx52uYaF+FLkiZ3VolR0YlC5YAja9FM3Fsk9cCs8C5fxnBEghMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VFrR+kpP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VFrR+kpP"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4F62760253;
	Wed, 29 Apr 2026 00:10:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777414244;
	bh=4lGdNNUubkhDVueTsynt9Wc868CSMqIOu5zt5WfEplM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFrR+kpPNWsKXq92xNq6mGD/9hy6/Shs6uUWb+A0l3yWZZ7y0HOQNViSViwrDZKTP
	 Dhq/RUO2ZvDZSHXd54egIs6n5J6Q8b/DMEZgta14Kh7KTrMrnK7QS+DseqF8PhtJL1
	 SuX+ovVe7nte/jw05oqAYXLZGl6dCTFP7J1UPUitSjT/XYj3bX/d+Kulb2lNVPNNWj
	 13Ef66OsWVm78E8kh80Csd9rInLRx4/N/DPyzD40h2aM0CC27MKnhsSPD+nhTbZX88
	 4n52khUwCRS3UwTaf8WtPfSq2hQF0jtFVeXJ2+GHdqtMnfcu0sn1D/0IAtpd1O59r5
	 uRcoife+rAAfA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf 2/2] netfilter: nft_compat: run checkentry() from .validate
Date: Wed, 29 Apr 2026 00:10:38 +0200
Message-ID: <20260428221038.96012-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428221038.96012-1-pablo@netfilter.org>
References: <20260428221038.96012-1-pablo@netfilter.org>
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

This patch calls checkentry() for matches and targets from the
nft_compat expression .validate path for the following matches/target:

- addrtype
- devgroup
- physdev
- policy
- set
- TCPMSS
- SET

The .destroy indirection is also called to restore the xt_set refcounts
that is performed by .checkentry. The remaining extensions provide no
.destroy interface.

This patch sets the table in the nft_ctx struct in nft_table_validate()
which is required by this patch.

The nft_compat_check_match() and nft_compat_check_target() helper
functions are added to wrap common code used from .init and .validate
path.

The protocol and inverse flags are set to always match from the
expression .validate path, this is already checked from the init path.

Based on patch from Florian Westphal.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |  1 +
 net/netfilter/nft_compat.c    | 58 ++++++++++++++++++++++++++++++++---
 2 files changed, 55 insertions(+), 4 deletions(-)

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
index decc725a33c2..0c4315b66b09 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -261,9 +261,17 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			return ret;
 	}
 
+	nft_compat_wait_for_destructors(ctx->net);
+
 	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
 
-	nft_compat_wait_for_destructors(ctx->net);
+	if (nft_is_base_chain(ctx->chain)) {
+		if (target->hooks && !(par.hook_mask & target->hooks))
+			return -EINVAL;
+
+		if (xt_check_hooks_target(&par) < 0)
+			return -EOPNOTSUPP;
+	}
 
 	ret = xt_check_target(&par, size, proto, inv);
 	if (ret < 0) {
@@ -353,7 +361,6 @@ static int nft_target_dump(struct sk_buff *skb,
 static int nft_target_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
-	struct xt_target *target = expr->ops->data;
 	unsigned int hook_mask = 0;
 	int ret;
 
@@ -377,11 +384,20 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
 		const struct nf_hook_ops *ops = &basechain->ops;
+		struct xt_target *target = expr->ops->data;
+		void *info = nft_expr_priv(expr);
+		struct xt_tgchk_param par;
+		union nft_entry e = {};
 
 		hook_mask = 1 << ops->hooknum;
 		if (target->hooks && !(hook_mask & target->hooks))
 			return -EINVAL;
 
+		nft_target_set_tgchk_param(&par, ctx, target, info, &e, 0, false);
+
+		if (xt_check_hooks_target(&par) < 0)
+			return -EOPNOTSUPP;
+
 		ret = nft_compat_chain_validate_dependency(ctx, target->table);
 		if (ret < 0)
 			return ret;
@@ -515,9 +531,18 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			return ret;
 	}
 
+	nft_compat_wait_for_destructors(ctx->net);
+
 	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
 
-	nft_compat_wait_for_destructors(ctx->net);
+	if (nft_is_base_chain(ctx->chain)) {
+		if (match->hooks && !(par.hook_mask & match->hooks))
+			return -EINVAL;
+
+		ret = xt_check_hooks_match(&par);
+		if (ret < 0)
+			return ret;
+	}
 
 	return xt_check_match(&par, size, proto, inv);
 }
@@ -614,7 +639,6 @@ static int nft_match_large_dump(struct sk_buff *skb,
 static int nft_match_validate(const struct nft_ctx *ctx,
 			      const struct nft_expr *expr)
 {
-	struct xt_match *match = expr->ops->data;
 	unsigned int hook_mask = 0;
 	int ret;
 
@@ -638,11 +662,37 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
 		const struct nf_hook_ops *ops = &basechain->ops;
+		struct xt_match *match = expr->ops->data;
+		size_t size = XT_ALIGN(match->matchsize);
+		void *info;
 
 		hook_mask = 1 << ops->hooknum;
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
+		if (nft_is_base_chain(ctx->chain)) {
+			unsigned int hook_mask = 1 << ops->hooknum;
+			struct xt_mtchk_param par;
+			union nft_entry e = {};
+
+			if (match->hooks && !(hook_mask & match->hooks))
+				return -EINVAL;
+
+			nft_match_set_mtchk_param(&par, ctx, match, info, &e, 0, false);
+
+			ret = xt_check_hooks_match(&par);
+			if (ret < 0)
+				return ret;
+		}
+
 		ret = nft_compat_chain_validate_dependency(ctx, match->table);
 		if (ret < 0)
 			return ret;
-- 
2.47.3

