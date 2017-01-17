From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH] netfilter: nf_tables: exthdr: Add support for existence check
Date: Tue, 17 Jan 2017 22:51:26 +0100
Message-ID: <20170117215126.13356-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60803 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbdAQV4S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 16:56:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If NFT_EXTHDR_F_PRESENT is set, exthdr will not copy any header field
data into *dest, but instead set it to 1 if the header is found and 0
otherwise.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h |  6 ++++++
 net/netfilter/nft_exthdr.c               | 14 ++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index b00a05d1ee566..f15696af168ac 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -704,6 +704,10 @@ enum nft_payload_attributes {
 };
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
 
+enum nft_exthdr_flags {
+	NFT_EXTHDR_F_PRESENT = (1 << 0),
+};
+
 /**
  * enum nft_exthdr_attributes - nf_tables IPv6 extension header expression netlink attributes
  *
@@ -711,6 +715,7 @@ enum nft_payload_attributes {
  * @NFTA_EXTHDR_TYPE: extension header type (NLA_U8)
  * @NFTA_EXTHDR_OFFSET: extension header offset (NLA_U32)
  * @NFTA_EXTHDR_LEN: extension header length (NLA_U32)
+ * @NFTA_EXTHDR_FLAGS: extension header flags (NLA_U32)
  */
 enum nft_exthdr_attributes {
 	NFTA_EXTHDR_UNSPEC,
@@ -718,6 +723,7 @@ enum nft_exthdr_attributes {
 	NFTA_EXTHDR_TYPE,
 	NFTA_EXTHDR_OFFSET,
 	NFTA_EXTHDR_LEN,
+	NFTA_EXTHDR_FLAGS,
 	__NFTA_EXTHDR_MAX
 };
 #define NFTA_EXTHDR_MAX		(__NFTA_EXTHDR_MAX - 1)
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 47beb3abcc9da..b5b37f211c417 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -23,6 +23,7 @@ struct nft_exthdr {
 	u8			offset;
 	u8			len;
 	enum nft_registers	dreg:8;
+	u32			flags;
 };
 
 static void nft_exthdr_eval(const struct nft_expr *expr,
@@ -35,8 +36,12 @@ static void nft_exthdr_eval(const struct nft_expr *expr,
 	int err;
 
 	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
-	if (err < 0)
+	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
+		*dest = (err >= 0);
+		return;
+	} else if (err < 0) {
 		goto err;
+	}
 	offset += priv->offset;
 
 	dest[priv->len / NFT_REG32_SIZE] = 0;
@@ -52,6 +57,7 @@ static const struct nla_policy nft_exthdr_policy[NFTA_EXTHDR_MAX + 1] = {
 	[NFTA_EXTHDR_TYPE]		= { .type = NLA_U8 },
 	[NFTA_EXTHDR_OFFSET]		= { .type = NLA_U32 },
 	[NFTA_EXTHDR_LEN]		= { .type = NLA_U32 },
+	[NFTA_EXTHDR_FLAGS]		= { .type = NLA_U32 },
 };
 
 static int nft_exthdr_init(const struct nft_ctx *ctx,
@@ -65,7 +71,8 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_EXTHDR_DREG] == NULL ||
 	    tb[NFTA_EXTHDR_TYPE] == NULL ||
 	    tb[NFTA_EXTHDR_OFFSET] == NULL ||
-	    tb[NFTA_EXTHDR_LEN] == NULL)
+	    tb[NFTA_EXTHDR_LEN] == NULL ||
+	    tb[NFTA_EXTHDR_FLAGS] == NULL)
 		return -EINVAL;
 
 	err = nft_parse_u32_check(tb[NFTA_EXTHDR_OFFSET], U8_MAX, &offset);
@@ -80,6 +87,7 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 	priv->offset = offset;
 	priv->len    = len;
 	priv->dreg   = nft_parse_register(tb[NFTA_EXTHDR_DREG]);
+	priv->flags  = ntohl(nla_get_u32(tb[NFTA_EXTHDR_FLAGS]));
 
 	return nft_validate_register_store(ctx, priv->dreg, NULL,
 					   NFT_DATA_VALUE, priv->len);
@@ -97,6 +105,8 @@ static int nft_exthdr_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_EXTHDR_LEN, htonl(priv->len)))
 		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_EXTHDR_FLAGS, htonl(priv->flags)))
+		goto nla_put_failure;
 	return 0;
 
 nla_put_failure:
-- 
2.11.0

