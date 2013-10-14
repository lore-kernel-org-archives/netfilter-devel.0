From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables-kernel PATCH 6/7] netfilter: nf_tables: Add left and right shifts to bitwise expression
Date: Mon, 14 Oct 2013 15:46:55 +0300
Message-ID: <1381754816-28472-7-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52811 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab3JNMrK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:47:10 -0400
In-Reply-To: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This add left and right shift operators. Thus it is possible to make
logical shifts to nft_data.

A multiplication by 2 can be easily ordered this way and more.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/uapi/linux/netfilter/nf_tables.h | 30 +++++++++++++-
 net/netfilter/nft_bitwise.c              | 70 +++++++++++++++++++++++++++-----
 2 files changed, 88 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 65f41ff..8b12b8f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -351,16 +351,32 @@ enum nft_immediate_attributes {
 #define NFTA_IMMEDIATE_MAX	(__NFTA_IMMEDIATE_MAX - 1)
 
 /**
+ * enum nft_bitwise_ops - nf_tables bitwise operators
+ *
+ * @NFT_BITWISE_XOR: xor operator
+ * @NFT_BITWISE_LSHIFT: left shift operator
+ * @NFT_BITWISE_RSHIFT: right shift operator
+ */
+enum nft_bitwise_ops {
+	NFT_BITWISE_XOR,
+	NFT_BITWISE_LSHIFT,
+	NFT_BITWISE_RSHIFT,
+};
+
+/**
  * enum nft_bitwise_attributes - nf_tables bitwise expression netlink attributes
  *
  * @NFTA_BITWISE_SREG: source register (NLA_U32: nft_registers)
  * @NFTA_BITWISE_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_BITWISE_OP: operator (NLA_U32: enum nft_bitwise_ops)
  * @NFTA_BITWISE_LEN: length of operands (NLA_U32)
  * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_SHIFT: shift length (NLA_U32)
  *
- * The bitwise expression performs the following operation:
+ * The bitwise expression performs the 3 following operations:
  *
+ * XOR:
  * dreg = (sreg & mask) ^ xor
  *
  * which allow to express all bitwise operations:
@@ -370,14 +386,26 @@ enum nft_immediate_attributes {
  * OR:		0	x
  * XOR:		1	x
  * AND:		x	0
+ *
+ * Then, LSHIFT/RSHIFT.
+ * For instance on LSHIFT:
+ * dreg = sreg << shift | (rest ? rest : 0)
+ *
+ * where rest (internal) is calculated on previous sreg:
+ * rest = (sreg & mask) >> (sizeof_u32 - shift)
+ *
+ * where provided mask is:
+ * ~(UINT32_MAX >> shift)
  */
 enum nft_bitwise_attributes {
 	NFTA_BITWISE_UNSPEC,
 	NFTA_BITWISE_SREG,
 	NFTA_BITWISE_DREG,
+	NFTA_BITWISE_OP,
 	NFTA_BITWISE_LEN,
 	NFTA_BITWISE_MASK,
 	NFTA_BITWISE_XOR,
+	NFTA_BITWISE_SHIFT,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 4fb6ee2..d32058c 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -20,9 +20,11 @@
 struct nft_bitwise {
 	enum nft_registers	sreg:8;
 	enum nft_registers	dreg:8;
+	u8			op;
 	u8			len;
 	struct nft_data		mask;
 	struct nft_data		xor;
+	u8			shift;
 };
 
 static void nft_bitwise_eval(const struct nft_expr *expr,
@@ -32,17 +34,43 @@ static void nft_bitwise_eval(const struct nft_expr *expr,
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	const struct nft_data *src = &data[priv->sreg];
 	struct nft_data *dst = &data[priv->dreg];
-	unsigned int i;
-
-	for (i = 0; i < DIV_ROUND_UP(priv->len, 4); i++) {
-		dst->data[i] = (src->data[i] & priv->mask.data[i]) ^
-			       priv->xor.data[i];
+	unsigned int i, r, rest = 0;
+	int cr_shift;
+
+	switch (priv->op) {
+	case NFT_BITWISE_XOR:
+		for (i = 0; i < DIV_ROUND_UP(priv->len, 4); i++) {
+			dst->data[i] = (src->data[i] & priv->mask.data[i]) ^
+				       priv->xor.data[i];
+		}
+		break;
+	case NFT_BITWISE_LSHIFT:
+		cr_shift = sizeof(unsigned int) - priv->shift;
+		for (i = 0; i < priv->len; i++) {
+			r = (src->data[i] & priv->mask.data[i]) >> cr_shift;
+			dst->data[i] = src->data[i] << priv->shift;
+			if (rest)
+				dst->data[i] |= rest;
+			rest = r;
+		}
+		break;
+	case NFT_BITWISE_RSHIFT:
+		cr_shift = sizeof(unsigned int) - priv->shift;
+		for (i = priv->len - 1; i >= 0; i--) {
+			r = (src->data[i] & priv->mask.data[i]) << cr_shift;
+			dst->data[i] = src->data[i] >> priv->shift;
+			if (rest)
+				dst->data[i] |= rest;
+			rest = r;
+		}
+		break;
 	}
 }
 
 static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_SREG]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_DREG]	= { .type = NLA_U32 },
+	[NFTA_BITWISE_OP]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_LEN]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_MASK]	= { .type = NLA_NESTED },
 	[NFTA_BITWISE_XOR]	= { .type = NLA_NESTED },
@@ -58,9 +86,11 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 
 	if (tb[NFTA_BITWISE_SREG] == NULL ||
 	    tb[NFTA_BITWISE_DREG] == NULL ||
+	    tb[NFTA_BITWISE_OP] == NULL ||
 	    tb[NFTA_BITWISE_LEN] == NULL ||
 	    tb[NFTA_BITWISE_MASK] == NULL ||
-	    tb[NFTA_BITWISE_XOR] == NULL)
+	    (tb[NFTA_BITWISE_XOR] == NULL &&
+	     tb[NFTA_BITWISE_SHIFT] == NULL))
 		return -EINVAL;
 
 	priv->sreg = ntohl(nla_get_be32(tb[NFTA_BITWISE_SREG]));
@@ -76,6 +106,20 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
+	switch (priv->op) {
+	case NFT_BITWISE_XOR:
+		if (tb[NFTA_BITWISE_XOR] == NULL)
+			return -EINVAL;
+		break;
+	case NFT_BITWISE_LSHIFT:
+	case NFT_BITWISE_RSHIFT:
+		if (tb[NFTA_BITWISE_SHIFT] != NULL)
+			break;
+	default:
+		return -EINVAL;
+	};
+
 	priv->len = ntohl(nla_get_be32(tb[NFTA_BITWISE_LEN]));
 
 	err = nft_data_init(NULL, &priv->mask, &d1, tb[NFTA_BITWISE_MASK]);
@@ -84,11 +128,15 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	if (d1.len != priv->len)
 		return -EINVAL;
 
-	err = nft_data_init(NULL, &priv->xor, &d2, tb[NFTA_BITWISE_XOR]);
-	if (err < 0)
-		return err;
-	if (d2.len != priv->len)
-		return -EINVAL;
+	if (priv->op == NFT_BITWISE_XOR) {
+		err = nft_data_init(NULL, &priv->xor,
+				    &d2, tb[NFTA_BITWISE_XOR]);
+		if (err < 0)
+			return err;
+		if (d2.len != priv->len)
+			return -EINVAL;
+	} else
+		priv->shift = ntohl(nla_get_be32(tb[NFTA_BITWISE_SHIFT]));
 
 	return 0;
 }
-- 
1.8.3.2

