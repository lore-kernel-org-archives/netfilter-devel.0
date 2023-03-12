Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079C5C6FA99
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Mar 2023 14:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjCLOh0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Mar 2023 10:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCLOh0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Mar 2023 10:37:26 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265EEA5CC
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Mar 2023 07:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HS1mcTWE1Fr15cBmnSuZdnpaVXWXL08H6Hp9v/DjTrU=; b=rXm+iTQdfgRahk1LndzzR7IBcb
        2CcHMfTuJaT3iNeiu1IbUJbedfkohD1srAGDmuEiSaZ53i5Bo5Gj74LzSRsFKYjcGJI05xhrYh2CJ
        YJjrh7sR69AO7OJQ56CMY2M9wKR8OQB63IIIZObjpDLT6snavzSrdiRVlhgAN+g0ryDnHfh7gdUYH
        HXnyQxO1nBptWIvrNOsMRGgZiIlwmxyZoh1J8K3yMui/auqxdJODpNnWHJ7jyDcWV0qFPVgpHZ3nV
        tUon2tqLQKRkNUjz/c3AiEe1r4KqsJoEdMCubq0D3dmU/FVXECsXIrL2NhNXzyoEDcrVx8lFAKrYh
        fXeY30Bw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pbMp9-005aYQ-GN
        for netfilter-devel@vger.kernel.org; Sun, 12 Mar 2023 14:37:23 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next] netfilter: nft_exthdr: add boolean DCCP option matching
Date:   Sun, 12 Mar 2023 14:37:14 +0000
Message-Id: <20230312143714.158943-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The xt_dccp iptables module supports the matching of DCCP packets based
on the presence or absence of DCCP options.  Extend nft_exthdr to add
this functionality to nftables.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=930
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nft_exthdr.c               | 105 +++++++++++++++++++++++
 2 files changed, 107 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 9c6f02c26054..1406952e7139 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -859,12 +859,14 @@ enum nft_exthdr_flags {
  * @NFT_EXTHDR_OP_TCP: match against tcp options
  * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
  * @NFT_EXTHDR_OP_SCTP: match against sctp chunks
+ * @NFT_EXTHDR_OP_DCCP: match against dccp otions
  */
 enum nft_exthdr_op {
 	NFT_EXTHDR_OP_IPV6,
 	NFT_EXTHDR_OP_TCPOPT,
 	NFT_EXTHDR_OP_IPV4,
 	NFT_EXTHDR_OP_SCTP,
+	NFT_EXTHDR_OP_DCCP,
 	__NFT_EXTHDR_OP_MAX
 };
 #define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a54a7f772cec..204feefbb7ea 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -10,6 +10,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/dccp.h>
 #include <linux/sctp.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
@@ -25,6 +26,17 @@ struct nft_exthdr {
 	u8			flags;
 };
 
+struct nft_exthdr_dccp {
+	struct nft_exthdr exthdr;
+	/* A buffer into which to copy the DCCP packet options for parsing.  The
+	 * options are located between the packet header and its data.  The
+	 * offset of the data from the start of the header is stored in an 8-bit
+	 * field as the number of 32-bit words, so the options will definitely
+	 * be shorter than `4 * U8_MAX` bytes.
+	 */
+	u8 optbuf[4 * U8_MAX];
+};
+
 static unsigned int optlen(const u8 *opt, unsigned int offset)
 {
 	/* Beware zero-length options: make finite progress */
@@ -406,6 +418,70 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 		regs->verdict.code = NFT_BREAK;
 }
 
+static void nft_exthdr_dccp_eval(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
+{
+	struct nft_exthdr_dccp *priv_dccp = nft_expr_priv(expr);
+	struct nft_exthdr *priv = &priv_dccp->exthdr;
+	u32 *dest = &regs->data[priv->dreg];
+	unsigned int optoff, optlen, i;
+	const struct dccp_hdr *dh;
+	struct dccp_hdr _dh;
+	const u8 *options;
+
+	if (pkt->tprot != IPPROTO_DCCP || pkt->fragoff)
+		goto err;
+
+	dh = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(_dh), &_dh);
+	if (!dh)
+		goto err;
+
+	if (dh->dccph_doff * 4 < __dccp_hdr_len(dh))
+		goto err;
+
+	optoff = __dccp_hdr_len(dh);
+	optlen = dh->dccph_doff * 4 - optoff;
+
+	if (!optlen)
+		goto err;
+
+	options = skb_header_pointer(pkt->skb, nft_thoff(pkt) + optoff, optlen,
+				     priv_dccp->optbuf);
+	if (!options)
+		goto err;
+
+	for (i = 0; i < optlen; ) {
+		/* Options 0 - 31 are 1B in the length.  Options 32 et seq. are
+		 * at least 2B long.  In all cases, the first byte contains the
+		 * option type.  In multi-byte options, the second byte contains
+		 * the option length, which must be at least two; if it is
+		 * greater than two, there are `len - 2` following bytes of
+		 * option data.
+		 */
+		unsigned int len;
+
+		if (options[i] > 31 && (optlen - i < 2 || options[i + 1] < 2))
+			goto err;
+
+		len = options[i] > 31 ? options[i + 1] : 1;
+
+		if (optlen - i < len)
+			goto err;
+
+		if (options[i] != priv->type) {
+			i += len;
+			continue;
+		}
+
+		*dest = 1;
+		return;
+	}
+
+err:
+	*dest = 0;
+}
+
 static const struct nla_policy nft_exthdr_policy[NFTA_EXTHDR_MAX + 1] = {
 	[NFTA_EXTHDR_DREG]		= { .type = NLA_U32 },
 	[NFTA_EXTHDR_TYPE]		= { .type = NLA_U8 },
@@ -557,6 +633,22 @@ static int nft_exthdr_ipv4_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static int nft_exthdr_dccp_init(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				const struct nlattr * const tb[])
+{
+	struct nft_exthdr *priv = nft_expr_priv(expr);
+	int err = nft_exthdr_init(ctx, expr, tb);
+
+	if (err < 0)
+		return err;
+
+	if (!(priv->flags & NFT_EXTHDR_F_PRESENT))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static int nft_exthdr_dump_common(struct sk_buff *skb, const struct nft_exthdr *priv)
 {
 	if (nla_put_u8(skb, NFTA_EXTHDR_TYPE, priv->type))
@@ -686,6 +778,15 @@ static const struct nft_expr_ops nft_exthdr_sctp_ops = {
 	.reduce		= nft_exthdr_reduce,
 };
 
+static const struct nft_expr_ops nft_exthdr_dccp_ops = {
+	.type		= &nft_exthdr_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr_dccp)),
+	.eval		= nft_exthdr_dccp_eval,
+	.init		= nft_exthdr_dccp_init,
+	.dump		= nft_exthdr_dump,
+	.reduce		= nft_exthdr_reduce,
+};
+
 static const struct nft_expr_ops *
 nft_exthdr_select_ops(const struct nft_ctx *ctx,
 		      const struct nlattr * const tb[])
@@ -720,6 +821,10 @@ nft_exthdr_select_ops(const struct nft_ctx *ctx,
 		if (tb[NFTA_EXTHDR_DREG])
 			return &nft_exthdr_sctp_ops;
 		break;
+	case NFT_EXTHDR_OP_DCCP:
+		if (tb[NFTA_EXTHDR_DREG])
+			return &nft_exthdr_dccp_ops;
+		break;
 	}
 
 	return ERR_PTR(-EOPNOTSUPP);
-- 
2.39.2

