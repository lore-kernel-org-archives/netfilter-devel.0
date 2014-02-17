From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: [RFC PATCH] netfilter: nf_tables: extend payload to support writing data
Date: Mon, 17 Feb 2014 19:12:17 +0100
Message-ID: <1392660737-10149-1-git-send-email-nikolay@redhat.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Nikolay Aleksandrov <nikolay@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaBQSMd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:12:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch extends the payload expression to support packet writing.
The new payload attribute - SREG specifies the source register to use
when changing packet data, the rest of the attributes are the same:
base - where to start from
offset - offset in the packet
len - length to write

The DREG attribute should not be set if writing is intended, if both
attributes are set the SREG (packet writing) will take precedence.
When the expression is dumped both registers will get dumped and the
user can differentiate the type of the payload (reading/writing) by
checking if the sreg attribute is different from zero.

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
---
I'm sending this patch early thus the RFC (I'm still testing),
just to see if you have any comments on the structure and changes. Now to
justify a few of the changes:
I added the sreg as a separate variable to struct nft_payload in order for
the user to be able to recognize which payload type is the expression when
dumping since both SREG and DREG get dumped.
I also factored the offset code in nft_payload_make_offset since it's used
by both evaluation functions, returns -1 on error.
The two init functions check only the registers as that's what is different
the rest of the attributes are still checked by the select_ops. I've also
allowed to have both SREG and DREG set but in such case SREG takes
precedence.
I left the old payload names as they were, but they can get _get or
something else if you'd like.
One question though, I saw that you've applied my previous power of 2 patch
but I didn't see it in net/net-next, is there another tree that I should be
writing the patches against ?
This patch applies to Dave's net-next tree.

 include/net/netfilter/nf_tables_core.h   |   1 +
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nft_payload.c              | 101 +++++++++++++++++++++++++------
 3 files changed, 84 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index cf2b7ae..0a0bd9a 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -32,6 +32,7 @@ struct nft_payload {
 	u8			offset;
 	u8			len;
 	enum nft_registers	dreg:8;
+	enum nft_registers	sreg:8;
 };
 
 extern const struct nft_expr_ops nft_payload_fast_ops;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 83c985a..7730a36 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -480,6 +480,7 @@ enum nft_payload_bases {
 /**
  * enum nft_payload_attributes - nf_tables payload expression netlink attributes
  *
+ * @NFTA_PAYLOAD_SREG: source register to load data from (NLA_U32: nft_registers)
  * @NFTA_PAYLOAD_DREG: destination register to load data into (NLA_U32: nft_registers)
  * @NFTA_PAYLOAD_BASE: payload base (NLA_U32: nft_payload_bases)
  * @NFTA_PAYLOAD_OFFSET: payload offset relative to base (NLA_U32)
@@ -491,6 +492,7 @@ enum nft_payload_attributes {
 	NFTA_PAYLOAD_BASE,
 	NFTA_PAYLOAD_OFFSET,
 	NFTA_PAYLOAD_LEN,
+	NFTA_PAYLOAD_SREG,
 	__NFTA_PAYLOAD_MAX
 };
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a2aeb31..1b42668 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -17,23 +17,19 @@
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
 
-static void nft_payload_eval(const struct nft_expr *expr,
-			     struct nft_data data[NFT_REG_MAX + 1],
-			     const struct nft_pktinfo *pkt)
+static int nft_payload_make_offset(const struct nft_pktinfo *pkt,
+				   const struct nft_payload *payload)
 {
-	const struct nft_payload *priv = nft_expr_priv(expr);
-	const struct sk_buff *skb = pkt->skb;
-	struct nft_data *dest = &data[priv->dreg];
-	int offset;
+	int offset = -1;
 
-	switch (priv->base) {
+	switch (payload->base) {
 	case NFT_PAYLOAD_LL_HEADER:
-		if (!skb_mac_header_was_set(skb))
-			goto err;
-		offset = skb_mac_header(skb) - skb->data;
+		if (!skb_mac_header_was_set(pkt->skb))
+			return offset;
+		offset = skb_mac_header(pkt->skb) - pkt->skb->data;
 		break;
 	case NFT_PAYLOAD_NETWORK_HEADER:
-		offset = skb_network_offset(skb);
+		offset = skb_network_offset(pkt->skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
 		offset = pkt->xt.thoff;
@@ -41,16 +37,49 @@ static void nft_payload_eval(const struct nft_expr *expr,
 	default:
 		BUG();
 	}
-	offset += priv->offset;
+	offset += payload->offset;
+
+	return offset;
+}
+
+static void nft_payload_eval(const struct nft_expr *expr,
+			     struct nft_data data[NFT_REG_MAX + 1],
+			     const struct nft_pktinfo *pkt)
+{
+	const struct nft_payload *priv = nft_expr_priv(expr);
+	struct nft_data *dest = &data[priv->dreg];
+	int offset = nft_payload_make_offset(pkt, priv);
 
-	if (skb_copy_bits(skb, offset, dest->data, priv->len) < 0)
+	if (offset == -1)
+		goto err;
+	if (skb_copy_bits(pkt->skb, offset, dest->data, priv->len) < 0)
 		goto err;
 	return;
 err:
 	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
+static void nft_payload_set_eval(const struct nft_expr *expr,
+				 struct nft_data data[NFT_REG_MAX + 1],
+				 const struct nft_pktinfo *pkt)
+{
+	const struct nft_payload *priv = nft_expr_priv(expr);
+	struct nft_data *source = &data[priv->sreg];
+	int offset = nft_payload_make_offset(pkt, priv);
+
+	if (offset == -1)
+		goto err;
+	if (!skb_make_writable(pkt->skb, offset + priv->len))
+		goto err;
+	memcpy(pkt->skb->data + offset, source, priv->len);
+
+	return;
+err:
+	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+}
+
 static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
+	[NFTA_PAYLOAD_SREG]	= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_DREG]	= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_BASE]	= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_OFFSET]	= { .type = NLA_U32 },
@@ -75,11 +104,29 @@ static int nft_payload_init(const struct nft_ctx *ctx,
 	return nft_validate_data_load(ctx, priv->dreg, NULL, NFT_DATA_VALUE);
 }
 
+static int nft_payload_set_init(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				const struct nlattr * const tb[])
+{
+	struct nft_payload *priv = nft_expr_priv(expr);
+	int err;
+
+	priv->base   = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
+	priv->offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
+	priv->len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
+
+	priv->sreg = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_SREG]));
+	err = nft_validate_input_register(priv->sreg);
+
+	return err;
+}
+
 static int nft_payload_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_payload *priv = nft_expr_priv(expr);
 
-	if (nla_put_be32(skb, NFTA_PAYLOAD_DREG, htonl(priv->dreg)) ||
+	if (nla_put_be32(skb, NFTA_PAYLOAD_SREG, htonl(priv->sreg)) ||
+	    nla_put_be32(skb, NFTA_PAYLOAD_DREG, htonl(priv->dreg)) ||
 	    nla_put_be32(skb, NFTA_PAYLOAD_BASE, htonl(priv->base)) ||
 	    nla_put_be32(skb, NFTA_PAYLOAD_OFFSET, htonl(priv->offset)) ||
 	    nla_put_be32(skb, NFTA_PAYLOAD_LEN, htonl(priv->len)))
@@ -107,6 +154,14 @@ const struct nft_expr_ops nft_payload_fast_ops = {
 	.dump		= nft_payload_dump,
 };
 
+static const struct nft_expr_ops nft_payload_set_ops = {
+	.type		= &nft_payload_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload)),
+	.eval		= nft_payload_set_eval,
+	.init		= nft_payload_set_init,
+	.dump		= nft_payload_dump,
+};
+
 static const struct nft_expr_ops *
 nft_payload_select_ops(const struct nft_ctx *ctx,
 		       const struct nlattr * const tb[])
@@ -114,7 +169,8 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	enum nft_payload_bases base;
 	unsigned int offset, len;
 
-	if (tb[NFTA_PAYLOAD_DREG] == NULL ||
+	if ((tb[NFTA_PAYLOAD_SREG] == NULL &&
+	    tb[NFTA_PAYLOAD_DREG] == NULL) ||
 	    tb[NFTA_PAYLOAD_BASE] == NULL ||
 	    tb[NFTA_PAYLOAD_OFFSET] == NULL ||
 	    tb[NFTA_PAYLOAD_LEN] == NULL)
@@ -135,10 +191,15 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	if (len == 0 || len > FIELD_SIZEOF(struct nft_data, data))
 		return ERR_PTR(-EINVAL);
 
-	if (len <= 4 && IS_ALIGNED(offset, len) && base != NFT_PAYLOAD_LL_HEADER)
-		return &nft_payload_fast_ops;
-	else
-		return &nft_payload_ops;
+	if (tb[NFTA_PAYLOAD_SREG]) {
+		return &nft_payload_set_ops;
+	} else {
+		if (len <= 4 && IS_ALIGNED(offset, len) &&
+		    base != NFT_PAYLOAD_LL_HEADER)
+			return &nft_payload_fast_ops;
+		else
+			return &nft_payload_ops;
+	}
 }
 
 static struct nft_expr_type nft_payload_type __read_mostly = {
-- 
1.8.4.2

