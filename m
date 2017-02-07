From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next v2,1/2] netfilter: nft_exthdr: Add support for existence check
Date: Tue,  7 Feb 2017 21:20:27 +0100
Message-ID: <1486498828-17936-1-git-send-email-pablo@netfilter.org>
Cc: phil@nwl.cc, fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56624 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932076AbdBGUUv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Feb 2017 15:20:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B6009BA6F1
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Feb 2017 21:20:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4BF9DA84E
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Feb 2017 21:20:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2BF89DA845
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Feb 2017 21:20:35 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Phil Sutter <phil@nwl.cc>

If NFT_EXTHDR_F_PRESENT is set, exthdr will not copy any header field
data into *dest, but instead set it to 1 if the header is found and 0
otherwise.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Phil: I have enhanced your patch shrink flags to u8, also check for
       unexisting flags. As well as the sparse warning. Please review
       if this looks good to you. Thanks.

 include/uapi/linux/netfilter/nf_tables.h |  6 ++++++
 net/netfilter/nft_exthdr.c               | 20 ++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7b730cab99bd..53aac8b8ed6b 100644
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
index 47beb3abcc9d..d43f750ab61c 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -23,6 +23,7 @@ struct nft_exthdr {
 	u8			offset;
 	u8			len;
 	enum nft_registers	dreg:8;
+	u8			flags;
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
@@ -59,7 +65,7 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
-	u32 offset, len;
+	u32 offset, len, flags;
 	int err;
 
 	if (tb[NFTA_EXTHDR_DREG] == NULL ||
@@ -76,10 +82,18 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	err = nft_parse_u32_check(tb[NFTA_EXTHDR_FLAGS], U8_MAX, &flags);
+	if (err < 0)
+		return err;
+
+	if (flags & ~NFT_EXTHDR_F_PRESENT)
+		return -EINVAL;
+
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
 	priv->offset = offset;
 	priv->len    = len;
 	priv->dreg   = nft_parse_register(tb[NFTA_EXTHDR_DREG]);
+	priv->flags  = flags;
 
 	return nft_validate_register_store(ctx, priv->dreg, NULL,
 					   NFT_DATA_VALUE, priv->len);
@@ -97,6 +111,8 @@ static int nft_exthdr_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_EXTHDR_LEN, htonl(priv->len)))
 		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_EXTHDR_FLAGS, htonl(priv->flags)))
+		goto nla_put_failure;
 	return 0;
 
 nla_put_failure:
-- 
2.1.4

