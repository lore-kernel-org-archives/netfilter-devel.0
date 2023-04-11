Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719ECC7619A
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Apr 2023 20:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjDKUpa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Apr 2023 16:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjDKUpX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Apr 2023 16:45:23 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A919EDF
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Apr 2023 13:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GEjB+84rD9xPubGhA/0UoldGWIGGeohDtKI4znkLAIU=; b=VXRIkhxz47cWvqIkouXLb/xEHw
        XAeY4WEy3K7dw3oV++tUjZBxmdNzsGGnl7fw8zPo8/aJRsfiQM/t1tLZ6FpHtl1GWSxb7QVlaM6FV
        1IRgHxhHTTnbBh4HZSV6z1ix/ut2Vm+e/uWSzPTMzFL5lWU1F/N36aRep4+9J3LEJA/cgwXEwRbVw
        rVriSX1vBxmX5QJMUTX5s21CZNQCZwv+LwSOb/VuTNxqBz2qm2ytLQrNdG1W325vp46dZ7U1snHYP
        Oy6MhZcm1uAbhjg61juqtH2JrSQR+jcmPJVsmZu1HNCPCe3ssi1tILYw5e1xzuXq4qvubAMjRYBer
        FDDkZYyQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pmKrV-009axI-MI
        for netfilter-devel@vger.kernel.org; Tue, 11 Apr 2023 21:45:09 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2] netfilter: nft_exthdr: add boolean DCCP option matching
Date:   Tue, 11 Apr 2023 21:45:04 +0100
Message-Id: <20230411204504.14835-1-jeremy@azazel.net>
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
Changes since v1

 * The order in which `optlen` and `optoff` are assigned and validated
   has been updated in line with Florian's feedback.
 * The whole option block is no longer copied into a buffer in `struct
   nft_exthdr_dccp`.  Access to this was not synchronized, which would
   have been unsafe.  Since DCCP options are encoded in a TLV format and
   we don't need to inspect the values, we use an on-stack buffer with
   enough space to hold the type and length.
 
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nft_exthdr.c               | 105 +++++++++++++++++++++++
 2 files changed, 107 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c4d4d8e42dc8..e059dc2644df 100644
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
index a54a7f772cec..09b99a48e5c3 100644
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
@@ -406,6 +407,81 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 		regs->verdict.code = NFT_BREAK;
 }
 
+static void nft_exthdr_dccp_eval(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
+{
+	struct nft_exthdr *priv = nft_expr_priv(expr);
+	unsigned int thoff, dataoff, optoff, optlen, i;
+	u32 *dest = &regs->data[priv->dreg];
+	const struct dccp_hdr *dh;
+	struct dccp_hdr _dh;
+
+	if (pkt->tprot != IPPROTO_DCCP || pkt->fragoff)
+		goto err;
+
+	thoff = nft_thoff(pkt);
+
+	dh = skb_header_pointer(pkt->skb, thoff, sizeof(_dh), &_dh);
+	if (!dh)
+		goto err;
+
+	dataoff = dh->dccph_doff * sizeof(u32);
+	optoff = __dccp_hdr_len(dh);
+	if (dataoff <= optoff)
+		goto err;
+
+	optlen = dataoff - optoff;
+
+	for (i = 0; i < optlen; ) {
+		/* Options 0 (DCCPO_PADDING) - 31 (DCCPO_MAX_RESERVED) are 1B in
+		 * the length; the remaining options are at least 2B long.  In
+		 * all cases, the first byte contains the option type.  In
+		 * multi-byte options, the second byte contains the option
+		 * length, which must be at least two: 1 for the type plus 1 for
+		 * the length plus 0-253 for any following option data.  We
+		 * aren't interested in the option data, only the type and the
+		 * length, so we don't need to read more than two bytes at a
+		 * time.
+		 */
+		unsigned int buflen;
+		u8 buf[2], *bufp;
+		u8 type, len;
+
+		buflen = optlen - i < sizeof(buf) ? optlen - i : sizeof(buf);
+
+		bufp = skb_header_pointer(pkt->skb, thoff + optoff + i, buflen,
+					  &buf);
+		if (!bufp)
+			goto err;
+
+		type = bufp[0];
+
+		if (type == priv->type) {
+			*dest = 1;
+			return;
+		}
+
+		if (type <= DCCPO_MAX_RESERVED) {
+			i++;
+			continue;
+		}
+
+		if (buflen < 2)
+			goto err;
+
+		len = bufp[1];
+
+		if (len < 2)
+			goto err;
+
+		i += len;
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
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
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

