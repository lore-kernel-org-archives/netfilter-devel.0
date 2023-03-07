Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7245C6FD1E
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 23:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCGXbp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 18:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCGXbk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 18:31:40 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8A8A8E98
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 15:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ze7HW2K/3yDW5ws4Ak4ExqR4mml7aPSUkkqCpCYl1I4=; b=ol+38VknR24tquHhsHVJMWvsY0
        2x0txzBDvGH09FKjuQiBX8hYMOV9cbW5cE8U4UJrituokPtHzUyVQdqKIOZsRmY52PDZuVmUT/wtj
        VFM8+Y2+9hlf+Gtro9aqY98wFMKA21OAN07QIKk3c1gA5zLVzyN+2ebftrTIQ0uO1wO4riwhgBF85
        eN5wj/FOfgLK/ZHlU5Dzz20rXIhD59rxHVgMyuToRYGexZsSFeVMEb6insk1l+DWXlQuZ4H709n3K
        v+f0UWG7GgRhm782TVfrv0IxyAtrCDKHalIFEKYZW95OO6eYaaZ6zWWAqPhaahhIUPKl4YunjS3vw
        OGCpMTtQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pZgmN-00H2Ov-JH
        for netfilter-devel@vger.kernel.org; Tue, 07 Mar 2023 23:31:35 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 9/9] netfilter: nft_redir: add support for shifted port-ranges
Date:   Tue,  7 Mar 2023 23:30:56 +0000
Message-Id: <20230307233056.2681361-10-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307233056.2681361-1-jeremy@azazel.net>
References: <20230307233056.2681361-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support was recently added to nft_nat to allow shifting port-ranges
during NAT.  Extend this support to allow them to used in redirecting
as well.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_nat_redirect.c          |  1 +
 net/netfilter/nft_redir.c                | 23 ++++++++++++++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index bab3e3c6de74..7249b67acd67 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1488,12 +1488,14 @@ enum nft_masq_attributes {
  * @NFTA_REDIR_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_REDIR_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
  * @NFTA_REDIR_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
+ * @NFTA_REDIR_REG_PROTO_BASE: source register of proto range base offset (NLA_U32: nft_registers)
  */
 enum nft_redir_attributes {
 	NFTA_REDIR_UNSPEC,
 	NFTA_REDIR_REG_PROTO_MIN,
 	NFTA_REDIR_REG_PROTO_MAX,
 	NFTA_REDIR_FLAGS,
+	NFTA_REDIR_REG_PROTO_BASE,
 	__NFTA_REDIR_MAX
 };
 #define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index 54ce8e6113ed..5641078da2cb 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -41,6 +41,7 @@ nf_nat_redirect(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	newrange.max_addr	= *newdst;
 	newrange.min_proto	= range->min_proto;
 	newrange.max_proto	= range->max_proto;
+	newrange.base_proto	= range->base_proto;
 
 	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_DST);
 }
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 1d52a05a8b03..adb010c40a07 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -16,12 +16,14 @@
 struct nft_redir {
 	u8			sreg_proto_min;
 	u8			sreg_proto_max;
+	u8			sreg_proto_base;
 	u16			flags;
 };
 
 static const struct nla_policy nft_redir_policy[NFTA_REDIR_MAX + 1] = {
 	[NFTA_REDIR_REG_PROTO_MIN]	= { .type = NLA_U32 },
 	[NFTA_REDIR_REG_PROTO_MAX]	= { .type = NLA_U32 },
+	[NFTA_REDIR_REG_PROTO_BASE]	= { .type = NLA_U32 },
 	[NFTA_REDIR_FLAGS]		= { .type = NLA_U32 },
 };
 
@@ -48,7 +50,7 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 	unsigned int plen;
 	int err;
 
-	plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	plen = sizeof_field(struct nf_nat_range2, min_addr.all);
 	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_REDIR_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
@@ -61,6 +63,16 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 						      plen);
 			if (err < 0)
 				return err;
+
+			if (tb[NFTA_REDIR_REG_PROTO_BASE]) {
+				err = nft_parse_register_load
+					(tb[NFTA_REDIR_REG_PROTO_BASE],
+					 &priv->sreg_proto_base, plen);
+				if (err < 0)
+					return err;
+
+				priv->flags |= NF_NAT_RANGE_PROTO_OFFSET;
+			}
 		} else {
 			priv->sreg_proto_max = priv->sreg_proto_min;
 		}
@@ -89,6 +101,11 @@ static int nft_redir_dump(struct sk_buff *skb,
 		if (nft_dump_register(skb, NFTA_REDIR_REG_PROTO_MAX,
 				      priv->sreg_proto_max))
 			goto nla_put_failure;
+
+		if (priv->sreg_proto_base)
+			if (nft_dump_register(skb, NFTA_REDIR_REG_PROTO_BASE,
+					      priv->sreg_proto_base))
+				goto nla_put_failure;
 	}
 
 	if (priv->flags != 0 &&
@@ -115,6 +132,10 @@ static void nft_redir_eval(const struct nft_expr *expr,
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

