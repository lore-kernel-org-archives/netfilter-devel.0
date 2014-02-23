From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: [RFC PATCH] netfilter: nf_tables: extend payload to support writing data
Date: Sun, 23 Feb 2014 18:32:22 +0100
Message-ID: <1393176742-28171-1-git-send-email-nikolay@redhat.com>
Cc: kaber@trash.net, pablo@netfilter.org,
	Nikolay Aleksandrov <nikolay@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbaBWRfV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Feb 2014 12:35:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch extends the payload expression to support packet writing.
The new payload attribute - SREG specifies the source register to use
when changing packet data, the rest of the attributes are the same:
base - where to start from
offset - offset in the packet
len - length to write

The DREG attribute should not be set if writing is intended, if both
attributes are set an error will be returned.

The checksum update is done automatically for the following cases:
IPv4 checksum - changing the IPv4 header
TCP checksum - changing addresses in the network header (pseudo) or
               changing TCP header/packet data
UDP checksum - same as TCP
The pseudo header works for both IPv4 and IPv6.

The following restrictions apply:
- Cross-header writing (NH -> TH) won't get their checksum updated
  properly.
- The "checksum" fields of the respective headers should not be altered.
- If altering an address in the network header, the write should not
  alter any other field. (This is okay for IPv4 as the previous field
  is the checksum, but changing the IPv6 "hop limit" and the first bytes
  of the source address should not be done for example)

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
---
This is _strictly_ RFC, I have some cleanups to do and a ton of tests
to run :-)

Now some explanation, this is the simplest way of doing it that I could
think of. I also have a version which doesn't copy in order to align but
writes directly in "broken" number of bytes i.e. if we had to shift 3 bytes
in order to round offset then on each iteration it'll either write 3 bytes
or 1 byte with heavy use of bitfield manipulation and asynchronous word
counting (i.e. one for the src and one for the dst). I don't believe that
the speed difference will be big so I prefer the simpler approach, if you
have any suggestion I'm willing to change the algorithm :-)

I think the rest is in the commit message, I'll continue to clean it up and
run some more tests. I think I've addressed all comments from the previous
RFC posting.
This patch should apply to Dave's net-next tree.

 include/net/netfilter/nf_tables_core.h   |   1 +
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nft_payload.c              | 255 +++++++++++++++++++++++++++++--
 3 files changed, 243 insertions(+), 15 deletions(-)

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
index a2aeb31..d27d4ed 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -14,22 +14,173 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/inetdevice.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/ip.h>
 
-static void nft_payload_eval(const struct nft_expr *expr,
-			     struct nft_data data[NFT_REG_MAX + 1],
-			     const struct nft_pktinfo *pkt)
+static u32 __mask_byte(u32 low, u32 high)
+{
+	return GENMASK_ULL(high * BITS_PER_BYTE - 1, low * BITS_PER_BYTE);
+}
+
+/**
+ * __adjust_cksum - adjust a checksum
+ * @sum: the original checksum which is to be adjusted
+ * @old: the original data
+ * @new: the new data
+ * @len: length which is going to change
+ * @off: alignment offset for @new to align with @old in bytes
+ * @alignbuf: pointer to the extra buffer for alignment
+ * @pseudo: calculating a pseudo header
+ *
+ * This function adjusts sum as if the bytes of @old were changed to @new >>
+ * 4 - @off (the shift here is a byte shift). @off is the offset counting from
+ * the LSB, so the offset from the MSB is 4 - off.
+ */
+static void __adjust_cksum(__sum16 *sum, u32 *old, u32 *new, u8 len, u32 off,
+			   u32 *alignbuf, bool pseudo)
+{
+	u32 mask, oldval, newval, written, tmpval, word, tot_words;
+
+	if (WARN_ON(len > 16))
+		return;
+
+	tot_words = roundup(len, 4) / 4;
+	/* align old with new and offset */
+	if (len > off && 4 - off > 0) {
+		memcpy((u8 *)alignbuf + 4 - off, new, len);
+		new = alignbuf;
+		tot_words = roundup(len + 4 - off, 4) / 4;
+	}
+
+	/* Initial bytes to write, either everything or the leftover space */
+	if (len <= off)
+		written = len;
+	else
+		written = off;
+	mask = __mask_byte(off - written, off);
+	for (word = 0; word < tot_words; word++, written += tmpval) {
+		oldval = ntohl(old[word]) & mask;
+		newval = ntohl(new[word]) & mask;
+		if (!pseudo) {
+			csum_replace4(sum, htonl(oldval), htonl(newval));
+		} else {
+			__be32 diff[] = { ~htonl(oldval), htonl(newval) };
+
+			*sum = ~csum_fold(csum_partial(diff, sizeof(diff),
+					  csum_unfold(*sum)));
+		}
+		tmpval = len - written > 4 ? 4 : len - written;
+		mask = __mask_byte(4 - tmpval, 4);
+	}
+}
+
+static void nft_payload_fix_cksum(const struct nft_pktinfo *pkt,
+				  const struct nft_payload *priv,
+				  struct nft_data *source,
+				  int offset)
+{
+	u32 byteoff, *oldp, chkoff, alignbuf[5];
+	struct sk_buff *skb = pkt->skb;
+	__sum16 *chkp = NULL;
+	struct tcphdr *tcph;
+	struct udphdr *udph;
+	struct iphdr *iph;
+	bool pseudo = 0;
+	int nhoff;
+
+	if (pkt->xt.family != NFPROTO_IPV4 &&
+	    pkt->xt.family != NFPROTO_IPV6)
+		return;
+
+	nhoff = skb_network_offset(skb);
+	switch (priv->base) {
+	case NFT_PAYLOAD_LL_HEADER:
+		/* Entirely in LL header, no need to update */
+		if (offset + priv->len < nhoff)
+			break;
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		if (offset >= pkt->xt.thoff)
+			goto do_th;
+		oldp = (u32 *)(skb->data + rounddown(offset, 4));
+		byteoff = 4 - (offset - rounddown(offset, 4));
+		if (pkt->xt.family == NFPROTO_IPV4) {
+			/* Make sure we can update the checksum */
+			iph = ip_hdr(skb);
+			chkoff = nhoff + offsetof(struct iphdr, check) +
+				 sizeof(iph->check);
+			if (offset + priv->len < chkoff &&
+			    !skb_make_writable(skb, chkoff))
+				break;
+			if (offset >= nhoff + offsetof(struct iphdr, saddr))
+				pseudo = 1;
+
+			__adjust_cksum(&iph->check, oldp, &source->data[0],
+				       priv->len, byteoff, alignbuf, 0);
+		} else {
+			if (offset >= nhoff + offsetof(struct ipv6hdr, saddr))
+				pseudo = 1;
+		}
+		if (!pseudo)
+			break;
+do_th:
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+			if (pkt->tprot == IPPROTO_TCP) {
+				tcph = (struct tcphdr *)(skb->data +
+							 pkt->xt.thoff);
+				chkoff = pkt->xt.thoff +
+					 offsetof(struct tcphdr, check) +
+					 sizeof(tcph->check);
+				chkp = &tcph->check;
+			} else if (pkt->tprot == IPPROTO_UDP) {
+				udph = (struct udphdr *)(skb->data +
+							 pkt->xt.thoff);
+				chkoff = pkt->xt.thoff +
+					 offsetof(struct udphdr, check) +
+					 sizeof(udph->check);
+				chkp = &udph->check;
+			}
+			/* Check if we have a valid protocol */
+			if (!chkp)
+				break;
+
+			/* Make sure we can update the checksum */
+			if (offset + priv->len < chkoff &&
+			    !skb_make_writable(skb, chkoff))
+				break;
+
+			/* We're here because the address got changed, update
+			 * only that as we don't allow cross-header writing.
+			 */
+			if (pseudo) {
+				__adjust_cksum(chkp, oldp, &source->data[0],
+					       priv->len, byteoff, alignbuf, 1);
+				break;
+			}
+
+			oldp = (u32 *)(skb->data + rounddown(priv->offset, 4));
+			byteoff = 4 - (offset - rounddown(priv->offset, 4));
+			__adjust_cksum(chkp, oldp, &source->data[0], priv->len,
+				       byteoff, alignbuf, 0);
+		break;
+	default:
+		break;
+	}
+}
+
+static int nft_payload_make_offset(const struct nft_pktinfo *pkt,
+				   const struct nft_payload *priv)
 {
-	const struct nft_payload *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-	struct nft_data *dest = &data[priv->dreg];
-	int offset;
+	int offset = -1;
 
 	switch (priv->base) {
 	case NFT_PAYLOAD_LL_HEADER:
 		if (!skb_mac_header_was_set(skb))
-			goto err;
+			return offset;
 		offset = skb_mac_header(skb) - skb->data;
 		break;
 	case NFT_PAYLOAD_NETWORK_HEADER:
@@ -43,14 +194,49 @@ static void nft_payload_eval(const struct nft_expr *expr,
 	}
 	offset += priv->offset;
 
-	if (skb_copy_bits(skb, offset, dest->data, priv->len) < 0)
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
+
+	if (offset == -1)
+		goto err;
+	if (skb_copy_bits(pkt->skb, offset, dest->data, priv->len) < 0)
+		goto err;
+	return;
+err:
+	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+}
+
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
 		goto err;
+
+	nft_payload_fix_cksum(pkt, priv, source, offset);
+	memcpy(pkt->skb->data + offset, source, priv->len);
+
 	return;
 err:
 	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
 static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
+	[NFTA_PAYLOAD_SREG]	= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_DREG]	= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_BASE]	= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_OFFSET]	= { .type = NLA_U32 },
@@ -75,12 +261,35 @@ static int nft_payload_init(const struct nft_ctx *ctx,
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
-	    nla_put_be32(skb, NFTA_PAYLOAD_BASE, htonl(priv->base)) ||
+	if (priv->sreg) {
+		if (nla_put_be32(skb, NFTA_PAYLOAD_SREG, htonl(priv->sreg)))
+			goto nla_put_failure;
+	} else {
+		if (nla_put_be32(skb, NFTA_PAYLOAD_DREG, htonl(priv->dreg)))
+			goto nla_put_failure;
+	}
+	if (nla_put_be32(skb, NFTA_PAYLOAD_BASE, htonl(priv->base)) ||
 	    nla_put_be32(skb, NFTA_PAYLOAD_OFFSET, htonl(priv->offset)) ||
 	    nla_put_be32(skb, NFTA_PAYLOAD_LEN, htonl(priv->len)))
 		goto nla_put_failure;
@@ -107,6 +316,14 @@ const struct nft_expr_ops nft_payload_fast_ops = {
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
@@ -114,11 +331,14 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	enum nft_payload_bases base;
 	unsigned int offset, len;
 
-	if (tb[NFTA_PAYLOAD_DREG] == NULL ||
+	if ((tb[NFTA_PAYLOAD_SREG] == NULL &&
+	    tb[NFTA_PAYLOAD_DREG] == NULL) ||
 	    tb[NFTA_PAYLOAD_BASE] == NULL ||
 	    tb[NFTA_PAYLOAD_OFFSET] == NULL ||
 	    tb[NFTA_PAYLOAD_LEN] == NULL)
 		return ERR_PTR(-EINVAL);
+	if (tb[NFTA_PAYLOAD_SREG] && tb[NFTA_PAYLOAD_DREG])
+		return ERR_PTR(-EINVAL);
 
 	base = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	switch (base) {
@@ -135,10 +355,15 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
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

