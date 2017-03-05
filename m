From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_tables: validate the expr explicitly after init successfully
Date: Sun,  5 Mar 2017 21:02:23 +0800
Message-ID: <1488718943-43346-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mproxygzc4.163.com ([218.107.63.212]:46307 "EHLO
        mproxygzc4.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751652AbdCES3T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2017 13:29:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

When we want to validate the expr's dependency or hooks, we must do two
things to accomplish it. First, write a X_validate callback function
and point ->validate to it. Second, call X_validate in init routine.
This is very common, such as fib, nat, reject expr and so on ...

It is a little ugly, since we will call X_validate in the expr's init
routine, it's better to do it in nf_tables_newexpr. So we can avoid to
do this again and again. After doing this, the second step listed above
is not useful anymore, remove them now.

Patch was tested by nftables/tests/py/nft-test.py and
nftables/tests/shell/run-tests.sh.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/bridge/netfilter/nft_reject_bridge.c |  6 +-----
 net/netfilter/nf_tables_api.c            | 11 +++++++++++
 net/netfilter/nft_compat.c               |  8 --------
 net/netfilter/nft_fib.c                  |  2 +-
 net/netfilter/nft_masq.c                 |  4 ----
 net/netfilter/nft_meta.c                 |  4 ----
 net/netfilter/nft_nat.c                  |  4 ----
 net/netfilter/nft_redir.c                |  4 ----
 net/netfilter/nft_reject.c               |  5 -----
 net/netfilter/nft_reject_inet.c          |  6 +-----
 10 files changed, 14 insertions(+), 40 deletions(-)

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 206dc26..346ef6b 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -375,11 +375,7 @@ static int nft_reject_bridge_init(const struct nft_ctx *ctx,
 				  const struct nlattr * const tb[])
 {
 	struct nft_reject *priv = nft_expr_priv(expr);
-	int icmp_code, err;
-
-	err = nft_reject_bridge_validate(ctx, expr, NULL);
-	if (err < 0)
-		return err;
+	int icmp_code;
 
 	if (tb[NFTA_REJECT_TYPE] == NULL)
 		return -EINVAL;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ff7304a..9479ab4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1780,8 +1780,19 @@ static int nf_tables_newexpr(const struct nft_ctx *ctx,
 			goto err1;
 	}
 
+	if (ops->validate) {
+		const struct nft_data *data = NULL;
+
+		err = ops->validate(ctx, expr, &data);
+		if (err < 0)
+			goto err2;
+	}
+
 	return 0;
 
+err2:
+	if (ops->destroy)
+		ops->destroy(ctx, expr);
 err1:
 	expr->ops = NULL;
 	return err;
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index c21e7eb..fab6bf3 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -230,10 +230,6 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	union nft_entry e = {};
 	int ret;
 
-	ret = nft_compat_chain_validate_dependency(target->table, ctx->chain);
-	if (ret < 0)
-		goto err;
-
 	target_compat_from_user(target, nla_data(tb[NFTA_TARGET_INFO]), info);
 
 	if (ctx->nla[NFTA_RULE_COMPAT]) {
@@ -419,10 +415,6 @@ nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	union nft_entry e = {};
 	int ret;
 
-	ret = nft_compat_chain_validate_dependency(match->table, ctx->chain);
-	if (ret < 0)
-		goto err;
-
 	match_compat_from_user(match, nla_data(tb[NFTA_MATCH_INFO]), info);
 
 	if (ctx->nla[NFTA_RULE_COMPAT]) {
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 29a4906..fd0b193 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -112,7 +112,7 @@ int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (err < 0)
 		return err;
 
-	return nft_fib_validate(ctx, expr, NULL);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_fib_init);
 
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 11ce016..6ac03d4 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -46,10 +46,6 @@ int nft_masq_init(const struct nft_ctx *ctx,
 	struct nft_masq *priv = nft_expr_priv(expr);
 	int err;
 
-	err = nft_masq_validate(ctx, expr, NULL);
-	if (err)
-		return err;
-
 	if (tb[NFTA_MASQ_FLAGS]) {
 		priv->flags = ntohl(nla_get_be32(tb[NFTA_MASQ_FLAGS]));
 		if (priv->flags & ~NF_NAT_RANGE_MASK)
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index e1f5ca9..d14417a 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -370,10 +370,6 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	err = nft_meta_set_validate(ctx, expr, NULL);
-	if (err < 0)
-		return err;
-
 	priv->sreg = nft_parse_register(tb[NFTA_META_SREG]);
 	err = nft_validate_register_load(priv->sreg, len);
 	if (err < 0)
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 19a7bf3..26a74df 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -138,10 +138,6 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 	}
 
-	err = nft_nat_validate(ctx, expr, NULL);
-	if (err < 0)
-		return err;
-
 	if (tb[NFTA_NAT_FAMILY] == NULL)
 		return -EINVAL;
 
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 40dcd05..1e66538 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -47,10 +47,6 @@ int nft_redir_init(const struct nft_ctx *ctx,
 	unsigned int plen;
 	int err;
 
-	err = nft_redir_validate(ctx, expr, NULL);
-	if (err < 0)
-		return err;
-
 	plen = FIELD_SIZEOF(struct nf_nat_range, min_addr.all);
 	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
 		priv->sreg_proto_min =
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index c64de3f7..29f5bd2 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -42,11 +42,6 @@ int nft_reject_init(const struct nft_ctx *ctx,
 		    const struct nlattr * const tb[])
 {
 	struct nft_reject *priv = nft_expr_priv(expr);
-	int err;
-
-	err = nft_reject_validate(ctx, expr, NULL);
-	if (err < 0)
-		return err;
 
 	if (tb[NFTA_REJECT_TYPE] == NULL)
 		return -EINVAL;
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 9e90a02..5a7fb5f 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -66,11 +66,7 @@ static int nft_reject_inet_init(const struct nft_ctx *ctx,
 				const struct nlattr * const tb[])
 {
 	struct nft_reject *priv = nft_expr_priv(expr);
-	int icmp_code, err;
-
-	err = nft_reject_validate(ctx, expr, NULL);
-	if (err < 0)
-		return err;
+	int icmp_code;
 
 	if (tb[NFTA_REJECT_TYPE] == NULL)
 		return -EINVAL;
-- 
2.5.5


