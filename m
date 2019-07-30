Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64EBC0650F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 11:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91A9F2087F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 11:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbfG3LcK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 07:32:10 -0400
Received: from correo.us.es ([193.147.175.20]:59704 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbfG3LcK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 07:32:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 323EDB5AAF
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 13:32:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 128FC115117
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 13:32:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0CAB8115112; Tue, 30 Jul 2019 13:32:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 517B9115105
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 13:32:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Jul 2019 13:32:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DB3C240705C4
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 13:32:04 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nft_bitwise: add offload support
Date:   Tue, 30 Jul 2019 13:32:01 +0200
Message-Id: <20190730113201.17542-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extract mask from bitwise operation and store it into the corresponding
context register so the cmp instruction can set the mask accordingly.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
eg. ip saddr 1.2.3.0/24

 net/netfilter/nft_bitwise.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index b310b637b550..1f04ed5c518c 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -13,6 +13,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_offload.h>
 
 struct nft_bitwise {
 	enum nft_registers	sreg:8;
@@ -126,12 +127,30 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static struct nft_data zero;
+
+static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
+                               struct nft_flow_rule *flow,
+                               const struct nft_expr *expr)
+{
+	const struct nft_bitwise *priv = nft_expr_priv(expr);
+
+	if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
+	    priv->sreg != priv->dreg))
+		return -EOPNOTSUPP;
+
+	memcpy(&ctx->regs[priv->dreg].mask, &priv->mask, sizeof(priv->mask));
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_bitwise_ops = {
 	.type		= &nft_bitwise_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_bitwise)),
 	.eval		= nft_bitwise_eval,
 	.init		= nft_bitwise_init,
 	.dump		= nft_bitwise_dump,
+	.offload	= nft_bitwise_offload,
 };
 
 struct nft_expr_type nft_bitwise_type __read_mostly = {
-- 
2.11.0

