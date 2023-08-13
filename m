Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36B7C001DB
	for <netfilter-devel@archiver.kernel.org>; Sun, 13 Aug 2023 21:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjHMVX3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Aug 2023 17:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjHMVX2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Aug 2023 17:23:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07D5BF;
        Sun, 13 Aug 2023 14:23:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66A7062890;
        Sun, 13 Aug 2023 21:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5DDC433C7;
        Sun, 13 Aug 2023 21:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1691961809;
        bh=BRLevBGrfVMwQ2osnvxXKlTN6p6K8Jye4hOJNUCFNmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xy0OOQnoBKD9KsckP/DDmMM/JILDkl0aSukkCAn3LVspT3F3AH4nGYKE7OfPgRrCt
         tlGlWOldvZctBiG5FjlVKukVqSuTc5L+sKmo9LXM1Yb6hG9818im/RQb58Jmkarr6u
         jslLkSM8IgPwhMsiikJk7a9R+gN3Sf6K73RtdXqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Laura Garcia Liebana <nevola@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 25/33] netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush
Date:   Sun, 13 Aug 2023 23:19:19 +0200
Message-ID: <20230813211704.842776409@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211703.915807095@linuxfoundation.org>
References: <20230813211703.915807095@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

From: Laura Garcia Liebana <nevola@gmail.com>

commit 9b05b6e11d5e93a3a517cadc12b9836e0470c255 upstream.

The deletion of a flowtable after a flush in the same transaction
results in EBUSY. This patch adds an activation and deactivation of
flowtables in order to update the _use_ counter.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    4 ++++
 net/netfilter/nf_tables_api.c     |   16 ++++++++++++++++
 net/netfilter/nft_flow_offload.c  |   19 +++++++++++++++++++
 3 files changed, 39 insertions(+)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1161,6 +1161,10 @@ struct nft_flowtable *nft_flowtable_look
 					   const struct nlattr *nla,
 					   u8 genmask);
 
+void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
+				    struct nft_flowtable *flowtable,
+				    enum nft_trans_phase phase);
+
 void nft_register_flowtable_type(struct nf_flowtable_type *type);
 void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
 
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5519,6 +5519,22 @@ struct nft_flowtable *nft_flowtable_look
 }
 EXPORT_SYMBOL_GPL(nft_flowtable_lookup);
 
+void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
+				    struct nft_flowtable *flowtable,
+				    enum nft_trans_phase phase)
+{
+	switch (phase) {
+	case NFT_TRANS_PREPARE:
+	case NFT_TRANS_ABORT:
+	case NFT_TRANS_RELEASE:
+		flowtable->use--;
+		/* fall through */
+	default:
+		return;
+	}
+}
+EXPORT_SYMBOL_GPL(nf_tables_deactivate_flowtable);
+
 static struct nft_flowtable *
 nft_flowtable_lookup_byhandle(const struct nft_table *table,
 			      const struct nlattr *nla, u8 genmask)
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -175,6 +175,23 @@ static int nft_flow_offload_init(const s
 	return nf_ct_netns_get(ctx->net, ctx->family);
 }
 
+static void nft_flow_offload_deactivate(const struct nft_ctx *ctx,
+					const struct nft_expr *expr,
+					enum nft_trans_phase phase)
+{
+	struct nft_flow_offload *priv = nft_expr_priv(expr);
+
+	nf_tables_deactivate_flowtable(ctx, priv->flowtable, phase);
+}
+
+static void nft_flow_offload_activate(const struct nft_ctx *ctx,
+				      const struct nft_expr *expr)
+{
+	struct nft_flow_offload *priv = nft_expr_priv(expr);
+
+	priv->flowtable->use++;
+}
+
 static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
 				     const struct nft_expr *expr)
 {
@@ -203,6 +220,8 @@ static const struct nft_expr_ops nft_flo
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_flow_offload)),
 	.eval		= nft_flow_offload_eval,
 	.init		= nft_flow_offload_init,
+	.activate	= nft_flow_offload_activate,
+	.deactivate	= nft_flow_offload_deactivate,
 	.destroy	= nft_flow_offload_destroy,
 	.validate	= nft_flow_offload_validate,
 	.dump		= nft_flow_offload_dump,


