Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5EDC6FD20
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Mar 2023 19:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCXTFb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCXTFa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 15:05:30 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D5F1E287
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2023 12:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+SmSGfFxwPJWADPGZCugv+ExpQ6hz75fF8ElVOQzCb4=; b=WbySBdlKNu/yl3X814TBwzXqIf
        02AmS6ePpJeCHDuo2a4IGqT3fBGe1iwboFfGl6UgkekekRLQWBlIT5FkN34Ys6r84JE6JxDeTVsq/
        C5AWQUDH/ykeUiZaXwR8mYIAbMy+GBlHfAkSZesfZPK8krFWzx3PoanBAJKMRpaJ2WAFUVcvZ7eFk
        Cq/xpZB+XQMW4Pd0cDdotEIfO2oK0k+yJE52IOeWSeA2KiaH6KrUmDsjBvbb13Fp39Xfb/IEmauhB
        7I/xnGp8ITdPoVAE9zFITLcDv5GP2itxSN1MtJdOKwQo2TD7yNNGprX6TgbA4KBSX0HNZZCbzx3Ka
        KEjznVZA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pfmiF-0044uC-MS
        for netfilter-devel@vger.kernel.org; Fri, 24 Mar 2023 19:04:31 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 2/4] netfilter: nft_nat: add support for shifted port-ranges
Date:   Fri, 24 Mar 2023 19:04:17 +0000
Message-Id: <20230324190419.543888-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324190419.543888-1-jeremy@azazel.net>
References: <20230324190419.543888-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 2eb0f624b709 ("netfilter: add NAT support for shifted portmap
ranges") introduced support for shifting port-ranges in NAT.  This
allows one to redirect packets intended for one port to another in a
range in such a way that the new port chosen has the same offset in the
range as the original port had from a specified base value.

For example, by using the base value 2000, one could redirect packets
intended for 10.0.0.1:2000-3000 to 10.10.0.1:12000-13000 so that the old
and new ports were at the same offset in their respective ranges, i.e.:

  10.0.0.1:2345 -> 10.10.0.1:12345

However, while support for this was added to the common NAT infra-
structure, only the xt_nat module was updated to make use of it.  This
commit updates the nft_nat module to allow shifted port-ranges to be
used by nftables.

In contrast to xt_nat, where shifting is only available for DNAT, both
DNAT and SNAT are supported.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=970672
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1501
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_nat.c                  | 41 ++++++++++++++++++------
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 9c6f02c26054..2938e878d3fd 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1434,6 +1434,7 @@ enum nft_nat_types {
  * @NFTA_NAT_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
  * @NFTA_NAT_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
+ * @NFTA_NAT_REG_PROTO_BASE: source register of proto range base offset (NLA_U32: nft_registers)
  */
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
@@ -1444,6 +1445,7 @@ enum nft_nat_attributes {
 	NFTA_NAT_REG_PROTO_MIN,
 	NFTA_NAT_REG_PROTO_MAX,
 	NFTA_NAT_FLAGS,
+	NFTA_NAT_REG_PROTO_BASE,
 	__NFTA_NAT_MAX
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 5c29915ab028..75026c8b36c5 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -25,6 +25,7 @@ struct nft_nat {
 	u8			sreg_addr_max;
 	u8			sreg_proto_min;
 	u8			sreg_proto_max;
+	u8			sreg_proto_base;
 	enum nf_nat_manip_type  type:8;
 	u8			family;
 	u16			flags;
@@ -58,6 +59,10 @@ static void nft_nat_setup_proto(struct nf_nat_range2 *range,
 		nft_reg_load16(&regs->data[priv->sreg_proto_min]);
 	range->max_proto.all = (__force __be16)
 		nft_reg_load16(&regs->data[priv->sreg_proto_max]);
+
+	if (priv->sreg_proto_base)
+		range->base_proto.all = (__force __be16)
+			nft_reg_load16(&regs->data[priv->sreg_proto_base]);
 }
 
 static void nft_nat_setup_netmap(struct nf_nat_range2 *range,
@@ -126,13 +131,14 @@ static void nft_nat_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
-	[NFTA_NAT_TYPE]		 = { .type = NLA_U32 },
-	[NFTA_NAT_FAMILY]	 = { .type = NLA_U32 },
-	[NFTA_NAT_REG_ADDR_MIN]	 = { .type = NLA_U32 },
-	[NFTA_NAT_REG_ADDR_MAX]	 = { .type = NLA_U32 },
-	[NFTA_NAT_REG_PROTO_MIN] = { .type = NLA_U32 },
-	[NFTA_NAT_REG_PROTO_MAX] = { .type = NLA_U32 },
-	[NFTA_NAT_FLAGS]	 = { .type = NLA_U32 },
+	[NFTA_NAT_TYPE]		  = { .type = NLA_U32 },
+	[NFTA_NAT_FAMILY]	  = { .type = NLA_U32 },
+	[NFTA_NAT_REG_ADDR_MIN]	  = { .type = NLA_U32 },
+	[NFTA_NAT_REG_ADDR_MAX]	  = { .type = NLA_U32 },
+	[NFTA_NAT_REG_PROTO_MIN]  = { .type = NLA_U32 },
+	[NFTA_NAT_REG_PROTO_MAX]  = { .type = NLA_U32 },
+	[NFTA_NAT_REG_PROTO_BASE] = { .type = NLA_U32 },
+	[NFTA_NAT_FLAGS]	  = { .type = NLA_U32 },
 };
 
 static int nft_nat_validate(const struct nft_ctx *ctx,
@@ -195,10 +201,10 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	switch (family) {
 	case NFPROTO_IPV4:
-		alen = sizeof_field(struct nf_nat_range, min_addr.ip);
+		alen = sizeof_field(struct nf_nat_range2, min_addr.ip);
 		break;
 	case NFPROTO_IPV6:
-		alen = sizeof_field(struct nf_nat_range, min_addr.ip6);
+		alen = sizeof_field(struct nf_nat_range2, min_addr.ip6);
 		break;
 	default:
 		if (tb[NFTA_NAT_REG_ADDR_MIN])
@@ -226,7 +232,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		priv->flags |= NF_NAT_RANGE_MAP_IPS;
 	}
 
-	plen = sizeof_field(struct nf_nat_range, min_proto.all);
+	plen = sizeof_field(struct nf_nat_range2, min_proto.all);
 	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
@@ -239,6 +245,16 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 						      plen);
 			if (err < 0)
 				return err;
+
+			if (tb[NFTA_NAT_REG_PROTO_BASE]) {
+				err = nft_parse_register_load
+					(tb[NFTA_NAT_REG_PROTO_BASE],
+					 &priv->sreg_proto_base, plen);
+				if (err < 0)
+					return err;
+
+				priv->flags |= NF_NAT_RANGE_PROTO_OFFSET;
+			}
 		} else {
 			priv->sreg_proto_max = priv->sreg_proto_min;
 		}
@@ -288,6 +304,11 @@ static int nft_nat_dump(struct sk_buff *skb,
 		    nft_dump_register(skb, NFTA_NAT_REG_PROTO_MAX,
 				      priv->sreg_proto_max))
 			goto nla_put_failure;
+
+		if (priv->sreg_proto_base)
+			if (nft_dump_register(skb, NFTA_NAT_REG_PROTO_BASE,
+					      priv->sreg_proto_base))
+				goto nla_put_failure;
 	}
 
 	if (priv->flags != 0) {
-- 
2.39.2

