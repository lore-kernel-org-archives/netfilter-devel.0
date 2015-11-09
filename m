From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH nf-next 1/1] netfilter: nft_payload: add packet mangling support
Date: Mon,  9 Nov 2015 14:10:34 +0000
Message-ID: <1447078234-21628-2-git-send-email-kaber@trash.net>
References: <1447078234-21628-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:48348 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751807AbbKIOKi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 09:10:38 -0500
In-Reply-To: <1447078234-21628-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for mangling packet payload. Checksum for the specified
base header is updated automatically, however no double updates (for
pseudo headers) are supported, meaning no stateless NAT is supported.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables_core.h   |   1 +
 include/uapi/linux/netfilter/nf_tables.h |   4 ++
 net/netfilter/nft_payload.c              | 116 +++++++++++++++++++++++++++++--
 3 files changed, 115 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index c6f400c..6d7a793 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -45,6 +45,7 @@ struct nft_payload {
 	u8			offset;
 	u8			len;
 	enum nft_registers	dreg:8;
+	u8			csum_offset;
 };
 
 extern const struct nft_expr_ops nft_payload_fast_ops;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index d8c8a7c..56e1706 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -604,6 +604,8 @@ enum nft_payload_bases {
  * @NFTA_PAYLOAD_BASE: payload base (NLA_U32: nft_payload_bases)
  * @NFTA_PAYLOAD_OFFSET: payload offset relative to base (NLA_U32)
  * @NFTA_PAYLOAD_LEN: payload length (NLA_U32)
+ * @NFTA_PAYLOAD_SREG: source register to load data from (NLA_U32: nft_registers)
+ * @NFTA_PAYLOAD_CSUM_OFFSET: checksum offset relative to base (NLA_U32)
  */
 enum nft_payload_attributes {
 	NFTA_PAYLOAD_UNSPEC,
@@ -611,6 +613,8 @@ enum nft_payload_attributes {
 	NFTA_PAYLOAD_BASE,
 	NFTA_PAYLOAD_OFFSET,
 	NFTA_PAYLOAD_LEN,
+	NFTA_PAYLOAD_SREG,
+	NFTA_PAYLOAD_CSUM_OFFSET,
 	__NFTA_PAYLOAD_MAX
 };
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 09b4b07..d04a31c 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -107,10 +107,12 @@ err:
 }
 
 static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
-	[NFTA_PAYLOAD_DREG]	= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_BASE]	= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_OFFSET]	= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_LEN]	= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_SREG]		= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_DREG]		= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_BASE]		= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_OFFSET]		= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_LEN]		= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_CSUM_OFFSET]	= { .type = NLA_U32 },
 };
 
 static int nft_payload_init(const struct nft_ctx *ctx,
@@ -160,6 +162,100 @@ const struct nft_expr_ops nft_payload_fast_ops = {
 	.dump		= nft_payload_dump,
 };
 
+static void nft_payload_set_eval(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
+{
+	const struct nft_payload *priv = nft_expr_priv(expr);
+	struct sk_buff *skb = pkt->skb;
+	const u32 *src = &regs->data[priv->dreg];
+	int offset, csum_offset;
+	__wsum fsum, tsum;
+	__sum16 sum;
+
+	switch (priv->base) {
+	case NFT_PAYLOAD_LL_HEADER:
+		if (!skb_mac_header_was_set(skb))
+			goto err;
+		offset = skb_mac_header(skb) - skb->data;
+		break;
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		offset = skb_network_offset(skb);
+		break;
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		offset = pkt->xt.thoff;
+		break;
+	default:
+		BUG();
+	}
+
+	csum_offset = offset + priv->csum_offset;
+	offset += priv->offset;
+
+	if (priv->base != NFT_PAYLOAD_TRANSPORT_HEADER ||
+	    skb->ip_summed != CHECKSUM_PARTIAL) {
+		if (skb_copy_bits(skb, csum_offset, &sum, sizeof(sum)) < 0)
+			goto err;
+
+		fsum = skb_checksum(skb, offset, priv->len, 0);
+		tsum = csum_partial(src, priv->len, 0);
+		sum = csum_fold(csum_add(csum_sub(~csum_unfold(sum), fsum),
+					 tsum));
+		if (sum == 0)
+			sum = CSUM_MANGLED_0;
+
+		skb_store_bits(skb, csum_offset, &sum, sizeof(sum));
+	}
+
+	if (!skb_make_writable(skb, offset + priv->len) ||
+	    skb_store_bits(skb, offset, src, priv->len) < 0)
+		goto err;
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
+}
+
+
+static int nft_payload_set_init(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				const struct nlattr * const tb[])
+{
+	struct nft_payload *priv = nft_expr_priv(expr);
+
+	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
+	priv->offset      = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
+	priv->len         = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
+	priv->csum_offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_OFFSET]));
+	priv->dreg        = nft_parse_register(tb[NFTA_PAYLOAD_SREG]);
+
+	return nft_validate_register_load(priv->dreg, priv->len);
+}
+
+static int nft_payload_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_payload *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_PAYLOAD_SREG, priv->dreg) ||
+	    nla_put_be32(skb, NFTA_PAYLOAD_BASE, htonl(priv->base)) ||
+	    nla_put_be32(skb, NFTA_PAYLOAD_OFFSET, htonl(priv->offset)) ||
+	    nla_put_be32(skb, NFTA_PAYLOAD_LEN, htonl(priv->len)) ||
+	    nla_put_be32(skb, NFTA_PAYLOAD_CSUM_OFFSET, htonl(priv->csum_offset)))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static const struct nft_expr_ops nft_payload_set_ops = {
+	.type		= &nft_payload_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload)),
+	.eval		= nft_payload_set_eval,
+	.init		= nft_payload_set_init,
+	.dump		= nft_payload_set_dump,
+};
+
 static const struct nft_expr_ops *
 nft_payload_select_ops(const struct nft_ctx *ctx,
 		       const struct nlattr * const tb[])
@@ -167,8 +263,7 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	enum nft_payload_bases base;
 	unsigned int offset, len;
 
-	if (tb[NFTA_PAYLOAD_DREG] == NULL ||
-	    tb[NFTA_PAYLOAD_BASE] == NULL ||
+	if (tb[NFTA_PAYLOAD_BASE] == NULL ||
 	    tb[NFTA_PAYLOAD_OFFSET] == NULL ||
 	    tb[NFTA_PAYLOAD_LEN] == NULL)
 		return ERR_PTR(-EINVAL);
@@ -183,6 +278,15 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
+	if (tb[NFTA_PAYLOAD_SREG] != NULL) {
+		if (tb[NFTA_PAYLOAD_DREG] != NULL)
+			return ERR_PTR(-EINVAL);
+		return &nft_payload_set_ops;
+	}
+
+	if (tb[NFTA_PAYLOAD_DREG] == NULL)
+		return ERR_PTR(-EINVAL);
+
 	offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
-- 
2.5.0

