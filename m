From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] netfilter: nft_numgen: add counter offset value and rename
 until by modulus
Date: Fri, 2 Sep 2016 10:39:37 +0200
Message-ID: <20160902083935.GA10237@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36005 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751647AbcIBIjm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 04:39:42 -0400
Received: by mail-wm0-f65.google.com with SMTP id i138so1894491wmf.3
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Sep 2016 01:39:41 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id i80sm2474241wmf.11.2016.09.02.01.39.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 02 Sep 2016 01:39:39 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for an initialization counter value. With this option the
sysadmin is able to start the counter when used with the increment
type.

Example:

	meta mark set numgen inc mod 2 sum 100

This will generate marks with the serie 100, 101, 100, 101, ...

The _until_ attribute is renamed to _modulus_ as the behaviour is similar to
other expresions with number limits(ex. nft_hash).

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  6 ++++--
 net/netfilter/nft_numgen.c               | 37 ++++++++++++++++++--------------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index e941139..4dbeeed 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1151,14 +1151,16 @@ enum nft_trace_types {
  *			    attributes
  *
  * @NFTA_NG_DREG: destination register (NLA_U32)
- * @NFTA_NG_UNTIL: source value to increment the counter until reset (NLA_U32)
+ * @NFTA_NG_MODULUS: maximum counter value (NLA_U32)
  * @NFTA_NG_TYPE: operation type (NLA_U32)
+ * @NFTA_NG_SUM: Offset to initiate the counter (NLA_U32)
  */
 enum nft_ng_attributes {
 	NFTA_NG_UNSPEC,
 	NFTA_NG_DREG,
-	NFTA_NG_UNTIL,
+	NFTA_NG_MODULUS,
 	NFTA_NG_TYPE,
+	NFTA_NG_SUM,
 	__NFTA_NG_MAX
 };
 #define NFTA_NG_MAX	(__NFTA_NG_MAX - 1)
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index e1d5a11..bfde6d0 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -21,7 +21,7 @@ static DEFINE_PER_CPU(struct rnd_state, nft_numgen_prandom_state);
 
 struct nft_ng_inc {
 	enum nft_registers      dreg:8;
-	u32			until;
+	u32			modulus;
 	atomic_t		counter;
 };
 
@@ -34,7 +34,7 @@ static void nft_ng_inc_eval(const struct nft_expr *expr,
 
 	do {
 		oval = atomic_read(&priv->counter);
-		nval = (oval + 1 < priv->until) ? oval + 1 : 0;
+		nval = (oval + 1 < priv->modulus) ? oval + 1 : 0;
 	} while (atomic_cmpxchg(&priv->counter, oval, nval) != oval);
 
 	memcpy(&regs->data[priv->dreg], &priv->counter, sizeof(u32));
@@ -42,8 +42,9 @@ static void nft_ng_inc_eval(const struct nft_expr *expr,
 
 const struct nla_policy nft_ng_policy[NFTA_NG_MAX + 1] = {
 	[NFTA_NG_DREG]		= { .type = NLA_U32 },
-	[NFTA_NG_UNTIL]		= { .type = NLA_U32 },
+	[NFTA_NG_MODULUS]	= { .type = NLA_U32 },
 	[NFTA_NG_TYPE]		= { .type = NLA_U32 },
+	[NFTA_NG_SUM]		= { .type = NLA_U32 },
 };
 
 static int nft_ng_inc_init(const struct nft_ctx *ctx,
@@ -51,27 +52,31 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_ng_inc *priv = nft_expr_priv(expr);
+	u32 sum = 0;
 
-	priv->until = ntohl(nla_get_be32(tb[NFTA_NG_UNTIL]));
-	if (priv->until == 0)
+	if (tb[NFTA_NG_SUM])
+		sum = ntohl(nla_get_be32(tb[NFTA_NG_SUM]));
+
+	priv->modulus = ntohl(nla_get_be32(tb[NFTA_NG_MODULUS]));
+	if (priv->modulus == 0 || sum >= priv->modulus)
 		return -ERANGE;
 
 	priv->dreg = nft_parse_register(tb[NFTA_NG_DREG]);
 	if (priv->dreg < 0)
 		return -ERANGE;
 
-	atomic_set(&priv->counter, 0);
+	atomic_set(&priv->counter, sum);
 
 	return nft_validate_register_store(ctx, priv->dreg, NULL,
 					   NFT_DATA_VALUE, sizeof(u32));
 }
 
 static int nft_ng_dump(struct sk_buff *skb, enum nft_registers dreg,
-		       u32 until, enum nft_ng_types type)
+		       u32 modulus, enum nft_ng_types type)
 {
 	if (nft_dump_register(skb, NFTA_NG_DREG, dreg))
 		goto nla_put_failure;
-	if (nft_dump_register(skb, NFTA_NG_UNTIL, until))
+	if (nft_dump_register(skb, NFTA_NG_MODULUS, modulus))
 		goto nla_put_failure;
 	if (nft_dump_register(skb, NFTA_NG_TYPE, type))
 		goto nla_put_failure;
@@ -86,12 +91,12 @@ static int nft_ng_inc_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_ng_inc *priv = nft_expr_priv(expr);
 
-	return nft_ng_dump(skb, priv->dreg, priv->until, NFT_NG_INCREMENTAL);
+	return nft_ng_dump(skb, priv->dreg, priv->modulus, NFT_NG_INCREMENTAL);
 }
 
 struct nft_ng_random {
 	enum nft_registers      dreg:8;
-	u32			until;
+	u32			modulus;
 };
 
 static void nft_ng_random_eval(const struct nft_expr *expr,
@@ -102,7 +107,7 @@ static void nft_ng_random_eval(const struct nft_expr *expr,
 	struct rnd_state *state = this_cpu_ptr(&nft_numgen_prandom_state);
 
 	regs->data[priv->dreg] = reciprocal_scale(prandom_u32_state(state),
-						  priv->until);
+						  priv->modulus);
 }
 
 static int nft_ng_random_init(const struct nft_ctx *ctx,
@@ -111,8 +116,8 @@ static int nft_ng_random_init(const struct nft_ctx *ctx,
 {
 	struct nft_ng_random *priv = nft_expr_priv(expr);
 
-	priv->until = ntohl(nla_get_be32(tb[NFTA_NG_UNTIL]));
-	if (priv->until == 0)
+	priv->modulus = ntohl(nla_get_be32(tb[NFTA_NG_MODULUS]));
+	if (priv->modulus == 0)
 		return -ERANGE;
 
 	prandom_init_once(&nft_numgen_prandom_state);
@@ -129,7 +134,7 @@ static int nft_ng_random_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_ng_random *priv = nft_expr_priv(expr);
 
-	return nft_ng_dump(skb, priv->dreg, priv->until, NFT_NG_RANDOM);
+	return nft_ng_dump(skb, priv->dreg, priv->modulus, NFT_NG_RANDOM);
 }
 
 static struct nft_expr_type nft_ng_type;
@@ -154,8 +159,8 @@ nft_ng_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 {
 	u32 type;
 
-	if (!tb[NFTA_NG_DREG]	||
-	    !tb[NFTA_NG_UNTIL]	||
+	if (!tb[NFTA_NG_DREG]	 ||
+	    !tb[NFTA_NG_MODULUS] ||
 	    !tb[NFTA_NG_TYPE])
 		return ERR_PTR(-EINVAL);
 
-- 
2.8.1

