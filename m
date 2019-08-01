Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FEDC19759
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 12:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D72220838
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 12:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbfHAMJe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 08:09:34 -0400
Received: from correo.us.es ([193.147.175.20]:55758 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729071AbfHAMJd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 08:09:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EE062FB362
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2019 14:09:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DEF43DA708
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2019 14:09:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D4C1CDA704; Thu,  1 Aug 2019 14:09:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC1B71150B9
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2019 14:09:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 01 Aug 2019 14:09:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id ADBB940705C3
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2019 14:09:29 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: store data in offload context registers
Date:   Thu,  1 Aug 2019 14:09:26 +0200
Message-Id: <20190801120926.26662-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Store immediate data into offload context register. This allows follow
up instructions to take it from the corresponding source register.

This patch is required to support for payload mangling, although other
instructions that take data from source register will benefit from this
too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_offload.h |  1 +
 net/netfilter/nft_immediate.c             | 24 +++++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 3196663a10e3..4977fbe7ed08 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -9,6 +9,7 @@ struct nft_offload_reg {
 	u32		len;
 	u32		base_offset;
 	u32		offset;
+	struct nft_data data;
 	struct nft_data	mask;
 };
 
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index ca2ae4b95a8d..c7f0ef73d939 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -125,17 +125,13 @@ static int nft_immediate_validate(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static int nft_immediate_offload(struct nft_offload_ctx *ctx,
-				 struct nft_flow_rule *flow,
-				 const struct nft_expr *expr)
+static int nft_immediate_offload_verdict(struct nft_offload_ctx *ctx,
+					 struct nft_flow_rule *flow,
+					 const struct nft_immediate_expr *priv)
 {
-	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 	struct flow_action_entry *entry;
 	const struct nft_data *data;
 
-	if (priv->dreg != NFT_REG_VERDICT)
-		return -EOPNOTSUPP;
-
 	entry = &flow->rule->action.entries[ctx->num_actions++];
 
 	data = &priv->data;
@@ -153,6 +149,20 @@ static int nft_immediate_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
+static int nft_immediate_offload(struct nft_offload_ctx *ctx,
+				 struct nft_flow_rule *flow,
+				 const struct nft_expr *expr)
+{
+	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+
+	if (priv->dreg == NFT_REG_VERDICT)
+		return nft_immediate_offload_verdict(ctx, flow, priv);
+
+	memcpy(&ctx->regs[priv->dreg].data, &priv->data, sizeof(priv->data));
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_imm_ops = {
 	.type		= &nft_imm_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
-- 
2.11.0

