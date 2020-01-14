Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3E9C33CB3
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EFA624656
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="TZH6E5pl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgANV3W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:29:22 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55094 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbgANV3V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 16:29:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3O603SGjmNGj6h898Pg6QsvMjS1HC0Q9oVRYCcnn/lQ=; b=TZH6E5plKPIQFMyv5sXdAR9Vqx
        /JRltavFq3r/3igE4AtE8deKHyAfoG+2SfQEDmyKhkoIYAf4IQVikXHIn9s+3QMIrltXXtUGgtPXF
        tqApULMPrtPyUFuV9mK7Sh4tXw1e0KXzv5hHa7AWpUoR1XMqo582bNOt4um3dVjUs9L5kAiN3lbOQ
        jFyu8RVZ9XV/lgb05CRrUVjjKr7Tbi672bXd8dml3uLPreCPg7JOZLKM+nztTJSzn+oabU4DFnFoa
        rzun1H2E1lyp6+bdaLCvAEvjgm3I3xsOnlKo4M713Wt7Xqbm7PtkuRFnJ7iZXFRhZ32x6F2ax56TA
        zc4agpJg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irTkW-0001Dh-3I; Tue, 14 Jan 2020 21:29:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 09/10] netfilter: bitwise: add NFTA_BITWISE_DATA attribute.
Date:   Tue, 14 Jan 2020 21:29:17 +0000
Message-Id: <20200114212918.134062-10-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114212918.134062-1-jeremy@azazel.net>
References: <20200114212918.134062-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new bitwise netlink attribute that will be used by shift
operations to store the size of the shift.  It is not used by boolean
operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_bitwise.c              | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index cfda75725455..7cb85fd0d38e 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -503,6 +503,7 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
+ * @NFTA_BITWISE_DATA: argument for non-boolean operations (NLA_U32)
  *
  * The bitwise expression performs the following operation:
  *
@@ -524,6 +525,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_MASK,
 	NFTA_BITWISE_XOR,
 	NFTA_BITWISE_OP,
+	NFTA_BITWISE_DATA,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 1d9079ba2102..72abaa83a8ca 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -22,6 +22,7 @@ struct nft_bitwise {
 	u8			len;
 	struct nft_data		mask;
 	struct nft_data		xor;
+	u32			data;
 };
 
 static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
@@ -54,6 +55,7 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_MASK]	= { .type = NLA_NESTED },
 	[NFTA_BITWISE_XOR]	= { .type = NLA_NESTED },
 	[NFTA_BITWISE_OP]	= { .type = NLA_U32 },
+	[NFTA_BITWISE_DATA]	= { .type = NLA_U32 },
 };
 
 static int nft_bitwise_init_bool(struct nft_bitwise *priv,
@@ -62,6 +64,9 @@ static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 	struct nft_data_desc d1, d2;
 	int err;
 
+	if (tb[NFTA_BITWISE_DATA])
+		return -EINVAL;
+
 	if (!tb[NFTA_BITWISE_MASK] ||
 	    !tb[NFTA_BITWISE_XOR])
 		return -EINVAL;
-- 
2.24.1

