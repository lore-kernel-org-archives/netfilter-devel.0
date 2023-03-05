Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB3F7C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 12:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjCEMeU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 07:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjCEMeR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 07:34:17 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8DAEC6B
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 04:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W0fDvTQIfFLVEyi+c1yf0Iy3NLE3+H20FSNWg7iQkwk=; b=BVYBajf+zkIlqwcGNmkI18uUvN
        OaaJl+Rw+bLOI8n1uJuYH/zUMVRmfOYJpob/qvkmP+ZyBGfzwDF8/maaE0zOvELJ8LIiJ5bVApWl5
        +z6tQU6i11Siuaw0LAT5XVaRosnnJSrtfFk+/Ao5wQBZ0LThMh39I1Gqg+O+SXeXexGca7Ds3FDEP
        uHPIjph4ehBu82ptcvmDEWuHabNoTU2FudwVdEMBixEZ0XkY72MA92NYAnWSt1614sguASAGLdf0G
        G4CqECImZgGL9pfXPtC3x6vjKx6lJo1m9/C+qB4Q3PYOKY+q0KhbnvwJD2habgroLf+C4jf/xFQRm
        VurKt1YA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYnZ7-00E3og-4N
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 12:34:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 08/13] netfilter: nft_masq: add support for shifted port-ranges
Date:   Sun,  5 Mar 2023 12:18:12 +0000
Message-Id: <20230305121817.2234734-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305121817.2234734-1-jeremy@azazel.net>
References: <20230305121817.2234734-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support was recently added to nft_nat to allow shifting port-ranges
during NAT.  Extend this support to allow them to used in masquerading
as well.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_nat_masquerade.c        |  2 ++
 net/netfilter/nft_masq.c                 | 22 ++++++++++++++++++++--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index af6032720c78..bab3e3c6de74 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1470,12 +1470,14 @@ enum nft_tproxy_attributes {
  * @NFTA_MASQ_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
  * @NFTA_MASQ_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_MASQ_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
+ * @NFTA_MASQ_REG_PROTO_BASE: source register of proto range base offset (NLA_U32: nft_registers)
  */
 enum nft_masq_attributes {
 	NFTA_MASQ_UNSPEC,
 	NFTA_MASQ_FLAGS,
 	NFTA_MASQ_REG_PROTO_MIN,
 	NFTA_MASQ_REG_PROTO_MAX,
+	NFTA_MASQ_REG_PROTO_BASE,
 	__NFTA_MASQ_MAX
 };
 #define NFTA_MASQ_MAX		(__NFTA_MASQ_MAX - 1)
diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 1a506b0c6511..8d40b507d4ad 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -69,6 +69,7 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 	newrange.max_addr.ip = newsrc;
 	newrange.min_proto   = range->min_proto;
 	newrange.max_proto   = range->max_proto;
+	newrange.base_proto  = range->base_proto;
 
 	/* Hand modified range to generic setup. */
 	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
@@ -264,6 +265,7 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	newrange.max_addr.in6	= src;
 	newrange.min_proto	= range->min_proto;
 	newrange.max_proto	= range->max_proto;
+	newrange.base_proto     = range->base_proto;
 
 	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
 }
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index b115d77fbbc7..80cf5d59b917 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -17,12 +17,14 @@ struct nft_masq {
 	u32			flags;
 	u8			sreg_proto_min;
 	u8			sreg_proto_max;
+	u8			sreg_proto_base;
 };
 
 static const struct nla_policy nft_masq_policy[NFTA_MASQ_MAX + 1] = {
 	[NFTA_MASQ_FLAGS]		= { .type = NLA_U32 },
 	[NFTA_MASQ_REG_PROTO_MIN]	= { .type = NLA_U32 },
 	[NFTA_MASQ_REG_PROTO_MAX]	= { .type = NLA_U32 },
+	[NFTA_MASQ_REG_PROTO_BASE]	= { .type = NLA_U32 },
 };
 
 static int nft_masq_validate(const struct nft_ctx *ctx,
@@ -43,7 +45,7 @@ static int nft_masq_init(const struct nft_ctx *ctx,
 			 const struct nft_expr *expr,
 			 const struct nlattr * const tb[])
 {
-	u32 plen = sizeof_field(struct nf_nat_range, min_proto.all);
+	u32 plen = sizeof_field(struct nf_nat_range2, min_proto.all);
 	struct nft_masq *priv = nft_expr_priv(expr);
 	int err;
 
@@ -65,9 +67,21 @@ static int nft_masq_init(const struct nft_ctx *ctx,
 						      plen);
 			if (err < 0)
 				return err;
+
+			if (tb[NFTA_MASQ_REG_PROTO_BASE]) {
+				err = nft_parse_register_load
+					(tb[NFTA_MASQ_REG_PROTO_BASE],
+					 &priv->sreg_proto_base, plen);
+				if (err < 0)
+					return err;
+
+				priv->flags |= NF_NAT_RANGE_PROTO_OFFSET;
+			}
 		} else {
 			priv->sreg_proto_max = priv->sreg_proto_min;
 		}
+
+		priv->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 
 	return nf_ct_netns_get(ctx->net, ctx->family);
@@ -86,7 +100,9 @@ static int nft_masq_dump(struct sk_buff *skb,
 		if (nft_dump_register(skb, NFTA_MASQ_REG_PROTO_MIN,
 				      priv->sreg_proto_min) ||
 		    nft_dump_register(skb, NFTA_MASQ_REG_PROTO_MAX,
-				      priv->sreg_proto_max))
+				      priv->sreg_proto_max) ||
+		    nft_dump_register(skb, NFTA_MASQ_REG_PROTO_BASE,
+				      priv->sreg_proto_base))
 			goto nla_put_failure;
 	}
 
@@ -110,6 +126,8 @@ static void nft_masq_eval(const struct nft_expr *expr,
 			nft_reg_load16(&regs->data[priv->sreg_proto_min]);
 		range.max_proto.all = (__force __be16)
 			nft_reg_load16(&regs->data[priv->sreg_proto_max]);
+		range.base_proto.all = (__force __be16)
+			nft_reg_load16(&regs->data[priv->sreg_proto_base]);
 	}
 
 	switch (nft_pf(pkt)) {
-- 
2.39.2

