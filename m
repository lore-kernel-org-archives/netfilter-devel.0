Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DACDC76196
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Mar 2023 19:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCXTFc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCXTFb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 15:05:31 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD7221297
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2023 12:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+1zOJjOJXUEFWYVQEszFvjsv3UOSgegF0Yh2XyDOLG8=; b=hjbQGijPWhAJ/1Ag8s2zGRsQ26
        AprRj6NathNo7Rr/ZCsjVXp66h631oQuHHmCCLv+/XtIdIAfl3JbJ/vOaFcngEYLa5GaOWQpDP4+n
        YfiHfdgXrswluZi9CgraKkAMmgzM710688hQ8onyn+vwwl2gWFza0cJqdVPRaKH6eKgMVn4gWbwH3
        L2SDYjTzpG8TBhsDcJKDA4FcSBzQW7srDagjA4u/75qfmRxmPHjxeV0C8VY7Tzh9cRWrfwUnNnGgi
        E0jgICdbQQ+kcHxC5qGnCk4dK/kLkxVBCJAAaTe3ZfZ9+2YMOq5R7SPYToQFkQfVK2WxjudT1sct9
        G9tlNwGQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pfmiF-0044uC-QF
        for netfilter-devel@vger.kernel.org; Fri, 24 Mar 2023 19:04:31 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 3/4] netfilter: nft_masq: add support for shifted port-ranges
Date:   Fri, 24 Mar 2023 19:04:18 +0000
Message-Id: <20230324190419.543888-4-jeremy@azazel.net>
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

Support was recently added to nft_nat to allow shifting port-ranges
during NAT.  Extend this support to allow them to used in masquerading
as well.

Set `NF_NAT_RANGE_PROTO_SPECIFIED` flag where appropriate.  `nft_nat`
and `nft_redir` both do this.  It is also set in user space.  However,
it is only ever used internally by the kernel modules, so it would be
good to remove the references to it from user space.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_nat_masquerade.c        |  2 ++
 net/netfilter/nft_masq.c                 | 25 +++++++++++++++++++++++-
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 2938e878d3fd..08780ed008c7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1472,12 +1472,14 @@ enum nft_tproxy_attributes {
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
index b115d77fbbc7..c9674f5a8c7f 100644
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
@@ -88,6 +102,11 @@ static int nft_masq_dump(struct sk_buff *skb,
 		    nft_dump_register(skb, NFTA_MASQ_REG_PROTO_MAX,
 				      priv->sreg_proto_max))
 			goto nla_put_failure;
+
+		if (priv->sreg_proto_base)
+			if (nft_dump_register(skb, NFTA_MASQ_REG_PROTO_BASE,
+					      priv->sreg_proto_base))
+				goto nla_put_failure;
 	}
 
 	return 0;
@@ -110,6 +129,10 @@ static void nft_masq_eval(const struct nft_expr *expr,
 			nft_reg_load16(&regs->data[priv->sreg_proto_min]);
 		range.max_proto.all = (__force __be16)
 			nft_reg_load16(&regs->data[priv->sreg_proto_max]);
+
+		if (priv->sreg_proto_base)
+			range.base_proto.all = (__force __be16)
+				nft_reg_load16(&regs->data[priv->sreg_proto_base]);
 	}
 
 	switch (nft_pf(pkt)) {
-- 
2.39.2

