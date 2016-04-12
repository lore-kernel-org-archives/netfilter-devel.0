From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v5 nf-next 4/4] netfilter: nftables: add connlabel set support
Date: Tue, 12 Apr 2016 18:14:26 +0200
Message-ID: <1460477666-17823-5-git-send-email-fw@strlen.de>
References: <1460477666-17823-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37359 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbcDLQOW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 12:14:22 -0400
In-Reply-To: <1460477666-17823-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of taking the value to set from a source register, userspace
passes the bit that we should set as an immediate netlink value.

This follows a similar approach that xtables 'connlabel'
match uses, so when user inputs

    ct label set bar

then we will set the bit used by the 'bar' label and leave the rest alone.
Pablo suggested to re-use the immediate attributes already used by
nft_immediate, nft_bitwise and nft_cmp to re-use as much code as
possible.

Just add new NFTA_CT_IMM that contains nested data attributes.
We can then use nft_data_init and nft_data_dump for this as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since last version:
 - add generic NFTA_CT_IMM and pass it a struct nft_data.

 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/netfilter/nft_ct.c                   | 76 ++++++++++++++++++++++++++++++--
 2 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index eeffde1..608b647 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -770,6 +770,7 @@ enum nft_ct_keys {
  * @NFTA_CT_KEY: conntrack data item to load (NLA_U32: nft_ct_keys)
  * @NFTA_CT_DIRECTION: direction in case of directional keys (NLA_U8)
  * @NFTA_CT_SREG: source register (NLA_U32)
+ * @NFTA_CT_IMM: immediate value (NLA_NESTED)
  */
 enum nft_ct_attributes {
 	NFTA_CT_UNSPEC,
@@ -777,6 +778,7 @@ enum nft_ct_attributes {
 	NFTA_CT_KEY,
 	NFTA_CT_DIRECTION,
 	NFTA_CT_SREG,
+	NFTA_CT_IMM,
 	__NFTA_CT_MAX
 };
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 25998fa..4ec1cea 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -29,6 +29,11 @@ struct nft_ct {
 		enum nft_registers	dreg:8;
 		enum nft_registers	sreg:8;
 	};
+	union {
+		u8		set_bit;
+	} imm;
+	unsigned int		imm_len:8;
+	struct nft_data		immediate;
 };
 
 static u64 nft_ct_get_eval_counter(const struct nf_conn_counter *c,
@@ -198,6 +203,11 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 		}
 		break;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	case NFT_CT_LABELS:
+		nf_connlabel_set(ct, priv->imm.set_bit);
+		break;
+#endif
 	default:
 		break;
 	}
@@ -208,6 +218,7 @@ static const struct nla_policy nft_ct_policy[NFTA_CT_MAX + 1] = {
 	[NFTA_CT_KEY]		= { .type = NLA_U32 },
 	[NFTA_CT_DIRECTION]	= { .type = NLA_U8 },
 	[NFTA_CT_SREG]		= { .type = NLA_U32 },
+	[NFTA_CT_IMM]		= { .type = NLA_NESTED },
 };
 
 static int nft_ct_l3proto_try_module_get(uint8_t family)
@@ -276,6 +287,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		if (tb[NFTA_CT_DIRECTION] != NULL)
 			return -EINVAL;
 		len = NF_CT_LABELS_MAX_SIZE;
+		err = nf_connlabels_get(ctx->net, (len * BITS_PER_BYTE) - 1);
+		if (err)
+			return err;
 		break;
 #endif
 	case NFT_CT_HELPER:
@@ -355,16 +369,50 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_ct *priv = nft_expr_priv(expr);
+	struct nft_data_desc imm_desc = {};
 	unsigned int len;
 	int err;
 
 	priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
+
+	if (tb[NFTA_CT_IMM]) {
+		/* We currently do not support both sreg and imm */
+		if (tb[NFTA_CT_SREG])
+			return -EINVAL;
+
+		err = nft_data_init(NULL, &priv->immediate, sizeof(priv->immediate),
+				    &imm_desc, tb[NFTA_CT_IMM]);
+		if (err < 0)
+			return err;
+
+		if (imm_desc.type != NFT_DATA_VALUE)
+			return -EINVAL;
+	}
 	switch (priv->key) {
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	case NFT_CT_MARK:
+		if (tb[NFTA_CT_DIRECTION])
+			return -EINVAL;
 		len = FIELD_SIZEOF(struct nf_conn, mark);
 		break;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	case NFT_CT_LABELS:
+		if (tb[NFTA_CT_DIRECTION] || imm_desc.len != sizeof(u32))
+			return -EINVAL;
+
+		err = nf_connlabels_get(ctx->net, htonl(priv->immediate.data[0]));
+		if (err < 0)
+			return err;
+
+		priv->imm_len = sizeof(u32);
+		priv->imm.set_bit = htonl(priv->immediate.data[0]);
+
+		err = nft_ct_l3proto_try_module_get(ctx->afi->family);
+		if (err < 0)
+			nf_connlabels_put(ctx->net);
+		return err;
+#endif
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -384,6 +432,18 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 static void nft_ct_destroy(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr)
 {
+	struct nft_ct *priv = nft_expr_priv(expr);
+
+	switch (priv->key) {
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	case NFT_CT_LABELS:
+		nf_connlabels_put(ctx->net);
+		break;
+#endif
+	default:
+		break;
+	}
+
 	nft_ct_l3proto_module_put(ctx->afi->family);
 }
 
@@ -426,10 +486,20 @@ static int nft_ct_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
 
-	if (nft_dump_register(skb, NFTA_CT_SREG, priv->sreg))
-		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_CT_KEY, htonl(priv->key)))
 		goto nla_put_failure;
+
+	if (priv->imm_len) {
+		if (nft_data_dump(skb, NFTA_CT_IMM, &priv->immediate,
+				  NFT_DATA_VALUE, priv->imm_len) < 0)
+			goto nla_put_failure;
+
+		return 0;
+	}
+
+	if (nft_dump_register(skb, NFTA_CT_SREG, priv->sreg))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
@@ -468,7 +538,7 @@ nft_ct_select_ops(const struct nft_ctx *ctx,
 	if (tb[NFTA_CT_DREG])
 		return &nft_ct_get_ops;
 
-	if (tb[NFTA_CT_SREG])
+	if (tb[NFTA_CT_SREG] || tb[NFTA_CT_IMM])
 		return &nft_ct_set_ops;
 
 	return ERR_PTR(-EINVAL);
-- 
2.7.3

