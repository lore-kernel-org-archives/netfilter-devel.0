Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A648C00140
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Aug 2022 15:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiHUPyI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Aug 2022 11:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiHUPyH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Aug 2022 11:54:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DA3D14D3F
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Aug 2022 08:54:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/3] netfilter: nft_dup: validate family and chains
Date:   Sun, 21 Aug 2022 17:53:59 +0200
Message-Id: <20220821155401.197971-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This only supports for netdev family and ingress and egress hooks.

Fixes: 502061f81d3e ("netfilter: nf_tables: add packet duplication to the netdev family")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_dup_netdev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index 63507402716d..1d5bbe8d2660 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -44,6 +44,14 @@ static int nft_dup_netdev_init(const struct nft_ctx *ctx,
 				       sizeof(int));
 }
 
+static int nft_dup_netdev_validate(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr,
+				   const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS) |
+						    (1 << NF_NETDEV_EGRESS));
+}
+
 static int nft_dup_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	struct nft_dup_netdev *priv = nft_expr_priv(expr);
@@ -79,6 +87,7 @@ static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.eval		= nft_dup_netdev_eval,
 	.init		= nft_dup_netdev_init,
 	.dump		= nft_dup_netdev_dump,
+	.validate	= nft_dup_netdev_validate,
 	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_dup_netdev_offload,
 	.offload_action	= nft_dup_netdev_offload_action,
-- 
2.30.2

