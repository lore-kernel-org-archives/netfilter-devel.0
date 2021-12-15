Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4C3C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 23:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhLOXt1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 18:49:27 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56628 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbhLOXtZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 18:49:25 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 33A25625F6;
        Thu, 16 Dec 2021 00:46:55 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 5/7] netfilter: nft_fwd_netdev: Support egress hook
Date:   Thu, 16 Dec 2021 00:49:09 +0100
Message-Id: <20211215234911.170741-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215234911.170741-1-pablo@netfilter.org>
References: <20211215234911.170741-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow packet redirection to another interface upon egress.

[lukas: set skb_iif, add commit message, original patch from Pablo. ]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

