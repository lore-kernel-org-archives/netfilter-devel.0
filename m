Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 742A21CEAB9;
	Fri, 15 Nov 2024 13:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677547; cv=none; b=AxJ3p16pplUFMlvsQ2Sg+kT3bERGkE5QnOXzhg/+vS5X8mCK1f1/jdXGOApVv1XMbHKkCXEBuCaiheBpFdFlToPRJ/Tuw7mxP6QJHzD/ODcBqdaCSNXJ7R/YZqFziuoknKkJVZUDmB/Ldy04JwMlr/sLGAO3pv4OEh+oEQPNovI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677547; c=relaxed/simple;
	bh=WbWm8lWchmza2OeHfP9X24+B+SNZZGzCc8YdKP+rb3I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KwkPHXtsLWAXMXR44aw35lMeRqZkTnMCSqzQ0SshLWXD6uzT/uahXkAwaeCxo8CHD0DF8fk72UpyKiVzIrvyiSqsde87khbeCY/b1VBR4lFsM6Bq5wpcQGVopuA9s3sKci/tR5+745X2oAPB3JQMWDFwvPO6jzLXv58y2XeTL0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 14/14] netfilter: bitwise: add support for doing AND, OR and XOR directly
Date: Fri, 15 Nov 2024 14:32:07 +0100
Message-Id: <20241115133207.8907-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241115133207.8907-1-pablo@netfilter.org>
References: <20241115133207.8907-1-pablo@netfilter.org>
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

Pablo made a few changes to the original patch:

- EINVAL if NFTA_BITWISE_SREG2 is used with fast version.
- Allow _AND,_OR,_XOR with _DATA != sizeof(u32)
- Dump _SREG2 or _DATA with _AND,_OR,_XOR

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   8 ++
 net/netfilter/nft_bitwise.c              | 134 +++++++++++++++++++++--
 2 files changed, 131 insertions(+), 11 deletions(-)

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
index 7f6a4f800537..d550910aabec 100644
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
@@ -157,6 +204,41 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 	return 0;
 }
 
+static int nft_bitwise_init_bool(const struct nft_ctx *ctx,
+				 struct nft_bitwise *priv,
+				 const struct nlattr *const tb[])
+{
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
+		struct nft_data_desc desc = {
+			.type	= NFT_DATA_VALUE,
+			.size	= sizeof(priv->data),
+			.len	= priv->len,
+		};
+
+		err = nft_data_init(NULL, &priv->data, &desc,
+				    tb[NFTA_BITWISE_DATA]);
+		if (err < 0)
+			return err;
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
@@ -188,6 +270,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 		case NFT_BITWISE_MASK_XOR:
 		case NFT_BITWISE_LSHIFT:
 		case NFT_BITWISE_RSHIFT:
+		case NFT_BITWISE_AND:
+		case NFT_BITWISE_OR:
+		case NFT_BITWISE_XOR:
 			break;
 		default:
 			return -EOPNOTSUPP;
@@ -204,6 +289,11 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	case NFT_BITWISE_RSHIFT:
 		err = nft_bitwise_init_shift(priv, tb);
 		break;
+	case NFT_BITWISE_AND:
+	case NFT_BITWISE_OR:
+	case NFT_BITWISE_XOR:
+		err = nft_bitwise_init_bool(ctx, priv, tb);
+		break;
 	}
 
 	return err;
@@ -232,6 +322,21 @@ static int nft_bitwise_dump_shift(struct sk_buff *skb,
 	return 0;
 }
 
+static int nft_bitwise_dump_bool(struct sk_buff *skb,
+				 const struct nft_bitwise *priv)
+{
+	if (priv->sreg2) {
+		if (nft_dump_register(skb, NFTA_BITWISE_SREG2, priv->sreg2))
+			return -1;
+	} else {
+		if (nft_data_dump(skb, NFTA_BITWISE_DATA, &priv->data,
+				  NFT_DATA_VALUE, sizeof(u32)) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
 static int nft_bitwise_dump(struct sk_buff *skb,
 			    const struct nft_expr *expr, bool reset)
 {
@@ -255,6 +360,11 @@ static int nft_bitwise_dump(struct sk_buff *skb,
 	case NFT_BITWISE_RSHIFT:
 		err = nft_bitwise_dump_shift(skb, priv);
 		break;
+	case NFT_BITWISE_AND:
+	case NFT_BITWISE_OR:
+	case NFT_BITWISE_XOR:
+		err = nft_bitwise_dump_bool(skb, priv);
+		break;
 	}
 
 	return err;
@@ -299,6 +409,7 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 	    track->regs[priv->dreg].bitwise &&
 	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
 	    priv->sreg == bitwise->sreg &&
+	    priv->sreg2 == bitwise->sreg2 &&
 	    priv->dreg == bitwise->dreg &&
 	    priv->op == bitwise->op &&
 	    priv->len == bitwise->len &&
@@ -375,7 +486,8 @@ static int nft_bitwise_fast_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	if (tb[NFTA_BITWISE_DATA])
+	if (tb[NFTA_BITWISE_DATA] ||
+	    tb[NFTA_BITWISE_SREG2])
 		return -EINVAL;
 
 	if (!tb[NFTA_BITWISE_MASK] ||
-- 
2.30.2

