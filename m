Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B3EC678DB
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 12:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjCEMeV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 07:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCEMeR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 07:34:17 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D641EC4F
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 04:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MEIzqMebzKeGL0RM0KolMi7MmHbIDKW4+Mge/rtVQkI=; b=cs1BfMdEGir/q5RjzI5NqIbds1
        Tmn6/11hHb6hUl8TWLu2z2JfhB+iqJEb/EqK6IlFYY0oG2nS0V/7nsirI753MtrrA40lKCjXPIrZ3
        weLDvCq9kCts+saUCfUkghj2ESOsc0IuM6lL6iAn1dCaiGvpr2qpWCfWrJERdaGJCb/w3q6Hj6SCl
        tegB2TSoVq1AMr8ZEF+nZhx5/qmTCX4qujcRVmCkvnsdirxPVQOHVPFL9htIBlMLLnNMrf2ADbEAo
        fw8618O2i0x/g/lo8FYtdIfVjZtN6GRVhh7CqKKCL7NJJWeGtctSurYD6rtoMoXpINZWsLhjh1LkZ
        /WN2TT8w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYnZ6-00E3og-QL
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 12:34:12 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 05/13] netfilter: nft_nat: add support for shifted port-ranges
Date:   Sun,  5 Mar 2023 12:18:09 +0000
Message-Id: <20230305121817.2234734-6-jeremy@azazel.net>
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
 net/netfilter/nft_nat.c                  | 38 +++++++++++++++++-------
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index ff677f3a6cad..af6032720c78 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1432,6 +1432,7 @@ enum nft_nat_types {
  * @NFTA_NAT_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
  * @NFTA_NAT_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
+ * @NFTA_NAT_REG_PROTO_BASE: source register of proto range base offset (NLA_U32: nft_registers)
  */
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
@@ -1442,6 +1443,7 @@ enum nft_nat_attributes {
 	NFTA_NAT_REG_PROTO_MIN,
 	NFTA_NAT_REG_PROTO_MAX,
 	NFTA_NAT_FLAGS,
+	NFTA_NAT_REG_PROTO_BASE,
 	__NFTA_NAT_MAX
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 5c29915ab028..0517a3efb259 100644
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
@@ -58,6 +59,8 @@ static void nft_nat_setup_proto(struct nf_nat_range2 *range,
 		nft_reg_load16(&regs->data[priv->sreg_proto_min]);
 	range->max_proto.all = (__force __be16)
 		nft_reg_load16(&regs->data[priv->sreg_proto_max]);
+	range->base_proto.all = (__force __be16)
+		nft_reg_load16(&regs->data[priv->sreg_proto_base]);
 }
 
 static void nft_nat_setup_netmap(struct nf_nat_range2 *range,
@@ -126,13 +129,14 @@ static void nft_nat_eval(const struct nft_expr *expr,
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
@@ -195,10 +199,10 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
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
@@ -226,7 +230,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		priv->flags |= NF_NAT_RANGE_MAP_IPS;
 	}
 
-	plen = sizeof_field(struct nf_nat_range, min_proto.all);
+	plen = sizeof_field(struct nf_nat_range2, min_proto.all);
 	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
@@ -239,6 +243,16 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
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
@@ -286,7 +300,9 @@ static int nft_nat_dump(struct sk_buff *skb,
 		if (nft_dump_register(skb, NFTA_NAT_REG_PROTO_MIN,
 				      priv->sreg_proto_min) ||
 		    nft_dump_register(skb, NFTA_NAT_REG_PROTO_MAX,
-				      priv->sreg_proto_max))
+				      priv->sreg_proto_max) ||
+		    nft_dump_register(skb, NFTA_NAT_REG_PROTO_BASE,
+				      priv->sreg_proto_base))
 			goto nla_put_failure;
 	}
 
-- 
2.39.2

