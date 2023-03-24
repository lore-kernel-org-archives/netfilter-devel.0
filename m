Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A61C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Mar 2023 19:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjCXTFe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjCXTFd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 15:05:33 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E858C212A2
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2023 12:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9XdpJpBldu31+KJUZG3UFL5eS9kFnEWlEE3ATT7sxFY=; b=K4L3d0xXMEORY7JN677EA0noNK
        FaUM102SK9aOmfQ8S0Ei8Z99+39TOzasMLZKTgeoKuscTVjegKQYRPDbHAyamrDq1av3M+ho16Nlb
        HIyQW97o+UE+a/aZxVKOLfyVhrPyTdIE00GxPX2ob/wfXVKkRZnUzUwDPqWNE4/mmY0TsP9hPQ9MB
        kvd3bopuyvQYg3/bEbmCS9G5kfGbhxCk1TgzKOUUeL45vPka8bqlZspmSELQmtQ/myu0Dt8OGCaES
        Jy1yUOn6WxDUNBc8fDVkwvRD3XJbc7EGy6wsCmu7MRBBmkcBoXPycorvD5RF6aEQin9NbqV0sfFZb
        eNBwUTQA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pfmiF-0044uC-UZ
        for netfilter-devel@vger.kernel.org; Fri, 24 Mar 2023 19:04:31 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 4/4] netfilter: nft_redir: add support for shifted port-ranges
Date:   Fri, 24 Mar 2023 19:04:19 +0000
Message-Id: <20230324190419.543888-5-jeremy@azazel.net>
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
during NAT.  Extend this support to allow them to used in redirecting
as well.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_nat_redirect.c          |  1 +
 net/netfilter/nft_redir.c                | 23 ++++++++++++++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 08780ed008c7..c737e8583274 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1490,12 +1490,14 @@ enum nft_masq_attributes {
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
index 6616ba5d0b04..ff58b563ef99 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -42,6 +42,7 @@ nf_nat_redirect(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	newrange.max_addr	= *newdst;
 	newrange.min_proto	= range->min_proto;
 	newrange.max_proto	= range->max_proto;
+	newrange.base_proto	= range->base_proto;
 
 	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_DST);
 }
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index a70196ffcb1e..bd9b802c1d64 100644
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
 
-	plen = sizeof_field(struct nf_nat_range, min_proto.all);
+	plen = sizeof_field(struct nf_nat_range2, min_proto.all);
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

