Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFF8C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Nov 2021 12:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F4C761077
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Nov 2021 12:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235932AbhKIMo6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 07:44:58 -0500
Received: from mailout1.hostsharing.net ([83.223.95.204]:40251 "EHLO
        mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbhKIMo5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 07:44:57 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 9A1DB10193E98;
        Tue,  9 Nov 2021 13:42:10 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 6BF3C6147FCD;
        Tue,  9 Nov 2021 13:42:10 +0100 (CET)
X-Mailbox-Line: From af1325c0c71ad2786b7fba282a4b21c8fc0cf53c Mon Sep 17 00:00:00 2001
Message-Id: <af1325c0c71ad2786b7fba282a4b21c8fc0cf53c.1636461297.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Tue, 9 Nov 2021 13:42:01 +0100
Subject: [PATCH nf-next] netfilter: nft_fwd_netdev: Support egress hook
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Allow packet redirection to another interface upon egress.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[lukas: set skb_iif, add commit message]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 net/netfilter/nft_fwd_netdev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index cd59afde5b2f..fa9301ca6033 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -27,9 +27,11 @@ static void nft_fwd_netdev_eval(const struct nft_expr *expr,
 {
 	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
 	int oif = regs->data[priv->sreg_dev];
+	struct sk_buff *skb = pkt->skb;
 
 	/* This is used by ifb only. */
-	skb_set_redirected(pkt->skb, true);
+	skb->skb_iif = skb->dev->ifindex;
+	skb_set_redirected(skb, nft_hook(pkt) == NF_NETDEV_INGRESS);
 
 	nf_fwd_netdev_egress(pkt, oif);
 	regs->verdict.code = NF_STOLEN;
@@ -198,7 +200,8 @@ static int nft_fwd_validate(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nft_data **data)
 {
-	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS));
+	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS) |
+						    (1 << NF_NETDEV_EGRESS));
 }
 
 static struct nft_expr_type nft_fwd_netdev_type;
-- 
2.33.0

