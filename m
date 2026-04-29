Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80BC2DCC01
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476369; cv=none; b=H61qcrDIyoV5octqFEeUjU2B8mzFq4zi8KWcDKKT5WaXv7TPD2CVfTSJrTzFCsG3/wTf6QCqdEHoVckK989m9voMKISMRUqB5oB6N0nBUgIEWLIcqc2sv7ljTauOkW9yZtoOmdy+akcSWg2X24omxQhjMgPtxl9DJkLVrDHhu6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476369; c=relaxed/simple;
	bh=Umcneb7Y//h078JMal5FI+uoQyv5I91mm6ubKzapc4c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VC5muvUsBKslZDyydan0eUHI19f4CCl0mnCAdxisNpcmqtluvOHCEyYL8E/paOPiTY0quG4nQWsXKcE6t8EgenL/v5H/C/CwDdz7AnpGsdnZ1uyw8T+S+CNt34DoSnl1C3r0CSi2Jug12S32lPAXTOcpCgmL1najYazDciSHEl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SekMvTak; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SekMvTak"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6BC336017D
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 17:26:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777476360;
	bh=qrJtttSJRYPZaz5mS1g8li2PMSCTwS54f1THScU7C9A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SekMvTakE0MB/Sv6sHkKSG4BY0pTbNGkabZ4G+0Uuje9iA8ODGYONEQ86AIrfiZ0T
	 Z72uLNycD5qpavwSNsUIkldpdDR05x4vWm1QWAj/hctlDZhaer15uA8FB8ENKIPOpm
	 T7CRFbT6VX8ZBK8j1hrzvK6ecWUxXxFygs3s/vNctKOnPrAPKfwkcBc5jeXVxgIBWC
	 yFaCgFtIfN4iVVKmarwhUQVhJabwhnlfOx9CJvzlsdSsjRDYhozB+XrpbjvJ6vcd/I
	 cVHFZp74Bf1EgANQ00BmUuYNnORhl9hJ35n2q94wf6tqhd7inukKrtcudUmKlEPKB0
	 VXVG6zknGlkjA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 RESEND 2/2] netfilter: nft_compat: run checkentry() from .validate
Date: Wed, 29 Apr 2026 17:25:55 +0200
Message-ID: <20260429152555.150390-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429152555.150390-1-pablo@netfilter.org>
References: <20260429152555.150390-1-pablo@netfilter.org>
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

This patch uses .check_hooks() for matches and targets from the
nft_compat expression .validate path.

This patch sets the table in the nft_ctx struct in nft_table_validate()
which is required by this patch.

Based on patch from Florian Westphal.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
resend of v2, sashiko failed to apply this v2 series, let's see if this
gives it another chance to make it.

 net/netfilter/nf_tables_api.c |  1 +
 net/netfilter/nft_compat.c    | 44 +++++++++++++++++++++++++++++------
 2 files changed, 38 insertions(+), 7 deletions(-)

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
index decc725a33c2..abdf3aad0928 100644
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
@@ -353,7 +353,6 @@ static int nft_target_dump(struct sk_buff *skb,
 static int nft_target_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
-	struct xt_target *target = expr->ops->data;
 	unsigned int hook_mask = 0;
 	int ret;
 
@@ -377,11 +376,21 @@ static int nft_target_validate(const struct nft_ctx *ctx,
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
+		ret = xt_check_hooks_target(&par);
+		if (ret < 0)
+			return ret;
+
 		ret = nft_compat_chain_validate_dependency(ctx, target->table);
 		if (ret < 0)
 			return ret;
@@ -515,10 +524,10 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			return ret;
 	}
 
-	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
-
 	nft_compat_wait_for_destructors(ctx->net);
 
+	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
+
 	return xt_check_match(&par, size, proto, inv);
 }
 
@@ -614,8 +623,6 @@ static int nft_match_large_dump(struct sk_buff *skb,
 static int nft_match_validate(const struct nft_ctx *ctx,
 			      const struct nft_expr *expr)
 {
-	struct xt_match *match = expr->ops->data;
-	unsigned int hook_mask = 0;
 	int ret;
 
 	if (ctx->family != NFPROTO_IPV4 &&
@@ -638,11 +645,34 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
 		const struct nf_hook_ops *ops = &basechain->ops;
+		unsigned int hook_mask = 1 << ops->hooknum;
+		struct xt_match *match = expr->ops->data;
+		size_t size = XT_ALIGN(match->matchsize);
+		struct xt_mtchk_param par;
+		union nft_entry e = {};
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
+		if (match->hooks && !(hook_mask & match->hooks))
+			return -EINVAL;
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

