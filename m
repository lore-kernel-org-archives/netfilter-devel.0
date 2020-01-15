Return-Path: <SRS0=+R7G=3E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DABD7C33CB8
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 21:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6CFE2084D
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 21:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="I0ZFvCZU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgAOVcU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 16:32:20 -0500
Received: from kadath.azazel.net ([81.187.231.250]:56840 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbgAOVcT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 16:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5ItoYff6P6cg4LSIHjAPYbVIPWU2kBcQVBMZ+lw0ehI=; b=I0ZFvCZUbT+BSq3RPaSt8a256h
        GETP2h44Wm+CLf4TCPv7fDeqJL+N9axkROILOHNuf4z1JzqkgcNmkrgvRMaiBE8/4ZN8yjJwfw3Bk
        kLZhDdk3vuWOFfJatQyvhTIfePiKEfz2uoDj122X86QPpZFFG8LBXH+VIZnTiUVjYB+ymRuyxH4Q+
        TR+2S53lWwZG8jV1ERPLq05qhKVbbj0zdvBu4sq23/fCqqaqS3m4kwNh4cb5PbEPVNBJxU8NV/58K
        5Vgtcco+ZOAObWHRUEUfYi0qvsytJW7j1EfMXzt49iNc8vtAi3CQZG89Ey1M7MQz1+sqRF6SMPTdn
        gIRPgK9w==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irqGv-0008BP-OP; Wed, 15 Jan 2020 21:32:17 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v4 04/10] netfilter: bitwise: add NFTA_BITWISE_OP attribute.
Date:   Wed, 15 Jan 2020 21:32:10 +0000
Message-Id: <20200115213216.77493-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115213216.77493-1-jeremy@azazel.net>
References: <20200115213216.77493-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new bitwise netlink attribute, NFTA_BITWISE_OP, which is set to a
value of a new enum, nft_bitwise_ops.  It describes the type of
operation an expression contains.  Currently, it only has one value:
NFT_BITWISE_BOOL.  More values will be added later to implement shifts.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h | 12 ++++++++++++
 net/netfilter/nft_bitwise.c              | 16 ++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index e237ecbdcd8a..cfda75725455 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -484,6 +484,16 @@ enum nft_immediate_attributes {
 };
 #define NFTA_IMMEDIATE_MAX	(__NFTA_IMMEDIATE_MAX - 1)
 
+/**
+ * enum nft_bitwise_ops - nf_tables bitwise operations
+ *
+ * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR and
+ *                    XOR boolean operations
+ */
+enum nft_bitwise_ops {
+	NFT_BITWISE_BOOL,
+};
+
 /**
  * enum nft_bitwise_attributes - nf_tables bitwise expression netlink attributes
  *
@@ -492,6 +502,7 @@ enum nft_immediate_attributes {
  * @NFTA_BITWISE_LEN: length of operands (NLA_U32)
  * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
  *
  * The bitwise expression performs the following operation:
  *
@@ -512,6 +523,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_LEN,
 	NFTA_BITWISE_MASK,
 	NFTA_BITWISE_XOR,
+	NFTA_BITWISE_OP,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index c15e9beb5243..4884716d844a 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -18,6 +18,7 @@
 struct nft_bitwise {
 	enum nft_registers	sreg:8;
 	enum nft_registers	dreg:8;
+	enum nft_bitwise_ops	op:8;
 	u8			len;
 	struct nft_data		mask;
 	struct nft_data		xor;
@@ -41,6 +42,7 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_LEN]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_MASK]	= { .type = NLA_NESTED },
 	[NFTA_BITWISE_XOR]	= { .type = NLA_NESTED },
+	[NFTA_BITWISE_OP]	= { .type = NLA_U32 },
 };
 
 static int nft_bitwise_init(const struct nft_ctx *ctx,
@@ -76,6 +78,18 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	if (tb[NFTA_BITWISE_OP]) {
+		priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
+		switch (priv->op) {
+		case NFT_BITWISE_BOOL:
+			break;
+		default:
+			return -EINVAL;
+		}
+	} else {
+		priv->op = NFT_BITWISE_BOOL;
+	}
+
 	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &d1,
 			    tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
@@ -112,6 +126,8 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		return -1;
 	if (nla_put_be32(skb, NFTA_BITWISE_LEN, htonl(priv->len)))
 		return -1;
+	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(priv->op)))
+		return -1;
 
 	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &priv->mask,
 			  NFT_DATA_VALUE, priv->len) < 0)
-- 
2.24.1

