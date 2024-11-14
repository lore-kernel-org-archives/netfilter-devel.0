Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0855029A1
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 21:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731618837; cv=none; b=fgCfpeHi3QBd9FWLl6l/T8xwZuxG1g24c4GNa0pdLal7mQ7UdNF8wGp2tZ8y4hU7KOnDpsKyMCkUdop4VzM+PLp6H8Rv7q7JdtVfZ5/ePvfNnFe70rmxwJCvsJef/2hGHTVHt/DNw+Z0j3YIVtnRT/8kStcNgcoTkPk/nO9tU28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731618837; c=relaxed/simple;
	bh=OIhnvDZhyF36v1LnE9QTd0THwlm1/dv8eS1JebOVWvQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OnNbtaqlApFSkVEk2xWPcyiyk+wu6YuRU2N0iqCu6bYbmCtXZ8RbMBGb+pjmWXvqrDrY9jgIquW7cPqfZCahHIrALubzwTGX9wOivABORvMecBOO8Uz0LMcuDOM9U5ACC5PMuq9HYnAuOUij7lXXXahbeBdnHSepDd89DcxsPT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: [PATCH nf-next 2/2] netfilter: bitwise: add support for doing AND, OR and XOR directly
Date: Thu, 14 Nov 2024 22:13:47 +0100
Message-Id: <20241114211347.24700-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241114211347.24700-1-pablo@netfilter.org>
References: <20241114211347.24700-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

Hitherto, these operations have been converted in user space to
mask-and-xor operations on one register and two immediate values, and it
is the latter which have been evaluated by the kernel.  We add support
for evaluating these operations directly in kernel space on one register
and either an immediate value or a second register.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   8 ++
 net/netfilter/nft_bitwise.c              | 133 +++++++++++++++++++++--
 2 files changed, 131 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 487542234ccd..49c944e78463 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -568,11 +568,17 @@ enum nft_immediate_attributes {
  *                        and XOR boolean operations
  * @NFT_BITWISE_LSHIFT: left-shift operation
  * @NFT_BITWISE_RSHIFT: right-shift operation
+ * @NFT_BITWISE_AND: and operation
+ * @NFT_BITWISE_OR: or operation
+ * @NFT_BITWISE_XOR: xor operation
  */
 enum nft_bitwise_ops {
 	NFT_BITWISE_MASK_XOR,
 	NFT_BITWISE_LSHIFT,
 	NFT_BITWISE_RSHIFT,
+	NFT_BITWISE_AND,
+	NFT_BITWISE_OR,
+	NFT_BITWISE_XOR,
 };
 /*
  * Old name for NFT_BITWISE_MASK_XOR.  Retained for backwards-compatibility.
@@ -590,6 +596,7 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_SREG2: second source register (NLA_U32: nft_registers)
  *
  * The bitwise expression supports boolean and shift operations.  It implements
  * the boolean operations by performing the following operation:
@@ -613,6 +620,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_XOR,
 	NFTA_BITWISE_OP,
 	NFTA_BITWISE_DATA,
+	NFTA_BITWISE_SREG2,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 7f6a4f800537..7e7e6d59c01f 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -17,6 +17,7 @@
 
 struct nft_bitwise {
 	u8			sreg;
+	u8			sreg2;
 	u8			dreg;
 	enum nft_bitwise_ops	op:8;
 	u8			len;
@@ -60,28 +61,72 @@ static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
 	}
 }
 
+static void nft_bitwise_eval_and(u32 *dst, const u32 *src, const u32 *src2,
+				 const struct nft_bitwise *priv)
+{
+	unsigned int i, n;
+
+	for (i = 0, n = DIV_ROUND_UP(priv->len, sizeof(u32)); i < n; i++)
+		dst[i] = src[i] & src2[i];
+}
+
+static void nft_bitwise_eval_or(u32 *dst, const u32 *src, const u32 *src2,
+				const struct nft_bitwise *priv)
+{
+	unsigned int i, n;
+
+	for (i = 0, n = DIV_ROUND_UP(priv->len, sizeof(u32)); i < n; i++)
+		dst[i] = src[i] | src2[i];
+}
+
+static void nft_bitwise_eval_xor(u32 *dst, const u32 *src, const u32 *src2,
+				 const struct nft_bitwise *priv)
+{
+	unsigned int i, n;
+
+	for (i = 0, n = DIV_ROUND_UP(priv->len, sizeof(u32)); i < n; i++)
+		dst[i] = src[i] ^ src2[i];
+}
+
 void nft_bitwise_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
-	const u32 *src = &regs->data[priv->sreg];
+	const u32 *src = &regs->data[priv->sreg], *src2;
 	u32 *dst = &regs->data[priv->dreg];
 
-	switch (priv->op) {
-	case NFT_BITWISE_MASK_XOR:
+	if (priv->op == NFT_BITWISE_MASK_XOR) {
 		nft_bitwise_eval_mask_xor(dst, src, priv);
-		break;
-	case NFT_BITWISE_LSHIFT:
+		return;
+	}
+	if (priv->op == NFT_BITWISE_LSHIFT) {
 		nft_bitwise_eval_lshift(dst, src, priv);
-		break;
-	case NFT_BITWISE_RSHIFT:
+		return;
+	}
+	if (priv->op == NFT_BITWISE_RSHIFT) {
 		nft_bitwise_eval_rshift(dst, src, priv);
-		break;
+		return;
+	}
+
+	src2 = priv->sreg2 ? &regs->data[priv->sreg2] : priv->data.data;
+
+	if (priv->op == NFT_BITWISE_AND) {
+		nft_bitwise_eval_and(dst, src, src2, priv);
+		return;
+	}
+	if (priv->op == NFT_BITWISE_OR) {
+		nft_bitwise_eval_or(dst, src, src2, priv);
+		return;
+	}
+	if (priv->op == NFT_BITWISE_XOR) {
+		nft_bitwise_eval_xor(dst, src, src2, priv);
+		return;
 	}
 }
 
 static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_SREG]	= { .type = NLA_U32 },
+	[NFTA_BITWISE_SREG2]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_DREG]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_LEN]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_MASK]	= { .type = NLA_NESTED },
@@ -105,7 +150,8 @@ static int nft_bitwise_init_mask_xor(struct nft_bitwise *priv,
 	};
 	int err;
 
-	if (tb[NFTA_BITWISE_DATA])
+	if (tb[NFTA_BITWISE_DATA] ||
+	    tb[NFTA_BITWISE_SREG2])
 		return -EINVAL;
 
 	if (!tb[NFTA_BITWISE_MASK] ||
@@ -139,7 +185,8 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 	int err;
 
 	if (tb[NFTA_BITWISE_MASK] ||
-	    tb[NFTA_BITWISE_XOR])
+	    tb[NFTA_BITWISE_XOR]  ||
+	    tb[NFTA_BITWISE_SREG2])
 		return -EINVAL;
 
 	if (!tb[NFTA_BITWISE_DATA])
@@ -157,6 +204,45 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 	return 0;
 }
 
+static int nft_bitwise_init_bool2(const struct nft_ctx *ctx,
+				  struct nft_bitwise *priv,
+				  const struct nlattr *const tb[])
+{
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->data),
+		.len	= sizeof(u32),
+	};
+	int err;
+
+	if (tb[NFTA_BITWISE_MASK] ||
+	    tb[NFTA_BITWISE_XOR])
+		return -EINVAL;
+
+	if ((!tb[NFTA_BITWISE_DATA] && !tb[NFTA_BITWISE_SREG2]) ||
+	    (tb[NFTA_BITWISE_DATA] && tb[NFTA_BITWISE_SREG2]))
+		return -EINVAL;
+
+	if (tb[NFTA_BITWISE_DATA]) {
+		err = nft_data_init(NULL, &priv->data, &desc,
+				    tb[NFTA_BITWISE_DATA]);
+		if (err < 0)
+			return err;
+
+		if (priv->data.data[0] >= BITS_PER_TYPE(u32)) {
+			nft_data_release(&priv->data, desc.type);
+			return -EINVAL;
+		}
+	} else {
+		err = nft_parse_register_load(ctx, tb[NFTA_BITWISE_SREG2],
+					      &priv->sreg2, priv->len);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
 static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nlattr * const tb[])
@@ -188,6 +274,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 		case NFT_BITWISE_MASK_XOR:
 		case NFT_BITWISE_LSHIFT:
 		case NFT_BITWISE_RSHIFT:
+		case NFT_BITWISE_AND:
+		case NFT_BITWISE_OR:
+		case NFT_BITWISE_XOR:
 			break;
 		default:
 			return -EOPNOTSUPP;
@@ -204,6 +293,11 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	case NFT_BITWISE_RSHIFT:
 		err = nft_bitwise_init_shift(priv, tb);
 		break;
+	case NFT_BITWISE_AND:
+	case NFT_BITWISE_OR:
+	case NFT_BITWISE_XOR:
+		err = nft_bitwise_init_bool2(ctx, priv, tb);
+		break;
 	}
 
 	return err;
@@ -232,6 +326,19 @@ static int nft_bitwise_dump_shift(struct sk_buff *skb,
 	return 0;
 }
 
+static int nft_bitwise_dump_bool2(struct sk_buff *skb,
+				 const struct nft_bitwise *priv)
+{
+	if (nft_dump_register(skb, NFTA_BITWISE_SREG2, priv->sreg2))
+		return -1;
+
+	if (nft_data_dump(skb, NFTA_BITWISE_DATA, &priv->data,
+			  NFT_DATA_VALUE, sizeof(u32)) < 0)
+		return -1;
+
+	return 0;
+}
+
 static int nft_bitwise_dump(struct sk_buff *skb,
 			    const struct nft_expr *expr, bool reset)
 {
@@ -255,6 +362,11 @@ static int nft_bitwise_dump(struct sk_buff *skb,
 	case NFT_BITWISE_RSHIFT:
 		err = nft_bitwise_dump_shift(skb, priv);
 		break;
+	case NFT_BITWISE_AND:
+	case NFT_BITWISE_OR:
+	case NFT_BITWISE_XOR:
+		err = nft_bitwise_dump_bool2(skb, priv);
+		break;
 	}
 
 	return err;
@@ -299,6 +411,7 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 	    track->regs[priv->dreg].bitwise &&
 	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
 	    priv->sreg == bitwise->sreg &&
+	    priv->sreg2 == bitwise->sreg2 &&
 	    priv->dreg == bitwise->dreg &&
 	    priv->op == bitwise->op &&
 	    priv->len == bitwise->len &&
-- 
2.30.2

