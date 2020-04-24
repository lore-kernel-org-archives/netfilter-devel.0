Return-Path: <SRS0=g4y9=6I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C667BC55186
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Apr 2020 19:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE27B20781
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Apr 2020 19:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgDXTzr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Apr 2020 15:55:47 -0400
Received: from correo.us.es ([193.147.175.20]:46112 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDXTzq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Apr 2020 15:55:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A53A2DA738
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96F3DDA736
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8CB7FBAABD; Fri, 24 Apr 2020 21:55:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 910B9DA736
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 Apr 2020 21:55:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7D54042EF4E0
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 4/5] netfilter: nft_nat: add helper function to set up NAT address and protocol
Date:   Fri, 24 Apr 2020 21:55:36 +0200
Message-Id: <20200424195537.23975-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424195537.23975-1-pablo@netfilter.org>
References: <20200424195537.23975-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch add nft_nat_setup_addr() and nft_nat_setup_proto() to set up
the NAT mangling.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_nat.c | 56 +++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 5c7ff213c030..7442aa8b1555 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -30,6 +30,36 @@ struct nft_nat {
 	u16			flags;
 };
 
+static void nft_nat_setup_addr(struct nf_nat_range2 *range,
+			       const struct nft_regs *regs,
+			       const struct nft_nat *priv)
+{
+	switch (priv->family) {
+	case AF_INET:
+		range->min_addr.ip = (__force __be32)
+				regs->data[priv->sreg_addr_min];
+		range->max_addr.ip = (__force __be32)
+				regs->data[priv->sreg_addr_max];
+		break;
+	case AF_INET6:
+		memcpy(range->min_addr.ip6, &regs->data[priv->sreg_addr_min],
+		       sizeof(range->min_addr.ip6));
+		memcpy(range->max_addr.ip6, &regs->data[priv->sreg_addr_max],
+		       sizeof(range->max_addr.ip6));
+		break;
+	}
+}
+
+static void nft_nat_setup_proto(struct nf_nat_range2 *range,
+				const struct nft_regs *regs,
+				const struct nft_nat *priv)
+{
+	range->min_proto.all = (__force __be16)
+		nft_reg_load16(&regs->data[priv->sreg_proto_min]);
+	range->max_proto.all = (__force __be16)
+		nft_reg_load16(&regs->data[priv->sreg_proto_max]);
+}
+
 static void nft_nat_eval(const struct nft_expr *expr,
 			 struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt)
@@ -40,29 +70,11 @@ static void nft_nat_eval(const struct nft_expr *expr,
 	struct nf_nat_range2 range;
 
 	memset(&range, 0, sizeof(range));
-	if (priv->sreg_addr_min) {
-		if (priv->family == AF_INET) {
-			range.min_addr.ip = (__force __be32)
-					regs->data[priv->sreg_addr_min];
-			range.max_addr.ip = (__force __be32)
-					regs->data[priv->sreg_addr_max];
-
-		} else {
-			memcpy(range.min_addr.ip6,
-			       &regs->data[priv->sreg_addr_min],
-			       sizeof(range.min_addr.ip6));
-			memcpy(range.max_addr.ip6,
-			       &regs->data[priv->sreg_addr_max],
-			       sizeof(range.max_addr.ip6));
-		}
-	}
+	if (priv->sreg_addr_min)
+		nft_nat_setup_addr(&range, regs, priv);
 
-	if (priv->sreg_proto_min) {
-		range.min_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_min]);
-		range.max_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_max]);
-	}
+	if (priv->sreg_proto_min)
+		nft_nat_setup_proto(&range, regs, priv);
 
 	range.flags = priv->flags;
 
-- 
2.20.1

