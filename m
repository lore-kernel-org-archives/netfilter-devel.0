From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables-kernel PATCH 7/7] netfilter: nf_tables: Improve payload expression for an extra offset
Date: Mon, 14 Oct 2013 15:46:56 +0300
Message-ID: <1381754816-28472-8-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52811 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab3JNMrL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:47:11 -0400
In-Reply-To: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Payload expression gets a new attribute: NFTA_PAYLOAD_SREG_EXTRA
This attribute will permit to provide a source register where an extra
offset will be added to the fixed offset of the expression.

This will be useful where some information cannot be found at a
pre-determined place. Such as the protocol address of an ARP-ETH packet:
its position is determined by the hardware address length.

Thus, in this example, a meta expression NFT_META_DEV_ADDRLEN will load
the value of the hardware length and put it into a register: such register,
as a NFTA_PAYLOAD_SREG_EXTRA in following payload expression, will be used
to add the hardware length to the fixed offset.

Suggested by Pablo Neira Ayuso.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/net/netfilter/nf_tables_core.h   |  1 +
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_core.c           |  6 +++++-
 net/netfilter/nft_payload.c              | 25 +++++++++++++++++++------
 4 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index fe7b162..5962528 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -31,6 +31,7 @@ struct nft_payload {
 	enum nft_payload_bases	base:8;
 	u8			offset;
 	u8			len;
+	enum nft_registers      sreg:8;
 	enum nft_registers	dreg:8;
 };
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 8b12b8f..a8d8aa6 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -511,6 +511,7 @@ enum nft_payload_bases {
  * @NFTA_PAYLOAD_DREG: destination register to load data into (NLA_U32: nft_registers)
  * @NFTA_PAYLOAD_BASE: payload base (NLA_U32: nft_payload_bases)
  * @NFTA_PAYLOAD_OFFSET: payload offset relative to base (NLA_U32)
+ * @NFTA_PAYLOAD_SREG_EXTRA: source register of an extra offset (NLA_U32: nft_registers)
  * @NFTA_PAYLOAD_LEN: payload length (NLA_U32)
  */
 enum nft_payload_attributes {
@@ -518,6 +519,7 @@ enum nft_payload_attributes {
 	NFTA_PAYLOAD_DREG,
 	NFTA_PAYLOAD_BASE,
 	NFTA_PAYLOAD_OFFSET,
+	NFTA_PAYLOAD_SREG_EXTRA,
 	NFTA_PAYLOAD_LEN,
 	__NFTA_PAYLOAD_MAX
 };
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 2324dd8..e9200e7 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -40,6 +40,7 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	const struct nft_payload *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
 	struct nft_data *dest = &data[priv->dreg];
+	int extra_offset = 0;
 	unsigned char *ptr;
 
 	if (priv->base == NFT_PAYLOAD_NETWORK_HEADER)
@@ -47,7 +48,10 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	else
 		ptr = skb_network_header(skb) + pkt->xt.thoff;
 
-	ptr += priv->offset;
+	if (priv->sreg)
+		extra_offset = (int) *data[priv->sreg].data;
+
+	ptr += extra_offset + priv->offset;
 
 	if (unlikely(ptr + priv->len >= skb_tail_pointer(skb)))
 		return false;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a2aeb31..41d3f21 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -24,7 +24,7 @@ static void nft_payload_eval(const struct nft_expr *expr,
 	const struct nft_payload *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
 	struct nft_data *dest = &data[priv->dreg];
-	int offset;
+	int offset, extra_offset = 0;
 
 	switch (priv->base) {
 	case NFT_PAYLOAD_LL_HEADER:
@@ -41,7 +41,11 @@ static void nft_payload_eval(const struct nft_expr *expr,
 	default:
 		BUG();
 	}
-	offset += priv->offset;
+
+	if (priv->sreg)
+		extra_offset = (int) *data[priv->sreg].data;
+
+	offset += extra_offset + priv->offset;
 
 	if (skb_copy_bits(skb, offset, dest->data, priv->len) < 0)
 		goto err;
@@ -51,10 +55,11 @@ err:
 }
 
 static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
-	[NFTA_PAYLOAD_DREG]	= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_BASE]	= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_OFFSET]	= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_LEN]	= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_DREG]		= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_BASE]		= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_OFFSET]		= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_SREG_EXTRA]	= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_LEN]		= { .type = NLA_U32 },
 };
 
 static int nft_payload_init(const struct nft_ctx *ctx,
@@ -68,6 +73,14 @@ static int nft_payload_init(const struct nft_ctx *ctx,
 	priv->offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
+	if (tb[NFTA_PAYLOAD_SREG_EXTRA]) {
+		priv->sreg = ntohl(nla_get_be32(
+					tb[NFTA_PAYLOAD_SREG_EXTRA]));
+		err = nft_validate_input_register(priv->sreg);
+		if (err < 0)
+			return err;
+	}
+
 	priv->dreg = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_DREG]));
 	err = nft_validate_output_register(priv->dreg);
 	if (err < 0)
-- 
1.8.3.2

