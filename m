From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v3] netfilter: nft_numgen: add number generation offset
Date: Tue, 13 Sep 2016 13:49:53 +0200
Message-ID: <20160913114950.GA15747@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32954 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbcIMLt6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Sep 2016 07:49:58 -0400
Received: by mail-wm0-f65.google.com with SMTP id b187so17901959wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 04:49:57 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id i195sm4939799wmg.14.2016.09.13.04.49.55
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 13 Sep 2016 04:49:55 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support of an offset value for incremental counter and random. With
this option the sysadmin is able to start the counter to a certain value
and then apply the generated number.

Example:

	meta mark set numgen inc mod 2 offset 100

This will generate marks with the serie 100, 101, 100, 101, ...

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
Changes in v2:
	- Separate offset changes with _until_ attribute renaming, as
Pablo suggested.

Changes in v3:
	- Rename SUM by OFFSET, as Pablo suggested.
	- Include correct behavior for the offset feature, as Pablo
suggested.
	- Include offset feature to the random operation.
	- Include u32 overflow validation.

 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_numgen.c               | 30 +++++++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index bc0eb6a..bcfb892 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1136,12 +1136,14 @@ enum nft_trace_types {
  * @NFTA_NG_DREG: destination register (NLA_U32)
  * @NFTA_NG_MODULUS: maximum counter value (NLA_U32)
  * @NFTA_NG_TYPE: operation type (NLA_U32)
+ * @NFTA_NG_OFFSET: offset to be added to the counter (NLA_U32)
  */
 enum nft_ng_attributes {
 	NFTA_NG_UNSPEC,
 	NFTA_NG_DREG,
 	NFTA_NG_MODULUS,
 	NFTA_NG_TYPE,
+	NFTA_NG_OFFSET,
 	__NFTA_NG_MAX
 };
 #define NFTA_NG_MAX	(__NFTA_NG_MAX - 1)
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index f173ebe..b39f909 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -23,6 +23,7 @@ struct nft_ng_inc {
 	enum nft_registers      dreg:8;
 	u32			modulus;
 	atomic_t		counter;
+	u32			offset;
 };
 
 static void nft_ng_inc_eval(const struct nft_expr *expr,
@@ -37,13 +38,14 @@ static void nft_ng_inc_eval(const struct nft_expr *expr,
 		nval = (oval + 1 < priv->modulus) ? oval + 1 : 0;
 	} while (atomic_cmpxchg(&priv->counter, oval, nval) != oval);
 
-	regs->data[priv->dreg] = nval;
+	regs->data[priv->dreg] = nval + priv->offset;
 }
 
 static const struct nla_policy nft_ng_policy[NFTA_NG_MAX + 1] = {
 	[NFTA_NG_DREG]		= { .type = NLA_U32 },
 	[NFTA_NG_MODULUS]	= { .type = NLA_U32 },
 	[NFTA_NG_TYPE]		= { .type = NLA_U32 },
+	[NFTA_NG_OFFSET]	= { .type = NLA_U32 },
 };
 
 static int nft_ng_inc_init(const struct nft_ctx *ctx,
@@ -52,10 +54,16 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 {
 	struct nft_ng_inc *priv = nft_expr_priv(expr);
 
+	if (tb[NFTA_NG_OFFSET])
+		priv->offset = ntohl(nla_get_be32(tb[NFTA_NG_OFFSET]));
+
 	priv->modulus = ntohl(nla_get_be32(tb[NFTA_NG_MODULUS]));
 	if (priv->modulus == 0)
 		return -ERANGE;
 
+	if (priv->offset + priv->modulus - 1 < priv->offset)
+		return -EOVERFLOW;
+
 	priv->dreg = nft_parse_register(tb[NFTA_NG_DREG]);
 	atomic_set(&priv->counter, 0);
 
@@ -64,7 +72,7 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 }
 
 static int nft_ng_dump(struct sk_buff *skb, enum nft_registers dreg,
-		       u32 modulus, enum nft_ng_types type)
+		       u32 modulus, enum nft_ng_types type, u32 offset)
 {
 	if (nft_dump_register(skb, NFTA_NG_DREG, dreg))
 		goto nla_put_failure;
@@ -72,6 +80,8 @@ static int nft_ng_dump(struct sk_buff *skb, enum nft_registers dreg,
 		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_NG_TYPE, htonl(type)))
 		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_NG_OFFSET, htonl(offset)))
+		goto nla_put_failure;
 
 	return 0;
 
@@ -83,12 +93,14 @@ static int nft_ng_inc_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_ng_inc *priv = nft_expr_priv(expr);
 
-	return nft_ng_dump(skb, priv->dreg, priv->modulus, NFT_NG_INCREMENTAL);
+	return nft_ng_dump(skb, priv->dreg, priv->modulus, NFT_NG_INCREMENTAL,
+			   priv->offset);
 }
 
 struct nft_ng_random {
 	enum nft_registers      dreg:8;
 	u32			modulus;
+	u32			offset;
 };
 
 static void nft_ng_random_eval(const struct nft_expr *expr,
@@ -99,7 +111,8 @@ static void nft_ng_random_eval(const struct nft_expr *expr,
 	struct rnd_state *state = this_cpu_ptr(&nft_numgen_prandom_state);
 
 	regs->data[priv->dreg] = reciprocal_scale(prandom_u32_state(state),
-						  priv->modulus);
+						  priv->modulus) +
+				 priv->offset;
 }
 
 static int nft_ng_random_init(const struct nft_ctx *ctx,
@@ -108,10 +121,16 @@ static int nft_ng_random_init(const struct nft_ctx *ctx,
 {
 	struct nft_ng_random *priv = nft_expr_priv(expr);
 
+	if (tb[NFTA_NG_OFFSET])
+		priv->offset = ntohl(nla_get_be32(tb[NFTA_NG_OFFSET]));
+
 	priv->modulus = ntohl(nla_get_be32(tb[NFTA_NG_MODULUS]));
 	if (priv->modulus == 0)
 		return -ERANGE;
 
+	if (priv->offset + priv->modulus - 1 < priv->offset)
+		return -EOVERFLOW;
+
 	prandom_init_once(&nft_numgen_prandom_state);
 
 	priv->dreg = nft_parse_register(tb[NFTA_NG_DREG]);
@@ -124,7 +143,8 @@ static int nft_ng_random_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_ng_random *priv = nft_expr_priv(expr);
 
-	return nft_ng_dump(skb, priv->dreg, priv->modulus, NFT_NG_RANDOM);
+	return nft_ng_dump(skb, priv->dreg, priv->modulus, NFT_NG_RANDOM,
+			   priv->offset);
 }
 
 static struct nft_expr_type nft_ng_type;
-- 
2.8.1

