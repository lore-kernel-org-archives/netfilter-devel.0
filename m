Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A5537FF4B
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 17:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776706966; cv=none; b=LZUJR1SQiTsMmeUwrS1xzeK75C/SIZ6z7UOxWIgENjsx8xu/ynAVZmuWQWz+6AkKUV5dN3joKRtPnl/VY6ZjVjHsdY2pLxB6NlAxkOiUVpRfHefhFhMdMyeEg71HXcckVhG3uI951ZYTKuz8aZ0Jl5aV2yqBPwNXEw5M1Ky8vKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776706966; c=relaxed/simple;
	bh=OrXPi+VJZ2nGN6TxJMJ5CBnK/QM1zQdf5/lBVn8lCgk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PIPWmdvANsjolyVit7psql0HliT350ry8RSG/46Ep7jySXuGSFDMXOl4NSZnf+ukTGvMHaNipepBGipF8BQFY93qcDSfas1gZjIRQFYPWIINjaAa6Q/Pa4YyxVqdOqJpar/j8eevjk+PDlwZ+D51gXnPG6HUVpPxH8yu3FznYSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pDrxBY7K; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pDrxBY7K"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 036E160179;
	Mon, 20 Apr 2026 19:42:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776706955;
	bh=EB05TBiWRpQQ6qQttaDsrgBS7AXHBEctibsy/6kePaY=;
	h=From:To:Cc:Subject:Date:From;
	b=pDrxBY7KFvURO5z1hxqhJ4yYTIgjYoUr8bZjUh08COaWRdhEhQtSt5MHBC1wwMy8k
	 atAVv9h7PCqwHSweSSH3BBMV2dbmX/dhgDbTIpHTi9NIWZCT/OjGXIcsl03yBAEe9Z
	 XYPZpO6bEXOzQqE0ggv28AnRykH76wwhomex44mWt0fYMg5ldiGrEryZP+mcXUX2R8
	 BNeyg6BiFV1IHxSmd+H9JmC8Xpc3wqxwd3kxnz3CrTiVQBD/g4BVBwlUiFIcsDAkU8
	 9EPbQUiJyp1SYMf6EDPvtbpiDWLQJxtYwKJkb/eN/GLP3LYYUegwh6VY5jByNCBywQ
	 +2yESmZmChbng==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: nft_compat: run checkentry() from .validate
Date: Mon, 20 Apr 2026 19:42:27 +0200
Message-ID: <20260420174227.13087-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

The xt_match .destroy indirection is also called to restore the
xt_set refcounts that is performed by .checkentry. The remaining
extensions provide no .destroy interface.

This patch sets the table in the nft_ctx struct in nft_table_validate()
which is required by this patch.

The nft_compat_check_match() and nft_compat_check_target() helper
functions are added to wrap common code used from .init and .validate
path.

The protocol and inverse flags are set to always match from the
expression .validate path, this is already checked from the init path.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
A more self-contained alternative to Florian's:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260419104509.42196-1-fw@strlen.de/

 net/netfilter/nf_tables_api.c |   1 +
 net/netfilter/nft_compat.c    | 118 ++++++++++++++++++++++++++++------
 2 files changed, 100 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 00ccc0734ac9..070e97efe7d1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4196,6 +4196,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 	struct nft_chain *chain;
 	struct nft_ctx ctx = {
 		.net	= net,
+		.table	= (struct nft_table *)table,
 		.family	= table->family,
 	};
 	int err = 0;
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index decc725a33c2..2352505fb992 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -229,6 +229,20 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 	return 0;
 }
 
+static int nft_compat_check_target(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr,
+				   void *info, size_t size,
+				   u16 proto, bool inv)
+{
+	struct xt_target *target = expr->ops->data;
+	struct xt_tgchk_param par;
+	union nft_entry e = {};
+
+	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
+
+	return xt_check_target(&par, size, proto, inv);
+}
+
 static void nft_compat_wait_for_destructors(struct net *net)
 {
 	/* xtables matches or targets can have side effects, e.g.
@@ -244,13 +258,11 @@ static int
 nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		const struct nlattr * const tb[])
 {
-	void *info = nft_expr_priv(expr);
 	struct xt_target *target = expr->ops->data;
-	struct xt_tgchk_param par;
 	size_t size = XT_ALIGN(nla_len(tb[NFTA_TARGET_INFO]));
-	u16 proto = 0;
+	void *info = nft_expr_priv(expr);
 	bool inv = false;
-	union nft_entry e = {};
+	u16 proto = 0;
 	int ret;
 
 	target_compat_from_user(target, nla_data(tb[NFTA_TARGET_INFO]), info);
@@ -261,11 +273,9 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			return ret;
 	}
 
-	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
-
 	nft_compat_wait_for_destructors(ctx->net);
 
-	ret = xt_check_target(&par, size, proto, inv);
+	ret = nft_compat_check_target(ctx, expr, info, size, proto, inv);
 	if (ret < 0) {
 		if (ret == -ENOENT) {
 			const char *modname = NULL;
@@ -382,6 +392,26 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 		if (target->hooks && !(hook_mask & target->hooks))
 			return -EINVAL;
 
+		/* At least one target needs to validate hooks at checkentry()
+		 * stage because such validation depends on the match
+		 * configuration. This cannot be enabled for all matches,
+		 * because some of them perform more than simple validation,
+		 * such as bumping reference counter on objects.
+		 */
+		if (!strcmp(target->name, "TCPMSS")) {
+			struct xt_target *target = expr->ops->data;
+			size_t size = XT_ALIGN(target->targetsize);
+			void *info = nft_expr_priv(expr);
+
+			/* nft_target_init() already checked for protocol and
+			 * inverse, not available in this patch, lie here.
+			 */
+			ret = nft_compat_check_target(ctx, expr, info, size,
+						      target->proto, false);
+			if (ret < 0)
+				return ret;
+		}
+
 		ret = nft_compat_chain_validate_dependency(ctx, target->table);
 		if (ret < 0)
 			return ret;
@@ -494,17 +524,29 @@ static void match_compat_from_user(struct xt_match *m, void *in, void *out)
 		memset(out + m->matchsize, 0, pad);
 }
 
+static int nft_compat_check_match(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr,
+				  void *info, size_t size,
+				  u16 proto, bool inv)
+{
+	struct xt_match *match = expr->ops->data;
+	struct xt_mtchk_param par;
+	union nft_entry e = {};
+
+	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
+
+	return xt_check_match(&par, size, proto, inv);
+}
+
 static int
 __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		 const struct nlattr * const tb[],
 		 void *info)
 {
-	struct xt_match *match = expr->ops->data;
-	struct xt_mtchk_param par;
 	size_t size = XT_ALIGN(nla_len(tb[NFTA_MATCH_INFO]));
-	u16 proto = 0;
+	struct xt_match *match = expr->ops->data;
 	bool inv = false;
-	union nft_entry e = {};
+	u16 proto = 0;
 	int ret;
 
 	match_compat_from_user(match, nla_data(tb[NFTA_MATCH_INFO]), info);
@@ -515,11 +557,9 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			return ret;
 	}
 
-	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
-
 	nft_compat_wait_for_destructors(ctx->net);
 
-	return xt_check_match(&par, size, proto, inv);
+	return nft_compat_check_match(ctx, expr, info, size, proto, inv);
 }
 
 static int
@@ -547,12 +587,9 @@ nft_match_large_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	return ret;
 }
 
-static void
-__nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr,
-		    void *info)
+static void nft_mt_destroy(const struct nft_ctx *ctx, struct xt_match *match,
+			   void *info)
 {
-	struct xt_match *match = expr->ops->data;
-	struct module *me = match->me;
 	struct xt_mtdtor_param par;
 
 	par.net = ctx->net;
@@ -561,7 +598,16 @@ __nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	par.family = ctx->family;
 	if (par.match->destroy != NULL)
 		par.match->destroy(&par);
+}
 
+static void
+__nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr,
+		    void *info)
+{
+	struct xt_match *match = expr->ops->data;
+	struct module *me = match->me;
+
+	nft_mt_destroy(ctx, match, info);
 	__nft_mt_tg_destroy(me, expr);
 }
 
@@ -643,6 +689,40 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 		if (match->hooks && !(hook_mask & match->hooks))
 			return -EINVAL;
 
+		/* Several matches need to validate hooks at checkentry() stage
+		 * because such validation depends on the match configuration.
+		 */
+		if (!strcmp(match->name, "addrtype") ||
+		    !strcmp(match->name, "devgroup") ||
+		    !strcmp(match->name, "physdev") ||
+		    !strcmp(match->name, "policy") ||
+		    !strcmp(match->name, "set")) {
+			struct xt_match *match = expr->ops->data;
+			size_t size = XT_ALIGN(match->matchsize);
+			void *info;
+
+			if (NFT_EXPR_SIZE(size) > NFT_MATCH_LARGE_THRESH) {
+				struct nft_xt_match_priv *priv = nft_expr_priv(expr);
+
+				info = priv->info;
+			} else {
+				info = nft_expr_priv(expr);
+			}
+
+			/* __nft_match_init() already checked for protocol and
+			 * inverse, not available in this patch, lie here.
+			 */
+			ret = nft_compat_check_match(ctx, expr, info, size,
+						     match->proto, false);
+			if (ret < 0)
+				return ret;
+
+			 /* The set match bumps reference count, restore after
+			  * this checkentry call.
+			  */
+			nft_mt_destroy(ctx, match, info);
+		}
+
 		ret = nft_compat_chain_validate_dependency(ctx, match->table);
 		if (ret < 0)
 			return ret;
-- 
2.47.3

